// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FLGPhoto.h instead.

@import CoreData;

extern const struct FLGPhotoAttributes {
	__unsafe_unretained NSString *photoData;
} FLGPhotoAttributes;

extern const struct FLGPhotoRelationships {
	__unsafe_unretained NSString *annotation;
} FLGPhotoRelationships;

@class FLGAnnotation;

@interface FLGPhotoID : NSManagedObjectID {}
@end

@interface _FLGPhoto : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) FLGPhotoID* objectID;

@property (nonatomic, strong) NSData* photoData;

//- (BOOL)validatePhotoData:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) FLGAnnotation *annotation;

//- (BOOL)validateAnnotation:(id*)value_ error:(NSError**)error_;

@end

@interface _FLGPhoto (CoreDataGeneratedPrimitiveAccessors)

- (NSData*)primitivePhotoData;
- (void)setPrimitivePhotoData:(NSData*)value;

- (FLGAnnotation*)primitiveAnnotation;
- (void)setPrimitiveAnnotation:(FLGAnnotation*)value;

@end
