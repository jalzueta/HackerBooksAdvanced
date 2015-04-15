#import "FLGAuthor.h"

@interface FLGAuthor ()

// Private interface goes here.

@end

@implementation FLGAuthor

// Custom logic goes here.

+ (instancetype) initWithName: (NSString *) name
                      context: (NSManagedObjectContext *) context{
    
    FLGAuthor *author = [self insertInManagedObjectContext:context];
    author.name = name;
    
    return author;
}

@end
