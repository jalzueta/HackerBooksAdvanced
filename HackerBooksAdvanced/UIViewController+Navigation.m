//
//  UIViewController+Navigation.m
//  Everpobre
//
//  Created by Javi Alzueta on 15/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

#import "UIViewController+Navigation.h"

@implementation UIViewController (Navigation)

- (UINavigationController *) wrappedInNavigationController{
    return [[UINavigationController alloc] initWithRootViewController:self];
}

@end
