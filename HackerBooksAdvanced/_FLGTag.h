// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FLGTag.h instead.

@import CoreData;

extern const struct FLGTagAttributes {
	__unsafe_unretained NSString *index;
	__unsafe_unretained NSString *name;
} FLGTagAttributes;

extern const struct FLGTagRelationships {
	__unsafe_unretained NSString *books;
} FLGTagRelationships;

@class FLGBook;

@interface FLGTagID : NSManagedObjectID {}
@end

@interface _FLGTag : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) FLGTagID* objectID;

@property (nonatomic, strong) NSNumber* index;

@property (atomic) int16_t indexValue;
- (int16_t)indexValue;
- (void)setIndexValue:(int16_t)value_;

//- (BOOL)validateIndex:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *books;

- (NSMutableSet*)booksSet;

@end

@interface _FLGTag (BooksCoreDataGeneratedAccessors)
- (void)addBooks:(NSSet*)value_;
- (void)removeBooks:(NSSet*)value_;
- (void)addBooksObject:(FLGBook*)value_;
- (void)removeBooksObject:(FLGBook*)value_;

@end

@interface _FLGTag (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveIndex;
- (void)setPrimitiveIndex:(NSNumber*)value;

- (int16_t)primitiveIndexValue;
- (void)setPrimitiveIndexValue:(int16_t)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSMutableSet*)primitiveBooks;
- (void)setPrimitiveBooks:(NSMutableSet*)value;

@end
