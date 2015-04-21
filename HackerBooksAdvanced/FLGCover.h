#import "_FLGCover.h"
@import UIKit;
@class FLGCover;

@protocol FLGCoverDelegate <NSObject>

-(void) coverDidChange:(FLGCover*) cover;

@end

@interface FLGCover : _FLGCover {}
// Custom logic goes here.

// Propiedad "transient" por código: esta no va a Core Data
@property (strong, nonatomic) UIImage *coverImage;
@property (weak, nonatomic) id <FLGCoverDelegate> delegate;

+ (instancetype) coverWithContext: (NSManagedObjectContext *) context;

@end
