//
//  GGUpdateProfileVC.m
//  GoGolf
//
//  Created by Eddyson Tan on 9/2/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGUpdateProfileVC.h"
#import "GGAPIManager.h"
#import "GGCommonFunc.h"
#import "MBProgressHUD.h"

@interface GGUpdateProfileVC () {
    UITextField *txtFirst, *txtLast, *txtAddress, *txtPhone, *txtCurPass, *txtNewPass, *txtConfirm, *txtEmail;
    NSString *stringLang;
    NSString *stringLangId;
    NSInteger selectedRowLang;
}

@end

int isEditMode = 0;

@implementation GGUpdateProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
    [self setNeedsStatusBarAppearanceUpdate];
    
    if (_clickSection == 1) {
        if (_clickIndex == 0) {
            stringLangId = [[GGGlobalVariable sharedInstance].itemUserDetail objectForKey:@"data"][@"lang"];
            [self setupLangPickerView];
        }
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tblUpdateProfile reloadData];
}

- (IBAction)goBack:(id)sender {
    if (isEditMode == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [txtFirst resignFirstResponder];
        [txtEmail resignFirstResponder];
        [txtLast resignFirstResponder];
        [txtAddress resignFirstResponder];
        [txtPhone resignFirstResponder];
        [txtCurPass resignFirstResponder];
        [txtNewPass resignFirstResponder];
        [txtConfirm resignFirstResponder];
        isEditMode = 0;
    }
}

