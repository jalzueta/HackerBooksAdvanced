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

@interface AppDelegate ()
@property (strong, nonatomic) AGTCoreDataStack *stack;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Creamos una instancia del Core Data Stack
    self.stack = [AGTCoreDataStack coreDataStackWithModelName:@"Model"];
    
    // Se comprueba a ver si se ha descargado el modelo anteriormente
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    if (![def objectForKey:IS_MODEL_DOWNLOADED]) {
        // crear una cola
        dispatch_queue_t json_download = dispatch_queue_create("json", 0);
        
        dispatch_async(json_download, ^{
            
            // Borro los datos de Core Data
            [self.stack zapAllData];
            
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
                            // Se inserta un libro a partir del diccionario
                            [FLGBook bookWithJsonDictionary:dict
                                                      stack:self.stack];
                        }
                    }else{
                        NSDictionary *dict = (NSDictionary *) jsonObject;
                        // Se inserta un libro a partir del diccionario
                        [FLGBook bookWithJsonDictionary:dict
                                                  stack:self.stack];
                    }
                    
                    // Se modifican los NSUserDefaults para que no se vuelva a descargar el modelo
                    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                    [def setObject:@"YES" forKey:IS_MODEL_DOWNLOADED];
                    
                    [self fetchTags];
                    [self fetchBooks];
                    [self fetchAuthors];
                    
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
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
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

- (void) fetchTags{
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[FLGTag entityName]];
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:FLGTagAttributes.name
                                                          ascending:YES
                                                           selector:@selector(caseInsensitiveCompare:)]];
    req.fetchBatchSize = 20;
    //            req.predicate = [NSPredicate predicateWithFormat:@"name = %@", tagName];
    
    NSArray *results = [self.stack executeFetchRequest:req
                                            errorBlock:^(NSError *error) {
                                                NSLog(@"Error al buscar! %@", error);
                                            }];
    NSLog(@"");
}

- (void) fetchBooks{
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[FLGBook entityName]];
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:FLGBookAttributes.title
                                                          ascending:YES
                                                           selector:@selector(caseInsensitiveCompare:)]];
    req.fetchBatchSize = 20;
    //            req.predicate = [NSPredicate predicateWithFormat:@"name = %@", tagName];
    
    NSArray *results = [self.stack executeFetchRequest:req
                                            errorBlock:^(NSError *error) {
                                                NSLog(@"Error al buscar! %@", error);
                                            }];
    NSLog(@"");
}

- (void) fetchAuthors{
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[FLGAuthor entityName]];
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:FLGAuthorAttributes.name
                                                          ascending:YES
                                                           selector:@selector(caseInsensitiveCompare:)]];
    req.fetchBatchSize = 20;
    //            req.predicate = [NSPredicate predicateWithFormat:@"name = %@", tagName];
    
    NSArray *results = [self.stack executeFetchRequest:req
                                            errorBlock:^(NSError *error) {
                                                NSLog(@"Error al buscar! %@", error);
                                            }];
    NSLog(@"");
}

@end
