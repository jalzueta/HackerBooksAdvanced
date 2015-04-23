#import "FLGAnnotation.h"
#import "FLGPhoto.h"
#import "FLGLocation.h"
#import "FLGConstants.h"

@interface FLGAnnotation ()

// Private interface goes here.

@end

@implementation FLGAnnotation

+ (NSArray *) observableKeys{
    // Mogenerator nos crea Constantes con los nombres de las propiedades
    //  @"photo.photoData": se refiere a la propiedad "photoData" de la propiedad "photo" --> por eso se llama keyPath
    return @[FLGAnnotationAttributes.title, FLGAnnotationAttributes.text, @"photo.photoData"];
}

+ (instancetype) annotationWithTitle: (NSString *) title
                                book: (FLGBook *) book
                             context: (NSManagedObjectContext *) context{
    
    FLGAnnotation *n = [FLGAnnotation insertInManagedObjectContext:context];
    
    // Reglas de validación - propiedades obligatorias
    n.title = title;
    n.book = book;
    n.creationDate = [NSDate date]; // Fecha/hora actual en GMT. Si quieres la hora local, necesitarías guardar una instancia de NSTimezone
    n.modificationDate = [NSDate date];
    n.photo = [FLGPhoto insertInManagedObjectContext:context]; // Photo vacia de contenido
//    n.location = [FLGLocation insertInManagedObjectContext:context];
    
    return n;
}

#pragma mark - KVO

// mensaje que se recibe siempre en KVO cuando cambia cualquiera de las propiedades observadas
- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context{
    
    // Actualizo la modificationDate
    self.modificationDate = [NSDate date];
    
    // Envio notificacion
    
}

- (void) sendAnnotationDidChangeItsContentNotification{
    
    if (self.managedObjectContext.hasChanges) {
        [self.managedObjectContext save:nil];
    }
    
    NSNotification *note = [NSNotification notificationWithName:ANNOTATION_DID_CHANGE_ITS_CONTENT_NOTIFICATION
                                                         object:self
                                                       userInfo:@{ANNOTATION_KEY: self}];
    
    // Enviamos la notificacion
    [[NSNotificationCenter defaultCenter] postNotification:note];
}

@end
