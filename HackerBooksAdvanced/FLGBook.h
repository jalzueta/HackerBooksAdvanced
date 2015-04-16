#import "_FLGBook.h"
@class AGTCoreDataStack;

@interface FLGBook : _FLGBook {}
// Custom logic goes here.

// Propiedad "transient" por código: esta no va a Core Data
@property (nonatomic) BOOL isFavourite;
@property (readonly, nonatomic) BOOL savedIntoDisk;

#pragma mark - Properties
- (void) setIsFavourite:(BOOL)isFavourite;
- (BOOL) isFavourite;

#pragma mark - Init
+ (instancetype) bookWithJsonDictionary:(NSDictionary *) jsonDict
                                  stack:(AGTCoreDataStack *)stack;

+ (instancetype) objectWithArchivedURIRepresentation:(NSData*)archivedURI
                                             context:(NSManagedObjectContext *) context;

#pragma mark - Utils
- (NSData*) archiveURIRepresentation;
- (NSString *) authorsString;
- (NSString *) tagsString;

@end
