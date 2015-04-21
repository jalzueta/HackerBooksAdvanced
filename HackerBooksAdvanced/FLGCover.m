#import "FLGCover.h"
#import "FLGBook.h"
#import "AGTAsyncImage.h"
#import "FLGConstants.h"

@interface FLGCover ()

@end

@implementation FLGCover
@synthesize delegate;

- (void) setCoverImage:(UIImage *)coverImage{
    
    // Convertir la UIImage en NSData
    self.imageData = UIImageJPEGRepresentation(coverImage, 0.9);
}

- (UIImage *) coverImage{
    
    // Convertir NSData en UIImage
    if (!self.imageData) {
        UIImage *defaultImage = [UIImage imageNamed:@"no_image.png"];
        self.imageData = UIImageJPEGRepresentation(defaultImage, 0.9);
        [self downloadCover];
    }
    return [UIImage imageWithData:self.imageData];
}

+ (instancetype) coverWithContext: (NSManagedObjectContext *) context{
    
    FLGCover *cover = [self insertInManagedObjectContext: context];
    
    return cover;
}

- (void) downloadCover{
    dispatch_queue_t cover_download = dispatch_queue_create("cover", 0);
    dispatch_async(cover_download,
                   ^{
                       NSLog(@"coverURL: %@", self.book.coverURL);
                       NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.book.coverURL]];
                       
                       dispatch_async(dispatch_get_main_queue(), ^{
                           // Lo hago en primer plano para asegurarme de
                           // todas las ntificaciones van en la ocla
                           // principal
                           [self coverImageDataWithData:data];
                       });
                   });
}

#pragma mark - Utils
- (void) coverImageDataWithData: (NSData *) data{
    self.imageData = data; // Launch KVO notification
    [self notifyChanges];
}

#pragma mark - Notifications
-(void) notifyChanges{
    
    NSNotification *n = [NSNotification
                         notificationWithName:COVER_DID_CHANGE_NOTIFICATION
                         object:self
                         userInfo:@{COVER_KEY : self}];
    
    [[NSNotificationCenter defaultCenter] postNotification:n];
    
    // Avisamos tambien al delegado en caso de haberlo
    if ([self.delegate respondsToSelector:@selector(coverDidChange:)]) {
        // Envio el mensaje al delegado
        [self.delegate coverDidChange:self];
    }
}

@end
