//
//  FLGLibraryTableViewController.h
//  HackerBooksAdvanced
//
//  Created by Javi Alzueta on 16/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "AGTCoreDataTableViewController.h"
@class AGTCoreDataStack;

@interface FLGLibraryTableViewController : AGTCoreDataTableViewController

-(id) initWithFetchedResultsController: (NSFetchedResultsController *) aFetchedResultsController
                                 stack: (AGTCoreDataStack *) aStack
                                 style: (UITableViewStyle) aStyle;

@end
