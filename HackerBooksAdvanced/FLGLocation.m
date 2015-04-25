#import "FLGLocation.h"
#import "FLGAnnotation.h"

@import AddressBookUI;

@interface FLGLocation ()

// Private interface goes here.

@end

@implementation FLGLocation

+ (instancetype) locationWithCLLocation: (CLLocation *) location
                          forAnnotation: (FLGAnnotation *) annotation{
    
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
                           loc.address = ABCreateStringWithAddressDictionary([[placemarks lastObject] addressDictionary], YES);
                       }
                   }];
    return loc;
}

@end
