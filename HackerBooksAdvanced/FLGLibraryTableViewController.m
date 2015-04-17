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

-(id) initWithFetchedResultsController: (NSFetchedResultsController *) aFetchedResultsController
                                 stack: (AGTCoreDataStack *) aStack
                                 style: (UITableViewStyle) aStyle{
    
    if (self = [super initWithFetchedResultsController:aFetchedResultsController
                                                 style:aStyle]) {
        _stack = aStack;
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Nos damos de alta en las notificaciones
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(notifyThatBookDidChangeItsContent:)
                   name:BOOK_DID_CHANGE_ITS_CONTENT_NOTIFICATION_NAME
                 object:nil];
}

- (void) dealloc{
    
    // Nos damos de baja de las notificaciones - Utilizo el dealloc para que en la versión de iPhone, al volver atrás, también se actualice la lista de libros
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
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
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30.0)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.tableView.frame.size.width - 40, 30.0)];
    
    FLGTag* tag = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                                      inSection:section]];
    titleLabel.text = [tag.name capitalizedString];
    titleLabel.font = [UIFont fontWithName:@"Palatino-Bold" size:18.0];
    
    if ([tag.name isEqualToString:FAVOURITES_TAG]) {
        titleLabel.textColor = [UIColor whiteColor];
        headerView.backgroundColor = FAVOURITE_HEADER_COLOR;
    }else{
        titleLabel.textColor = [UIColor whiteColor];
        headerView.backgroundColor = CATHEGORY_HEADER_COLOR;
    }
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [headerView addSubview:titleLabel];
    return headerView;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 10.0)];
    footerView.backgroundColor = [UIColor colorWithRed:77/255.0 green:173/255.0 blue:0/255.0 alpha:1.0];
    return footerView;
}
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
        
//         //Seleccionamos la celda, si procede
//            if (book == self.selectedBook && self.showSelectedCell) {
//                [tableView selectRowAtIndexPath:indexPath
//                                       animated:YES
//                                 scrollPosition:UITableViewScrollPositionNone];
//            }
        
        // Sincronizamos modelo (personaje) -> vista (celda)
        [cell configureWithBook: b];
    }
    
    //Devolverla
    return cell;
}


#pragma mark - TableView Delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Averiguar cual es el libro
    FLGTag *tag = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:indexPath.section]];
    
    NSArray *results = [tag.books allObjects];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:YES];
    results = [results sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    if (results) {
        FLGBook *book = [results objectAtIndex:indexPath.row];
        
        // Avisar al delegado (siempre y cuando entienda el mensaje) -> bookViewController
        if ([self.delegate respondsToSelector:@selector(libraryTableViewController:didSelectBook:)]) {
            // Envio el mensaje al delegado
            [self.delegate libraryTableViewController:self didSelectBook:book];
        }
        
        // Mandamos una notificacion -> para avisar a pdfViewController
        NSNotification *note = [NSNotification notificationWithName:BOOK_DID_CHANGE_NOTIFICATION_NAME
                                                             object:self
                                                           userInfo:@{BOOK_KEY: book}];
        
        // Enviamos la notificacion
        [[NSNotificationCenter defaultCenter] postNotification:note];
        
        // Guardamos las coordenadas del ultimo personaje en NSUserDefaults
        NSData *archivedBookURI = [book archiveURIRepresentation];
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:archivedBookURI forKey:LAST_SELECTED_BOOK_ARCHIVED_URI];
        [def synchronize];
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
// BOOK_DID_CHANGE_ITS_CONTENT_NOTIFICATION_NAME
- (void) notifyThatBookDidChangeItsContent: (NSNotification *) aNotification{
    
    // Sincronizamos modelo -> vista
    [self.tableView reloadData];
}

@end
