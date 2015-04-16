#import "FLGCover.h"
#import "FLGBook.h"

@interface FLGCover ()

// Private interface goes here.

@end

@implementation FLGCover

- (void) setImage: (UIImage *)image{
    
    // Convertir la UIImage en NSData
    self.imageData = UIImageJPEGRepresentation(image, 0.9);
}

- (UIImage *) image{
    
    // Convertir NSData en UIImage
    return [UIImage imageWithData:self.imageData];
}

@end
