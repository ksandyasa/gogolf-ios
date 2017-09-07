//
//  GGRegistrationVC.h
//  GoGolf
//
//  Created by Eddyson Tan on 6/8/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGRegistrationVC : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UIScrollViewDelegate> {
    NSString *countryID;
}
@property (weak, nonatomic) IBOutlet UIScrollView *svContainer;

@property (weak, nonatomic) IBOutlet UIView *viewContainer;

@property (weak, nonatomic) IBOutlet UITextField *txtCountry;

@property (weak, nonatomic) IBOutlet UITextField *txtFirstName;

@property (weak, nonatomic) IBOutlet UITextField *txtLastName;

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@property (weak, nonatomic) IBOutlet UITextField *txtConfirm;

@property (weak, nonatomic) IBOutlet UITextField *txtPhoneNumber;

@property (weak, nonatomic) IBOutlet UITextField *txtCodeNumber;

@property (weak, nonatomic) IBOutlet UITextField *txtLanguage;

@property (weak, nonatomic) IBOutlet UILabel *txtTermOfUse;

@property (weak, nonatomic) IBOutlet UIButton *btnMale;

@property (weak, nonatomic) IBOutlet UIButton *btnFemale;

@property (strong, nonatomic) UIAlertController *pickerCountryGroup;

@property (strong, nonatomic) UIPickerView *pickerCountry;

@property (strong, nonatomic) UIAlertController *pickerViewPopup;

@property (strong, nonatomic) UIView *viewPickerLang;

@property (strong, nonatomic) UIPickerView *pickerLanguage;

@end
