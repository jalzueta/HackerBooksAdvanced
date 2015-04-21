#import "_FLGAuthor.h"
@class AGTCoreDataStack;

@interface FLGAuthor : _FLGAuthor {}
// Custom logic goes here.

+ (instancetype) authorWithName: (NSString *) name
                        context: (NSManagedObjectContext *) context;

@end
