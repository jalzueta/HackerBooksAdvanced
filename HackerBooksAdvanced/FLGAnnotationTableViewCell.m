//
//  FLGAnnotationTableViewCell.m
//  HackerBooks
//
//  Created by Javi Alzueta on 2/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGAnnotationTableViewCell.h"
#import "FLGAnnotation.h"
#import "FLGConstants.h"
#import "FLGPhoto.h"

@interface FLGAnnotationTableViewCell()
@property (nonatomic, strong) FLGAnnotation *annotation;

@end

@implementation FLGAnnotationTableViewCell

+ (CGFloat) height{
    return 80;
}

+ (NSString *) cellId{
    return NSStringFromClass(self);
}

- (void)awakeFromNib {
    // Initialization code
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.frame];
    backgroundView.backgroundColor = SELECTED_CELL_BACKGROUND_COLOR;
    self.selectedBackgroundView = backgroundView;
    
    [self roundedStyled:self.annotationImageView];
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithAnnotation:(FLGAnnotation *)annotation{
    self.annotation = annotation;
    self.titleView.text = self.annotation.title;
    self.modificationDateView.text = [NSString stringWithFormat:@"%@", self.annotation.modificationDate];
    
    self.annotationImageView.image = annotation.photo.image;
}

#pragma mark -  Notificaciones
- (void) observeAnnotation:(FLGAnnotation *)annotation{
    
    self.annotation = annotation;
    
    [self addObserver];
    
    [self syncWithAnnotation];
}

- (void) addObserver{
    
    // Lo normal seria observar por FVO
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    // Muy importante, solo nos interesa los cambios en NUESTRO libro!
    [nc addObserver:self
           selector:@selector(syncWithAnnotation)
               name:ANNOTATION_DID_CHANGE_ITS_CONTENT_NOTIFICATION
             object:self.annotation];
}

- (void) removeObserver{
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
    
}

- (void) dealloc{
    
    // baja en notificaciones
    [self removeObserver];
}

#pragma mark -  Notification
// ANNOTATION_DID_CHANGE_ITS_CONTENT_NOTIFICATION
- (void) syncWithAnnotation{
    [UIView transitionWithView:self.annotationImageView
                      duration:0.7
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.annotationImageView.image = self.annotation.photo.image;
                    } completion:nil];

    self.titleView.text = self.annotation.title;
    self.modificationDateView.text = [NSString stringWithFormat:@"%@", self.annotation.modificationDate];
}

#pragma mark - Cleanup
// Esto lo manda la tabla cuando este apunto de borrarme
- (void) prepareForReuse{
    [super prepareForReuse];
    
    // hacemos limpieza
    [self cleanUp];
}

- (void) cleanUp{
    
    // baja en notificaciones
    [self removeObserver];
    
    self.annotation = nil;
    self.annotationImageView.image = nil;
    self.titleView.text = nil;
    self.modificationDateView.text = nil;
}

#pragma mark - Utils

- (void) roundedStyled: (UIView *) view{
    view.layer.cornerRadius = 5;
    view.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    view.layer.borderWidth = 0.5;
    view.layer.masksToBounds = YES;
}

@end
