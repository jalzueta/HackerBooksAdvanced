//
//  AGTAsyncImage.h
//  HackerBooks
//
//  Created by Fernando Rodríguez Romero on 15/04/15.
//  Copyright (c) 2015 Agbo. All rights reserved.
//

#define IMAGE_DID_CHANGE_NOTIFICATION @"AGTAsyncImageimageDidChange"
#define IMAGE_KEY @"newImageKey"


@import UIKit;

@class AGTAsyncImage;

@protocol AGTAsyncImageDelegate <NSObject>

/** The image property has a new value after downloading
 the remote one.
 */
-(void) asyncImageDidChange:(AGTAsyncImage*) aImage ;


@end


@interface AGTAsyncImage : NSObject


/** Removes all local images */
+(BOOL) flushLocalCache;

/** Removes the current image */
-(BOOL) flushLocalCache;


@property (strong, nonatomic) UIImage* image;
@property (weak, nonatomic) id<AGTAsyncImageDelegate> delegate;

/* Saves in documents by default */
+(instancetype) asyncImageWithURL:(NSURL*) url
                     defaultImage:(UIImage *) image;

// Designated
-(id) initWithURL:(NSURL*) url
     defaultImage:(UIImage*) image;


@end
