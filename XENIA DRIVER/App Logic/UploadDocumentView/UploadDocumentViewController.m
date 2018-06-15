//
//  UploadDocumentViewController.m
//  Store_project
//
//  Created by  CoolDev on 22/05/17.
//  Copyright © 2017 CoolDev. All rights reserved.
//

#import "UploadDocumentViewController.h"
#import "CarCategoryCell.h"
#import "CarTypeCell.h"
//#import "CallAPI.h"
#import "WebCallConstants.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import <GrepixKit/GrepixKit.h>
#import "SignInViewController.h"

//#import "nsuserdefaults-helper.h"

@interface UploadDocumentViewController ()
{
    NSArray *catArray;
  
    NSString *selectedCatID;
  
    BOOL isRc;
    BOOL isInsurance;
    BOOL isLic;
   
  
    int cellCount;
    BOOL isOwnCarType;
  
    NSString *carPlateNumber;
    int apiCallAttempt;
}

@end

@implementation UploadDocumentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setThemeConstants];
    
   
    cellCount = 8;
    
    _spinner1.hidden =YES;
    _spinner2.hidden =YES;
    _spinner3.hidden =YES;
    apiCallAttempt =0;
    [self getCarCategory];
    
    //[self getCarname];
   // [self getYears];
    
    
   
    
    if (_isfromProfile) {
        
        _btnBack.hidden=NO;
    }
    else{
        _btnBack.hidden=YES;
    }
    
    
    
    
    catArray =[[NSArray alloc]init];
   
    
    self.spinner.hidden=YES;
    
    
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textFieldDone)
                                                 name:@"DoneCalled"
                                               object:nil];
    
    
    
    self.txtSelectCategory.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.txtSelectCategory.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    self.txtLicenseNumber.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.txtLicenseNumber.placeholder attributes:@{NSForegroundColorAttributeName: [UIColor darkGrayColor]}];
    
    self.txtSelectCategory.delegate =self;
    
    
    
    [self setBorder:_viewIdproofBg];
    [self setBorder:_viewLicenseBg];
    [self setBorder:_viewCategoryBg];
    [self setBorder:_viewInsuranceBg];
    [self setBorder:_viewPlateNumberBg];
    
    [self updateDocumentDetail];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
     SignInViewController *vc =(SignInViewController*)[segue destinationViewController];
     vc.isFromUpload =YES;
 }


-(void)setThemeConstants{
    
    _viewHeader.backgroundColor = CONSTANT_THEME_COLOR1;
     _lblHeader.textColor =CONSTANT_TEXT_COLOR_HEADER;
    [_lblHeader setFont:FONTS_THEME_REGULAR(19)];
    [_lblVehicleInformation setFont:FONTS_THEME_REGULAR(17)];
    [_btnNext.titleLabel setFont:FONTS_THEME_REGULAR(19)];
    [_lblAddIdProof setFont:FONTS_THEME_REGULAR(16)];
     [_lblAddLicense setFont:FONTS_THEME_REGULAR(16)];
     [_lblAddInsurance setFont:FONTS_THEME_REGULAR(16)];
    
    [_txtSelectCategory setFont:FONTS_THEME_REGULAR(16)];
    [_txtLicenseNumber setFont:FONTS_THEME_REGULAR(16)];
    
}
-(void)setBorder:(UIView *)view{
    
    view.layer.borderWidth=1;
    view.layer.cornerRadius =2;
    view.layer.borderColor = RGBA(40.0, 40.0, 40.0, 1).CGColor;
    [view clipsToBounds];
    
}

-(void) updateDocumentDetail
{
    
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    
    NSString *strlpath =[dict objectForKey:P_DRIVER_LIC_IMAGE_PATH];
    NSString *strrcpath = [dict objectForKey:P_DRIVER_RC_IMAGE_PATH];
    NSString *strinsurance = [dict objectForKey:P_DRIVER_INSURANCE_IMAGE_PATH];
    
    
    
    
    if (strrcpath.length >0) {
        _imgTick1.hidden =NO;
        
        _lblAddIdProof.text =NSLocalizedString(@"Added ID Proof", @"");
        
    }
    else{
        _imgTick1.hidden =YES;
        _lblAddIdProof.text = NSLocalizedString(@"Add ID Proof", @"");
        
    }
    
    
    if (strlpath.length >0) {
        _imgTick2.hidden =NO;
        
        _lblAddLicense.text =NSLocalizedString(@"Added License", @"");
        
    }
    else{
        _imgTick2.hidden =YES;
        _lblAddLicense.text = NSLocalizedString(@"Add License", @"");
    }
    
    
    
    
    if (strinsurance.length >0) {
        _imgTick3.hidden =NO;
        
        _lblAddInsurance.text = NSLocalizedString(@"Added Insurance", @"");
        
    }
    else{
        _lblAddInsurance.text = NSLocalizedString(@"Add Insurance", @"");
        _imgTick3.hidden =YES;
    }
    
    
    
    
    selectedCatID = [dict objectForKey:P_CATEGORY_ID];;
   
    carPlateNumber  = [dict objectForKey:@"car_reg_no"];
    
    
  
    _txtLicenseNumber.text =carPlateNumber;
    
    
}



