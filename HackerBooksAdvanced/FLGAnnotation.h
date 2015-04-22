#import "_FLGAnnotation.h"

@interface FLGAnnotation : _FLGAnnotation {}

+ (instancetype) annotationWithTitle: (NSString *) title
                                book: (FLGBook *) book
                             context: (NSManagedObjectContext *) context;

@end
