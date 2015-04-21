
#import "_FLGBook.h"

@import UIKit;

@class AGTCoreDataStack;
@class FLGBook;

@protocol FLGBookDelegate <NSObject>

-(void) bookDidChange:(FLGBook*) book;

@end

@interface FLGBook : _FLGBook {}

#pragma mark - Propiedades "transient"
// Propiedades transient por código: estas no van a Core Data
@property (nonatomic) BOOL isFavourite;
@property (readonly, nonatomic) BOOL savedIntoDisk;

@property (weak, nonatomic) id<FLGBookDelegate> delegate;


#pragma mark - Init
+ (instancetype) bookWithJsonDictionary:(NSDictionary *) jsonDict
                                context:(NSManagedObjectContext *) context;

+ (instancetype) objectWithArchivedURIRepresentation:(NSData*)archivedURI
                                             context:(NSManagedObjectContext *) context;

#pragma mark - Utils
- (NSData*) archiveURIRepresentation;

#pragma mark - "Cosmetic" methods
- (NSString *) authorsString;
- (NSString *) tagsString;

- (NSString *) proxyForSorting;

@end
