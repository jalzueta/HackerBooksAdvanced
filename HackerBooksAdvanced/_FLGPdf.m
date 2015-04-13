// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FLGPdf.m instead.

#import "_FLGPdf.h"

const struct FLGPdfAttributes FLGPdfAttributes = {
	.pdfData = @"pdfData",
};

const struct FLGPdfRelationships FLGPdfRelationships = {
	.book = @"book",
};

@implementation FLGPdfID
@end

@implementation _FLGPdf

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Pdf" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Pdf";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Pdf" inManagedObjectContext:moc_];
}

- (FLGPdfID*)objectID {
	return (FLGPdfID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic pdfData;

@dynamic book;

@end

