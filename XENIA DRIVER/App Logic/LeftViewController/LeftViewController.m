//
//  LeftViewController.m
//  TempProject
//
//  Created by SFYT on 09/02/17.
//  Copyright © 2017 SFYT. All rights reserved.
//

#import "LeftViewController.h"
#import "SideMenuCell.h"
#import "EditProfileViewController.h"
#import "WebCallConstants.h"
#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
//#import "CallAPI.h"
#import "WebCallConstants.h"
////#import "nsuserdefaults-macros.h"
#import "RootViewController.h"
#import <GrepixKit/GrepixKit.h>
#import "UpdateUserCurrentLocation.h"
#import <MessageUI/MFMailComposeViewController.h>


@interface LeftViewController ()<MFMailComposeViewControllerDelegate>


@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setThemeConstants];
    [self.imgProfile.layer setBorderWidth:2];
    [self.imgProfile.layer setBorderColor:[UIColor whiteColor].CGColor];
    
    
    _arrSideMenu =[[NSArray alloc]initWithObjects:@{
                                                    @"title":NSLocalizedString(@"Profile", @""),
                                                    @"icon":@"man",
                                                    @"identifier":@"EditProfileViewController"
                                                    
                                                    },@{
                                                        @"title":NSLocalizedString(@"Trip_History", @""),
                                                        @"icon":@"order",
                                                        @"identifier":@"TripHistoryViewController"
                                                        },@{@"title":NSLocalizedString(@"Rating", @""),
                                                            @"icon":@"star",
                                                            @"identifier":@"RatingViewController",
                                                            },@{
                                                                @"title":NSLocalizedString(@"Logout", @""),
                                                                @"icon":@"power-button",
                                                                @"identifier":SIDE_MENU_LOGOUT
                                                                },
                   
                   /* @{
                    @"title":NSLocalizedString(@"Terms_Conditions", @""),
                    @"icon":@"terms_condition",
                    @"identifier":SIDE_MENU_TERMS
                    },
                    */
                   
                   @{
                     @"title":NSLocalizedString(@"Share", @""),
                     @"icon":@"share",
                     @"identifier":SIDE_MENU_SHARE
                     },
                   @{
                     @"title":NSLocalizedString(@"Deactivate_Acc", @""),
                     @"icon":@"deactivate",
                     @"identifier":SIDE_MENU_DEACTIVATE
                     },
                   @{
                     @"title":NSLocalizedString(@"Support", @""),
                     @"icon":@"support",
                     @"identifier": SIDE_MENU_SUPPORT
                     },
                   nil];
    
    UINib *nib = [UINib nibWithNibName:@"SideMenuCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"SideMenuCell"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    
    
    //     [self switchChange:_switchAvailability];
    [self setprofileImage];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setprofileImage) name:@"change_profile" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSwitchStatus:) name:@"change_switch" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setSwitchStatusNo) name:@"change_switch1" object:nil];
    
    
}

