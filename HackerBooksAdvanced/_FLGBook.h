// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FLGBook.h instead.

@import CoreData;

extern const struct FLGBookAttributes {
	__unsafe_unretained NSString *coverURL;
	__unsafe_unretained NSString *pdfURL;
	__unsafe_unretained NSString *title;
} FLGBookAttributes;

extern const struct FLGBookRelationships {
	__unsafe_unretained NSString *annotations;
	__unsafe_unretained NSString *authors;
	__unsafe_unretained NSString *cover;
	__unsafe_unretained NSString *pdf;
	__unsafe_unretained NSString *tags;
} FLGBookRelationships;

@class FLGAnnotation;
@class FLGAuthor;
@class FLGCover;
@class FLGPdf;
@class FLGTag;

@interface FLGBookID : NSManagedObjectID {}
@end

@interface _FLGBook : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) FLGBookID* objectID;

@property (nonatomic, strong) NSString* coverURL;

//- (BOOL)validateCoverURL:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* pdfURL;

//- (BOOL)validatePdfURL:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *annotations;

- (NSMutableSet*)annotationsSet;

@property (nonatomic, strong) NSSet *authors;

- (NSMutableSet*)authorsSet;

@property (nonatomic, strong) FLGCover *cover;

//- (BOOL)validateCover:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) FLGPdf *pdf;

//- (BOOL)validatePdf:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *tags;

- (NSMutableSet*)tagsSet;

@end

@interface _FLGBook (AnnotationsCoreDataGeneratedAccessors)
- (void)addAnnotations:(NSSet*)value_;
- (void)removeAnnotations:(NSSet*)value_;
- (void)addAnnotationsObject:(FLGAnnotation*)value_;
- (void)removeAnnotationsObject:(FLGAnnotation*)value_;

@end

@interface _FLGBook (AuthorsCoreDataGeneratedAccessors)
- (void)addAuthors:(NSSet*)value_;
- (void)removeAuthors:(NSSet*)value_;
- (void)addAuthorsObject:(FLGAuthor*)value_;
- (void)removeAuthorsObject:(FLGAuthor*)value_;

@end

@interface _FLGBook (TagsCoreDataGeneratedAccessors)
- (void)addTags:(NSSet*)value_;
- (void)removeTags:(NSSet*)value_;
- (void)addTagsObject:(FLGTag*)value_;
- (void)removeTagsObject:(FLGTag*)value_;

@end

@interface _FLGBook (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveCoverURL;
- (void)setPrimitiveCoverURL:(NSString*)value;

- (NSString*)primitivePdfURL;
- (void)setPrimitivePdfURL:(NSString*)value;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (NSMutableSet*)primitiveAnnotations;
- (void)setPrimitiveAnnotations:(NSMutableSet*)value;

- (NSMutableSet*)primitiveAuthors;
- (void)setPrimitiveAuthors:(NSMutableSet*)value;

- (FLGCover*)primitiveCover;
- (void)setPrimitiveCover:(FLGCover*)value;

- (FLGPdf*)primitivePdf;
- (void)setPrimitivePdf:(FLGPdf*)value;

- (NSMutableSet*)primitiveTags;
- (void)setPrimitiveTags:(NSMutableSet*)value;

@end
