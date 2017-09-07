//
//  GGRegistrationVC.m
//  GoGolf
//
//  Created by Eddyson Tan on 6/8/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGRegistrationVC.h"
#import "GGAPIManager.h"
#import "GGCommonFunc.h"
#import "GGGlobalVariable.h"
#import "MBProgressHUD.h"
#import "GGHomePageVC.h"
#import "GGGlobal.h"
#import "GGTermsVC.h"

@interface GGRegistrationVC () {
    NSInteger selectedRowLang;
    NSString *langId;
    NSInteger selectedRowCountry;
    GGTermsVC *termsVC;
}

@end

@implementation GGRegistrationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.svContainer setDelegate:self];
    [self.svContainer setUserInteractionEnabled:true];
    [self.svContainer setExclusiveTouch:true];
    
    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    countryID = @"1";
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tapTerms = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTermOfUse:)];
    [self.txtTermOfUse addGestureRecognizer:tapTerms];
    
    self.view.frame = CGRectMake(0, 0, [[GGCommonFunc sharedInstance] obtainScreenWidth], 736);
    self.viewContainer.frame = CGRectMake(self.viewContainer.frame.origin.x, self.viewContainer.frame.origin.y, self.viewContainer.frame.size.width, 736);
    
    [self.view updateConstraints];
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.pickerCountry reloadAllComponents];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [self.svContainer setContentSize:CGSizeMake(self.svContainer.bounds.size.width, 608)];
}

-(void)dismissKeyboard {
    [self.txtFirstName resignFirstResponder];
    [self.txtLastName resignFirstResponder];
    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
    [self.txtCodeNumber resignFirstResponder];
    [self.txtPhoneNumber resignFirstResponder];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

- (IBAction)registerAccount:(id)sender {
    NSLog(@"Clicked");
    
    if ([self.txtPassword.text isEqual:self.txtConfirm.text] ) {
        [self showCommonAlert:@"Notification" message:@"Password and Confirm password not same." index:3];
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            NSString *genderID = @"";
            if ([self.btnMale isSelected])
                genderID = @"m";
            else if ([self.btnFemale isSelected])
                genderID = @"f";
            
            [[GGAPIManager sharedInstance] registerInAccountWithFirstname:self.txtFirstName.text lastName:self.txtLastName.text email:self.txtEmail.text password:self.txtPassword.text country_ID:countryID gender:genderID phone:[NSString stringWithFormat:@"%@%@", self.txtCodeNumber.text, self.txtPhoneNumber.text] device_ID:@"device_id" langID:langId phoneCode:[self.txtCodeNumber.text stringByReplacingOccurrencesOfString:@"+" withString:@""] completion:^(NSError *error) {
                if (error != nil) {
                    
                    [self showCommonAlert:@"Error Notification" message:error.localizedDescription index:0];
                    
                } else {
                    
                    if ([[[GGGlobalVariable sharedInstance].itemRegister objectForKey:@"code"] integerValue] != 200) {
                        
                        [self showCommonAlert:@"Error Notification" message:[[GGGlobalVariable sharedInstance].itemRegister objectForKey:@"message"] index:0];
                        
                    } else {
                        
                        [self showCommonAlert:@"Notification" message:@"Registration Success" index:1];
                        //[self resetAllValue];
                    }
                }
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            });
        });
    }        
}

- (void) showCommonAlert:(NSString *) title message:(NSString *)msg index:(int) respIndex{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   //Handel no, thanks button
                                   
                                   if (respIndex == 1) {
                                       //[self.navigationController popViewControllerAnimated:YES];
                                       [self loginAfterSignUp];
                                   }
                                   
                               }];
    
    [alert addAction:okButton];
    
    [self presentViewController:alert  animated:YES completion:nil];
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
    [self resetAllValue];
}

- (IBAction)clickGender:(UIButton *)btnGender {
    if (btnGender == self.btnMale) {
        [self.btnMale setSelected:YES];
        [self.btnFemale setSelected:NO];
    } else if (btnGender == self.btnFemale) {
        [self.btnFemale setSelected:YES];
        [self.btnMale setSelected:NO];
    }
}

- (void)loginAfterSignUp {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [[GGAPIManager sharedInstance] signInAccountWithEmail:self.txtEmail.text
                                                     password:self.txtPassword.text
                                                   completion:^(NSError *error) {
                                                       if (error != nil) {
                                                           
                                                           [self showCommonAlert:@"Error Notification" message:error.description index:2];
                                                           
                                                       } else {
                                                           
                                                           if ([[[GGGlobalVariable sharedInstance].itemLogin objectForKey:@"code"] integerValue] != 200) {
                                                               
                                                               [self showCommonAlert:@"Error Notification" message:[[GGGlobalVariable sharedInstance].itemLogin objectForKey:@"message"] index:2];
                                                               
                                                           } else {
                                                               
                                                               GGHomePageVC *homePage = [self.storyboard instantiateViewControllerWithIdentifier:@"homePage"];
                                                               [self.navigationController pushViewController:homePage animated:YES];
                                                               
                                                               self.txtEmail.text = nil;
                                                               self.txtPassword.text = nil;
                                                           }
                                                       }
                                                   }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    });
}

- (void)showTermOfUse:(UITapGestureRecognizer *)sender {
    NSLog(@"tapped");
    
    termsVC = [[GGTermsVC alloc] initWithNibName:@"GGTermsVC" bundle:nil];
    termsVC.signUpDelegate = self;
    
    [self presentViewController:termsVC animated:true completion:nil];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[GGGlobal apiTermsOfUse]]];
}

