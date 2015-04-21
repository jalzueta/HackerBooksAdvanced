//
//  AGTAsyncImage.m
//  HackerBooks
//
//  Created by Fernando Rodríguez Romero on 15/04/15.
//  Copyright (c) 2015 Agbo. All rights reserved.
//


#import "AGTAsyncImage.h"

@interface AGTAsyncImage ()
@property (nonatomic, strong) UIImage *defaultImage;
@property (nonatomic, strong) NSURL *remoteImageURL;
@property (nonatomic, readonly) NSSearchPathDirectory sandboxDirectory;
@end

@implementation AGTAsyncImage

#pragma mark - Lifecycle
+(instancetype) asyncImageWithURL:(NSURL*) url
                     defaultImage:(UIImage *) image{
    
    return [[self alloc] initWithURL:url
                        defaultImage:image];
    
}

-(id) initWithURL:(NSURL *) url
     defaultImage:(UIImage*) image{
    
    // check that url points to a file
    if ([self urlPointsToFile:url]) {
        if (self = [super init]) {
            _remoteImageURL = url;
            NSFileManager *fm = [NSFileManager defaultManager];
            NSURL *localURL = [self localURLForRemoteURL:url];
            if ([fm fileExistsAtPath:[localURL path]]) {
                
                // El fichero ya está cacheado en local, lo leemos
                _image = [UIImage imageWithData:
                          [NSData dataWithContentsOfURL:localURL]];
                
            }else{
                _image = image;
                // Para que dé tiempo a que se vea la imagen por defecto
                // el siguiente mensaje se tiene que enviar en la siguiente
                // vuelta del RunLoop (asi la interfaz se actualiza).
                // Esta técnica se verá con detalle en el curso avanzado
                [self performSelector:@selector(downloadImage)
                           withObject:nil
                           afterDelay:0.01];
                
                
            }
            
        }
        
    }else{
        // Don't throw an exception here.
        // Exceptions in Objective-C are meant for states which you can't
        // really recover from, not just something to show that an operation
        // failed. If you initializer fails, simply return nil to show it.
        self = nil;
    }
    return self;
}



#pragma mark - Remote Image
-(void) downloadImage{
    
    dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0),
                   ^{
                       NSData *data = [NSData dataWithContentsOfURL:self.remoteImageURL];
                       
                       dispatch_async(dispatch_get_main_queue(), ^{
                           // Lo hago en primer plano para asegurarme de
                           // todas las ntificaciones van en la ocla
                           // principal
                           [self setNewImageWithData:data];
                       });
                   });
    
}

-(void) setNewImageWithData:(NSData *) data{
    
    // Guardo la imagen en  (con el nombre que tenia en la url
    // original.
    NSURL *localURL = [self localURLForRemoteURL:self.remoteImageURL];
    [data writeToURL:localURL atomically:YES];
    
    // Asigno como nueva imagen (esto envía notificación de KVO)
    self.image = [UIImage imageWithData:data];
    
    // Aviso a delegado y mando notificación
    [self notifyChangeInImage];
}

#pragma mark -  Notification
-(void)notifyChangeInImage{
    
    // avisamos delegado si lo tenemos
    if ([self.delegate respondsToSelector:@selector(asyncImageDidChange:)]) {
        // Envio el mensaje al delegado
        [self.delegate asyncImageDidChange:self];
    }
    
    // Enviamos una notificación
    NSNotification *notification =
    [NSNotification notificationWithName: IMAGE_DID_CHANGE_NOTIFICATION
                                  object:self
                                userInfo:@{IMAGE_KEY : self.image}];
    
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    
    // con esto y las notificaciones KVO, quien necesite saber lo que ando
    // lo tendrá muy fácil
}



#pragma mark - Local Cache
+(NSURL*) sandboxSubfolderURL{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSURL *locURL = [[fm URLsForDirectory:NSDocumentDirectory
                                inDomains:NSUserDomainMask] lastObject];
    
    locURL = [locURL URLByAppendingPathComponent:NSStringFromClass(self)];
    
    // If it doesn't exist, we'll create it
    if (![fm fileExistsAtPath:[locURL path] isDirectory:nil]) {
        
        NSError *err;
        BOOL rc = [fm createDirectoryAtPath:[locURL path]
                withIntermediateDirectories:YES attributes:nil error:&err];
        if (!rc) {
            NSLog(@"error while creating directory at %@:\n%@", locURL, err);
        }
        
    }
    
    return locURL;

}

+(BOOL) flushLocalCache{
    return [self deleteItemAtURL:[self sandboxSubfolderURL]];
}

-(BOOL) flushLocalCache{
    return [AGTAsyncImage deleteItemAtURL:[self localURLForRemoteURL:self.remoteImageURL]];
}

+(BOOL) deleteItemAtURL:(NSURL*) url{
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *err = nil;
    BOOL rc = [fm removeItemAtPath:[url path]
                             error:&err];
    if (!rc ) {
        NSLog(@"Error while deleting image at %@\n%@", url, err);
    }
    return rc;
}

-(NSURL*) localURLForRemoteURL:(NSURL*) remoteURL{
    
    NSString *fileName = [remoteURL lastPathComponent];
    return [[[self class ]sandboxSubfolderURL]  URLByAppendingPathComponent:fileName];
    
}

-(UIImage*)imageFromLocalURL{
    NSData *data = [NSData dataWithContentsOfURL:self.remoteImageURL];
    return [UIImage imageWithData:data];
}

#pragma mark - Integrity Checks
-(BOOL)urlPointsToFile:(NSURL*) url{
    
    NSString *last = [url lastPathComponent];
    
    if ([last isEqualToString:@""] ||
        [last isEqualToString:@"/"]) {
        return NO;
    }else{
        // Por vagancia no compruebo que sea realmente una imagen
        // gif, png, jpg, etc... Ejercicio para el alumno con
        // más paciencia. Esto realmente deberia de ser labor de un test
        // en el backend: no enviar NUNCA info incorrecta.
        return YES;
    }
}





@end
