#import "_FLGTag.h"

@interface FLGTag : _FLGTag {}
// Custom logic goes here.

+ (instancetype) tagWithName: (NSString *) name
                     context: (NSManagedObjectContext *) context;

+ (instancetype) favoriteTagWithContext: (NSManagedObjectContext *) context;

- (NSComparisonResult)compare:(FLGTag *)other;

@end
