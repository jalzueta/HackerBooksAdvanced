#import "_FLGAnnotation.h"

@interface FLGAnnotation : _FLGAnnotation {}

@property (nonatomic, readonly) BOOL hasLocation;

+ (instancetype) annotationWithTitle: (NSString *) title
                                book: (FLGBook *) book;

@end
