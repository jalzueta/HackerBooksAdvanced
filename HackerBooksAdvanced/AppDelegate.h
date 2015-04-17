//
//  AppDelegate.h
//  HackerBooksAdvanced
//
//  Created by Javi Alzueta on 13/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AppDelegate;
@class AGTCoreDataStack;

@protocol AppDelegateDelegate <NSObject>

@optional
- (void) didFinishSavingBooksInAppDelegate:(AppDelegate *)appDelegate;

@end

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) id <AppDelegateDelegate> delegate;

@end

