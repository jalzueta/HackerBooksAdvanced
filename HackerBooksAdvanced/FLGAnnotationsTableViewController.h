//
//  FLGAnnotationsTableViewController.h
//  HackerBooksAdvanced
//
//  Created by Javi Alzueta on 22/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "AGTCoreDataTableViewController.h"

@class FLGBook;

@interface FLGAnnotationsTableViewController : AGTCoreDataTableViewController

- (id) initWithFetchedResultsController:(NSFetchedResultsController *)aFetchedResultsController
                                  style:(UITableViewStyle)aStyle
                                   book:(FLGBook *) book;

@end
