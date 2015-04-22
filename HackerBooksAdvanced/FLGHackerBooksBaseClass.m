//
//  FLGHackerBooksBaseClass.m
//  HackerBooksAdvanced
//
//  Created by Javi Alzueta on 17/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGHackerBooksBaseClass.h"

@implementation FLGHackerBooksBaseClass

#pragma mark - Class Methods

+ (NSArray *) observableKeys{
    // Devuelve por defecto un array vacio -> Luego se sobreescribira en cada subclase
    return @[];
}

#pragma mark - Life cycle

// Solo se produce 1 vez en la vida del objeto
- (void) awakeFromInsert{
    [super awakeFromInsert];
    // Alta en la notificaciones
    [self setupKVO];
}

// Se produce n veces a lo largo de la vida del objeto:
//    - Cada vez que pasa de Fault a objeto con contenido
//    - Cada vez que se saca un objeto de base de datos
- (void) awakeFromFetch{
    [super awakeFromFetch];
    // Alta en la notificaciones
    [self setupKVO];
}

// Se produce cuando un objeto se vacía convirtiendose en un fault
- (void) willTurnIntoFault{
    [super willTurnIntoFault];
    // Baja en la notificaciones
    [self tearDownKVO];
}

#pragma mark - KVO

- (void) setupKVO{
    
    // Observamos todas las propiedades EXCEPTO "modificationDate" (creariamos bucle infinito)
    for (NSString *key in [[self class] observableKeys]) {
        [self addObserver:self
               forKeyPath:key
                  options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                  context:NULL];
    }
}

- (void) tearDownKVO{
    
    // Me doy de baja de toda las notificaciones
    for (NSString *key in [[self class] observableKeys]) {
        [self removeObserver:self
                  forKeyPath:key];
    }
}

// mensaje que se recibe siempre en KVO cuando cambia cualquiera de las propiedades observadas
- (void) observeValueForKeyPath:(NSString *)keyPath
                       ofObject:(id)object
                         change:(NSDictionary *)change
                        context:(void *)context{
    
    // Sobreescribiremos este metodo para cada subclase
}

@end
