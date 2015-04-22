//
//  FLGPhotoViewController.m
//  Everpobre
//
//  Created by Javi Alzueta on 10/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGPhotoViewController.h"
#import "FLGPhoto.h"
@import CoreImage;

@interface FLGPhotoViewController ()

@end

@implementation FLGPhotoViewController

#pragma mark - Init

- (id) initWithModel: (FLGPhoto *) model{
    if (self = [super initWithNibName:nil
                               bundle:nil]) {
        _model = model;
    }
    return self;
}


#pragma mark - Life Cycle

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Me aseguro que la vista no ocupa toda la pantalla sino lo que queda disponible dentro del navigation
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Sincronizo modelo -> vista
    self.photoView.image = self.model.image;
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // Sincronizo vista -> modelo
    self.model.image = self.photoView.image;
}


#pragma mark - Actions

- (IBAction)takePicture:(id)sender {
    
    // Creamos un UIImagePickerController
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    // -------------- Lo configuramos ---------------
    // Compruebo si el dispositivo tiene camara
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        // Uso la camara
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        // Tiro de la galeria
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    // Asigno el delegado
    picker.delegate = self;
    
    // Customizo la transicion del controlador modal
    // picker.modalPresentationStyle -> forma en la que se va a presentar
    // picker.modalTransitionStyle -> animacion que se va a usar al hacer la transicion
    
    // ojo si se usa "UIModalTransitionStylePartialCurl" -> No se va a llamar a viewWillDisappear ni a viewWillAppear cuando se produzca la transicion
    picker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    // Lo muetro de forma modal
    [self presentViewController:picker
                       animated:YES
                     completion:^{
                        // Esto se va a ejecutar cuando termine la animacion que muestra al picker
                     }];
}

// TODO: aplicar el filtro en segundo plano y poner un activity indicator
- (IBAction)applyFilter:(id)sender {
    // Los filtros se ejecutan en la GPU -> son muy rapidos, incluso para videos
    // Creo un contexto de CoreImage
    CIContext *ctxt = [CIContext contextWithOptions:nil];
    
    // Imagen de entrada para el filtro
    CIImage *inputImg = [CIImage imageWithCGImage:[self.photoView.image CGImage]];
    
    // Creo un filtro y lo configuro
    CIFilter *vintage = [CIFilter filterWithName:@"CIFalseColor"];
    [vintage setValue:inputImg
               forKey:kCIInputImageKey];
    
    CIImage *outputImg = vintage.outputImage;
    
    // Lo aplico
    CGImageRef out = nil;
    out = [ctxt createCGImage:outputImg
                     fromRect:outputImg.extent]; // el tamaño de la imagen de salida del filtro. Es el "frame" de una CIImage
    
    // Actualizo el modelo
    self.model.image = [UIImage imageWithCGImage:out];
    CGImageRelease(out);
    
    // Sustituyo la imagen
    self.photoView.image = self.model.image;
    
}

- (IBAction)deletePhoto:(id)sender {
    
    // La eliminamos del modelo
    self.model.image = nil;
    
    // GUardamos el bounds inicial
    CGRect oldRect = self.photoView.bounds;
    // frame: se refiere al sistema de coordenadas de su supervista
    // bounds: se refiere al sistema de coordenadas global
    
    // Sincronizo modelo -> vista
    [UIView animateWithDuration:0.7
                     animations:^{
                         self.photoView.alpha = 0;
                         self.photoView.bounds = CGRectZero;
                         self.photoView.transform = CGAffineTransformMakeRotation(M_1_PI);
                     } completion:^(BOOL finished) {
                         
                         self.photoView.image = nil;
                         self.photoView.transform = CGAffineTransformIdentity;
                         self.photoView.bounds = oldRect;
                         self.photoView.alpha = 1;
                     }];
}

#pragma mark - UIImagePickerControllerDelegate

- (void) imagePickerController:(UIImagePickerController *)picker
 didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    // ¡OJO! Pico de memoria asegurado, especialmente en dispositivos "antiguos" (iPhone 4S, iPhone 5), por culpa de la UIImage que se recibe en el diccionario
    // Sacamos la UIImage del diccionario
    UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    // La guardo en el modelo
    self.model.image = img;
    
    // Quito de enmedio al picker
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 // Se ejecutará cuando se haya ocultado del todo
                             }];
    
    // Usar self.presentingViewController si no existe un protocolo de delegado. No hace falta montar uno solo para ocultar la modal.
}

@end
