//
//  FLGLibraryTableViewController.h
//  HackerBooksAdvanced
//
//  Created by Javi Alzueta on 16/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "AGTCoreDataTableViewController.h"
@class AGTCoreDataStack;
@class FLGBook;
@class FLGLibraryTableViewController;

@protocol FLGLibraryTableViewControllerDelegate <NSObject>

@optional
- (void) libraryTableViewController: (FLGLibraryTableViewController *) libraryTableViewController didSelectBook: (FLGBook *) book;
- (void) libraryTableViewController: (FLGLibraryTableViewController *) libraryTableViewController didChangeFavoriteStateInBook: (FLGBook *) book;

@end

@interface FLGLibraryTableViewController : AGTCoreDataTableViewController


@property (weak, nonatomic) id <FLGLibraryTableViewControllerDelegate> delegate;
@property (strong, nonatomic) FLGBook *selectedBook;


-(id) initWithFetchedResultsController: (NSFetchedResultsController *) aFetchedResultsController
                                 stack: (AGTCoreDataStack *) aStack
                                 style: (UITableViewStyle) aStyle;

@end
