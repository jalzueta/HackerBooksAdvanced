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

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self launchAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) launchAnimation{
    
    UIViewAnimationOptions options = UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear;
    
    NSTimeInterval step = 0.3;
    
    // Traslacion
    [UIView animateWithDuration:step
                          delay:0
                        options:options
                     animations:^{
                         self.bookImage.transform = CGAffineTransformMakeRotation(M_PI/2);
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    [UIView animateWithDuration:step
                          delay:step
                        options:options
                     animations:^{
                         self.bookImage.transform = CGAffineTransformMakeRotation(M_PI);
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    [UIView animateWithDuration:step
                          delay:2*step
                        options:options
                     animations:^{
                         self.bookImage.transform = CGAffineTransformMakeRotation(3*M_PI/2);
                         
                     } completion:^(BOOL finished) {
                         
                     }];
    [UIView animateWithDuration:step
                          delay:3*step
                        options:options
                     animations:^{
                         self.bookImage.transform = CGAffineTransformMakeRotation(2*M_PI);
                         
                     } completion:^(BOOL finished) {
                         if (self.shouldAnimate) {
                             [self launchAnimation];
                         }else{
                             [self launchApp];
                         }
                     }];
}


#pragma mark - AppDelegateDelegate
- (void) didFinishSavingBooksInAppDelegate:(AppDelegate *)appDelegate{
    
    // Desactivo el bucle de la animacion - Al terminar esta iteracion, se lanzara la App
    self.shouldAnimate = NO;
}

- (void) launchApp{
    
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[FLGTag entityName]];
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:FLGTagAttributes.name
                                                          ascending:YES selector:@selector(caseInsensitiveCompare:)]];
    
    req.fetchBatchSize = 20;
    
    // Creamos un FetchedResultsController
    NSFetchedResultsController *fc = [[NSFetchedResultsController alloc]
                                      initWithFetchRequest:req
                                      managedObjectContext:self.stack.context
                                      sectionNameKeyPath:FLGTagAttributes.name
                                      cacheName:nil];
    
    // Creamos el controller
    self.libraryVC = [[FLGLibraryTableViewController alloc]
                      initWithFetchedResultsController: fc
                      stack: self.stack
                      style: UITableViewStylePlain];
    
    // Asignamos delegados
    self.libraryVC.delegate = self.libraryVC;
    
    self.libraryVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:[self.libraryVC wrappedInNavigationController]
                       animated:YES
                     completion:^{
                         
                     }];
}

@end