- (IBAction)ButtonNext:(id)sender {
    
    
    
    // AppDelegate *appdelegate =APP_DELEGATE;
    
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    
    
    if (carPlateNumber.length>0 && [carPlateNumber isEqualToString:_txtLicenseNumber.text]) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if (_txtLicenseNumber.text.length==0) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                 message:NSLocalizedString(@"Enter_Lic_Number", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             //[self dismissViewControllerAnimated:YES completion:nil];
                                                         }]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
        
    }
    else if (selectedCatID.length ==0){
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                 message:NSLocalizedString(@"Select_Category", @"")
                                                                          preferredStyle:UIAlertControllerStyleAlert];
        //We add buttons to the alert controller by creating UIAlertActions:
        UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             //[self dismissViewControllerAnimated:YES completion:nil];
                                                         }]; //You can use a block here to handle a press on this button
        [alertController addAction:actionOk];
        [self presentViewController:alertController animated:YES completion:nil];
        return;
        
    }
    
   
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{
                                                                                
                                                                                P_DRIVER_ID               :[dict1 objectForKey:P_DRIVER_ID],
                                                                               @"car_reg_no"   :_txtLicenseNumber.text,
                                                                                P_CATEGORY_ID           :selectedCatID,
                                                                                }];
    
    
    
    [UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];
    
    [APP_CallAPI gcURL:BASE_URL_DRIVER app:UPDATE_DRIVER_PROFILE
                  data:dict
     isShowErrorAlert:NO
       completionBlock:^(id results, NSError *error) {
           if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
               // success
               
               AppDelegate *appdelegate =APP_DELEGATE;
               appdelegate.userDict = [results objectForKey:P_RESPONSE];
               defaults_set_object(P_USER_DICT, appdelegate.userDict);
               
               
               
               if (_isfromProfile) {
                   [self.navigationController popViewControllerAnimated:YES];
               }
               else{
                   [self performSegueWithIdentifier:@"SignInViewController" sender:nil];
               }
           }
           else{
               
               UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                        message:NSLocalizedString(@"Car_Registered", @"")
                                                                                 preferredStyle:UIAlertControllerStyleAlert];
               //We add buttons to the alert controller by creating UIAlertActions:
               UIAlertAction *actionOk = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_ok", @"")
                                                                  style:UIAlertActionStyleDefault
                                                                handler:^(UIAlertAction * _Nonnull action) {
                                                                    [self dismissViewControllerAnimated:YES completion:nil];
                                                                }]; //You can use a block here to handle a press on this button
               [alertController addAction:actionOk];
               [self presentViewController:alertController animated:YES completion:nil];
           }
           [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
       }];
    
}