- (IBAction) updateProfile:(id)sender {
    
    if (_clickSection == 0) {
        
        if (_clickIndex == 0) {
//            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
//            UITableViewCell *cell = [self.tblUpdateProfile cellForRowAtIndexPath:indexPath];
//            
//            txtFirst = (UITextField *)[cell viewWithTag:2];
//            
//            NSIndexPath *indexPath1=[NSIndexPath indexPathForRow:1 inSection:0];
//            UITableViewCell *cell1 = [self.tblUpdateProfile cellForRowAtIndexPath:indexPath1];
//            
//            txtLast = (UITextField *)[cell1 viewWithTag:2];
//            
//            txtFirst.delegate = self;
//            txtLast.delegate = self;
            
            if ([txtFirst.text isEqualToString:@""]) {
                [self showCommonAlert:@"Alert" message:@"Please insert first name" indeks:1];
            }else if ([txtFirst.text length] > 35) {
                [self showCommonAlert:@"Alert" message:@"The length of first name cannot be more than 35 characters" indeks:1];
            }else {
                if ([txtLast.text isEqualToString:@""]) {
                    [self showCommonAlert:@"Alert" message:@"Please insert last name" indeks:1];
                }else if ([txtLast.text length] > 35) {
                    [self showCommonAlert:@"Alert" message:@"The length of last name cannot be more than 35 characters" indeks:1];
                }else {
                    if ([[GGCommonFunc sharedInstance] connected]) {
                        [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
                        
                        [[GGAPIUserManager sharedInstance] updateUserProfile:txtFirst.text lname:txtLast.text email:[GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"email"] phone:[GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"phone"] address:[GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"address"] lang:[GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"lang"] phoneCode:[GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"phone_country"] withcompletion:^(NSDictionary *responseDict, NSError *error) {
                            if (error == nil) {
                                [txtFirst resignFirstResponder];
                                [txtLast resignFirstResponder];
                                [[GGCommonFunc sharedInstance] hideLoadingImage];
                                
                                if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                                    [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                                    [[GGAPIManager sharedInstance] clearAllData];
                                    [self.navigationController popToRootViewControllerAnimated:YES];
                                } else {
                                    [self showCommonAlert:@"Notification" message:[responseDict objectForKey:@"message"] indeks:0];
                                    NSLog(@"UPDATE : %@", responseDict);
                                }
                            } else {
                                [self showCommonAlert:@"Notification" message:[[responseDict objectForKey:@"message"] description] indeks:1];
                            }
                            
                        }];
                    }else{
                        [self showCommonAlert:@"Alert" message:@"No internet connection." indeks:1];
                    }
                }
            }
            
        } else if (_clickIndex == 1) {
//            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
//            UITableViewCell *cell = [self.tblUpdateProfile cellForRowAtIndexPath:indexPath];
//            
//            txtEmail = (UITextField *)[cell viewWithTag:2];
//            txtEmail.delegate = self;
            
            if ([txtEmail.text isEqualToString:@""]) {
                [self showCommonAlert:@"Alert" message:@"Please insert email" indeks:1];
            }else if ([txtEmail.text length] > 255) {
                [self showCommonAlert:@"Alert" message:@"The length of email cannot be more than 254 characters" indeks:1];
            }else if (![[GGCommonFunc sharedInstance] isValidEmail:txtEmail.text]) {
                [self showCommonAlert:@"Alert" message:@"Please insert valid email" indeks:1];
            }else {
                if ([[GGCommonFunc sharedInstance] connected]) {
                    [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
                    [[GGAPIUserManager sharedInstance] updateUserProfile:[GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"fname"] lname:[GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"lname"] email:txtEmail.text phone:[GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"phone"] address:[GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"address"] lang:[GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"lang"] phoneCode:[GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"phone_country"] withcompletion:^(NSDictionary *responseDict, NSError *error) {
                        [txtEmail resignFirstResponder];
                        if (error == nil) {
                            [[GGCommonFunc sharedInstance] hideLoadingImage];
                            if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                                [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                                [[GGAPIManager sharedInstance] clearAllData];
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            } else {
                                [self showCommonAlert:@"Notification" message:[responseDict objectForKey:@"message"] indeks:0];
                                NSLog(@"UPDATE : %@", responseDict);
                            }
                        } else {
                            [self showCommonAlert:@"Notification" message:[[responseDict objectForKey:@"message"] description] indeks:1];
                        }
                        
                    }];
                }else{
                    [self showCommonAlert:@"Alert" message:@"No internet connection." indeks:1];
                }
            }
            
        } else if (_clickIndex == 2) {
//            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
//            UITableViewCell *cell = [self.tblUpdateProfile cellForRowAtIndexPath:indexPath];
//            
//            txtPhone = (UITextField *)[cell viewWithTag:2];
//            txtPhone.delegate = self;
            
            if ([txtPhone.text isEqualToString:@""]) {
                [self showCommonAlert:@"Alert" message:@"Please insert phone number" indeks:1];
            }else if ([txtPhone.text length] > 15) {
                [self showCommonAlert:@"Alert" message:@"The length of phone number cannot be more than 15 characters" indeks:1];
            }else if ([txtPhone.text length] < 9) {
                [self showCommonAlert:@"Alert" message:@"The length of phone number cannot be less than 9 characters" indeks:1];
            }else {
                if ([[GGCommonFunc sharedInstance] connected]) {
                    [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
                    [[GGAPIUserManager sharedInstance] updateUserProfile:[GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"fname"] lname:[GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"lname"] email:[GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"email"] phone:txtPhone.text address:[GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"address"] lang:[GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"lang"] phoneCode:[GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"phone_country"] withcompletion:^(NSDictionary *responseDict, NSError *error) {
                        [txtPhone resignFirstResponder];
                        if (error == nil) {
                            [[GGCommonFunc sharedInstance] hideLoadingImage];
                            if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                                [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                                [[GGAPIManager sharedInstance] clearAllData];
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            } else {
                                [self showCommonAlert:@"Notification" message:[responseDict objectForKey:@"message"] indeks:0];
                                NSLog(@"UPDATE : %@", responseDict);
                            }
                        } else {
                            [self showCommonAlert:@"Notification" message:[[responseDict objectForKey:@"message"] description] indeks:1];
                        }
                        
                    }];
                }else{
                    [self showCommonAlert:@"Alert" message:@"No internet connection." indeks:1];
                }
            }
            
        } else if (_clickIndex == 3) {
//            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
//            UITableViewCell *cell = [self.tblUpdateProfile cellForRowAtIndexPath:indexPath];
//            
//            txtAddress = (UITextField *)[cell viewWithTag:2];
//            txtAddress.delegate = self;
            
            if ([txtAddress.text isEqualToString:@""]) {
                [self showCommonAlert:@"Alert" message:@"Please insert address" indeks:1];
            }else if ([txtAddress.text length] > 300) {
                [self showCommonAlert:@"Alert" message:@"The length of address cannot be more than 300 characters" indeks:1];
            }else {
                if ([[GGCommonFunc sharedInstance] connected]) {
                    [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
                    [[GGAPIUserManager sharedInstance] updateUserProfile:[GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"fname"] lname:[GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"lname"] email:[GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"email"] phone:[GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"phone"] address:txtAddress.text lang:[GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"lang"] phoneCode:[GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"phone_country"] withcompletion:^(NSDictionary *responseDict, NSError *error) {
                        [[GGCommonFunc sharedInstance] hideLoadingImage];
                        [txtAddress resignFirstResponder];
                        if (error == nil) {
                            if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                                [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                                [[GGAPIManager sharedInstance] clearAllData];
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            } else {
                                [self showCommonAlert:@"Notification" message:[responseDict objectForKey:@"message"] indeks:0];
                                NSLog(@"UPDATE : %@", responseDict);
                            }
                        } else {
                            [self showCommonAlert:@"Notification" message:[[responseDict objectForKey:@"message"] description] indeks:1];
                        }
                        
                    }];
                }else{
                    [self showCommonAlert:@"Alert" message:@"No internet connection." indeks:1];
                }
            }
        }
        
    } else if (_clickSection == 1) {
//        if (_clickIndex == 0) {
//            
//            if ([[GGCommonFunc sharedInstance] connected]) {
//                [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
//                [[GGAPIUserManager sharedInstance] updateUserProfile:[GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"fname"] lname:[GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"lname"] email:[GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"email"] phone:[GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"phone"] address:[GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"address"] lang:stringLangId phoneCode:[GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"phone_country"] withcompletion:^(NSDictionary *responseDict, NSError *error) {
//                    if (error == nil) {
//                        [[GGCommonFunc sharedInstance] hideLoadingImage];
//                        if ([[responseDict objectForKey:@"code"] intValue] == 400) {
//                            [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
//                            [[GGAPIManager sharedInstance] clearAllData];
//                            [self.navigationController popToRootViewControllerAnimated:YES];
//                        } else {
//                            [self showCommonAlert:@"Notification" message:[responseDict objectForKey:@"message"] indeks:0];
//                            NSLog(@"UPDATE : %@", responseDict);
//                        }
//                    } else {
//                        [self showCommonAlert:@"Notification" message:[responseDict objectForKey:@"message"] indeks:1];
//                    }
//                    
//                }];
//            }else{
//                [self showCommonAlert:@"Alert" message:@"No internet connection." indeks:1];
//            }
//            
//        } else
            if (_clickIndex == 0) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//            UITableViewCell *cell = [self.tblUpdateProfile cellForRowAtIndexPath:indexPath];
//            
//            txtCurPass = (UITextField *)[cell viewWithTag:2];
//
//            NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:1 inSection:0];
//            UITableViewCell *cell1 = [self.tblUpdateProfile cellForRowAtIndexPath:indexPath1];
//            
//            txtNewPass = (UITextField *)[cell1 viewWithTag:2];
//
//            NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:2 inSection:0];
//            UITableViewCell *cell2 = [self.tblUpdateProfile cellForRowAtIndexPath:indexPath2];
//            
//            txtConfirm = (UITextField *)[cell2 viewWithTag:2];
//            
//            txtCurPass.delegate = self;
//            txtNewPass.delegate = self;
//            txtConfirm.delegate = self;
            
            if ([txtCurPass.text isEqualToString:@""]) {
                [self showCommonAlert:@"Alert" message:@"Please insert password" indeks:1];
            }else if ([txtCurPass.text length] > 20) {
                [self showCommonAlert:@"Alert" message:@"The lenght of password cannot be more than 20 characters" indeks:1];
            }else if ([txtCurPass.text length] < 8) {
                [self showCommonAlert:@"Alert" message:@"The lenght of password cannot be less than 8 characters" indeks:1];
            }else {
                if ([txtNewPass.text isEqualToString:@""]) {
                    [self showCommonAlert:@"Alert" message:@"Please insert password" indeks:1];
                }else if ([txtNewPass.text length] > 20) {
                    [self showCommonAlert:@"Alert" message:@"The lenght of password cannot be more than 20 characters" indeks:1];
                }else if ([txtNewPass.text length] < 8) {
                    [self showCommonAlert:@"Alert" message:@"The lenght of password cannot be less than 8 characters" indeks:1];
                }else {
                    if ([txtConfirm.text isEqualToString:@""]) {
                        [self showCommonAlert:@"Alert" message:@"Please insert password" indeks:1];
                    }else if ([txtConfirm.text length] > 20) {
                        [self showCommonAlert:@"Alert" message:@"The lenght of password cannot be more than 20 characters" indeks:1];
                    }else if ([txtConfirm.text length] < 8) {
                        [self showCommonAlert:@"Alert" message:@"The lenght of password cannot be less than 8 characters" indeks:1];
                    }else if (![txtConfirm.text isEqualToString:txtNewPass.text] && ![txtNewPass.text isEqualToString:@""]) {
                        [self showCommonAlert:@"Alert" message:@"Confirm password doesn't match with new password." indeks:1];
                    }else {
                        if ([[GGCommonFunc sharedInstance] connected]) {
                            [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
                            [[GGAPIUserManager sharedInstance] updateUserPassword:txtCurPass.text newpassword:txtNewPass.text confirmpassword:txtConfirm.text withcompletion:^(NSDictionary *responseDict, NSError *error) {
                                [txtCurPass resignFirstResponder];
                                [txtNewPass resignFirstResponder];
                                [txtConfirm resignFirstResponder];
                                if (error == nil) {
                                    [[GGCommonFunc sharedInstance] hideLoadingImage];
                                    if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                                        [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                                        [[GGAPIManager sharedInstance] clearAllData];
                                        [self.navigationController popToRootViewControllerAnimated:YES];
                                    } else {
                                        [self showCommonAlert:@"Notification" message:[responseDict objectForKey:@"message"] indeks:0];
                                    }
                                } else {
                                    [self showCommonAlert:@"Notification" message:[responseDict objectForKey:@"message"] indeks:1];
                                }
                                
                            }];
                        }else{
                            [self showCommonAlert:@"Alert" message:@"No internet connection." indeks:1];
                        }
                    }
                }
            }
        }
    }

}

- (void) showCommonAlert:(NSString *) title message:(NSString *)msg indeks:(int)indeks {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   if (indeks == 0)
                                       if (isEditMode == 0) {
                                           [self goBack:nil];
                                       }
                               }];
    
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)setupLangPickerView {
    self.pickerViewPopup = [UIAlertController alertControllerWithTitle:@"Select Language" message:@"\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
    
    //    [self.pickerViewPopup.view setBounds:CGRectMake(7, 180, [[GGCommonFunc sharedInstance] obtainScreenWidth], 114)];
    
    self.pickerLanguage = [[UIPickerView alloc] init];
    [self.pickerLanguage setDataSource: self];
    [self.pickerLanguage setDelegate: self];
    self.pickerLanguage.showsSelectionIndicator = true;
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
                                    stringLang = [GGGlobalVariable sharedInstance].itemLanguageList[selectedRowLang];
                                    stringLangId = (selectedRowLang == 0) ? @"en" : (selectedRowLang == 1) ? @"id" : @"jp";
                                    [self dismissViewControllerAnimated:true completion:nil];
                                    [self.tblUpdateProfile reloadData];
                                }];
    
    [self.pickerViewPopup addAction:yesButton];
    [self.pickerViewPopup.view addSubview:self.pickerLanguage];
}

- (void)showPickerLanguageView {
    [self presentViewController:self.pickerViewPopup animated:true completion:nil];
    [self.pickerLanguage selectRow:selectedRowLang inComponent:0 animated:true];
}

#pragma mark - UITABLEVIEW DELEGATE & DATASOURCE

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_clickSection == 0) {
        if (_clickIndex == 0)
            return 2;
        else if (_clickIndex == 1)
            return 1;
        else if (_clickIndex == 2)
            return 1;
        else if (_clickIndex == 3)
            return 1;
    } else if (_clickSection == 1) {
//        if (_clickIndex == 0)
//            return 1;
//        else
            if (_clickIndex == 0)
            return 3;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseIdentifier = @"profileDetailCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    UILabel *lblTitle = (UILabel *)[cell viewWithTag:1];
    
    if (_clickSection == 0) {
        if (_clickIndex == 0) {
            
            if (indexPath.row == 0) {
                txtFirst = (UITextField *)[cell viewWithTag:2];
                txtFirst.delegate = self;
                lblTitle.text = @"First Name";
                txtFirst.text = [[GGGlobalVariable sharedInstance].itemUserDetail objectForKey:@"data"][@"fname"];
                [txtFirst becomeFirstResponder];
                isEditMode = 1;
            } else if (indexPath.row == 1) {
                txtLast = (UITextField *)[cell viewWithTag:2];
                txtLast.delegate = self;
                lblTitle.text = @"Last Name";
                txtLast.text = [[GGGlobalVariable sharedInstance].itemUserDetail objectForKey:@"data"][@"lname"];
            }
            
        } else if (_clickIndex == 1) {
            txtEmail = (UITextField *)[cell viewWithTag:2];
            txtEmail.delegate = self;
            lblTitle.text = @"Email";
            txtEmail.text = [[GGGlobalVariable sharedInstance].itemUserDetail objectForKey:@"data"][@"email"];
            [txtEmail becomeFirstResponder];
            isEditMode = 1;
        } else if (_clickIndex == 2) {
            txtPhone = (UITextField *)[cell viewWithTag:2];
            txtPhone.delegate = self;
            lblTitle.text = @"Phone";
            txtPhone.text = [[GGGlobalVariable sharedInstance].itemUserDetail objectForKey:@"data"][@"phone"];
            [txtPhone becomeFirstResponder];
            isEditMode = 1;
        } else if (_clickIndex == 3) {
            txtAddress = (UITextField *)[cell viewWithTag:2];
            txtAddress.delegate = self;
            lblTitle.text = @"Address";
            txtAddress.text = [[GGGlobalVariable sharedInstance].itemUserDetail objectForKey:@"data"][@"address"];
            [txtAddress becomeFirstResponder];
            isEditMode = 1;
        }
    } else if (_clickSection == 1) {
//        if (_clickIndex == 0) {
//            UITextField *txtField = (UITextField *)[cell viewWithTag:2];
//            txtField.delegate = self;
//            lblTitle.text = @"Language";
//            if ([stringLangId isEqualToString:@"en"]) {
//                txtField.text = @"English";
//                selectedRowLang = 0;
//            }else if ([stringLangId isEqualToString:@"id"]) {
//                txtField.text = @"Bahasa Indonesia";
//                selectedRowLang = 1;
//            }else {
//                txtField.text = @"Japanese";
//                selectedRowLang = 2;
//            }
//            [txtField setEnabled:false];
//            
//        } else
            if (_clickIndex == 0) {
            
            if (indexPath.row == 0) {
                txtCurPass = (UITextField *)[cell viewWithTag:2];
                txtCurPass.delegate = self;
                lblTitle.text = @"Current Password";
                [txtCurPass setSecureTextEntry:true];
                [txtCurPass becomeFirstResponder];
                isEditMode = 1;
            } else if (indexPath.row == 1) {
                txtNewPass = (UITextField *)[cell viewWithTag:2];
                txtNewPass.delegate = self;
                lblTitle.text = @"New Password";
                [txtNewPass setSecureTextEntry:true];
            } else if (indexPath.row == 2) {
                txtConfirm = (UITextField *)[cell viewWithTag:2];
                txtConfirm.delegate = self;
                lblTitle.text = @"Confirm Password";
                [txtConfirm setSecureTextEntry:true];
            }
            
        }
    }
        
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_clickSection == 1) {
        if (_clickIndex == 0) {
            NSLog(@"clicked");
            [UIView animateWithDuration:0.4
                             animations:^{
                                 [NSTimer scheduledTimerWithTimeInterval:0.3
                                                                  target:self
                                                                selector:@selector(showPickerLanguageView)
                                                                userInfo:nil
                                                                 repeats:NO];
                             }];
        }
    }
}

