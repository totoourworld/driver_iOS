//
//  FirstViewController.m
//  Store_project
//
//  Created by  CoolDev on 22/05/17.
//  Copyright © 2017 CoolDev. All rights reserved.
//

#import "RootViewController.h"
#import "MainViewController.h"
#import "HomeViewController.h"
#import "WebCallConstants.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
//#import "CallAPI.h"
#import <GrepixKit/GrepixKit.h>

@interface RootViewController ()


@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   
    
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


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    
    NSString *apiKey =[[NSUserDefaults standardUserDefaults]objectForKey:P_API_KEY];
    //    NSString *driverId =[[NSUserDefaults standardUserDefaults]objectForKey:@"driver_id"];
    
    if (apiKey.length>0) {
        //        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [self getDriverProfile:apiKey];
        
    }
}
- (IBAction)ButtonSignInPressed:(id)sender {
    [self performSegueWithIdentifier:@"SignInViewController" sender:nil];
}
- (IBAction)ButtonSignUpPressed:(id)sender {
    [self performSegueWithIdentifier:@"SignUpViewController" sender:nil];
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

-(void)getDriverProfile:(NSString *)apikey{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                P_API_KEY :apikey,
                                                                                
                                                                                }];
    
    
    [UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];
    
    [APP_CallAPI gcURL:BASE_URL_DRIVER app:GET_DRIVER_PROFILE
                  data:dict
     isShowErrorAlert:NO
       completionBlock:^(id results, NSError *error) {
           if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
               // success
               
               AppDelegate *appdelegate =APP_DELEGATE;
               appdelegate.userDict = [[results objectForKey:P_RESPONSE]objectAtIndex:0];
               [[NSUserDefaults standardUserDefaults]setObject:appdelegate.userDict  forKey:P_USER_DICT];
               [[NSUserDefaults standardUserDefaults]synchronize];
               [self updateDeviceToken];
               [self navigateHome];
               
           }
           [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
       }];
    
    
}

-(void)updateDeviceToken{
    
    // [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AppDelegate *appdelegate =APP_DELEGATE;
    NSString * deviceToken=[[NSUserDefaults standardUserDefaults] objectForKey:P_DEVICE_TOKEN];
    
    
    if (deviceToken) {
        
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                    P_DEVICE_TOKEN :deviceToken,
                                                                                    P_DEVICE_TYPE   :@"ios",
                                                                                    P_DRIVER_ID  :[appdelegate.userDict objectForKey:P_DRIVER_ID],
                                                                                    
                                                                                    
                                                                                    }];
        
        
        [APP_CallAPI gcURL:BASE_URL_DRIVER app:UPDATE_DRIVER_PROFILE
                      data:dict
         isShowErrorAlert:NO 
           completionBlock:^(id results, NSError *error) {
               if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
                   // success
                   
                   appdelegate.userDict =[results objectForKey:P_RESPONSE];;
                   
                   
               }
               
           }];
    }
    
    
    
}


@end
