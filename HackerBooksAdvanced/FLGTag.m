#import "FLGTag.h"
#import "FLGConstants.h"
#import "AGTCoreDataStack+FetchWithContext.h"

@interface FLGTag () <NSCopying>

// Private interface goes here.

@end

@implementation FLGTag

// Custom logic goes here.

+ (instancetype) tagWithName: (NSString *) name
                     context: (NSManagedObjectContext *) context{
    
    // Search for the Tags in Core Data:
    // If a tag already exists, I add it to the book.
    // If not, I create the tag before adding it to the book
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[FLGTag entityName]];
    
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:FLGTagAttributes.name
                                                          ascending:YES
                                                           selector:@selector(caseInsensitiveCompare:)]];
    
    req.predicate = [NSPredicate predicateWithFormat:@"name = %@", name];
    
    NSArray *results = [AGTCoreDataStack executeFetchRequest:req
                                                     context:context
                                       errorBlock:^(NSError *error) {
                                           NSLog(@"Error al buscar! %@", error);
                                       }];
    
    if (results.count > 0) {
        return [results firstObject];
    }
    else{
        FLGTag *tag = [self insertInManagedObjectContext:context];
        tag.name = name;
        
        return tag;
    }
}

+ (instancetype) favoriteTagWithContext:(NSManagedObjectContext *)context{
    
    return [self tagWithName:FAVOURITES_TAG context:context];
}


-(NSString*) normalizedName{
    return self.name;
}

#pragma mark - Utils
-(NSString*) normalizeCase:(NSString*) aString{
    
    NSString *norm;
    
    if (aString.length <= 1) {
        norm = [aString capitalizedString];
    } else {
        norm = [NSString stringWithFormat:@"%@%@",[[aString substringToIndex:1] uppercaseString],[[aString substringFromIndex:1]lowercaseString]];
    }
    return norm;
}

#pragma mark - Comparison
- (NSComparisonResult)compare:(FLGTag *)other{
    
    /* favorite always comes first */
    
    if ([[self normalizedName] isEqualToString:[other normalizedName]]) {
        return NSOrderedSame;
    }else if ([[self normalizedName] isEqualToString:FAVOURITES_TAG]){
        return NSOrderedAscending;
    }else if ([[other normalizedName] isEqualToString:FAVOURITES_TAG]){
        return NSOrderedDescending;
    }else{
        return [self.name compare:other.normalizedName];
    }
}

#pragma mark - NSCopying
/** Every class that might be used as a key in a Dict must implement NSCopying
 as keys are always copied.
 
 Since bookTags are immutable, we just return self: no real copying.
 */
- (id)copyWithZone:(NSZone *)zone{
    return self;
}

#pragma mark - NSObject
-(NSString*) description{
    return [NSString stringWithFormat:@"<%@: %@>",
            [self class], [self normalizedName]];
}

//-(BOOL) isEqual:(id)object{
//    
//    if (object == self) {
//        return YES;
//    }
//    
//    if (![object isKindOfClass:[self class]]) {
//        return NO;
//    }else{
//        return [self.name isEqualToString: [object name]];
//    }
//}
//-(NSUInteger)hash{
//    return [self.name hash];
//}

@end
