//
//  SignInViewController.h
//  Store_project
//
//  Created by  CoolDev on 22/05/17.
//  Copyright © 2017 CoolDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) IBOutlet UIButton *btnSignIn;
@property (strong, nonatomic) IBOutlet UILabel *lblHeader;
@property (strong, nonatomic) IBOutlet UIButton *btnSignUp;
@property (strong, nonatomic) IBOutlet UIButton *btnForgotPassword;
@property (nonatomic) BOOL isFromUpload;
@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@end
