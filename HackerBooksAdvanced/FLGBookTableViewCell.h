//
//  FLGBookTableViewCell.h
//  HackerBooks
//
//  Created by Javi Alzueta on 2/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FLGBook;

@interface FLGBookTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *bookImage;
@property (weak, nonatomic) IBOutlet UIImageView *downloadIcon;
@property (weak, nonatomic) IBOutlet UIImageView *favouriteIcon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *authors;

+ (NSString *) cellId;

- (void) configureWithBook: (FLGBook *) book;

@end
