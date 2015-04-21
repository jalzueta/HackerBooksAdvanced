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

@end

@interface FLGLibraryTableViewController : AGTCoreDataTableViewController<FLGLibraryTableViewControllerDelegate, UISearchResultsUpdating>


@property (weak, nonatomic) id <FLGLibraryTableViewControllerDelegate> delegate;
@property (strong, nonatomic) FLGBook *selectedBook;
@property (nonatomic) BOOL showSelectedCell;

- (id) initWithFetchedResultsController: (NSFetchedResultsController *) aFetchedResultsController
                                 stack: (AGTCoreDataStack *) aStack
                                 style: (UITableViewStyle) aStyle
                      showSelectedCell: (BOOL) aShowSelectedCellValue;


@end
