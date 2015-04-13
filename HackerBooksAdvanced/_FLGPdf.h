// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FLGPdf.h instead.

@import CoreData;

extern const struct FLGPdfAttributes {
	__unsafe_unretained NSString *pdfData;
} FLGPdfAttributes;

extern const struct FLGPdfRelationships {
	__unsafe_unretained NSString *book;
} FLGPdfRelationships;

@class FLGBook;

@interface FLGPdfID : NSManagedObjectID {}
@end

@interface _FLGPdf : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) FLGPdfID* objectID;

@property (nonatomic, strong) NSData* pdfData;

//- (BOOL)validatePdfData:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) FLGBook *book;

//- (BOOL)validateBook:(id*)value_ error:(NSError**)error_;

@end

@interface _FLGPdf (CoreDataGeneratedPrimitiveAccessors)

- (NSData*)primitivePdfData;
- (void)setPrimitivePdfData:(NSData*)value;

- (FLGBook*)primitiveBook;
- (void)setPrimitiveBook:(FLGBook*)value;

@end
