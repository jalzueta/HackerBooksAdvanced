#import "FLGLocation.h"
#import "FLGAnnotation.h"

@import AddressBookUI;

@interface FLGLocation ()

// Private interface goes here.

@end

@implementation FLGLocation

+ (instancetype) locationWithCLLocation: (CLLocation *) location
                          forAnnotation: (FLGAnnotation *) annotation{
    
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[FLGLocation entityName]];
    
    NSPredicate *latitudePred = [NSPredicate predicateWithFormat:@"abs(latitude) - abs(%lf) < 0.001", location.coordinate.latitude];
    NSPredicate *longitudePred = [NSPredicate predicateWithFormat:@"abs(longitude) - abs(%lf) < 0.001", location.coordinate.longitude];
    
    NSCompoundPredicate *latLongPred = [NSCompoundPredicate andPredicateWithSubpredicates:@[latitudePred, longitudePred]];
    req.predicate = latLongPred;
    
    NSError *error;
    NSArray *results = [annotation.managedObjectContext executeFetchRequest:req
                                                                      error:&error];
    
    NSAssert(results, @"Error al buscar");
    if ([results count]) {
        FLGLocation *found = [results lastObject];
        [found addAnnotationsObject:annotation];
        return found;
    }else{
        FLGLocation *loc = [self insertInManagedObjectContext:annotation.managedObjectContext];
        
        loc.latitudeValue = location.coordinate.latitude;
        loc.longitudeValue = location.coordinate.longitude;
        
        [loc addAnnotationsObject:annotation];
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:location
                       completionHandler:^(NSArray *placemarks, NSError *error) {
                           
                           if (error) {
                               NSLog(@"Error obtaining address: %@", error);
                           }else{
                               NSDictionary *addressDict = [[placemarks lastObject] addressDictionary];
                               loc.address = [NSString stringWithFormat:@"%@, %@ %@ (%@)", [addressDict objectForKey:@"Name"], [addressDict objectForKey:@"ZIP"], [addressDict objectForKey:@"City"], [addressDict objectForKey:@"Country"]];
//                               loc.address = ABCreateStringWithAddressDictionary([[placemarks lastObject] addressDictionary], YES);
                           }
                       }];
        return loc;
    }
}

@end