-(void)setThemeConstants{
    
    _viewBackground.backgroundColor = CONSTANT_THEME_COLOR1;
    _viewSeparator.backgroundColor =CONSTANT_THEME_COLOR2;
    [_btnAvailability.titleLabel setFont:FONTS_THEME_REGULAR(17)];
    
   
    
}
-(void)setSwitchStatusNo{
    
    [UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];
    
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    NSString *driverID = [dict1 objectForKey:P_DRIVER_ID];
    NSDictionary *dict=@{
                         P_DRIVER_AVAILAILITY:@"0",
                         P_DRIVER_ID:driverID,
                         
                         };
    
    [APP_CallAPI gcURL:BASE_URL_DRIVER app:UPDATE_DRIVER_PROFILE
                  data:dict
      isShowErrorAlert:NO 
       completionBlock:^(id results, NSError *error) {
           if (error == nil) {
               
               [APP_DELEGATE setUserDict:[results objectForKey:P_RESPONSE]];
               
               _switchAvailability.userInteractionEnabled=YES;
               [_switchAvailability setOn:NO];
               [_btnAvailability setTitle:NSLocalizedString(@"Availability Off", @"") forState:UIControlStateNormal];
               
           }
           
           [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
       }];
}


-(void)setSwitchStatus:(NSNotification *)sender{
    
    BOOL isOn = [[sender.object objectForKey:@"isAvailable"] boolValue];
    
    
    if ( isOn) {
        
        _switchAvailability.userInteractionEnabled=YES;
        [_switchAvailability setOn:YES];
        [_btnAvailability setTitle:NSLocalizedString(@"Availability On", @"") forState:UIControlStateNormal];
        
    }
    else{
        
        _switchAvailability.userInteractionEnabled=NO;
        [_switchAvailability setOn:NO];
        [_btnAvailability setTitle:NSLocalizedString(@"Availability Off", @"")  forState:UIControlStateNormal];
    }
    
}
-(void)setprofileImage{
    
    
    
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    
    _lblName.text =[dict1 objectForKey:P_NAME];
    
    [_lblName setFont:FONT_ROB_COND_REG(17)];
    
    NSString *profile=[dict1 objectForKey:P_DRIVER_PROFILE_IMAGE_PATH];
    
    if (profile.length>0) {
        
        
        [_imgProfile sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",url_base_images, profile]] placeholderImage:[UIImage imageNamed:@"Profile Icon Crop Image"]];
    }
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arrSideMenu.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"SideMenuCell";
    
    
    
    SideMenuCell *cell = (SideMenuCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SideMenuCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    cell.lblMenu.text =[[_arrSideMenu objectAtIndex:indexPath.row]objectForKey:@"title"];
    [cell.imgIcon setImage:[UIImage imageNamed:[[_arrSideMenu objectAtIndex:indexPath.row] objectForKey:@"icon"]]];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor =CONSTANT_THEME_COLOR1;
    cell.viewSeparator.backgroundColor =CONSTANT_THEME_COLOR2;
    [cell.lblMenu setFont:FONTS_THEME_REGULAR(17)];
    
    //    [cell.lblMenu setFont:FONT_HELVETICANEUE_REGULAR(18)];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) {
        [cell setSelected:YES animated:NO];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 52;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    if (indexPath.row==3) {
    //
    //
    //    }
    //    else if (indexPath.row == 4) {
    //        // open url
    //        NSURL *url = [NSURL URLWithString:@""];
    //        [self openUrl:url];
    //    }
    //    else if(indexPath.row == 5){
    //        //share
    //        [self shareApp];
    //    }
    //    else if (indexPath.row == 6){
    //        //deactivate account
    //
    //    }
    
    
    NSString *sideOption = [[_arrSideMenu objectAtIndex:indexPath.row] objectForKey:@"identifier"];
    
    if ([sideOption isEqualToString:SIDE_MENU_LOGOUT]) {
        [self LogoutPressed_isLogout:YES];
    }
    else if ([sideOption isEqualToString:SIDE_MENU_TERMS]) {
        NSURL *url = [NSURL URLWithString:Terms_Conditions];
        [self openUrl:url];
    }
    else if ([sideOption isEqualToString:SIDE_MENU_SHARE]) {
        [self shareApp];
    }
    else if ([sideOption isEqualToString:SIDE_MENU_DEACTIVATE]) {
        [self LogoutPressed_isLogout:NO];
        //[self deactivateAccount];
    }
    
    else if ([sideOption isEqualToString:SIDE_MENU_SUPPORT]) {
        [self openMailComposer];
    }
    
    else{
        [self setViewControllers:sideOption]; //[[_arrSideMenu objectAtIndex:indexPath.row] objectForKey:@"identifier"]
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}



-(void)openUrl:(NSURL *)url{
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    }else {
        [UtilityClass showWarningAlert:nil message:NSLocalizedString(@"Url_Cannot_Open", @"") cancelButtonTitle:@"Ok" otherButtonTitle:nil];
    }
}

-(void)shareApp{
    NSString *textToShare = Share_Text;
    NSURL *myWebsite = [NSURL URLWithString:Promotion_Link];
    
    NSArray *objectsToShare = @[textToShare, myWebsite];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    
    NSArray *excludeActivities = @[UIActivityTypeAirDrop,
                                   UIActivityTypePrint,
                                   UIActivityTypeAssignToContact,
                                   UIActivityTypeSaveToCameraRoll,
                                   UIActivityTypeAddToReadingList,
                                   UIActivityTypePostToFlickr,
                                   UIActivityTypePostToVimeo];
    
    activityVC.excludedActivityTypes = excludeActivities;
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

-(void)deactivateAccount{
    
    //AppDelegate *appdelegate =APP_DELEGATE;
    
    NSString *status = defaults_object(DRIVER_STATUS);
    
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    
    NSString *driverID = [dict1 objectForKey:P_DRIVER_ID];
    
    if ([status isEqualToString:TS_WAITING]) {
        
        [UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];
        
        NSDictionary *dict=@{
                             P_DRIVER_AVAILAILITY:@"0",
                             P_DRIVER_ID:driverID,
                             P_DRIVER_VERIFIED :@"0"
                             };
        
        [APP_CallAPI gcURL:BASE_URL_DRIVER app:UPDATE_DRIVER_PROFILE
                      data:dict
         isShowErrorAlert:NO
           completionBlock:^(id results, NSError *error) {
               if (error == nil) {
                   
                   [APP_DELEGATE setUserDict:[results objectForKey:P_RESPONSE]];
                   
                   [self afterLogutWork];
                   
               }
               
               [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
           }];
    }
    
    
}




- (void)LogoutPressed_isLogout:(BOOL)isLogout {
    
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:isLogout ? NSLocalizedString(@"Logout", @"") : NSLocalizedString(@"Deactivate_Acc", @"")
                                 message: isLogout ? NSLocalizedString(@"logout_alert_message", @"") : NSLocalizedString(@"Deactivate_Alert", @"")
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Buttons
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"Yes", @"")
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    isLogout ? [self logoutAction] : [self deactivateAccount];
                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"No", @"")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   //Handle no, thanks button
                               }];
    
    //Add your buttons to alert controller
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
}

-(void)logoutAction{
    
    NSString *status = defaults_object(DRIVER_STATUS);
    NSLog(@"**** status ==== %@ ",status);
    
    if ([status isEqualToString:TS_WAITING]) {
        
        [[UpdateUserCurrentLocation sharedInstance]  updateDriverAvailablity:@"0"];
        [self afterLogutWork];
    }
    
    
}


-(void)afterLogutWork{
    
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:P_API_KEY];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:P_USER_DICT];
    
    RootViewController *loginViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"RootViewController"];
    
    UIWindow *window = UIApplication.sharedApplication.delegate.window;
    window.rootViewController = loginViewController;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

