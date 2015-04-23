//
//  FLGBookTableViewCell.m
//  HackerBooks
//
//  Created by Javi Alzueta on 2/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "FLGBookTableViewCell.h"
#import "FLGBook.h"
#import "FLGConstants.h"
#import "FLGAuthor.h"
#import "FLGCover.h"
#import "FLGPdf.h"

@interface FLGBookTableViewCell()
@property (nonatomic, strong) FLGBook *book;

@end

@implementation FLGBookTableViewCell

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
    
    [self roundedStyled:self.coverImageView];
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithBook: (FLGBook *) book{
    self.book = book;
    self.titleView.text = self.book.title;
    
    self.authorsView.text = [self.book authorsString];
    
    self.downloadIconView.hidden = !book.pdf.pdfData;
    self.coverImageView.image = book.cover.coverImage;
    
    [self syncFavoriteWithBook];
}

#pragma mark -  Notificaciones
- (void) observeBook:(FLGBook*) book{
    
    self.book = book;
    
    [self addObserver];
    
    [self syncWithBook];
}

- (void) addObserver{
    
    // Lo normal seria observar por FVO
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    // Muy importante, solo nos interesa los cambios en NUESTRO libro!
    [nc addObserver:self
           selector:@selector(syncCoverWithBook)
               name:BOOK_DID_CHANGE_COVER_NOTIFICATION
             object:self.book];
    
    [nc addObserver:self
           selector:@selector(syncFavoriteWithBook)
               name:BOOK_DID_CHANGE_FAVORITE_STATE_NOTIFICATION
             object:self.book];
    
    [nc addObserver:self
           selector:@selector(syncDownloadedWithBook)
               name:BOOK_DID_CHANGE_PDF_NOTIFICATION
             object:self.book];
}

- (void) removeObserver{
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
    
}

- (void) dealloc{
    
    // baja en notificaciones
    [self removeObserver];
}

#pragma mark -  Sync

- (void) syncWithBook{
    [self syncCoverWithBook];
    [self syncDownloadedWithBook];
    [self syncFavoriteWithBook];
}

- (void) syncCoverWithBook{
    
    [UIView transitionWithView:self.coverImageView
                      duration:0.7
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        self.coverImageView.image = self.book.cover.coverImage;
                    } completion:nil];
    }

- (void)syncFavoriteWithBook{
    
    if ([self.book isFavourite]) {
        self.favouriteIconView.image = [UIImage imageNamed:FAVOURITE_ON_IMAGE_NAME];
    } else{
        self.favouriteIconView.image = [UIImage imageNamed:FAVOURITE_OFF_IMAGE_NAME];
    }
}

- (void)syncDownloadedWithBook{
    self.downloadIconView.hidden = ![self.book savedIntoDisk];
}

#pragma mark - Actions

- (IBAction)favoriteDidPressed:(id)sender {
//    [self.book setIsFavourite:!self.book.isFavourite];
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
    
    self.book = nil;
    self.coverImageView.image = nil;
    self.titleView.text = nil;
    self.favouriteIconView.image = nil;
    self.downloadIconView.image = nil;
    self.authorsView.text = nil;
}

#pragma mark - Utils

- (void) roundedStyled: (UIView *) view{
    view.layer.cornerRadius = 5;
    view.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    view.layer.borderWidth = 0.5;
    view.layer.masksToBounds = YES;
}


@end