- (void) resetAllValue {
    
    countryID = nil;
    
    [self.pickerCountry reloadAllComponents];
    [self.pickerCountry selectRow:0 inComponent:0 animated:YES];
    
    self.txtFirstName.text = nil;
    self.txtLastName.text = nil;
    self.txtEmail.text = nil;
    self.txtPassword.text = nil;
    self.txtCodeNumber.text = nil;
    self.txtPhoneNumber.text = nil;
    self.txtCountry.text = nil;
    self.txtLanguage.text = nil;
    
    [self.btnMale setSelected:NO];
    [self.btnFemale setSelected:NO];
}

-(void)categoryDoneButtonPressed{
    self.txtLanguage.text = [GGGlobalVariable sharedInstance].itemLanguageList[selectedRowLang];
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)setupCountryPickerView {
    self.pickerCountryGroup = [UIAlertController alertControllerWithTitle:@"Select Country" message:@"\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
    
    self.pickerCountry = [[UIPickerView alloc] init];
    [self.pickerCountry setDataSource: self];
    [self.pickerCountry setDelegate: self];
    self.pickerCountry.showsSelectionIndicator = true;
    self.pickerCountry.tag = 80;
    [self.pickerCountry reloadAllComponents];
    
    [self.pickerCountry setBounds:CGRectMake(-20,
                                              self.pickerCountry.bounds.origin.y,
                                              self.pickerCountry.bounds.size.width,
                                              self.pickerCountry.bounds.size.height)];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Done"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    countryID = [GGGlobalVariable sharedInstance].itemCountryList[@"data"][selectedRowCountry][@"country_id"];
                                    self.txtCountry.text = [GGGlobalVariable sharedInstance].itemCountryList[@"data"][selectedRowCountry][@"country_name"];
                                    [self dismissViewControllerAnimated:true completion:nil];
                                }];
    
    [self.pickerCountryGroup addAction:yesButton];
    [self.pickerCountryGroup.view addSubview:self.pickerCountry];
    
    [self presentViewController:self.pickerCountryGroup animated:true completion:nil];
}

- (void)setupLangPickerView {
    self.pickerViewPopup = [UIAlertController alertControllerWithTitle:@"Select Language" message:@"\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
    
//    [self.pickerViewPopup.view setBounds:CGRectMake(7, 180, [[GGCommonFunc sharedInstance] obtainScreenWidth], 114)];
    
    self.pickerLanguage = [[UIPickerView alloc] init];
    [self.pickerLanguage setDataSource: self];
    [self.pickerLanguage setDelegate: self];
    self.pickerLanguage.showsSelectionIndicator = true;
    self.pickerLanguage.tag = 81;
    [self.pickerLanguage reloadAllComponents];
    
    [self.pickerLanguage setBounds:CGRectMake(-20,
                                              self.pickerLanguage.bounds.origin.y,
                                              self.pickerLanguage.bounds.size.width,
                                              self.self.pickerLanguage.bounds.size.height)];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Done"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    self.txtLanguage.text = [GGGlobalVariable sharedInstance].itemLanguageList[selectedRowLang];
                                    langId = (selectedRowLang == 0) ? @"en" : (selectedRowLang == 1) ? @"id" : @"jp";
                                    [self dismissViewControllerAnimated:true completion:nil];
                                }];
    
    [self.pickerViewPopup addAction:yesButton];
    [self.pickerViewPopup.view addSubview:self.pickerLanguage];
    
    [self presentViewController:self.pickerViewPopup animated:true completion:nil];
}

#pragma mark - UIPICKER
- (IBAction)showLanguageList:(id)sender {
    [UIView animateWithDuration:0.4
                     animations:^{                          
                         [NSTimer scheduledTimerWithTimeInterval:0.3
                                                          target:self
                                                        selector:@selector(setupLangPickerView)
                                                        userInfo:nil
                                                         repeats:NO];
                     }];
}

- (IBAction)showCountryList:(id)sender {
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         
                         
                         [NSTimer scheduledTimerWithTimeInterval:0.3
                                                          target:self
                                                        selector:@selector(setupCountryPickerView)
                                                        userInfo:nil
                                                         repeats:NO];
                     }];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView.tag == 81)
        return [[GGGlobalVariable sharedInstance].itemLanguageList count];
    else
        return [[GGGlobalVariable sharedInstance].itemCountryList[@"data"] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView.tag == 81) {
        selectedRowLang = row;
        
        return [GGGlobalVariable sharedInstance].itemLanguageList[row];
    }else {
        selectedRowCountry = row;
        
        return [GGGlobalVariable sharedInstance].itemCountryList[@"data"][row][@"country_name"];
    }
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}


#pragma mark - TEXTFIELD DELEGATE

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.txtFirstName) {
        [self.txtLastName becomeFirstResponder];
    } else if (theTextField == self.txtLastName) {
        [self.txtEmail becomeFirstResponder];
    } else if (theTextField == self.txtEmail) {
        [self.txtPassword becomeFirstResponder];
    } else if (theTextField == self.txtPassword) {
        [self.txtCodeNumber becomeFirstResponder];
    }
    
    return YES;
}

#pragma end

#pragma mark - UISCROLLVIEW

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return ![view isKindOfClass:[UIButton class]];
}

#pragma end

@end
