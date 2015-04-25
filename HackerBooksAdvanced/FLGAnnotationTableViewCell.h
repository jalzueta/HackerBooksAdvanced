//
//  FLGAnnotationTableViewCell.h
//  HackerBooks
//
//  Created by Javi Alzueta on 2/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FLGAnnotation;

@interface FLGAnnotationTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *annotationImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *modificationDateView;
@property (weak, nonatomic) IBOutlet UIImageView *locationView;

+ (CGFloat) height;
+ (NSString *) cellId;

- (void) configureWithAnnotation: (FLGAnnotation *) annotation;
- (void) observeAnnotation:(FLGAnnotation*) annotation;

- (void) cleanUp;

@end
