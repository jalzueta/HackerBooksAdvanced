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
#import "FLGAnnotationTableViewCell.h"

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

- (void) viewDidLoad{
    [super viewDidLoad];
    
    // Registramos el Nib de la celda personalizada - Lo hago aquí, porque al hacerlo en el viewWillApper, me petaba en la version iPad vertical
    UINib *nib = [UINib nibWithNibName:@"FLGAnnotationTableViewCell"
                                bundle:[NSBundle mainBundle]];
    
    [self.tableView registerNib:nib
         forCellReuseIdentifier:[FLGAnnotationTableViewCell cellId]];
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
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [FLGAnnotationTableViewCell height];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Averiguar la nota
    FLGAnnotation *n = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // Crear la celda
    FLGAnnotationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[FLGAnnotationTableViewCell cellId]
                                                            forIndexPath:indexPath];
    
    // Sincronizar nota -> celda
    // Sincronizamos modelo (personaje) -> vista (celda)
    [cell configureWithAnnotation: n];
    [cell observeAnnotation: n];
    
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

-(void) tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // Por si acaso y para ahorrar memoria
    // hago de limpieza de las celdas aquí
    // nates de que le llegue prepareForReuse
    FLGAnnotationTableViewCell *bCell = (FLGAnnotationTableViewCell*) cell;
    [bCell cleanUp];
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
