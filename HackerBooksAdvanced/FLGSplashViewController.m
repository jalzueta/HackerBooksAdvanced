//
//  FLGSplashViewController.m
//  HackerBooksAdvanced
//
//  Created by Javi Alzueta on 17/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGSplashViewController.h"
#import "AGTCoreDataStack.h"
#import "FLGTag.h"
#import "FLGLibraryTableViewController.h"
#import "UIViewController+Navigation.h"
#import "FLGBookViewController.h"
#import "FLGConstants.h"
#import "FLGBook.h"

@interface FLGSplashViewController ()
@property (nonatomic) BOOL shouldAnimate;
@property (strong, nonatomic) AGTCoreDataStack *stack;
@property (strong, nonatomic) FLGLibraryTableViewController *libraryVC;
@end

@implementation FLGSplashViewController

- (instancetype) initWithStack: (AGTCoreDataStack *) stack{
    
    if (self = [super initWithNibName:nil
                               bundle:nil]) {
        
        _shouldAnimate = YES;
        _stack = stack;
    }
    return self;
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self launchAnimation1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) launchAnimation1{
    
    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear;
    
    NSTimeInterval step = 0.5;
    
    // Traslacion
    [UIView animateWithDuration:step
                          delay:0
                        options:options
                     animations:^{
                         self.bookImage.layer.transform = CATransform3DMakeRotation(M_PI/2, 0.0, 1.0, 0.0);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:step
                                               delay:0
                                             options:options
                                          animations:^{
                                              self.bookImage.layer.transform = CATransform3DMakeRotation(M_PI, 0.0, 1.0, 0.0);
                                          } completion:^(BOOL finished) {
                                              [UIView animateWithDuration:step
                                                                    delay:0
                                                                  options:options
                                                               animations:^{
                                                                   self.bookImage.layer.transform = CATransform3DMakeRotation(3 * M_PI/2, 0.0, 1.0, 0.0);
                                                               } completion:^(BOOL finished) {
                                                                   [UIView animateWithDuration:step
                                                                                         delay:0
                                                                                       options:options
                                                                                    animations:^{
                                                                                        self.bookImage.layer.transform = CATransform3DMakeRotation(2 * M_PI, 0.0, 1.0, 0.0);
                                                                                    } completion:^(BOOL finished) {
                                                                                        if (self.shouldAnimate) {
                                                                                            [self launchAnimation2];
                                                                                        }else{
                                                                                            [self launchApp];
                                                                                        }
                                                                                    }];

                                                               }];

                                          }];
                     }];
    
}

- (void) launchAnimation2{
    
    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear;
    
    NSTimeInterval step = 0.5;
    
    // Traslacion
    [UIView animateWithDuration:step
                          delay:0
                        options:options
                     animations:^{
                         self.bookImage.layer.transform = CATransform3DMakeRotation(M_PI/2, 1.0, 0.0, 0.0);
                     } completion:^(BOOL finished) {
                         [UIView animateWithDuration:step
                                               delay:0
                                             options:options
                                          animations:^{
                                              self.bookImage.layer.transform = CATransform3DMakeRotation(M_PI, 1.0, 0.0, 0.0);
                                          } completion:^(BOOL finished) {
                                              [UIView animateWithDuration:step
                                                                    delay:0
                                                                  options:options
                                                               animations:^{
                                                                   self.bookImage.layer.transform = CATransform3DMakeRotation(3 * M_PI/2, 1.0, 0.0, 0.0);
                                                               } completion:^(BOOL finished) {
                                                                   [UIView animateWithDuration:step
                                                                                         delay:0
                                                                                       options:options
                                                                                    animations:^{
                                                                                        self.bookImage.layer.transform = CATransform3DMakeRotation(2 * M_PI, 1.0, 0.0, 0.0);
                                                                                    } completion:^(BOOL finished) {
                                                                                        if (self.shouldAnimate) {
                                                                                            [self launchAnimation1];
                                                                                        }else{
                                                                                            [self launchApp];
                                                                                        }
                                                                                    }];
                                                                   
                                                               }];
                                              
                                          }];
                     }];
    
}


#pragma mark - AppDelegateDelegate
- (void) didFinishSavingBooksInAppDelegate:(AppDelegate *)appDelegate{
    
    // Desactivo el bucle de la animacion - Al terminar esta iteracion, se lanzara la App
    self.shouldAnimate = NO;
}

- (void) launchApp{
    
    // Tenemos que hacer la busqueda de libros
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
    
    // Detectamos el tipo de pantalla
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        // Tipo tableta
        [self configureForPadWithModel:fc];
    }else{
        
        // Tipo telefono
        [self configureForPhoneWithModel:fc];
    }
}

- (void) configureForPadWithModel: (NSFetchedResultsController *) fc{
    
    FLGBook *lastSelectedBook = [self lastSelectedBookInContext];
    
    // Creamos el controller
    self.libraryVC = [[FLGLibraryTableViewController alloc]
                      initWithFetchedResultsController: fc
                      stack: self.stack
                      style: UITableViewStyleGrouped
                      showSelectedCell:YES];
    
    // Creamos un BookVC
    FLGBookViewController *bookVC = [[FLGBookViewController alloc] initWithModel:lastSelectedBook
                                                                           stack:self.stack];
    
    UISplitViewController *spliVC = [[UISplitViewController alloc] init];
    spliVC.viewControllers = @[[self.libraryVC wrappedInNavigationController], [bookVC wrappedInNavigationController]];
    
    // Asignamos delegados
    spliVC.delegate = bookVC;
    self.libraryVC.delegate = bookVC;
    
    spliVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:spliVC
                       animated:YES
                     completion:^{
                         
                     }];
}

- (void) configureForPhoneWithModel: (NSFetchedResultsController *) fc{
    // Creamos el controller
    self.libraryVC = [[FLGLibraryTableViewController alloc]
                      initWithFetchedResultsController: fc
                      stack: self.stack
                      style: UITableViewStylePlain
                      showSelectedCell:NO];
    
    // Asignamos delegados
    self.libraryVC.delegate = self.libraryVC;
    
    self.libraryVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:[self.libraryVC wrappedInNavigationController]
                       animated:YES
                     completion:^{
                         
                     }];
}

- (FLGBook *) lastSelectedBookInContext{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *archivedUri = [defaults objectForKey:LAST_SELECTED_BOOK_ARCHIVED_URI];
    
    if (archivedUri) {
        return [FLGBook objectWithArchivedURIRepresentation:archivedUri
                                                    context:self.stack.context];
    }else{
        NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[FLGBook entityName]];
        
        req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:FLGBookAttributes.title
                                                              ascending:YES selector:@selector(caseInsensitiveCompare:)]];
        
        req.fetchBatchSize = 20;
        
        // Creamos un FetchedResultsController
        NSFetchedResultsController *fc = [[NSFetchedResultsController alloc]
                                          initWithFetchRequest:req
                                          managedObjectContext:self.stack.context
                                          sectionNameKeyPath:nil
                                          cacheName:nil];
        
        
        return [fc.fetchedObjects firstObject];
    }
}

@end
