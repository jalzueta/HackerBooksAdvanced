#import "FLGTag.h"

@interface FLGTag ()

// Private interface goes here.

@end

@implementation FLGTag

// Custom logic goes here.

+ (instancetype) initWithName: (NSString *) name
                      context: (NSManagedObjectContext *) context{
    
    FLGTag *tag = [self insertInManagedObjectContext:context];
    tag.name = name;
    
    return tag;
}

@end
