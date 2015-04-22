//
//  FLGAnnotationsTableViewController.m
//  HackerBooksAdvanced
//
//  Created by Javi Alzueta on 22/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGAnnotationsTableViewController.h"
#import "FLGBook.h"
#import "FLGAnnotation.h"
#import "FLGPhoto.h"
#import "FLGAnnotationViewController.h"

@interface FLGAnnotationsTableViewController ()
@property (strong, nonatomic) FLGBook *book;
@end

@implementation FLGAnnotationsTableViewController

- (id) initWithFetchedResultsController:(NSFetchedResultsController *)aFetchedResultsController
                                  style:(UITableViewStyle)aStyle
                                   book:(FLGBook *) book{
    
    if (self = [super initWithFetchedResultsController:aFetchedResultsController
                                                 style:aStyle]) {
        _book = book;
        self.title = book.title;
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self addNewAnnotationButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table Data Source

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Averiguar la nota
    FLGAnnotation *n = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Crear la celda
    static NSString *cellId = @"noteCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellId];
    }
    
    // Sincronizar nota -> celda
    cell.imageView.image = n.photo.image;
    cell.textLabel.text = n.title;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", n.modificationDate];
    
    // Devolverla
    return cell;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // Averiguo la nota
        FLGAnnotation *n = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        // Inmediatamente lo elimino del modelo
        [self.fetchedResultsController.managedObjectContext deleteObject:n];
        
        // Para poder mover las celdas, las "notes" tendrían que tener una propiedd "userOrder" y la cambiaríamos. Hay que tener en cuenta que el orden de las celdas viene dado por los criterios de ordenación del "fetch" que se realiza, por lo que haría falta una propiedad ordinal para esa maniobra
    }
}

#pragma mark - Table Delegate

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Averiguo la annotation
    FLGAnnotation *n = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Crear el controlador
    FLGAnnotationViewController *nVC = [[FLGAnnotationViewController alloc] initWithModel:n];
    
    // Hacer el push
    [self.navigationController pushViewController:nVC
                                         animated:YES];
}

#pragma mark - Utils

- (void) addNewAnnotationButton{
    
    UIBarButtonItem *addBtnItem = [[UIBarButtonItem alloc]
                                   initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                   target:self
                                   action:@selector(addNewAnnotation:)];
    
    self.navigationItem.rightBarButtonItem = addBtnItem;
}

#pragma mark - Actions

- (void) addNewAnnotation: (id) sender{
    
    // Creamos una nueva instancia de una libreta y Core Data se encarga de notificar al fetchResultsController, y este avisa a su delegado (el controlador AGTCoreDataTableViewController)
    [FLGAnnotation annotationWithTitle:@"Nueva nota"
                                  book:self.book
                               context:self.fetchedResultsController.managedObjectContext];
    // Todo objeto de Core Data sabe cual es su contexto, por eso se lo preguntamos a "self.fetchedResultsController"
}

@end
