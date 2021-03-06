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
#import "FLGBookViewController.h"
#import "FLGConstants.h"

@interface FLGLibraryTableViewController ()
@property (strong, nonatomic) AGTCoreDataStack *stack;
@end

@implementation FLGLibraryTableViewController

- (id) initWithFetchedResultsController: (NSFetchedResultsController *) aFetchedResultsController
                                  stack: (AGTCoreDataStack *) aStack
                                  style: (UITableViewStyle) aStyle
                       showSelectedCell: (BOOL) aShowSelectedCellValue{
    
    if (self = [super initWithFetchedResultsController:aFetchedResultsController
                                                 style:aStyle]) {
        _stack = aStack;
        _showSelectedCell = aShowSelectedCellValue;
        self.title = @"Hacker Books PRO";
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

- (void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(notifyThatFavoriteStateDidChange:)
               name:BOOK_DID_CHANGE_FAVORITE_STATE_NOTIFICATION
             object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table DataSource

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    FLGTag *tag = [self.fetchedResultsController.fetchedObjects objectAtIndex:section];
    return tag.books.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [FLGBookTableViewCell height];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30.0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    FLGTag* tag = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                                      inSection:section]];
    if ([tag.name isEqualToString:FAVOURITES_TAG]) {
        return 10.0;
    }
    return 0.0;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    FLGTag* tag = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                                      inSection:section]];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30.0)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.tableView.frame.size.width - 40, 30.0)];
    
    
    
    titleLabel.text = [tag.name capitalizedString];
    titleLabel.font = [UIFont fontWithName:@"Palatino-Bold" size:18.0];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [headerView addSubview:titleLabel];
    
    
    if ([tag.name isEqualToString:FAVOURITES_TAG]) {
        headerView.backgroundColor = FAVOURITE_HEADER_COLOR;
    }else{
        headerView.backgroundColor = CATHEGORY_HEADER_COLOR;
    }
    return headerView;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    FLGTag* tag = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                    inSection:section]];
    if ([tag.name isEqualToString:FAVOURITES_TAG]) {
        
        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 10.0)];
        footerView.backgroundColor = [UIColor colorWithRed:77/255.0 green:173/255.0 blue:0/255.0 alpha:1.0];
        return footerView;
    }
    return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Averiguar cual es el libro
    FLGBook *b = [self bookAtIndexPath:indexPath];
    FLGBookTableViewCell *cell;
    if (b) {
        
        // Crear una celda
        cell = [tableView dequeueReusableCellWithIdentifier:[FLGBookTableViewCell cellId]
                                                                     forIndexPath:indexPath];
        
        //Seleccionamos la celda, si procede
        if (b == self.selectedBook && self.showSelectedCell) {
            [tableView selectRowAtIndexPath:indexPath
                                   animated:YES
                             scrollPosition:UITableViewScrollPositionNone];
        }
        
        // Sincronizamos modelo (personaje) -> vista (celda)
        [cell configureWithBook: b];
        [cell observeBook:b];
    }
    
    //Devolverla
    return cell;
}


#pragma mark - TableView Delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Averiguar cual es el libro
    FLGBook *book = [self bookAtIndexPath:indexPath];
    if (book) {
        
        self.selectedBook = book;
        
        // Avisar al delegado (siempre y cuando entienda el mensaje) -> bookViewController
        if ([self.delegate respondsToSelector:@selector(libraryTableViewController:didSelectBook:)]) {
            // Envio el mensaje al delegado
            [self.delegate libraryTableViewController:self didSelectBook:book];
        }
        
        // Mandamos una notificacion -> para avisar a pdfViewController
        NSNotification *note = [NSNotification notificationWithName:BOOK_DID_CHANGE_NOTIFICATION
                                                             object:self
                                                           userInfo:@{BOOK_KEY: book}];
        
        // Enviamos la notificacion
        [[NSNotificationCenter defaultCenter] postNotification:note];
        
        // Guardamos en NSUserDefaults el libro seleccionado
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[book archiveURIRepresentation] forKey:LAST_SELECTED_BOOK_ARCHIVED_URI];
        [defaults synchronize];
    }
}

#pragma mark - FLGLibraryTableViewControllerDelegate

- (void) libraryTableViewController:(FLGLibraryTableViewController *)libraryTableViewController didSelectBook:(FLGBook *)book{
    
    // Creamos un BookVC
    FLGBookViewController *bookVC = [[FLGBookViewController alloc] initWithModel:book
                                                                           stack:self.stack];
    // Hago un push
    [self.navigationController pushViewController:bookVC animated:YES];
}

#pragma mark - Notifications

// BOOK_DID_CHANGE_FAVORITE_STATE_NOTIFICATION
- (void) notifyThatFavoriteStateDidChange: (NSNotification *) aNotification{
//    FLGBook *b = [aNotification.userInfo objectForKey:BOOK_KEY];
    
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[FLGTag entityName]];
    // Implementar el metodo "compare" que ha hecho fernando para los tags
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                          ascending:YES
                                                           selector:@selector(compare:)]];
    
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:FLGTagAttributes.name
                                                          ascending:YES selector:@selector(caseInsensitiveCompare:)]];
    
    req.fetchBatchSize = 20;
    
    // Creamos un FetchedResultsController
    NSFetchedResultsController *fc = [[NSFetchedResultsController alloc]
                                      initWithFetchRequest:req
                                      managedObjectContext:self.stack.context
                                      sectionNameKeyPath:FLGTagAttributes.name
                                      cacheName:nil];
    
    [self setFetchedResultsController:fc];
    
//    [self.fetchedResultsController performFetch:nil];
}


#pragma mark - UISearchResultsUpdating

- (void) updateSearchResultsForSearchController:(UISearchController *)searchController{
    
}


#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
//    [super controllerWillChangeContent:controller];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
//    [super controller:controller
//     didChangeSection:sectionInfo
//              atIndex:sectionIndex
//        forChangeType:type];
}


- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
//    [super controller:controller
//      didChangeObject:anObject
//          atIndexPath:indexPath
//        forChangeType:type
//         newIndexPath:newIndexPath];
    
//    FLGTag *tag = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
//    
//    if (![tag isFavoriteTag]) {
//        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }else{
//        FLGBookTableViewCell *cell = (FLGBookTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
//        FLGBook *b = [cell book];
//        NSLog(@"IndexPath: %ld", (long)indexPath.row);
//        NSLog(@"NewIndexPath: %ld", (long)newIndexPath.row);
//        if (!b) {
//            // Es el primer favorito
//            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//        }else{
//            if (b.isFavourite) {
//                [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
//            }else{
//                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//            }
//        }
//    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
//    [super controllerDidChangeContent:controller];
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
//{
//    return [super sectionIndexTitlesForTableView:tableView];
//}



#pragma mark - Utils

- (FLGBook *) bookAtIndexPath: (NSIndexPath *) indexPath{
    // Averiguar cual es el libro
    FLGTag *tag = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
    
    NSArray *results = [tag.books allObjects];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    results = [results sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    if (results.count > 0) {
        FLGBook *book = [results objectAtIndex:indexPath.row];
        return book;
    }
    else{
        return nil;
    }
}

@end
