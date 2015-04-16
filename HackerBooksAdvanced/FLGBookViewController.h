//
//  FLGBookViewController.h
//  HackerBooks
//
//  Created by Javi Alzueta on 1/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

@import UIKit;
@class FLGBook;
@class FLGBookViewController;
#import "FLGLibraryTableViewController.h"

@protocol FLGBookViewControllerDelegate <NSObject>

@optional

- (void) bookViewController: (FLGBookViewController *) bookViewController didChangeBook: (FLGBook *) book;

@end

@interface FLGBookViewController : UIViewController<UISplitViewControllerDelegate, FLGLibraryTableViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *bookDataView;
@property (weak, nonatomic) IBOutlet UILabel *bookTitle;
@property (weak, nonatomic) IBOutlet UILabel *authors;
@property (weak, nonatomic) IBOutlet UILabel *tags;
@property (weak, nonatomic) IBOutlet UIImageView *bookImage;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundBookImage;
@property (weak, nonatomic) IBOutlet UIImageView *favouriteImage;
@property (weak, nonatomic) IBOutlet UIImageView *savedOnDiskImage;

@property (weak, nonatomic) id <FLGBookViewControllerDelegate> delegate;

@property (strong, nonatomic) FLGBook *book;

- (id) initWithModel: (FLGBook *) book;

- (IBAction)displayPdf:(id)sender;
- (IBAction)didPressFavourite:(id)sender;

@end
