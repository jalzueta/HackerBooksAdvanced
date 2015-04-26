//
//  AppDelegate.m
//  HackerBooksAdvanced
//
//  Created by Javi Alzueta on 13/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "AppDelegate.h"
#import "AGTCoreDataStack.h"
#import "FLGConstants.h"
#import "FLGBook.h"
#import "FLGTag.h"
#import "FLGAuthor.h"
#import "FLGAnnotation.h"
#import "FLGLocation.h"
#import "FLGLibraryTableViewController.h"
#import "UIViewController+Navigation.h"
#import "FLGSplashViewController.h"

@interface AppDelegate ()
@property (strong, nonatomic) AGTCoreDataStack *stack;
@property (strong, nonatomic) FLGLibraryTableViewController *libraryVC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Creamos una instancia del Core Data Stack
    self.stack = [AGTCoreDataStack coreDataStackWithModelName:@"Model"];
    
    
    
    // Creo el controlador de inicio: animacion durante la carga inicial de datos
    FLGSplashViewController *splashVC = [[FLGSplashViewController alloc] initWithStack:self.stack];
    self.delegate = splashVC;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.window.rootViewController = splashVC;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // Se comprueba a ver si se ha descargado el modelo anteriormente
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if (![def objectForKey:IS_MODEL_DOWNLOADED]) {
        // crear una cola
        dispatch_queue_t json_download = dispatch_queue_create("json", 0);
        
        dispatch_async(json_download, ^{
            
            // Borro los datos de Core Data
//            [self.stack zapAllData];
            
            // Descarga de datos de libros - JSON
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:JSON_DOWNLOAD_URL]];
            NSURLResponse *response = [[NSURLResponse alloc] init];
            NSError *err;
            NSData *booksJSONData = [NSURLConnection sendSynchronousRequest:request
                                                          returningResponse:&response
                                                                      error:&err];
            
            if (booksJSONData != nil) {
                //No ha habido error
                id jsonObject = [NSJSONSerialization JSONObjectWithData:booksJSONData
                                                                options:kNilOptions
                                                                  error:&err];
                if (jsonObject != nil) {
                    // No ha habido error al parsear el JSON
                    // comprueba si tenemos un array
                    if ([jsonObject isKindOfClass:[NSArray class]]) {
                        NSArray *JSONObjects = (NSArray *) jsonObject;
                        for (NSDictionary *dict in JSONObjects) {
                            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                            if (![defaults objectForKey:LAST_SELECTED_BOOK_ARCHIVED_URI]) {
                                [defaults setObject:[[FLGBook bookWithJsonDictionary:dict context:self.stack.context] archiveURIRepresentation] forKey:LAST_SELECTED_BOOK_ARCHIVED_URI];
                                [defaults synchronize];
                            }else{
                                [FLGBook bookWithJsonDictionary:dict
                                                        context:self.stack.context];
                            }
                        }
                    }else{
                        NSDictionary *dict = (NSDictionary *) jsonObject;
                        // Se inserta un libro en Core Data a partir del diccionario
                        [FLGBook bookWithJsonDictionary:dict
                                                context:self.stack.context];
                    }
                    
                    // Creamos e insertamos en Core Data el tag "FAVOURITE"
                    [FLGTag favoriteTagWithContext:self.stack.context];
                    
                    // Guardamos el contexto
                    [self.stack saveWithErrorBlock:^(NSError *error) {
                        NSLog(@"Error al autoguardar!: %@", error);
                    }];
                    
                    // Se modifican los NSUserDefaults para que no se vuelva a descargar el modelo
                    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                    [def setObject:@"YES" forKey:IS_MODEL_DOWNLOADED];
                    [def synchronize];
                    
                    // Arranco el autosave
                    [self autoSave];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if ([self.delegate respondsToSelector:@selector(didFinishSavingBooksInAppDelegate:)]) {
                            // Envio el mensaje al delegado
                            [self.delegate didFinishSavingBooksInAppDelegate:self];
                        }
                        
                        [self performSelector:@selector(printContextState)
                                   withObject:nil
                                   afterDelay:5];
                    });
                    
//                    // Creamos un fetchRequest
//                    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[FLGTag entityName]];
//                    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:FLGTagAttributes.name
//                                                                          ascending:YES selector:@selector(caseInsensitiveCompare:)]];
//                    
//                    req.fetchBatchSize = 20;
//                    
//                    // Creamos un FetchedResultsController
//                    NSFetchedResultsController *fc = [[NSFetchedResultsController alloc]
//                                                      initWithFetchRequest:req
//                                                      managedObjectContext:self.stack.context
//                                                      sectionNameKeyPath:FLGTagAttributes.name
//                                                      cacheName:nil];
//                    
//                    // En primer plano
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                 
//                        [self.libraryVC setFetchedResultsController: fc];
//                        
//                    });
                    
                }else{
                    // Se ha producido un error al parsear el JSON
                    NSLog(@"Error al parsear JSON: %@", err.localizedDescription);
                }
            }
            else{
                //Se ha producido un error al parsear ael JSON
                NSLog(@"Error al descargar JSON: %@", err.localizedDescription);
            }
        });
    } else{
        
        // Arranco el autosave
        [self autoSave];
        
        if ([self.delegate respondsToSelector:@selector(didFinishSavingBooksInAppDelegate:)]) {
            // Envio el mensaje al delegado
            [self.delegate didFinishSavingBooksInAppDelegate:self];
        }
        
        [self performSelector:@selector(printContextState)
                   withObject:nil
                   afterDelay:5];
    }
    
    // Creamos un fetchRequest
