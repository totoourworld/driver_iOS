//
//  SignInViewController.m
//  Store_project
//
//  Created by  CoolDev on 22/05/17.
//  Copyright © 2017 CoolDev. All rights reserved.
//

#import "SignInViewController.h"
#import <GrepixKit/GrepixKit.h>
#import "WebCallConstants.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "HomeViewController.h"
//#import "CallAPI.h"

@interface SignInViewController ()


@end

@implementation SignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setupTextField:_txtEmail];
    [self setupTextField:_txtPassword];
    //    _txtEmail.text=@"test01@gmail.com";
    //    _txtPassword.text =@"testtest";
    
    [self setThemeConstants];
    if (_isFromUpload) {
        _btnBack.hidden=YES;
    }
    
   

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


-(void)setThemeConstants{
    
    _viewHeader.backgroundColor = CONSTANT_THEME_COLOR1;
    _btnSignIn.backgroundColor = CONSTANT_THEME_COLOR2;
    [_btnSignIn setTitleColor:CONSTANT_TEXT_COLOR_BUTTONS forState:UIControlStateNormal];
     _lblHeader.textColor =CONSTANT_TEXT_COLOR_HEADER;
    [_lblHeader setFont:FONTS_THEME_REGULAR(19)];
     [_btnSignIn.titleLabel setFont:FONTS_THEME_REGULAR(18)];
     [_btnSignUp.titleLabel setFont:FONTS_THEME_REGULAR(14)];
     [_btnForgotPassword.titleLabel setFont:FONTS_THEME_REGULAR(14)];
    [_txtEmail setFont:FONTS_THEME_REGULAR(16)];
    [_txtPassword setFont:FONTS_THEME_REGULAR(16)];

}
-(void)setupTextField:(UITextField*)textField{
    
    [textField setValue:[UIColor colorWithRed:0.6156862745 green:0.6156862745 blue:0.6235294118 alpha:1]
             forKeyPath:@"_placeholderLabel.textColor"];
}

- (IBAction)ButtonSignUpPressed:(id)sender {
    [self performSegueWithIdentifier:@"SignUpViewController" sender:nil];
}
- (IBAction)ButtonForgotPasswordPressed:(id)sender {
    
    [self performSegueWithIdentifier:@"forgotPasswordViewController" sender:nil];
}

- (IBAction)ButtonBackAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)ButtonSignIN:(id)sender {
    
    if (self.txtPassword.text.length == 0 || self.txtEmail.text.length == 0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Warning!", @"")
                                                                                 message:NSLocalizedString(@"email_invalid_error", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }
    
    else if (![UtilityClass validateEmailWithString:_txtEmail.text ]){
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Warning!", @"")
                                                                                 message:NSLocalizedString(@"invalid_email", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
    }
    else{
        
        
        NSDictionary *dict = @{P_EMAIL:_txtEmail.text, P_PASSWORD:_txtPassword.text };
        
        [UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];
        
        
        [APP_CallAPI gcURL:BASE_URL_DRIVER app:DRIVER_SIGNIN
                      data:dict
         isShowErrorAlert:NO
           completionBlock:^(id results, NSError *error) {
               
               if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                   // success
                   
                   NSDictionary *dict =[results objectForKey:P_RESPONSE];
                   
                   if ([[dict objectForKey:@"d_is_verified"] isEqualToString:@"1"]) {
                       
                       AppDelegate *appdelegate =APP_DELEGATE;
                       appdelegate.userDict = [results objectForKey:P_RESPONSE];
                       
                       
                       [[NSUserDefaults standardUserDefaults]setObject:[appdelegate.userDict objectForKey:P_API_KEY] forKey:P_API_KEY];
                       [[NSUserDefaults standardUserDefaults]setObject:appdelegate.userDict  forKey:P_USER_DICT];
                       
                       
                       [[NSUserDefaults standardUserDefaults]synchronize];
                       [self updateDeviceToken];
                   }
                   else{
                       
                       UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Warning!", @"")
                                                                                                message:NSLocalizedString(MESSAGE_DEACTIVATE, @"")
                                                                                         preferredStyle:UIAlertControllerStyleAlert];
                       //We add buttons to the alert controller by creating UIAlertActions:
                       UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                                          style:UIAlertActionStyleDefault
                                                                        handler:nil]; //You can use a block here to handle a press on this button
                       [alertController addAction:actionOk];
                       [self presentViewController:alertController animated:YES completion:nil];
                       [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
                       
                   }
                   
                   
               }
               else{
                   
                   UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Warning!", @"")
                                                                                            message:NSLocalizedString(@"login_error_message", @"")
                                                                                     preferredStyle:UIAlertControllerStyleAlert];
                   //We add buttons to the alert controller by creating UIAlertActions:
                   UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:nil]; //You can use a block here to handle a press on this button
                   [alertController addAction:actionOk];
                   [self presentViewController:alertController animated:YES completion:nil];
                   [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
                   
               }
               
           }];
        
    }
}

-(void)updateDeviceToken{
    
    // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AppDelegate *appdelegate =APP_DELEGATE;
    NSString * deviceToken=[[NSUserDefaults standardUserDefaults] objectForKey:P_DEVICE_TOKEN];
    
    
    if (deviceToken) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                    P_DEVICE_TOKEN :deviceToken,
                                                                                    P_DEVICE_TYPE   :@"ios",
                                                                                    P_DRIVER_ID   :[appdelegate.userDict objectForKey:P_DRIVER_ID],
                                                                                    
                                                                                    
                                                                                    }];
        
        
        [APP_CallAPI gcURL:BASE_URL_DRIVER app:UPDATE_DRIVER_PROFILE
                      data:dict
         isShowErrorAlert:NO 
           completionBlock:^(id results, NSError *error) {
               if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                   // success
                   
                   
                   
                   appdelegate.userDict =[results objectForKey:P_RESPONSE];
                   
               }
               [self navigateHome];
           }];
    }
    else{
        
        
        
        [self navigateHome];
    }
    
    
}

-(void)navigateHome{
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    
    
    
    [navigationController setViewControllers:@[[storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"]]];
    
    
    MainViewController *mainViewController =[storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    mainViewController.rootViewController = navigationController;
    [mainViewController setupWithType:2];
    //    self.leftViewWidth =;
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    window.rootViewController = mainViewController;
    
    [UIView transitionWithView:window
                      duration:0.3
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:nil
                    completion:nil];
    
    [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
    
}


@end