- (IBAction)ButtonBackAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getCarCategory{
    
    // appdelegate.apikey = @"07c855e85b6f2598085cccca852bd15d";
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    
    [UtilityClass SetLoaderHidden:NO withTitle:NSLocalizedString(@"loading", @"")];
    
    [APP_CallAPI gcURL:BASE_URL_DRIVER app:CAR_GETCATEGORY
                  data:dict
      isShowErrorAlert:NO
       completionBlock:^(id results, NSError *error) {
           apiCallAttempt++;
           if ([[results objectForKey:P_STATUS] isEqualToString:@"OK"]) {
               // success
               
               
               catArray =[results objectForKey:P_RESPONSE];
               
               NSArray *arrCat  =[catArray valueForKey:@"cat_name"] ;
               _txtSelectCategory.isOptionalDropDown = YES;
               _txtSelectCategory.optionalItemText = NSLocalizedString(@"Select a Category",@"");
               [_txtSelectCategory setItemList:arrCat];
               
               for (NSDictionary *dic in catArray) {
                   if ([[dic objectForKey:P_CATEGORY_ID] isEqualToString:selectedCatID]) {
                       [_txtSelectCategory setSelectedItem:[dic objectForKey:@"cat_name"]];
                   }
               }
               
           }
           else{
               
               if(apiCallAttempt<3){
                   [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
                   [self getCarCategory];
               }
               
           }
           [UtilityClass SetLoaderHidden:YES withTitle:NSLocalizedString(@"loading", @"")];
       }];
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    AppDelegate *appdelegate =APP_DELEGATE;
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *resizeImage= [self imageWithImage:chosenImage scaledToSize:CGSizeMake(300, 300)];
    [Base64 initialize];
    NSString *strImage =[Base64 encode:UIImagePNGRepresentation(resizeImage)];
    NSDictionary *dict1 = [[NSUserDefaults standardUserDefaults]objectForKey:P_USER_DICT];
    NSMutableDictionary * dict=[[NSMutableDictionary alloc] initWithDictionary:@{P_API_KEY:[dict1 objectForKey:P_API_KEY],P_DRIVER_ID:[dict1 objectForKey:P_DRIVER_ID]}];
    if (isRc) {
        [dict setObject:strImage forKey:P_DRIVER_RC];
        [self.spinner1 startAnimating];
        self.spinner1.hidden=NO;
        _imgTick1.hidden=YES;
    }
    else if(isLic) {
        [dict setObject:strImage forKey:P_DRIVER_LIC];
        [self.spinner2 startAnimating];
        self.spinner2.hidden=NO;
        _imgTick2.hidden =YES;
    }
    else if (isInsurance){
        [dict setObject:strImage forKey:P_DRIVER_INSURANCE];
        [self.spinner3 startAnimating];
        self.spinner3.hidden=NO;
        _imgTick3.hidden =YES;
    }
    [APP_CallAPI gcURL:BASE_URL_DRIVER app:UPDATE_DRIVER_PROFILE
                  data:dict
     isShowErrorAlert:NO
       completionBlock:^(id results, NSError *error) {
        if([[results objectForKey:P_STATUS] isEqualToString:@"OK"])
        {
            appdelegate.userDict = [results objectForKey:P_RESPONSE];
            defaults_set_object(P_USER_DICT, appdelegate.userDict);
            //  NSIndexPath* indexPath1;
            if ([dict.allKeys containsObject:P_DRIVER_RC]) {
                
                // indexPath1 = [NSIndexPath indexPathForRow:1 inSection:0];
                [self.spinner1 stopAnimating];
                self.spinner1.hidden=YES;
                _imgTick1.hidden=NO;
                  _lblAddIdProof.text = NSLocalizedString(@"Added ID Proof", @"");
                
            }
            else if([dict.allKeys containsObject:P_DRIVER_LIC]) {
                
                //indexPath1 = [NSIndexPath indexPathForRow:0 inSection:0];
                
                
                [self.spinner2 stopAnimating];
                self.spinner2.hidden=YES;
                _imgTick2.hidden =NO;
                 _lblAddLicense.text = NSLocalizedString(@"Added License", @"");
                
                
            }
            else if (isInsurance){
                //indexPath1 = [NSIndexPath indexPathForRow:2 inSection:0];
                
                [self.spinner3 stopAnimating];
                self.spinner3.hidden=YES;
                _imgTick3.hidden =NO;
               _lblAddInsurance.text = NSLocalizedString(@"Added Insurance", @"");
            }
            // [self.tableView reloadRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }];
}


-(NSString *)encodeImageToBase64String:(UIImage *)image
{
    return [UIImagePNGRepresentation(image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}

- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


#pragma mark - Picker
-(void)textField:(nonnull IQDropDownTextField*)textField didSelectItem:(nonnull NSString*)item {
    
    if (textField.tag ==4){
            
            
            for (NSDictionary *dic in catArray) {
                if ([[dic objectForKey:@"cat_name"] isEqualToString:item]) {
                    selectedCatID = [dic objectForKey:@"category_id"];
                    
                }
            }
            
        }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == _txtSelectCategory) {
        
        if (catArray.count ==0) {
            [self getCarCategory];
        }
    }
    
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return YES;
}

-(void)setCustomDoneTarget:(nullable id)target action:(nullable SEL)action{
    
}

-(void)textFieldDone{
    
//    if ([selectedCarType isEqualToString:NSLocalizedString(@"add your own",@"")]) {
//        
//        isOwnCarType =YES;
//        //  NSIndexPath* indexPath1 = [NSIndexPath indexPathForRow:3 inSection:0];
//        //  NSIndexPath* indexPath2 = [NSIndexPath indexPathForRow:4 inSection:0];
//        
//        //  [self.tableView reloadRowsAtIndexPaths:@[indexPath1] withRowAnimation:UITableViewRowAnimationNone];
//        //  [self.tableView reloadRowsAtIndexPaths:@[indexPath2] withRowAnimation:UITableViewRowAnimationNone];
//        
//        self.viewEnterMakeBg.hidden =NO;
//        self.viewEnterModelBg.hidden =NO;
//        self.viewMakeBg.hidden=YES;
//        self.viewModelBg.hidden =YES;
//        
//    }
//    else{
//        isOwnCarType =NO;
//    }
    
}

-(void)text:(UITextField *)textField{
    if (textField.tag == 7) {
        carPlateNumber= textField.text;
    }
    
    
}
- (IBAction)ButtonSelectImage:(UIButton *)sender {
    
    if (sender.tag ==1) {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        isRc=YES;
        isLic=NO;
        isInsurance =NO;
        [self presentViewController:picker animated:YES completion:nil];
        
        //selectedCell=[tableView cellForRowAtIndexPath:indexPath];
        
    }
    else if (sender.tag ==2){
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        isRc=NO;
        isInsurance =NO;
        isLic =YES;
        [self presentViewController:picker animated:YES completion:nil];
        // selectedCell=[tableView cellForRowAtIndexPath:indexPath];
        
    }
    
    else if (sender.tag ==3){
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        isInsurance=YES;
        isRc=NO;
        isLic=NO;
        [self presentViewController:picker animated:YES completion:nil];
        //selectedCell=[tableView cellForRowAtIndexPath:indexPath];
        
    }
}



@end
