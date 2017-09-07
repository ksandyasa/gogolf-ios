//
//  GGSignUpVC.h
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/9/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GGSignUpCell1.h"
#import "GGSignUpCell2.h"
#import "GGSignUpCell3.h"
#import "GGSignUpCell4.h"
#import "GGSignUpFooter.h"
#import "GGAPIManager.h"
#import "GGCommonFunc.h"
#import "GGGlobalVariable.h"
#import "MBProgressHUD.h"
#import "GGHomePageVC.h"
#import "GGGlobal.h"
#import "GGTermsVC.h"

@interface GGSignUpVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tblSignUp;

@property (weak, nonatomic) id loginDelegate;

@property (strong, nonatomic) UIAlertController *pickerCountryGroup;

@property (strong, nonatomic) UIPickerView *pickerCountry;

@property (strong, nonatomic) UIAlertController *pickerViewPopup;

@property (strong, nonatomic) UIView *viewPickerLang;

@property (strong, nonatomic) UIPickerView *pickerLanguage;

- (IBAction)goBack:(id)sender;

- (void)registerWithNewAccount;

- (void)setupCountryPickerView:(UITapGestureRecognizer *)sender;

- (void)setupLangPickerView:(UITapGestureRecognizer *)sender;

- (void)setupMaleGender;

- (void)setupFemaleGender;

- (void)showTermOfUse;

@end
