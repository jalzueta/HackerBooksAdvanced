#import "FLGPhoto.h"
#import "FLGConstants.h"

@interface FLGPhoto ()

// Private interface goes here.

@end

@implementation FLGPhoto

#pragma mark - Class Methods
+ (NSArray *) observableKeys{
    // Mogenerator nos crea Constantes con los nombres de las propiedades
    //  @"photo.photoData": se refiere a la propiedad "photoData" de la propiedad "photo" --> por eso se llama keyPath
    return @[FLGPhotoAttributes.photoData];
}

#pragma mark - Properties
- (void) setImage: (UIImage *)image{
    
    // Convertir la UIImage en NSData
    self.photoData = UIImageJPEGRepresentation(image, 0.9);
}

- (UIImage *) image{
    
    // Convertir NSData en UIImage
    if (!self.photoData) {
        return [UIImage imageNamed:@"no_image.png"];
    }
    return [UIImage imageWithData:self.photoData];
}

#pragma mark - KVO

// mensaje que se recibe siempre en KVO cuando cambia cualquiera de las propiedades observadas
- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context{
    
    // Envio la notificacion
    [self sendPhotoDidChangePhotoNotification];
}


- (void) sendPhotoDidChangePhotoNotification{
    NSNotification *note = [NSNotification notificationWithName:PHOTO_DID_CHANGE_PHOTO
                                                         object:self
                                                       userInfo:@{PHOTO_KEY: self}];
    
    // Enviamos la notificacion
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

@end
