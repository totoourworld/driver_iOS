 //
//  SignUpViewController.m
//  Store_project
//
//  Created by  CoolDev on 22/05/17.
//  Copyright © 2017 CoolDev. All rights reserved.
//

#import "SignUpViewController.h"
#import <GrepixKit/GrepixKit.h>
//#import "CallAPI.h"
#import "WebCallConstants.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "UploadDocumentViewController.h"

@interface SignUpViewController ()

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setThemeConstants];
    
    [self setupTextField:_txtMobile];
    [self setupTextField:_txtLastName];
    [self setupTextField:_txtFirstName];
    [self setupTextField:_txtPassword];
    [self setupTextField:_txtEmail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)setThemeConstants{
    
    _viewHeader.backgroundColor = CONSTANT_THEME_COLOR1;
    _btnJoin.backgroundColor = CONSTANT_THEME_COLOR2;
    [_btnJoin setTitleColor:CONSTANT_TEXT_COLOR_BUTTONS forState:UIControlStateNormal];
     _blHeader.textColor =CONSTANT_TEXT_COLOR_HEADER;
    [_blHeader setFont:FONTS_THEME_REGULAR(19)];
     [_btnJoin.titleLabel setFont:FONTS_THEME_REGULAR(18)];
   
      [_txtEmail setFont:FONTS_THEME_REGULAR(16)];
      [_txtPassword setFont:FONTS_THEME_REGULAR(16)];
      [_txtFirstName setFont:FONTS_THEME_REGULAR(16)];
      [_txtLastName setFont:FONTS_THEME_REGULAR(16)];
      [_txtMobile setFont:FONTS_THEME_REGULAR(16)];
    
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"UploadDocumentViewController"]) {
        UploadDocumentViewController *view =(UploadDocumentViewController *)[segue destinationViewController];
        
        view.isfromProfile = NO;
    }
}


-(void)setupTextField:(UITextField*)textField{
    
    [textField setValue:[UIColor colorWithRed:0.6156862745 green:0.6156862745 blue:0.6235294118 alpha:1]
             forKeyPath:@"_placeholderLabel.textColor"];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (IBAction)ButtonBackAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)ButtonJoinPressed:(id)sender {
    
    if (![UtilityClass validateEmailWithString:_txtEmail.text]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Alert !", @"")
                                                                                 message:NSLocalizedString(@"invalid_email", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
    else if (_txtPassword.text.length<6){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Alert !", @"")
                                                                                 message:NSLocalizedString(@"password must be atleast 6 character long.", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
    
    
    else if (_txtFirstName.text.length==0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Alert !", @"")
                                                                                 message:NSLocalizedString(@"firstname_alert", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else if (_txtLastName.text.length==0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Alert !", @"")
                                                                                 message:NSLocalizedString(@"lastname_alert", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
    else  if (_txtMobile.text.length==0  ){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Alert !", @"")
                                                                                 message:NSLocalizedString(@"mobile_alert", @"")                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    
    else{
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                    P_EMAIL      :_txtEmail.text,
                                                                                    P_PASSWORD   :_txtPassword.text,
                                                                                    P_FNAME      :_txtFirstName.text,
                                                                                    P_LNAME      :_txtLastName.text,
                                                                                    P_MOBILE     :_txtMobile.text,
                                                                                    
                                                                                    }];
        
        NSString * deviceToken=[[NSUserDefaults standardUserDefaults] objectForKey:P_DEVICE_TOKEN];
        
        if (deviceToken.length>0) {
            
            [dict  setObject:deviceToken forKey:P_DEVICE_TOKEN];
            [dict  setObject:@"ios" forKey:P_DEVICE_TYPE];
        }
        
        
        [UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];
        
        
        [APP_CallAPI gcURL:BASE_URL_DRIVER app:DRIVER_SIGNUP
                      data:dict
         isShowErrorAlert:NO 
           completionBlock:^(id results, NSError *error) {
               
               if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                   // success
                   
                   
                   
                   AppDelegate *appdelegate =APP_DELEGATE;
                   
                   appdelegate.userDict = [results objectForKey:P_RESPONSE];
                   [[NSUserDefaults standardUserDefaults]setObject:appdelegate.userDict  forKey:P_USER_DICT];
                   [[NSUserDefaults standardUserDefaults]synchronize];
                   
                   [self performSegueWithIdentifier:@"UploadDocumentViewController" sender:nil];
                   
                   
               }
               else{
                   
                   UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Warning!", @"")
                                                                                            message:NSLocalizedString(@"Something_went_Wrong", @"")
                                                                                     preferredStyle:UIAlertControllerStyleAlert];
                   //We add buttons to the alert controller by creating UIAlertActions:
                   UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:nil]; //You can use a block here to handle a press on this button
                   [alertController addAction:actionOk];
                   [self presentViewController:alertController animated:YES completion:nil];
                   [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
               }
               
               [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
               
           }];
        
    }
    
}



@end
