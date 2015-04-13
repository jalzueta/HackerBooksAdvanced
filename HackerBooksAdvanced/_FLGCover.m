// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FLGCover.m instead.

#import "_FLGCover.h"

const struct FLGCoverAttributes FLGCoverAttributes = {
	.imageData = @"imageData",
};

const struct FLGCoverRelationships FLGCoverRelationships = {
	.book = @"book",
};

@implementation FLGCoverID
@end

@implementation _FLGCover

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Cover" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Cover";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Cover" inManagedObjectContext:moc_];
}

- (FLGCoverID*)objectID {
	return (FLGCoverID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic imageData;

@dynamic book;

@end

