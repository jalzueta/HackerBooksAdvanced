//
//  FLGPhotoViewController.m
//  Everpobre
//
//  Created by Javi Alzueta on 10/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGPhotoViewController.h"
#import "FLGPhoto.h"
#import "FLGConstants.h"
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
    
    // Alta en Notifications
    [self setupNotifications];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // Sincronizo vista -> modelo
    self.model.image = self.photoView.image;
    
    // Baja en Notifications
    [self tearDownNotifications];
}


#pragma mark - Actions

- (IBAction)deletePhoto:(id)sender {
    
    // La eliminamos del modelo
    self.model.image = nil;
}

- (IBAction)takePictureFromCamera:(id)sender {
    [self takePicture:CAMERA];
}

- (IBAction)takePictureFromRoll:(id)sender {
    [self takePicture:ROLL];
}

- (IBAction)takePictureFromAlbum:(id)sender {
    [self takePicture:ALBUM];
}

- (void) takePicture: (NSString *) type{
    // Creamos un UIImagePickerController
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    // -------------- Lo configuramos ---------------
    if ([type isEqualToString:CAMERA]) {
        // Compruebo si el dispositivo tiene camara
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            // Uso la camara
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        }else{
            // Tiro de la galeria
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
    } else if ([type isEqualToString:ROLL]){
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        picker.modalPresentationStyle = UIModalPresentationFormSheet;
    } else{
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        picker.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    // Asigno el delegado
    picker.delegate = self;
    
    // Customizo la transicion del controlador modal
    // picker.modalPresentationStyle -> forma en la que se va a presentar
//    picker.modalPresentationStyle = UIModalPresentationFormSheet;
    
    // picker.modalTransitionStyle -> animacion que se va a usar al hacer la transicion
    // ojo si se usa "UIModalTransitionStylePartialCurl" -> No se va a llamar a viewWillDisappear ni a viewWillAppear cuando se produzca la transicion
    picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    // Lo muetro de forma modal
    [self presentViewController:picker
                       animated:YES
                     completion:^{
                         // Esto se va a ejecutar cuando termine la animacion que muestra al picker
                     }];
}

#pragma mark - Notifications
- (void) setupNotifications{
    // Nos damos de alta en las notificaciones
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(notifyThatPhotoDidChange:)
                   name:PHOTO_DID_CHANGE_PHOTO
                 object:self.model];
}

- (void) tearDownNotifications{
    // Nos damos de baja de las notificaciones
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

// PHOTO_DID_CHANGE_PHOTO
- (void) notifyThatPhotoDidChange: (NSNotification *) aNotification{
    
    // Sincronizamos modelo -> vista
    [UIView transitionWithView:self.photoView
                      duration:0.7
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.photoView.image = self.model.image;
                    } completion:NULL];
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
