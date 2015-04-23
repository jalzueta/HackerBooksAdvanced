#HackerBooks Advanced

Esta App corresponde a la práctica de la asignatura de iOS Avanzado - KeepCoding Bootcamp

Hola Fernando, María José. 

No estoy para nada contento con el ejercicio que estoy entregando ahora mismo. La verdad es que me he atascado y mucho en la presentación de la tabla con los libros y las secciones. Esa relación *many-to-many* entre libros y tags me ha dejado KO.

He conseguido mostrar la tabla de libros con las secciones por tags haciendo una búsqueda a nivel de Tags y sobreescribiendo el método:

 **- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section#**
 
 La búsqueda ha quedado así:
    
             
    NSFetchRequest *req = [NSFetchRequest fetchRequestWithEntityName:[FLGTag entityName]];
    
    req.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                          ascending:YES
                                                           selector:@selector(compare:)]];
                                                           selector:@selector(compare:)]];
    req.fetchBatchSize = 20;
    
    NSFetchedResultsController *fc = [[NSFetchedResultsController alloc]
                                      initWithFetchRequest:req
                                      managedObjectContext:self.stack.context
                                      sectionNameKeyPath:FLGTagAttributes.name
                                      cacheName:nil];

Pero haciendolo así, al FetchResultsController me ha dado muchos problemas a la hora de gestionar los favoritos. No he conseguido modificarle los resultados *(por ahora, soy navarro, muy cabezón)* para que me gestione los favoritos. Solamente me añade bien el primero de ellos; a partir de ahí, peta cuando le modifico a cualquier libro la condición de favorito.

Así que he decidido dejar el codigo de modificacion de favoritos comentado para que no de problemas.

He decidido dejar ese tema aparcado de momento e intentar implementar el resto de cosas.

He implementado las descargas en segundo plano tanto del JSON (muestro un sencillo ViewController con una animación durante la misma), como las de las portadas  y los PDFs de los libros. Esta parte esta implementada tanto para iPhone como para iPad.

He conseguido montar el tema de las Anotaciones con los *UIImagePickerController*, aunque aun me queda el tema de la localización y el hacer esta parte Universal con el SplitVC.

En cualquier caso, me preocupa no haber sido capaz de gestionar en condiciones el NSFetchResultsController con las relaciones many-to-many, así que es lo primero que quiero resolver.

