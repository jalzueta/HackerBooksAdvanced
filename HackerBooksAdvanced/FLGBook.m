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
            tag = [FLGTag initWithName:tagName
                               context:context];
        }
        [book addTagsObject:tag];
    }
    
//    [stack saveWithErrorBlock:^(NSError *error) {
//        NSLog(@"Error al guardar el contexto en Core Data: %@", error);
//    }];
    
    return book;
}

@end