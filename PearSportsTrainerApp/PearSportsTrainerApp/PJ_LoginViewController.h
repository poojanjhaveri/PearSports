//
//  PJ_LoginViewController.h
//  PearSportsTrainerApp
//
//  Created by Poojan Jhaveri on 1/16/14.
//  Copyright (c) 2014 Poojan Jhaveri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BZGFormViewController.h>

@class BZGMailgunEmailValidator;

@interface PJ_LoginViewController : BZGFormViewController<UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic, strong) BZGFormFieldCell *emailFieldCell;
@property (nonatomic, strong) BZGFormFieldCell *passwordFieldCell;



@end
