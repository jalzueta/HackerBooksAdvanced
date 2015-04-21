#import "FLGAuthor.h"
#import "AGTCoreDataStack+FetchWithContext.h"

@interface FLGAuthor ()

// Private interface goes here.

@end

@implementation FLGAuthor

// Custom logic goes here.

+ (instancetype) authorWithName: (NSString *) name
                        context: (NSManagedObjectContext *) context{
    
    // Search for the Authors in Core Data:
    // If an author already exists, I add it to the book.
    // If not, I create the author before adding it to the book
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[FLGAuthor entityName]];
    
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:FLGAuthorAttributes.name
                                                          ascending:YES
                                                           selector:@selector(caseInsensitiveCompare:)]];
    
    req.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    
    NSArray *results = [AGTCoreDataStack executeFetchRequest:req
                                                     context: context
                                                  errorBlock:^(NSError *error) {
                                                      NSLog(@"Error al buscar! %@", error);
                                                  }];
    
    if (results.count > 0) {
        return [results firstObject];
    }
    else{
        FLGAuthor *author = [self insertInManagedObjectContext:context];
        author.name = name;
        
        return author;
    }
}

@end
