// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FLGAuthor.m instead.

#import "_FLGAuthor.h"

const struct FLGAuthorAttributes FLGAuthorAttributes = {
	.name = @"name",
};

const struct FLGAuthorRelationships FLGAuthorRelationships = {
	.book = @"book",
};

@implementation FLGAuthorID
@end

@implementation _FLGAuthor

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Author" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Author";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Author" inManagedObjectContext:moc_];
}

- (FLGAuthorID*)objectID {
	return (FLGAuthorID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic name;

@dynamic book;

- (NSMutableSet*)bookSet {
	[self willAccessValueForKey:@"book"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"book"];

	[self didAccessValueForKey:@"book"];
	return result;
}

@end