#pragma end

#pragma mark - UIPICKER
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[GGGlobalVariable sharedInstance].itemLanguageList count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    selectedRowLang = row;
    
    return [GGGlobalVariable sharedInstance].itemLanguageList[row];
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

#pragma end

#pragma mark - UITEXTFIELD

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    isEditMode = 1;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == txtFirst) {
//        if ([textField.text isEqualToString:@""]) {
//            [self showCommonAlert:@"Alert" message:@"Please insert first name" indeks:1];
//        }else if ([textField.text length] > 35) {
//            [self showCommonAlert:@"Alert" message:@"The length of first name cannot be more than 35 characters" indeks:1];
//        }
    }else if (textField == txtLast) {
//        if ([textField.text isEqualToString:@""]) {
//            [self showCommonAlert:@"Alert" message:@"Please insert last name" indeks:1];
//        }else if ([textField.text length] > 35) {
//            [self showCommonAlert:@"Alert" message:@"The length of last name cannot be more than 35 characters" indeks:1];
//        }
    }else if (textField == txtAddress) {
//        if ([textField.text isEqualToString:@""]) {
//            [self showCommonAlert:@"Alert" message:@"Please insert address" indeks:1];
//        }else if ([textField.text length] > 300) {
//            [self showCommonAlert:@"Alert" message:@"The length of address cannot be more than 300 characters" indeks:1];
//        }
    }else if (textField == txtEmail) {
//        if ([textField.text isEqualToString:@""]) {
//            [self showCommonAlert:@"Alert" message:@"Please insert email" indeks:1];
//        }else if ([textField.text length] > 255) {
//            [self showCommonAlert:@"Alert" message:@"The length of email cannot be more than 254 characters" indeks:1];
//        }else if (![[GGCommonFunc sharedInstance] isValidEmail:textField.text]) {
//            [self showCommonAlert:@"Alert" message:@"Please insert valid email" indeks:1];
//        }
    }else if (textField == txtPhone) {
//        if ([textField.text isEqualToString:@""]) {
//            [self showCommonAlert:@"Alert" message:@"Please insert phone number" indeks:1];
//        }else if ([textField.text length] > 12) {
//            [self showCommonAlert:@"Alert" message:@"The length of phone number cannot be more than 12 characters" indeks:1];
//        }else if ([textField.text length] < 9) {
//            [self showCommonAlert:@"Alert" message:@"The length of phone number cannot be less than 9 characters" indeks:1];
//        }
//        else if (![[GGCommonFunc sharedInstance] isValidPhoneNumber:textField.text]) {
//            [self showCommonAlert:@"Alert" message:@"Please insert valid phone number" indeks:1];
//        }
    }else if (textField == txtCurPass) {
//        if ([textField.text isEqualToString:@""]) {
//            [self showCommonAlert:@"Alert" message:@"Please insert password" indeks:1];
//        }else if ([textField.text length] > 20) {
//            [self showCommonAlert:@"Alert" message:@"The lenght of password cannot be more than 20 characters" indeks:1];
//        }else if ([textField.text length] < 8) {
//            [self showCommonAlert:@"Alert" message:@"The lenght of password cannot be less than 8 characters" indeks:1];
//        }
    }else if (textField == txtNewPass) {
//        if ([textField.text isEqualToString:@""]) {
//            [self showCommonAlert:@"Alert" message:@"Please insert password" indeks:1];
//        }else if ([textField.text length] > 20) {
//            [self showCommonAlert:@"Alert" message:@"The lenght of password cannot be more than 20 characters" indeks:1];
//        }else if ([textField.text length] < 8) {
//            [self showCommonAlert:@"Alert" message:@"The lenght of password cannot be less than 8 characters" indeks:1];
//        }
    }else if (textField == txtConfirm) {
//        if ([textField.text isEqualToString:@""]) {
//            [self showCommonAlert:@"Alert" message:@"Please insert password" indeks:1];
//        }else if ([textField.text length] > 20) {
//            [self showCommonAlert:@"Alert" message:@"The lenght of password cannot be more than 20 characters" indeks:1];
//        }else if ([textField.text length] < 8) {
//            [self showCommonAlert:@"Alert" message:@"The lenght of password cannot be less than 8 characters" indeks:1];
//        }else if (![textField.text isEqualToString:txtNewPass.text] && ![txtNewPass.text isEqualToString:@""]) {
//            [self showCommonAlert:@"Alert" message:@"Confirm password doesn't match with new password." indeks:1];
//        }
    }
}

#pragma end

@end
