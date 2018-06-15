//
//  RatingViewController.m
//  TaxiDriver
//
//  Created by  CoolDev on 24/05/17.
//  Copyright © 2017 CoolDev. All rights reserved.
//

#import "RatingViewController.h"
#import "StarRatingView.h"
#import "WebCallConstants.h"
#import "AppDelegate.h"
//#import "Constants.h"
////#import "nsuserdefaults-macros.h"
//#import "CallAPI.h"
#import <GrepixKit/GrepixKit.h>


#define kLabelAllowance 50.0f
#define kStarViewHeight 35.0f
#define kStarViewWidth 180.0f
#define kLeftPadding 5.0f


@interface RatingViewController ()

@end

@implementation RatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setThemeConstants];
    [self getDriverProfile:defaults_object(P_API_KEY)];
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setThemeConstants{
    
    _viewHeader.backgroundColor = CONSTANT_THEME_COLOR1;
     _lblHeader.textColor =CONSTANT_TEXT_COLOR_HEADER;
    [_lblHeader setFont:FONTS_THEME_REGULAR(19)];
  
    
}

- (IBAction)ButtonBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
               defaults_set_object(P_USER_DICT,  appdelegate.userDict);
               
           }
           [self showRating];
           [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
       }];
    
    
}

-(void)showRating{
    
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    
    NSString *rating = [dict1 objectForKey:@"d_rating"];
    
    StarRatingView* starViewNoLabel = [[StarRatingView alloc]initWithFrame:CGRectMake((self.view.frame.size.width -kStarViewWidth) /2, (self.view.frame.size.height/2)-20, kStarViewWidth, kStarViewHeight) andRating:[rating floatValue]*20 withLabel:NO animated:YES];
    [starViewNoLabel setUserInteractionEnabled:NO];
    
    UILabel * ratingCount=[[UILabel alloc]  initWithFrame:CGRectMake(30, (self.view.frame.size.height/2)+20, SCREEN_WIDTH-60, 40)];
    ratingCount.font=FONTS_THEME_REGULAR(14);
    ratingCount.textAlignment=NSTextAlignmentCenter;
    
    ratingCount.text=[NSString stringWithFormat:@"Rating Count :%d",[[dict1  objectForKey:@"d_rating_count"]  intValue]];
    [self.view addSubview:starViewNoLabel];
    [self.view addSubview:ratingCount];
}
@end
