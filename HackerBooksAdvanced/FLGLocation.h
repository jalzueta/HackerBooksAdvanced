#import "_FLGLocation.h"

@import CoreLocation;
@class FLGAnnotation;

@interface FLGLocation : _FLGLocation {}

+ (instancetype) locationWithCLLocation: (CLLocation *) location
                          forAnnotation: (FLGAnnotation *) annotation;

@end
