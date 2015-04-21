#import "_FLGPdf.h"
@class FLGPdf;

@protocol FLGPdfDelegate <NSObject>

-(void) pdfDidChange:(FLGPdf*) pdf;

@end

@interface FLGPdf : _FLGPdf {}

@property (weak, nonatomic) id <FLGPdfDelegate> delegate;

- (NSData *) pdfEndData;

+ (instancetype) pdfWithContext: (NSManagedObjectContext *) context;

@end
