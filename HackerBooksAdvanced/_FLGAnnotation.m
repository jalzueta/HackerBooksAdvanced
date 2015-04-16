// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FLGAnnotation.m instead.

#import "_FLGAnnotation.h"

const struct FLGAnnotationAttributes FLGAnnotationAttributes = {
	.creationDate = @"creationDate",
	.modificationDate = @"modificationDate",
	.text = @"text",
	.title = @"title",
};

const struct FLGAnnotationRelationships FLGAnnotationRelationships = {
	.book = @"book",
	.location = @"location",
	.photo = @"photo",
};

@implementation FLGAnnotationID
@end

@implementation _FLGAnnotation

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Annotation" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Annotation";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Annotation" inManagedObjectContext:moc_];
}

- (FLGAnnotationID*)objectID {
	return (FLGAnnotationID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic creationDate;

@dynamic modificationDate;

@dynamic text;

@dynamic title;

@dynamic book;

@dynamic location;

@dynamic photo;

@end