//    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[FLGTag entityName]];
//    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:FLGTagAttributes.name
//                                                          ascending:YES selector:@selector(caseInsensitiveCompare:)]];
//    
//    req.fetchBatchSize = 20;
//    
//    // Creamos un FetchedResultsController
//    NSFetchedResultsController *fc = [[NSFetchedResultsController alloc]
//                                      initWithFetchRequest:req
//                                      managedObjectContext:self.stack.context
//                                      sectionNameKeyPath:FLGTagAttributes.name
//                                       cacheName:nil];
//    
//    // Creamos el controller
//    self.libraryVC = [[FLGLibraryTableViewController alloc]
//                      initWithFetchedResultsController:fc
//                      stack: self.stack
//                      style:UITableViewStylePlain];
//    
//    // Asignamos delegados
//    self.libraryVC.delegate = self.libraryVC;
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    // Aqui vamos a guardar el contexto
    [self.stack saveWithErrorBlock:^(NSError *error) {
        NSLog(@"Error al guardar el contexto en Core Data: %@", error);
    }];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // Aqui vamos a guardar el contexto
    [self.stack saveWithErrorBlock:^(NSError *error) {
        NSLog(@"Error al guardar el contexto en Core Data: %@", error);
    }];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Utils

- (void) autoSave{
    
    if (AUTO_SAVE) {
        NSLog(@"Autoguardando");
        
        [self.stack saveWithErrorBlock:^(NSError *error) {
            NSLog(@"Error al autoguardar!: %@", error);
        }];
        
        // Pongo en mi agenda una nueva llamada a "autosave"
        // En cada vuelta del runloop, se mirará si ha pasado el tiempo y si es así, se ejecutará el método antes de tu código, es decir, al principio del runloop
        // Todo esto se ejecuta en la cola principal
        [self performSelector:@selector(autoSave)
                   withObject:nil afterDelay:AUTO_SAVE_DELAY];
    }
}

- (void) printContextState{
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[FLGTag entityName]];
    NSUInteger numberOfTags = [[self.stack executeFetchRequest:req
                                            errorBlock:nil] count];
    
    req = [NSFetchRequest fetchRequestWithEntityName:[FLGBook entityName]];
    NSUInteger numberOfBooks = [[self.stack executeFetchRequest:req
                                                    errorBlock:nil] count];
    
    req = [NSFetchRequest fetchRequestWithEntityName:[FLGAuthor entityName]];
    NSUInteger numberOfAuthors = [[self.stack executeFetchRequest:req
                                                     errorBlock:nil] count];
    
    req = [NSFetchRequest fetchRequestWithEntityName:[FLGAnnotation entityName]];
    NSUInteger numberOfAnnotations = [[self.stack executeFetchRequest:req
                                                     errorBlock:nil] count];
    
    req = [NSFetchRequest fetchRequestWithEntityName:[FLGLocation entityName]];
    NSUInteger numberOfLocations = [[self.stack executeFetchRequest:req
                                                     errorBlock:nil] count];
    
    printf("----------------------------------------------------\n");
    printf("Number of Tags:          %lu\n", (unsigned long)numberOfTags);
    printf("Number of Books:         %lu\n", (unsigned long)numberOfBooks);
    printf("Number of Authors:       %lu\n", (unsigned long)numberOfAuthors);
    printf("Number of Annotations:   %lu\n", (unsigned long)numberOfAnnotations);
    printf("Number of Locations:     %lu\n", (unsigned long)numberOfLocations);
    
    [self performSelector:@selector(printContextState)
               withObject:nil
               afterDelay:5];
}

- (NSComparisonResult)favouriteFirst:(NSString *)string {
    return [string isEqualToString:FAVOURITES_TAG];
}

@end
