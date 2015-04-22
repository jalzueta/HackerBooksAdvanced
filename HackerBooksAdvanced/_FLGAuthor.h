// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FLGAuthor.h instead.

@import CoreData;
#import "FLGHackerBooksBaseClass.h"

extern const struct FLGAuthorAttributes {
	__unsafe_unretained NSString *name;
} FLGAuthorAttributes;

extern const struct FLGAuthorRelationships {
	__unsafe_unretained NSString *book;
} FLGAuthorRelationships;

@class FLGBook;

@interface FLGAuthorID : NSManagedObjectID {}
@end

@interface _FLGAuthor : FLGHackerBooksBaseClass {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) FLGAuthorID* objectID;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *book;

- (NSMutableSet*)bookSet;

@end

@interface _FLGAuthor (BookCoreDataGeneratedAccessors)
- (void)addBook:(NSSet*)value_;
- (void)removeBook:(NSSet*)value_;
- (void)addBookObject:(FLGBook*)value_;
- (void)removeBookObject:(FLGBook*)value_;

@end

@interface _FLGAuthor (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSMutableSet*)primitiveBook;
- (void)setPrimitiveBook:(NSMutableSet*)value;

@end
