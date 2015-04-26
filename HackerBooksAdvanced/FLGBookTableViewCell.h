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

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UIImageView *downloadIconView;
@property (weak, nonatomic) IBOutlet UIImageView *favouriteIconView;
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UILabel *authorsView;

@property (nonatomic, strong) FLGBook *book;

- (IBAction)favoriteDidPressed:(id)sender;

+ (CGFloat) height;
+ (NSString *) cellId;

- (void) configureWithBook: (FLGBook *) book;
- (void) observeBook:(FLGBook*) book;

- (void) cleanUp;

@end
