#import "FLGAnnotation.h"
#import "FLGPhoto.h"
#import "FLGLocation.h"
#import "FLGConstants.h"
#import "FLGLocation.h"
#import "FLGBook.h"

@import CoreLocation;

@interface FLGAnnotation ()<CLLocationManagerDelegate>

@property (nonatomic, strong) CLLocationManager *locationManager;

@end

@implementation FLGAnnotation
@synthesize locationManager = _locationManager;

- (BOOL) hasLocation{
    return (self.location != nil);
}

+ (NSArray *) observableKeys{
    // Mogenerator nos crea Constantes con los nombres de las propiedades
    //  @"photo.photoData": se refiere a la propiedad "photoData" de la propiedad "photo" --> por eso se llama keyPath
    return @[FLGAnnotationAttributes.title, FLGAnnotationAttributes.text, @"photo.image", @"location", @"location.latitude", @"location.longitude", @"location.address"];
}

+ (instancetype) annotationWithTitle: (NSString *) title
                                book: (FLGBook *) book{
    
    FLGAnnotation *n = [FLGAnnotation insertInManagedObjectContext:book.managedObjectContext];
    
    // Reglas de validación - propiedades obligatorias
    n.title = title;
    n.book = book;
    n.creationDate = [NSDate date]; // Fecha/hora actual en GMT. Si quieres la hora local, necesitarías guardar una instancia de NSTimezone
    n.modificationDate = [NSDate date];
    n.photo = [FLGPhoto insertInManagedObjectContext:book.managedObjectContext]; // Photo vacia de contenido
    
    return n;
}

#pragma mark - Init
- (void) awakeFromInsert{
    [super awakeFromInsert];
    
    // Se comprueban permisos de Localizacion
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if ([CLLocationManager locationServicesEnabled]) {
        if (status == kCLAuthorizationStatusNotDetermined) {
            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
                if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                    [self.locationManager requestAlwaysAuthorization];
                }
            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
//                if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                    [self.locationManager requestWhenInUseAuthorization];
//                }
            } else {
                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
            }
            [self.locationManager startUpdatingLocation];
        }else if (status == kCLAuthorizationStatusAuthorizedWhenInUse){
            self.locationManager = [[CLLocationManager alloc] init];
            self.locationManager.delegate = self;
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
            [self.locationManager startUpdatingLocation];
        }
    }
    
}

#pragma mark - KVO

// mensaje que se recibe siempre en KVO cuando cambia cualquiera de las propiedades observadas
- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context{
    
    // Actualizo la modificationDate
    self.modificationDate = [NSDate date];
    
    // Envio notificacion
    [self sendAnnotationDidChangeItsContentNotification];
}

- (void) sendAnnotationDidChangeItsContentNotification{
    
    if (self.managedObjectContext.hasChanges) {
        [self.managedObjectContext save:nil];
    }
    
    NSNotification *note = [NSNotification notificationWithName:ANNOTATION_DID_CHANGE_ITS_CONTENT_NOTIFICATION
                                                         object:self
                                                       userInfo:@{ANNOTATION_KEY: self}];
    
    // Enviamos la notificacion
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

#pragma mark - CLLocationManagerDelegate

- (void) locationManager:(CLLocationManager *)manager
      didUpdateLocations:(NSArray *)locations{
    
    [self.locationManager stopUpdatingLocation];
    self.locationManager = nil;
    
    CLLocation *location = [locations lastObject];
    
    self.location = [FLGLocation locationWithCLLocation: location forAnnotation: self];
}

@end
