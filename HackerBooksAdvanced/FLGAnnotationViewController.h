//
//  FLGAnnotationViewController.h
//  HackerBooksAdvanced
//
//  Created by Javi Alzueta on 9/4/15.
//  Copyright (c) 2015 FillinGAPPs. All rights reserved.
//

@import UIKit;

@class FLGAnnotation;

@interface FLGAnnotationViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *creationDateView;
@property (weak, nonatomic) IBOutlet UILabel *modificationDateView;
@property (weak, nonatomic) IBOutlet UITextField *titleView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIToolbar *bottomBar;

@property (strong, nonatomic) FLGAnnotation *model;
@property (nonatomic) CGRect textViewInitialFrame;

- (id) initWithModel: (FLGAnnotation *) model;

- (IBAction)displayPhoto:(id)sender;
- (IBAction)hideKeyboard:(id)sender;

@end
