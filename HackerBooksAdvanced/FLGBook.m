#import "FLGBook.h"
#import "FLGConstants.h"
#import "AGTCoreDataStack+FetchWithContext.h"
#import "FLGCover.h"
#import "FLGAuthor.h"
#import "FLGPdf.h"
#import "FLGTag.h"
#import "AGTAsyncImage.h"

@interface FLGBook ()

@end

@implementation FLGBook
@dynamic delegate;

#pragma mark - Class Methods

+ (NSArray *) observableKeys{
    // Devuelve por defecto un array vacio -> Luego se sobreescribira en cada subclase
    return @[@"cover.imageData"];
//    return @[];
}


#pragma mark - Properties
- (void) setIsFavourite:(BOOL)isFavourite{
    
    // Se obtiene el Tag "FAVOURITE"
    FLGTag *tag = [FLGTag favoriteTagWithContext:self.managedObjectContext];
    
    if (isFavourite) {
        // Se añade el tag "FAVOURITE" al book
        [self addTagsObject:tag];
    }else{
        // Se elimina el tag "FAVOURITE" del book
        [self removeTagsObject:tag];
    }
    [self sendBookDidChangeItsContentNotification];
}

- (BOOL) isFavourite{
    
    // Se comprueba si el tag "FAVOURITE" pertenece al book
    for (FLGTag *tag in self.tags) {
        if ([tag.name isEqualToString:FAVOURITES_TAG]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL) savedIntoDisk{
    if (self.pdf.pdfData) {
        return YES;
    }
    return NO;
}

#pragma mark - Init
// Custom logic goes here.
+ (instancetype) bookWithJsonDictionary:(NSDictionary *) jsonDict
                                context:(NSManagedObjectContext *)context{
    
    FLGBook *book = [FLGBook insertInManagedObjectContext:context];
    
    book.title = [jsonDict objectForKey:TITLE_KEY];
    book.coverURL = [jsonDict objectForKey:COVER_URL_KEY];
    book.pdfURL = [jsonDict objectForKey:PDF_URL_KEY];
    
//    book.annotations is optional
    
    NSArray *bookAuthorsArray = [[jsonDict objectForKey:AUTHORS_KEY] componentsSeparatedByString: @", "];
    for (NSString *authorName in bookAuthorsArray) {
        
        FLGAuthor *author = [FLGAuthor authorWithName:authorName
                                              context:context];
        
        [book addAuthorsObject:author];
    }
    
    book.cover = [FLGCover coverWithCoverURL:[NSURL URLWithString: book.coverURL]
                                     context:context];
    
    book.pdf = [FLGPdf insertInManagedObjectContext:context];
    
    NSArray *bookTagsArray = [[jsonDict objectForKey:TAGS_KEY] componentsSeparatedByString: @", "];
    for (NSString *tagName in bookTagsArray) {
        
        FLGTag *tag = [FLGTag tagWithName:tagName
                                    context:context];
        
        [book addTagsObject:tag];
    }
    
//    [stack saveWithErrorBlock:^(NSError *error) {
//        NSLog(@"Error al guardar el contexto en Core Data: %@", error);
//    }];
    
    return book;
}

+ (instancetype) objectWithArchivedURIRepresentation:(NSData*)archivedURI
                                            context:(NSManagedObjectContext *) context{
    
    NSURL *uri = [NSKeyedUnarchiver unarchiveObjectWithData:archivedURI];
    if (uri == nil) {
        return nil;
    }
    
    NSManagedObjectID *nid = [context.persistentStoreCoordinator
                              managedObjectIDForURIRepresentation:uri];
    if (nid == nil) {
        return nil;
    }
    
    NSManagedObject *ob = [context objectWithID:nid];
    if (ob.isFault) {
        // Got it!
        return (FLGBook *)ob;
    }else{
        // Might not exist anymore. Let's fetch it!
        NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:ob.entity.name];
        req.predicate = [NSPredicate predicateWithFormat:@"SELF = %@", ob];
        
        NSError *error;
        NSArray *res = [context executeFetchRequest:req
                                              error:&error];
        if (res == nil) {
            return nil;
        }else{
            return [res lastObject];
        }
    }
}

#pragma mark - Life cycle

// Solo se produce 1 vez en la vida del objeto
- (void) awakeFromInsert{
    [super awakeFromInsert];
    // Alta en la notificaciones
    [self setupKVO];
//    [self setupNotifications];
}

// Se produce n veces a lo largo de la vida del objeto:
//    - Cada vez que pasa de Fault a objeto con contenido
//    - Cada vez que se saca un objeto de base de datos
- (void) awakeFromFetch{
    [super awakeFromFetch];
    // Alta en la notificaciones
    [self setupKVO];
//    [self setupNotifications];
}

// Se produce cuando un objeto se vacía convirtiendose en un fault
- (void) willTurnIntoFault{
    [super willTurnIntoFault];
    // Baja en la notificaciones
    [self tearDownKVO];
//    [self tearDownNotifications];
}

#pragma mark - KVO

- (void) setupKVO{
    
    // Observamos todas las propiedades EXCEPTO "modificationDate" (creariamos bucle infinito)
    for (NSString *key in [[self class] observableKeys]) {
        [self addObserver:self
               forKeyPath:key
                  options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                  context:NULL];
    }
}

- (void) tearDownKVO{
    
    // Me doy de baja de toda las notificaciones
    for (NSString *key in [[self class] observableKeys]) {
        [self removeObserver:self
                  forKeyPath:key];
    }
}

// mensaje que se recibe siempre en KVO cuando cambia cualquiera de las propiedades observadas
- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context{
    
    // Se llama a este metodo cuando cambia la imagen del cover -> se enviara una notificacion
    NSLog(@"Se ha cargado la cover del libro: %@", self.title);
    // Mandamos una notificacion
    [self sendBookDidChangeItsContentNotification];
}

#pragma mark - Notifications

- (void) setupNotifications{
    // Nos damos de alta en las notificaciones
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(notifyThatCoverDidChange:)
                   name:COVER_DID_CHANGE_NOTIFICATION
                 object:self.cover];
}

