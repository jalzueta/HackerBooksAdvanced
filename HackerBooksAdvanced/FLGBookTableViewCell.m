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

@implementation FLGBookTableViewCell

+ (NSString *) cellId{
    return NSStringFromClass(self);
}

- (void)awakeFromNib {
    // Initialization code
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.frame];
    backgroundView.backgroundColor = SELECTED_CELL_BACKGROUND_COLOR;
    self.selectedBackgroundView = backgroundView;
}

- (void) prepareForReuse{
    // Reseteamos la celda para el reuso
//    [self setSelected:NO];
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) configureWithBook: (FLGBook *) book{
    self.title.text = book.title;
    
    NSString *authorsString = @"";
    NSSet *authors = book.authors;
    for (FLGAuthor *author in authors) {
        authorsString = [NSString stringWithFormat:@"%@%@, ", authorsString, author.name];
    }
    self.authors.text = [authorsString substringToIndex:(authorsString.length - 2)];
    
    if (!book.cover.image) {
        
        self.imageView.image = [UIImage imageNamed:@"no_image.png"];
        
        dispatch_queue_t cover_download = dispatch_queue_create("cover", 0);
        dispatch_async(cover_download, ^{
            // Descarga de datos de cover
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:book.coverURL]];
            NSURLResponse *response = [[NSURLResponse alloc] init];
            NSError *err;
            NSData *coverData = [NSURLConnection sendSynchronousRequest:request
                                                      returningResponse:&response
                                                                  error:&err];
            
            UIImage *coverImage = [UIImage imageWithData:coverData];
            if (coverImage) {
                //No ha habido error
                book.cover.imageData = coverData;
            }
            else{
                //Se ha producido un error al parsear el JSON
                NSLog(@"Error al descargar la imagen de portada: %@", err.localizedDescription);
                coverImage = [UIImage imageNamed:@"no_image.png"];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                self.imageView.image = coverImage;
//                self.imageView.contentMode = UIViewContentModeScaleAspectFill;
                [self reloadInputViews];
            });
        });
    }
    else{
        self.imageView.image = book.cover.image;
//        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
}

@end