-(void)setViewControllers:(NSString *)sender{
    
    
    MainViewController *mainViewController = (MainViewController *)self.sideMenuController;
    UINavigationController *navigationController = (UINavigationController *)mainViewController.rootViewController;
    UIViewController *viewController=[self.storyboard instantiateViewControllerWithIdentifier:sender];
    
    [navigationController pushViewController:viewController animated:YES];
    [mainViewController hideLeftViewAnimated:YES completionHandler:nil];
    
}
- (IBAction)switchChange:(UISwitch *)sender {
    
    
    NSString *status;
    
    if (_switchAvailability.isOn) {
        status=@"1";
        
    }
    else{
        status=@"0";
    }
    
    [[UpdateUserCurrentLocation sharedInstance]  updateDriverAvailablity:status];
    
    _switchAvailability.userInteractionEnabled  =YES;
    
}


#pragma  mark -  Mail delegate method

-(void)openMailComposer{
    
    if([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
        mailCont.mailComposeDelegate = self;        // Required to invoke mailComposeController when send
        
        
        NSString * supportEmail = SUPPORT_EMAIL;
        NSMutableArray  *arrayEmails=[[NSMutableArray alloc]  init];
        [arrayEmails addObject:supportEmail];
        
        [mailCont setToRecipients:arrayEmails];
        /*
         [mailCont setSubject:@""];
         NSMutableString *body = [NSMutableString string];
         NSString *url = [NSString stringWithFormat:@"http://maps.google.com?q=%f,%f",[APP_DELEGATE currLoc].latitude,[APP_DELEGATE currLoc].longitude];
         [body appendString:[NSString stringWithFormat:@"Please help, I am in danger and need assistance.Follow my location,<a href=\"%@\">Click Here</a> \n ",url]];
         
         [mailCont setMessageBody:body isHTML:YES];
         */
        [self presentViewController:mailCont animated:YES completion:nil];
    }
    else
    {
        [UtilityClass showWarningAlert:@"Whoops!" message:NSLocalizedString(@"Config_Mail", @"") cancelButtonTitle:NSLocalizedString(@"alert_ok", @"") otherButtonTitle:nil];
    }
}


- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    if(error!= nil)
    {
        
       
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Whoops!"
                                                                                 message:[NSString stringWithFormat:@" ERROR %@",error]                                                                       preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:nil]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        
        
        return;
    }
    [controller dismissViewControllerAnimated:YES completion:nil];
}





@end
