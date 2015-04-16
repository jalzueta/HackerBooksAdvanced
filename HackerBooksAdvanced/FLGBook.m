#import "FLGBook.h"
#import "FLGConstants.h"
#import "AGTCoreDataStack.h"
#import "FLGCover.h"
#import "FLGAuthor.h"
#import "FLGPdf.h"
#import "FLGTag.h"

@interface FLGBook ()

// Private interface goes here.

@end

@implementation FLGBook


#pragma mark - Properties
- (void) setIsFavourite:(BOOL)isFavourite{
    
    if (isFavourite) {
        // Se añade el tag "FAVOURITE" al book
        
    }else{
        // Se elimina el tag "FAVOURITE" del book
        
    }
}

- (BOOL) isFavourite{
    
    // Se comprueba si el tag "FAVOURITE" pertenece al book
    
    return NO;
}

- (BOOL) savedIntoDisk{
    return self.pdf.pdfData;
}

#pragma mark - Init
// Custom logic goes here.
+ (instancetype) bookWithJsonDictionary:(NSDictionary *) jsonDict
                                  stack:(AGTCoreDataStack *)stack{

    NSManagedObjectContext *context = stack.context;
    
    FLGBook *book = [FLGBook insertInManagedObjectContext:context];
    book.title = [jsonDict objectForKey:TITLE_KEY];
    book.coverURL = [jsonDict objectForKey:COVER_URL_KEY];
    book.pdfURL = [jsonDict objectForKey:PDF_URL_KEY];
    
//    book.annotations is optional
    
    // Obtengo los Authors del libro actual y miro si existen ya en Core Data:
    // Si existen, añado el Author de Core Data al libro.
    // Si no existe, creo ese Author en Core Data y se lo asigno al libro
    NSArray *bookAuthorsArray = [[jsonDict objectForKey:AUTHORS_KEY] componentsSeparatedByString: @", "];
    for (NSString *authorName in bookAuthorsArray) {
        
        // Authors: hago una busqueda del Author en Core Data.
        NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[FLGAuthor entityName]];
        req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:FLGAuthorAttributes.name
                                                              ascending:YES
                                                               selector:@selector(caseInsensitiveCompare:)]];
        req.fetchBatchSize = 20;
        req.predicate = [NSPredicate predicateWithFormat:@"name = %@", authorName];
        
        NSArray *results = [stack executeFetchRequest:req
                                           errorBlock:^(NSError *error) {
                                               NSLog(@"Error al buscar! %@", error);
                                           }];
        
        FLGAuthor *author = [results firstObject];
        if (!author) {
            author = [FLGAuthor initWithName:authorName
                                     context:context];
        }
        [book addAuthorsObject:author];
    }
    
    book.cover = [FLGCover insertInManagedObjectContext:context];
    book.pdf = [FLGPdf insertInManagedObjectContext:context];
    
    // Obtengo los Tags del libro actual y miro si existen ya en Core Data:
    // Si existen, añado el Tag de Core Data al libro.
    // Si no existe, creo ese Tag en Core Data y se lo asigno al libro
    NSArray *bookTagsArray = [[jsonDict objectForKey:TAGS_KEY] componentsSeparatedByString: @", "];
    for (NSString *tagName in bookTagsArray) {
        // Authors: hago una busqueda del Author en Core Data.
        NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[FLGTag entityName]];
        req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:FLGTagAttributes.name
                                                              ascending:YES
                                                               selector:@selector(caseInsensitiveCompare:)]];
        req.fetchBatchSize = 20;
        req.predicate = [NSPredicate predicateWithFormat:@"name = %@", tagName];
        
        NSArray *results = [stack executeFetchRequest:req
                                           errorBlock:^(NSError *error) {
                                               NSLog(@"Error al buscar! %@", error);
                                           }];
        
        FLGTag *tag = [results firstObject];
        if (!tag) {
            tag = [FLGTag tagWithName:tagName
                               context:context];
        }
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
    return authorsString;
}

- (NSString *) tagsString{
    
    NSString *tagsString = @"";
    NSSet *tags = self.tags;
    for (FLGTag *tag in tags) {
        tagsString = [NSString stringWithFormat:@"%@%@, ", tagsString, tag.name];
    }
    return tagsString;
}


@end