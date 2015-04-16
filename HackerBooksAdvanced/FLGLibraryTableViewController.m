//
//  FLGLibraryTableViewController.m
//  HackerBooksAdvanced
//
//  Created by Javi Alzueta on 16/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGLibraryTableViewController.h"
#import "FLGBook.h"
#import "FLGCover.h"
#import "FLGBookTableViewCell.h"
#import "FLGTag.h"
#import "AGTCoreDataStack.h"

@interface FLGLibraryTableViewController ()
@property (strong, nonatomic) AGTCoreDataStack *stack;
@end

@implementation FLGLibraryTableViewController

-(id) initWithFetchedResultsController: (NSFetchedResultsController *) aFetchedResultsController
                                 stack: (AGTCoreDataStack *) aStack
                                 style: (UITableViewStyle) aStyle{
    
    if (self = [super initWithFetchedResultsController:aFetchedResultsController
                                                 style:aStyle]) {
        _stack = aStack;
    }
    return self;
}

- (void) viewDidLoad{
    
    [super viewDidLoad];
    
    // Registramos el Nib de la celda personalizada - Lo hago aquí, porque al hacerlo en el viewWillApper, me petaba en la version iPad vertical
    UINib *nib = [UINib nibWithNibName:@"FLGBookTableViewCell"
                                bundle:[NSBundle mainBundle]];
    
    [self.tableView registerNib:nib
         forCellReuseIdentifier:[FLGBookTableViewCell cellId]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table DataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    FLGTag *tag = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    return tag.books.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80.0;
}

//- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 30.0;
//}
//
//- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
//    if ([[self.model.tags objectAtIndex:section] isEqualToString:FAVOURITES_TAG]) {
//        return 10.0;
//    }
//    return 0.0;
//}

//- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30.0)];
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.tableView.frame.size.width - 40, 30.0)];
//    titleLabel.text = [[self.model tagForIndex:section] capitalizedString];
//    titleLabel.font = [UIFont fontWithName:@"Palatino-Bold" size:18.0];
//    
//    if ([[self.model.tags objectAtIndex:section] isEqualToString:FAVOURITES_TAG]) {
//        titleLabel.textColor = [UIColor whiteColor];
//        headerView.backgroundColor = FAVOURITE_HEADER_COLOR;
//    }else{
//        titleLabel.textColor = [UIColor whiteColor];
//        headerView.backgroundColor = CATHEGORY_HEADER_COLOR;
//    }
//    titleLabel.textAlignment = NSTextAlignmentCenter;
//    
//    [headerView addSubview:titleLabel];
//    return headerView;
//}
//
//- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 10.0)];
//    footerView.backgroundColor = [UIColor colorWithRed:77/255.0 green:173/255.0 blue:0/255.0 alpha:1.0];
//    return footerView;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Averiguar cual es el libro
    FLGTag *tag = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
    
    NSArray *results = [tag.books allObjects];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    results = [results sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    FLGBookTableViewCell *cell;
    if (results) {
        FLGBook *b = [results objectAtIndex:indexPath.row];
        
        // Crear una celda
        cell = [tableView dequeueReusableCellWithIdentifier:[FLGBookTableViewCell cellId]
                                                                     forIndexPath:indexPath];
        
        // Seleccionamos la celda, si procede
        //    if (book == self.selectedBook && self.showSelectedCell) {
        //        [tableView selectRowAtIndexPath:indexPath
        //                               animated:YES
        //                         scrollPosition:UITableViewScrollPositionNone];
        //    }
        
        // Sincronizamos modelo (personaje) -> vista (celda)
        [cell configureWithBook: b];
    }
    
    //Devolverla
    return cell;
}

@end