- (void) tearDownNotifications{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

// COVER_DID_CHANGE_NOTIFICATION
- (void) notifyThatCoverDidChange: (NSNotification *) n{
    [self sendBookDidChangeItsContentNotification];
}

- (void) sendBookDidChangeItsContentNotification{
    NSNotification *note = [NSNotification notificationWithName:BOOK_DID_CHANGE_ITS_CONTENT_NOTIFICATION
                                                         object:self
                                                       userInfo:@{BOOK_KEY: self}];
    
    // Enviamos la notificacion
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

#pragma mark - Utils
- (NSData*) archiveURIRepresentation{
    
    NSURL *uri = self.objectID.URIRepresentation;
    return [NSKeyedArchiver archivedDataWithRootObject:uri];
}

- (NSString *) authorsString{
    
    NSString *authorsString = @"";
    NSSet *authors = self.authors;
    for (FLGAuthor *author in authors) {
        authorsString = [NSString stringWithFormat:@"%@%@, ", authorsString, author.name];
    }
    return [authorsString substringToIndex:authorsString.length -2];
}

- (NSString *) tagsString{
    
    NSString *tagsString = @"";
    NSSet *tags = self.tags;
    for (FLGTag *tag in tags) {
        tagsString = [NSString stringWithFormat:@"%@%@, ", tagsString, tag.name];
    }
    return [tagsString substringToIndex:tagsString.length -2];
}

#pragma mark - Comparison
//- (NSComparisonResult)compare:(FLGBook *)other{
//    
//    return [[self proxyForSorting] compare:[other proxyForSorting]];
//}

- (NSString *) proxyForSorting{
    NSString *tagsString = @"";
    for (FLGTag *tag in self.tags) {
        tagsString = [NSString stringWithFormat:@"%@%@", tagsString, tag.name];
    }
    return tagsString;
}

#pragma mark - NSObject
-(NSString *) description{
    return [NSString stringWithFormat:@"<%@:\nTitle:%@\nAuthors:%@\nTags:%@>",
            [self class], self.title, self.authors, self.tags];
}


@end