//
//  SignUpViewController.h
//  Store_project
//
//  Created by  CoolDev on 22/05/17.
//  Copyright © 2017 CoolDev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UITextField *txtFirstName;
@property (strong, nonatomic) IBOutlet UITextField *txtLastName;
@property (strong, nonatomic) IBOutlet UITextField *txtEmail;
@property (strong, nonatomic) IBOutlet UITextField *txtMobile;
@property (strong, nonatomic) IBOutlet UITextField *txtPassword;
@property (strong, nonatomic) IBOutlet UIButton *btnJoin;
@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) IBOutlet UILabel *blHeader;

@end
