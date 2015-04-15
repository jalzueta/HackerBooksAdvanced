#import "_FLGAuthor.h"

@interface FLGAuthor : _FLGAuthor {}
// Custom logic goes here.

+ (instancetype) initWithName: (NSString *) name
                      context: (NSManagedObjectContext *) context;

@end
