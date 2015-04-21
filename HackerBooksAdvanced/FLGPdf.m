#import "FLGPdf.h"
#import "FLGConstants.h"
#import "FLGBook.h"

@interface FLGPdf ()

@property (strong, nonatomic) NSData *pdfEndData;

@end

@implementation FLGPdf
@synthesize delegate;

- (void) setPdfEndData:(NSData *)pdfEndData{
    self.pdfData = pdfEndData;
}

- (NSData *) pdfEndData{
    if (!self.pdfData) {
        [self downloadPdf];
    }
    return self.pdfData;
}

+ (instancetype) pdfWithContext: (NSManagedObjectContext *) context{
    
    FLGPdf *pdf = [self insertInManagedObjectContext: context];
    
    return pdf;
}

- (void) downloadPdf{
    dispatch_queue_t pdf_download = dispatch_queue_create("pdf", 0);
    dispatch_async(pdf_download,
                   ^{
                       NSLog(@"pdfURL: %@", self.book.pdfURL);
                       NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.book.pdfURL]];
                       
                       dispatch_async(dispatch_get_main_queue(), ^{
                           // Lo hago en primer plano para asegurarme de
                           // todas las ntificaciones van en la ocla
                           // principal
                           [self pdfDataWithData:data];
                       });
                   });
}

#pragma mark - Utils
- (void) pdfDataWithData: (NSData *) data{
    self.pdfData = data; // Launch KVO notification
    [self notifyChanges];
}

#pragma mark - Notifications
-(void) notifyChanges{
    
    NSNotification *n = [NSNotification
                         notificationWithName:PDF_DID_CHANGE_NOTIFICATION
                         object:self
                         userInfo:@{PDF_KEY : self}];
    
    [[NSNotificationCenter defaultCenter] postNotification:n];
    
    // Avisamos tambien al delegado en caso de haberlo
    if ([self.delegate respondsToSelector:@selector(pdfDidChange:)]) {
        // Envio el mensaje al delegado
        [self.delegate pdfDidChange:self];
    }
}

@end
