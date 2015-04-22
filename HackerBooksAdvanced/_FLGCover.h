// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FLGCover.h instead.

@import CoreData;
#import "FLGHackerBooksBaseClass.h"

extern const struct FLGCoverAttributes {
	__unsafe_unretained NSString *imageData;
} FLGCoverAttributes;

extern const struct FLGCoverRelationships {
	__unsafe_unretained NSString *book;
} FLGCoverRelationships;

@class FLGBook;

@interface FLGCoverID : NSManagedObjectID {}
@end

@interface _FLGCover : FLGHackerBooksBaseClass {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) FLGCoverID* objectID;

@property (nonatomic, strong) NSData* imageData;

//- (BOOL)validateImageData:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) FLGBook *book;

//- (BOOL)validateBook:(id*)value_ error:(NSError**)error_;

@end

@interface _FLGCover (CoreDataGeneratedPrimitiveAccessors)

- (NSData*)primitiveImageData;
- (void)setPrimitiveImageData:(NSData*)value;

- (FLGBook*)primitiveBook;
- (void)setPrimitiveBook:(FLGBook*)value;

@end
