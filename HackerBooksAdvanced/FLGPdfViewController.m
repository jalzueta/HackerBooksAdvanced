//
//  FLGPdfViewController.m
//  HackerBooks
//
//  Created by Javi Alzueta on 2/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGPdfViewController.h"
#import "FLGBook.h"
#import "FLGConstants.h"
#import "FLGPdf.h"

@interface FLGPdfViewController ()
@property (nonatomic) BOOL hideActivity;
@end

@implementation FLGPdfViewController

#pragma mark - Init

- (id) initWithModel: (FLGBook *) model{
    if (self = [super initWithNibName:nil
                               bundle:nil]) {
        _model = model;
        self.title = @"PDF reader";
    }
    return self;
}

#pragma mark - LifeCycle

- (void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // Asegurarse de que no se ocupa toda la pantalla cuando se esta en un combinador
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Asigno delegados
    self.browser.delegate = self;
    
    // Nos damos de alta en las notificaciones
    [self setupNotifications];
    
    [self configViewBeforeLoadingPDF];
}

- (void) viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self syncViewToModel];
}

- (void) viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    // Nos damos de baja de las notificaciones
    [self tearDownNotifications];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWebViewDelegate

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    // Paro y oculto el activityView
    [self.activityView setHidden:YES];
    [self.activityView stopAnimating];
    
    NSLog(@"Error en la carga: %@", error);
}

- (void) webViewDidFinishLoad:(UIWebView *)webView{
    
    if (self.hideActivity) {
        // Paro y oculto el activityView
        [self.activityView setHidden:YES];
        [self.activityView stopAnimating];
    }
}

#pragma mark - Notifications

- (void) setupNotifications{
    // Nos damos de alta en las notificaciones
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(notifyThatBookDidChange:)
                   name:BOOK_DID_CHANGE_NOTIFICATION
                 object:nil]; // Quien es el sender de la notificacion: en este caso no da igual
    
    [center addObserver:self
               selector:@selector(notifyThatBookDidChangeItsContent:)
                   name:BOOK_DID_CHANGE_ITS_CONTENT_NOTIFICATION
                 object:self.model]; // Quien es el sender de la notificacion: el modelo
}

- (void) tearDownNotifications{
    // Nos damos de baja de las notificaciones
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

- (void) updateSetupNotifications{
    [self tearDownNotifications];
    [self setupNotifications];
}

// BOOK_DID_CHANGE_NOTIFICATION
- (void) notifyThatBookDidChange: (NSNotification *) aNotification{
    
    // Sacamos el libro
    FLGBook *book = [aNotification.userInfo objectForKey:BOOK_KEY];
    
    // Actualizamos el modelo
    self.model = book;
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];;
    [center addObserver:self
               selector:@selector(notifyThatBookDidChangeItsContent:)
                   name:BOOK_DID_CHANGE_ITS_CONTENT_NOTIFICATION
                 object:self.model]; // Quien es el sender de la notificacion: el modelo
    
    // Sincronizamos modelo -> vista
    [self syncViewToModel];
}

// BOOK_DID_CHANGE_ITS_CONTENT_NOTIFICATION
- (void) notifyThatBookDidChangeItsContent: (NSNotification *) aNotification{
    
    // Guardamos el contexto
//    [self.stack saveWithErrorBlock:^(NSError *error) {
//        NSLog(@"Error al autoguardar!: %@", error);
//    }];
    
    // Sincronizamos modelo -> vista
    [self syncViewToModel];
}


#pragma mark - Utils

- (void) configViewBeforeLoadingPDF{
    [self.activityView setHidden:NO];
    [self.activityView startAnimating];
}

- (void) syncViewToModel{
    
    [self.activityView setHidden:NO];
    [self.activityView startAnimating];
    
    // Sincronizar modelo -> vista
    self.browser.delegate = self;
    
    NSData *pdfData = [NSData dataWithData:self.model.pdf.pdfEndData];
    if (![pdfData isEqualToData:[NSData dataWithData:nil]]) {
        self.hideActivity = YES;
        [self.browser loadData:pdfData
                      MIMEType:@"application/pdf"
              textEncodingName:@"UTF-8"
                       baseURL:nil];
    }else{
        self.hideActivity = NO;
    }
}

@end
