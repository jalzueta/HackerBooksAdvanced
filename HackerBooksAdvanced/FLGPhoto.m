#import "FLGPhoto.h"

@interface FLGPhoto ()

// Private interface goes here.

@end

@implementation FLGPhoto

- (void) setImage: (UIImage *)image{
    
    // Convertir la UIImage en NSData
    self.photoData = UIImageJPEGRepresentation(image, 0.9);
}

- (UIImage *) image{
    
    // Convertir NSData en UIImage
    return [UIImage imageWithData:self.photoData];
}

@end
