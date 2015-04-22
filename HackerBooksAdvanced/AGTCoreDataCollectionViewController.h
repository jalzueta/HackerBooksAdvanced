//
//  AGTCoreDataCollectionViewController.h
//  CoreDataTest
//
//  Created by Fernando Rodríguez Romero on 16/06/14.
//  Copyright (c) 2014 Agbo. All rights reserved.
//  Forked form Ash Furrows AFMasterViewController
//  https://github.com/AshFurrow/UICollectionView-NSFetchedResultsController
//

@import Foundation;
@import CoreData;
@import UIKit;

@interface AGTCoreDataCollectionViewController : UICollectionViewController

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSString *detailViewControllerClassName;

+(instancetype) coreDataCollectionViewControllerWithFetchedResultsController:(NSFetchedResultsController *) resultsController
                                                                      layout:(UICollectionViewLayout*) layout;

-(id) initWithFetchedResultsController:(NSFetchedResultsController *) resultsController
                                layout:(UICollectionViewLayout*) layout;


@end
