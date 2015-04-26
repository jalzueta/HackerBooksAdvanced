#HackerBooks Advanced

Esta App corresponde a la práctica de la asignatura de iOS Avanzado - KeepCoding Bootcamp

##Versión a día 22 de Abril (tag v1.0)

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


##Versión a día 26 de Abril (tag v1.1)

Bueno, después de unos cuantos días, he conseguido implementar unas cuantas cosas mas:

Gestion de favoritos: lo he coseguido deshabilitando el *"NSFetchedResultsControllerDelegate"* y actualizando el *"NSFetchedResultsController"* a través de una notificación de cambio de estado *favorito* de cualquiera de los libros. Seguramente no es lo más eficiente, pero tal y como he planteado el *NSFetchedResultsController* con los Tags, no he encontrado otra manera.

Lo que no he conseguido es la ordenación de las secciones de manera que el *"Favoritos"* aparezca la primera. Al no poderse sobreescribir los metodos de ordenacion en las clases que dependen de NSManagedObject, tengo que seguir buscando alguna estrategia distinta para conseguirlo.

He implementado el tema de las *Localizaciones* para las anotaciones (que se presentan en una tabla - la collection prefiero montarla cuanda haya podido ver todos los videos del curso online).

He implementado también el UIActivityController para poder compartir las anotaciones en redes sociales, email, sms... En realidad el menú que presenta depende de si el usuario tiene configuradas sus cuentas de redes sociales en los Settings del dispositivo, así que me gustaría darle una vuelta adicional para integrar los SDKs de FB y TW.



