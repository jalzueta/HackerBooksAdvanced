//
//  FLGBookViewController.m
//  HackerBooks
//
//  Created by Javi Alzueta on 1/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGBookViewController.h"
#import "FLGBook.h"
#import "FLGConstants.h"
#import "FLGCover.h"
#import "AGTCoreDataStack.h"
#import "FLGPdfViewController.h"
//#import "FLGVfrReaderViewController.h"


@implementation FLGBookViewController

#pragma mark - Init

- (id) initWithModel: (FLGBook *) book
               stack: (AGTCoreDataStack *) stack{
    if (self = [super initWithNibName:nil
                               bundle:nil]) {
        _book = book;
        _stack = stack;
    }
    return self;
}

#pragma mark - LifeCycle

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Asegurarse de que no se ocupa toda la pantalla cuando se esta en un combinador
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Configuro la vista de inicio
    [self configView];
    
    // Sincronizo modelo -> vista(s)
    [self syncViewToModel];
    
    // Asignamos al navigationItem del controlador el boton del SplitViewController.
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    
    // Nos damos de alta en las notificaciones
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(notifyThatBookDidChangeCover:)
                   name:BOOK_DID_CHANGE_COVER_NOTIFICATION
                 object:self.book];
    
    [center addObserver:self
               selector:@selector(notifyThatBookDidChangePdf:)
                   name:BOOK_DID_CHANGE_PDF_NOTIFICATION
                 object:self.book];
    
    [center addObserver:self
               selector:@selector(notifyThatBookDidChangeFavoriteState:)
                   name:BOOK_DID_CHANGE_FAVORITE_STATE_NOTIFICATION
                 object:self.book];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // Nos damos de baja de las notificaciones
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (IBAction)displayPdf:(id)sender {
    
    [self launchPdfInWebview];
    
//    [self launchVfrReader];
}

- (IBAction)didPressFavourite:(id)sender {
//    [self.book setIsFavourite: ![self.book isFavourite]];
    
    [self syncFavouriteValue];
}

#pragma mark - UISplitViewControllerDelegate

- (void) splitViewController:(UISplitViewController *)svc willChangeToDisplayMode:(UISplitViewControllerDisplayMode)displayMode{
    
    // Averiguar si la tabla se ve o no
    if (displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
        self.navigationItem.leftBarButtonItem = svc.displayModeButtonItem;
    }else {
        self.navigationItem.leftBarButtonItem = nil;
    }
}

#pragma mark - FLGLibraryTableViewControllerDelegate
- (void) libraryTableViewController:(FLGLibraryTableViewController *)libraryTableViewController didSelectBook:(FLGBook *)book{
    
    // Actualizamos el modelo
    self.book = book;
    
    // Sincronizamos modelo -> vista
    [self syncViewToModel];
}

#pragma mark - Notifications
// BOOK_DID_CHANGE_COVER_NOTIFICATION
- (void) notifyThatBookDidChangeCover: (NSNotification *) aNotification{
    [self syncCoverValue];
}

// BOOK_DID_CHANGE_PDF_NOTIFICATION
- (void) notifyThatBookDidChangePdf: (NSNotification *) aNotification{
    [self syncPdfValue];
}

// BOOK_DID_CHANGE_FAVORITE_STATE_NOTIFICATION
- (void) notifyThatBookDidChangeFavoriteState: (NSNotification *) aNotification{
    [self syncFavouriteValue];
}

#pragma mark - Utils
- (void) configView{
    self.bookImage.layer.shadowColor = [UIColor whiteColor].CGColor;
    self.bookImage.layer.masksToBounds = NO;
    self.bookImage.layer.shadowOffset = CGSizeMake(5, 5);
    self.bookImage.layer.shadowOpacity = 0.5;
    
//    self.bookDataView.backgroundColor = SELECTED_CELL_BACKGROUND_COLOR;
}

- (void) syncViewToModel{
    self.title = self.book.title;
    
    self.bookTitle.text = self.book.title;
    self.authors.text = [NSString stringWithFormat:@"Authors: %@", [self.book authorsString]];
    self.tags.text = [NSString stringWithFormat:@"Tags: %@", [self.book tagsString]];
    
    [self syncCoverValue];
    [self syncPdfValue];
    [self syncFavouriteValue];
}

- (void) syncCoverValue{
    self.backgroundBookImage.image = self.book.cover.coverImage;
    self.bookImage.image = self.book.cover.coverImage;
}

- (void) syncPdfValue{
    self.savedOnDiskImage.hidden = ![self.book savedIntoDisk];
}

- (void) syncFavouriteValue{
    if (self.book.isFavourite) {
        self.favouriteImage.image = [UIImage imageNamed:FAVOURITE_ON_IMAGE_NAME];
    } else{
        self.favouriteImage.image = [UIImage imageNamed:FAVOURITE_OFF_IMAGE_NAME];
    }
}

- (void) launchPdfInWebview{
    //    // Crear un pdfVC
        FLGPdfViewController *pdfVC = [[FLGPdfViewController alloc] initWithModel:self.book];
    
    //    // Hacer un push usando la propiedad "navigationController" que tiene todo UIViewController
        [self.navigationController pushViewController:pdfVC animated:YES];
}

- (void) launchVfrReader{
    //    // Crear un vfrReaderVC
    //    FLGVfrReaderViewController *vfrVC = [[FLGVfrReaderViewController alloc] initWithModel:self.model];
    //
    //    // Hacer un push usando la propiedad "navigationController" que tiene todo UIViewController
    ////    [self presentViewController:vfrVC animated:YES completion:nil];
    //    [self.navigationController pushViewController:vfrVC animated:YES];
}


@end
