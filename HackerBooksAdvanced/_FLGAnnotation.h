// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FLGAnnotation.h instead.

@import CoreData;
#import "FLGHackerBooksBaseClass.h"

extern const struct FLGAnnotationAttributes {
	__unsafe_unretained NSString *creationDate;
	__unsafe_unretained NSString *modificationDate;
	__unsafe_unretained NSString *text;
	__unsafe_unretained NSString *title;
} FLGAnnotationAttributes;

extern const struct FLGAnnotationRelationships {
	__unsafe_unretained NSString *book;
	__unsafe_unretained NSString *location;
	__unsafe_unretained NSString *photo;
} FLGAnnotationRelationships;

@class FLGBook;
@class FLGLocation;
@class FLGPhoto;

@interface FLGAnnotationID : NSManagedObjectID {}
@end

@interface _FLGAnnotation : FLGHackerBooksBaseClass {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) FLGAnnotationID* objectID;

@property (nonatomic, strong) NSDate* creationDate;

//- (BOOL)validateCreationDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* modificationDate;

//- (BOOL)validateModificationDate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* text;

//- (BOOL)validateText:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) FLGBook *book;

//- (BOOL)validateBook:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) FLGLocation *location;

//- (BOOL)validateLocation:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) FLGPhoto *photo;

//- (BOOL)validatePhoto:(id*)value_ error:(NSError**)error_;

@end

@interface _FLGAnnotation (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveCreationDate;
- (void)setPrimitiveCreationDate:(NSDate*)value;

- (NSDate*)primitiveModificationDate;
- (void)setPrimitiveModificationDate:(NSDate*)value;

- (NSString*)primitiveText;
- (void)setPrimitiveText:(NSString*)value;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (FLGBook*)primitiveBook;
- (void)setPrimitiveBook:(FLGBook*)value;

- (FLGLocation*)primitiveLocation;
- (void)setPrimitiveLocation:(FLGLocation*)value;

- (FLGPhoto*)primitivePhoto;
- (void)setPrimitivePhoto:(FLGPhoto*)value;

@end
