//
//  FLGSplashViewController.h
//  HackerBooksAdvanced
//
//  Created by Javi Alzueta on 17/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface FLGSplashViewController : UIViewController<AppDelegateDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *bookImage;

- (instancetype) initWithStack: (AGTCoreDataStack *) stack;

@end
