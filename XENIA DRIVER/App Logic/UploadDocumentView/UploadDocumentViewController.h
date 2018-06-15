//
//  UploadDocumentViewController.h
//  Store_project
//
//  Created by  CoolDev on 22/05/17.
//  Copyright © 2017 CoolDev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IQDropDownTextField.h"
#import "TextFieldPadding.h"

@interface UploadDocumentViewController : UIViewController<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,IQDropDownTextFieldDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;


@property (nonatomic) BOOL isfromProfile;

@property (strong, nonatomic) IBOutlet UIButton *btnBack;

@property (strong, nonatomic) IBOutlet UIImageView *imgTick1;
@property (strong, nonatomic) IBOutlet UIImageView *imgTick2;
@property (strong, nonatomic) IBOutlet UIImageView *imgTick3;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner1;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner2;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner3;
@property (strong, nonatomic) IBOutlet UILabel *lblAddIdProof;
@property (strong, nonatomic) IBOutlet UILabel *lblAddLicense;
@property (strong, nonatomic) IBOutlet UILabel *lblAddInsurance;

@property (strong, nonatomic) IBOutlet IQDropDownTextField *txtSelectCategory;
@property (strong, nonatomic) IBOutlet TextFieldPadding *txtLicenseNumber;
@property (strong, nonatomic) IBOutlet UIView *viewIdproofBg;
@property (strong, nonatomic) IBOutlet UIView *viewLicenseBg;
@property (strong, nonatomic) IBOutlet UIView *viewInsuranceBg;

@property (strong, nonatomic) IBOutlet UIView *viewCategoryBg;
@property (strong, nonatomic) IBOutlet UIView *viewPlateNumberBg;


@property (strong, nonatomic) IBOutlet UIView *viewHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblHeader;
@property (strong, nonatomic) IBOutlet UILabel *lblVehicleInformation;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;

@end
