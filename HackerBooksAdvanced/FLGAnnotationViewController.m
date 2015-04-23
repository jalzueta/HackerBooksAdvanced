//
//  FLGAnnotationViewController.m
//  HackerBooksAdvanced
//
//  Created by Javi Alzueta on 18/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGAnnotationViewController.h"
#import "FLGAnnotation.h"
#import "FLGPhotoViewController.h"
#import "FLGPhoto.h"

@interface FLGAnnotationViewController ()

@end

@implementation FLGAnnotationViewController

#pragma mark - Init

- (id) initWithModel: (FLGAnnotation *) model{
    if (self = [super initWithNibName:nil
                               bundle:nil]) {
        _model = model;
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Asignamos delegados
    self.titleView.delegate = self;
    
    // Nos damos de alta en notificaciones de teclado -> las lanza UIWindow
    [self setupKeyboardNotifications];
    
    // Sincronizar modelo -> vista
    NSDateFormatter *fmt = [NSDateFormatter new];
    fmt.dateStyle = NSDateFormatterShortStyle;
    
    self.creationDateView.text = [fmt stringFromDate:self.model.creationDate];
    self.modificationDateView.text = [fmt stringFromDate:self.model.modificationDate];
    
    self.titleView.text = self.model.title;
    self.textView.text = self.model.text;
    self.photoView.image = self.model.photo.image;
    
    [self roundedStyled:self.textView];
    [self roundedStyled:self.creationDateView];
    [self roundedStyled:self.modificationDateView];
    [self roundedStyled:self.photoView];
}

- (void) viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    // Baja en notificaciones de teclado
    [self tearDownKeyboardNotifications];
    
    // Sincronizo vistas -> modelo
    self.model.title = self.titleView.text;
    self.model.text = self.textView.text;
}

#pragma mark - Actions

- (IBAction)displayPhoto:(id)sender {
    
    // Crear un controlador de fotos
    FLGPhotoViewController *photoVC = [[FLGPhotoViewController alloc]
                                       initWithModel:self.model.photo];
    
    // Push
    [self.navigationController pushViewController:photoVC
                                         animated:YES];
}

- (IBAction)hideKeyboard:(id)sender {
    // Le decimos a "view" que pare de editar, ella y todas sus subvistas
    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    // Buen momento para validar el texto
//    if (textField.text.length > 0) {
//        [textField resignFirstResponder];
//        return YES;
//    }else{
//        return NO;
//    }
    
    [textField resignFirstResponder];
    return YES;
}

// Ha pasado la validación del metodo "textFieldShouldReturn"
- (void) textFieldDidEndEditing:(UITextField *)textField{
    
    // Buen momento para guardar el texto en el modelo. Nosotros lo hemos hecho en el viewWillDisappear
}


#pragma mark - keyboard Notifications

- (void) setupKeyboardNotifications{
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
        
        [nc addObserver:self
               selector:@selector(notifyThatKeyboardWillAppear:)
                   name:UIKeyboardWillShowNotification
                 object:nil];
        
        [nc addObserver:self
               selector:@selector(notifyThatKeyboardWillDisappear:)
                   name:UIKeyboardWillHideNotification
                 object:nil];
    }
}

- (void) tearDownKeyboardNotifications{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

// UIKeyboardWillShowNotification
- (void) notifyThatKeyboardWillAppear: (NSNotification *) n{
    
    // Guardo el frame original de self.textView
    self.textViewInitialFrame = self.textView.frame;
    
    // --------------- userInfo que viene en la notificacion -------------------
    // Sacar el tamaño (bounds) del keyboard del objeto
    // NSValue es un contenedor de clases de c que no son objetos, para poderlos meter en colecciones: diccionarios, arrays...
    NSValue *wrappedFrame = [n.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect kbEndFrame = [wrappedFrame CGRectValue];
    
    // Sacar la aceleracion
    int curve = [[n.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    // Sacar la duracion
    double duration = [[n.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // Calcular los nuevos bounds de self.textView y encogerlo mediante animación que coincida con la de aparicion del teclado
    CGRect currentFrame = self.textView.frame;
    CGRect newFrame = CGRectMake(currentFrame.origin.x,
                                 currentFrame.origin.y,
                                 currentFrame.size.width,
                                 currentFrame.size.height - kbEndFrame.size.height + self.bottomBar.frame.size.height);
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:curve
                     animations:^{
                         self.textView.frame = newFrame;
                     } completion:^(BOOL finished) {
                         
                     }];
}

// UIKeyboardWillHideNotification
- (void) notifyThatKeyboardWillDisappear: (NSNotification *) n{
    
    // Devolver a self.textView su bounds original mediante una animacion que coincida con la del teclado
    
    // Sacar la aceleracion
    int curve = [[n.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] intValue];
    
    // Sacar la duracion
    double duration = [[n.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration
                          delay:0
                        options:curve
                     animations:^{
                         self.textView.frame = self.textViewInitialFrame;
                     } completion:^(BOOL finished) {
                         
                     }];
}

#pragma mark - Utils

- (void) roundedStyled: (UIView *) view{
    view.layer.cornerRadius = 5;
    view.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    view.layer.borderWidth = 0.5;
    view.layer.masksToBounds = YES;
}

@end
