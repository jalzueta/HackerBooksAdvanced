#import "_FLGBook.h"
@class AGTCoreDataStack;

@interface FLGBook : _FLGBook {}
// Custom logic goes here.

+ (instancetype) bookWithJsonDictionary:(NSDictionary *) jsonDict
                                  stack:(AGTCoreDataStack *)stack;

@end
