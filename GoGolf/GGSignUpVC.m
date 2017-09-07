//
//  GGSignUpVC.m
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/9/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGSignUpVC.h"

@interface GGSignUpVC () {
    GGSignUpCell1 *cell1;
    GGSignUpCell2 *cell2;
    GGSignUpCell3 *cell3;
    GGSignUpCell4 *cell4;
    GGSignUpFooter *footerView;
    GGTermsVC *termsVC;
    UITextField *txtFirst;
    UITextField *txtLast;
    UITextField *txtEmail;
    UITextField *txtPass;
    UITextField *txtConfirm;
    UITextField *txtPhone;
    UITextField *txtPhoneCode;
    UITextField *txtCountry;
    UITextField *txtLang;
    NSString *countryID;
    NSInteger selectedRowLang;
    NSString *langId;
    NSInteger selectedRowCountry;
    NSString *firstName;
    NSString *lastName;
    NSString *emailAddr;
    NSString *password;
    NSString *confirmPass;
    NSString *phoneNumber;
    NSString *gender;
    NSString *countryName;
    NSString *languageString;
}

@end

int posField = 1;
static NSString *cellIdentifier1 = @"signUpCell1";
static NSString *cellIdentifier2 = @"signUpCell2";
static NSString *cellIdentifier3 = @"signUpCell3";
static NSString *cellIdentifier4 = @"signUpCell4";

@implementation GGSignUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    langId = @"en";
    
    [self.tblSignUp registerNib:[UINib nibWithNibName:@"GGSignUpCell1" bundle:nil] forCellReuseIdentifier:cellIdentifier1];
    [self.tblSignUp registerNib:[UINib nibWithNibName:@"GGSignUpCell2" bundle:nil] forCellReuseIdentifier:cellIdentifier2];
    [self.tblSignUp registerNib:[UINib nibWithNibName:@"GGSignUpCell3" bundle:nil] forCellReuseIdentifier:cellIdentifier3];
    [self.tblSignUp registerNib:[UINib nibWithNibName:@"GGSignUpCell4" bundle:nil] forCellReuseIdentifier:cellIdentifier4];
    
    [self.tblSignUp setDelegate:self];
    [self.tblSignUp setDataSource:self];
    self.tblSignUp.sectionHeaderHeight = 1.0;
    self.tblSignUp.sectionFooterHeight = 114.0;

    [self setupFooterView];
    
}

- (void)setupFooterView {
    footerView = [[GGSignUpFooter alloc] initWithNibName:@"GGSignUpFooter" bundle:nil];
    footerView.signUpDelegate = self;
    [self addChildViewController:footerView];
    [footerView didMoveToParentViewController:self];
}

- (void)setupCountryPickerView:(UITapGestureRecognizer *)sender {
    self.pickerCountryGroup = [UIAlertController alertControllerWithTitle:@"Select Country" message:@"\n\n\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
    
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
                                    NSLog(@"countryID %@", countryID);
                                    countryName = [GGGlobalVariable sharedInstance].itemCountryList[@"data"][selectedRowCountry][@"country_name"];
                                    NSLog(@"countryName %@", countryName);
                                    [self dismissViewControllerAnimated:true completion:nil];
                                    
                                    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:7 inSection:0];
                                    NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
                                    [self.tblSignUp reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationAutomatic];
                                }];
    
    [self.pickerCountryGroup addAction:yesButton];
    [self.pickerCountryGroup.view addSubview:self.pickerCountry];
    
    [self presentViewController:self.pickerCountryGroup animated:true completion:nil];
}

- (void)setupLangPickerView:(UITapGestureRecognizer *)sender {
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
                                    languageString = [GGGlobalVariable sharedInstance].itemLanguageList[selectedRowLang];
                                    langId = (selectedRowLang == 0) ? @"en" : (selectedRowLang == 1) ? @"id" : @"jp";
                                    [self dismissViewControllerAnimated:true completion:nil];
                                    
                                    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:8 inSection:0];
                                    NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
                                    [self.tblSignUp reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationAutomatic];
                                }];
    
    [self.pickerViewPopup addAction:yesButton];
    [self.pickerViewPopup.view addSubview:self.pickerLanguage];
    
    [self presentViewController:self.pickerViewPopup animated:true completion:nil];
}

- (void)setupMaleGender {
    gender = @"m";
}

- (void)setupFemaleGender {
    gender = @"f";
}

- (void)registerWithNewAccount {
    NSLog(@"First Name : %@", txtFirst.text);
    NSLog(@"First Name : %@", txtCountry.text);
    NSLog(@"First Name : %@", txtLang.text);
    if ([txtFirst.text isEqualToString:@""] || [txtLast.text isEqualToString:@""] || [txtEmail.text isEqualToString:@""] || [txtPass.text isEqualToString:@""] || [txtConfirm.text isEqualToString:@""] || [txtPhone.text isEqualToString:@""] || [txtCountry.text isEqualToString:@"Choose"] || [txtLang.text isEqualToString:@"Choose"]) {
        [self showCommonAlert:@"Notification" message:@"Please fill blank field or must select a country or language." index:3];
    } else if ([txtPhone.text length] > 15) {
        [self showCommonAlert:@"Notification" message:@"Phone number should not more than 15 characters." index:3];
    } else {
        if (![txtPass.text isEqual:txtConfirm.text] ) {
            [self showCommonAlert:@"Notification" message:@"Password and Confirm password not same." index:3];
        }else{
            if ([[GGCommonFunc sharedInstance] connected]) {
                [footerView.btnSignUp setEnabled:false];
                [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
                
                dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                    
                    [[GGAPIManager sharedInstance] registerInAccountWithFirstname:txtFirst.text lastName:txtLast.text email:txtEmail.text password:txtPass.text country_ID:countryID gender:gender phone:[NSString stringWithFormat:@"%@", txtPhone.text] device_ID:@"device_id" langID:langId phoneCode:[txtPhoneCode.text stringByReplacingOccurrencesOfString:@"+" withString:@""] completion:^(NSError *error) {
                        [[GGCommonFunc sharedInstance] hideLoadingImage];
                        
                        if (error != nil) {
                            
                            [self showCommonAlert:@"Error Notification" message:error.localizedDescription index:0];
                            [footerView.btnSignUp setEnabled:true];
                            
                        } else {
                            
                            if ([[[GGGlobalVariable sharedInstance].itemRegister objectForKey:@"code"] integerValue] != 200) {
                                
                                [self showCommonAlert:@"Error Notification" message:[[GGGlobalVariable sharedInstance].itemRegister objectForKey:@"message"] index:0];
                                
                                [footerView.btnSignUp setEnabled:true];
                                
                            } else {
                                
                                [self showCommonAlert:@"Notification" message:@"Registration Success" index:1];
                                //[self resetAllValue];
                            }
                        }
                    }];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[GGCommonFunc sharedInstance] hideLoadingImage];
                    });
                });
            }else{
                [self showCommonAlert:@"Alert" message:@"No internet connection." index:4];
            }
        }
    }
}

- (void)loginAfterSignUp {    
    [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [[GGAPIManager sharedInstance] signInAccountWithEmail:txtEmail.text
                                                     password:txtPass.text
                                                   completion:^(NSError *error) {
                                                       if (error != nil) {
                                                           
                                                           [self showCommonAlert:@"Error Notification" message:error.description index:2];
                                                                                                                      
                                                       } else {
                                                           
                                                           if ([[[GGGlobalVariable sharedInstance].itemLogin objectForKey:@"code"] integerValue] != 200) {
                                                               
                                                               [self showCommonAlert:@"Error Notification" message:[[GGGlobalVariable sharedInstance].itemLogin objectForKey:@"message"] index:2];
                                                               
                                                           } else {
                                                               
                                                               GGHomePageVC *homePage = [self.storyboard instantiateViewControllerWithIdentifier:@"homePage"];
                                                               [self.navigationController pushViewController:homePage animated:YES];
                                                               
                                                               txtEmail.text = nil;
                                                               txtPass.text = nil;
                                                           }
                                                       }
                                                   }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[GGCommonFunc sharedInstance] hideLoadingImage];
            [footerView.btnSignUp setEnabled:false];
        });
    });
}

- (void)showTermOfUse {
    NSLog(@"tapped");
    
    termsVC = [[GGTermsVC alloc] initWithNibName:@"GGTermsVC" bundle:nil];
    termsVC.signUpDelegate = self;
    
    [self presentViewController:termsVC animated:true completion:nil];
    //    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[GGGlobal apiTermsOfUse]]];
}

- (void) showCommonAlert:(NSString *) title message:(NSString *)msg index:(int) respIndex {
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITABLEVIEW

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 8;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        cell1 = (GGSignUpCell1 *)[self.tblSignUp dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (cell1 == nil) {
            NSArray *cellArray1 = [[NSBundle mainBundle] loadNibNamed:@"GGSignUpCell1" owner:self options:nil];
            cell1 = [cellArray1 objectAtIndex:0];
        }
        
        cell1.lblTitle.text  = @"First Name";
        txtFirst = cell1.txtInput;
        txtFirst.delegate = self;
        
        return cell1;
        
    }else if (indexPath.row == 1) {
        
        cell1 = (GGSignUpCell1 *)[self.tblSignUp dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (cell1 == nil) {
            NSArray *cellArray1 = [[NSBundle mainBundle] loadNibNamed:@"GGSignUpCell1" owner:self options:nil];
            cell1 = [cellArray1 objectAtIndex:0];
        }
        
        cell1.lblTitle.text  = @"Last Name";
        txtLast = cell1.txtInput;
        txtLast.delegate = self;
        
        return cell1;
        
    }else if (indexPath.row == 2) {
        
        cell1 = (GGSignUpCell1 *)[self.tblSignUp dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (cell1 == nil) {
            NSArray *cellArray1 = [[NSBundle mainBundle] loadNibNamed:@"GGSignUpCell1" owner:self options:nil];
            cell1 = [cellArray1 objectAtIndex:0];
        }
        
        cell1.lblTitle.text  = @"Email Address";
        txtEmail = cell1.txtInput;
        txtEmail.delegate = self;
        
        return cell1;
        
    }else if (indexPath.row == 3) {
        
        cell1 = (GGSignUpCell1 *)[self.tblSignUp dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (cell1 == nil) {
            NSArray *cellArray1 = [[NSBundle mainBundle] loadNibNamed:@"GGSignUpCell1" owner:self options:nil];
            cell1 = [cellArray1 objectAtIndex:0];
        }
        
        cell1.lblTitle.text  = @"Password";
        [cell1.txtInput setSecureTextEntry:true];
        txtPass = cell1.txtInput;
        txtPass.delegate = self;
        
        return cell1;
        
    }else if (indexPath.row == 4) {
        
        cell1 = (GGSignUpCell1 *)[self.tblSignUp dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (cell1 == nil) {
            NSArray *cellArray1 = [[NSBundle mainBundle] loadNibNamed:@"GGSignUpCell1" owner:self options:nil];
            cell1 = [cellArray1 objectAtIndex:0];
        }
        
        cell1.lblTitle.text  = @"Password Confirm";
        [cell1.txtInput setSecureTextEntry:true];
        txtConfirm = cell1.txtInput;
        txtConfirm.delegate = self;
        
        return cell1;
        
    }else if (indexPath.row == 5) {
        
        cell2 = (GGSignUpCell2 *)[self.tblSignUp dequeueReusableCellWithIdentifier:cellIdentifier2];
        if (cell2 == nil) {
            NSArray *cellArray2 = [[NSBundle mainBundle] loadNibNamed:@"GGSignUpCell2" owner:self options:nil];
            cell2 = [cellArray2 objectAtIndex:0];
        }
        
        cell2.lblTitle.text = @"Phone Number";
        txtPhoneCode = cell2.txtCode;
        txtPhone = cell2.txtPhone;
        txtPhone.delegate = self;
        
        return cell2;
        
    }else if (indexPath.row == 6) {
        
        cell3 = (GGSignUpCell3 *)[self.tblSignUp dequeueReusableCellWithIdentifier:cellIdentifier3];
        if (cell3 == nil) {
            NSArray *cellArray3 = [[NSBundle mainBundle] loadNibNamed:@"GGSignUpCell3" owner:self options:nil];
            cell3 = [cellArray3 objectAtIndex:0];
        }
        
        cell3.lblTitle.text = @"Gender";
        [self setupMaleGender];
        
        return cell3;
        
    }else if (indexPath.row == 7) {
        
        cell4 = (GGSignUpCell4 *)[self.tblSignUp dequeueReusableCellWithIdentifier:cellIdentifier4];
        if (cell4 == nil) {
            NSArray *cellArray4 = [[NSBundle mainBundle] loadNibNamed:@"GGSignUpCell4" owner:self options:nil];
            cell4 = [cellArray4 objectAtIndex:0];
        }
        
        cell4.lblTitle.text = @"Country";
        UITapGestureRecognizer *tapCountry1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setupCountryPickerView:)];
        UITapGestureRecognizer *tapCountry2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setupCountryPickerView:)];
        [cell4.viewSelect addGestureRecognizer:tapCountry1];
        [cell4.ivSelect addGestureRecognizer:tapCountry2];
        if (![countryName isEqualToString:@""])
            cell4.txtInput.text = countryName;
        
        return cell4;
        
    }
//    else if (indexPath.row == 8) {
//
//        cell4 = (GGSignUpCell4 *)[self.tblSignUp dequeueReusableCellWithIdentifier:cellIdentifier4];
//        if (cell4 == nil) {
//            NSArray *cellArray4 = [[NSBundle mainBundle] loadNibNamed:@"GGSignUpCell4" owner:self options:nil];
//            cell4 = [cellArray4 objectAtIndex:0];
//        }
//        
//        cell4.lblTitle.text = @"Language";
//        UITapGestureRecognizer *tapLang1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setupLangPickerView:)];
//        UITapGestureRecognizer *tapLang2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(setupLangPickerView:)];
//        [cell4.viewSelect addGestureRecognizer:tapLang1];
//        [cell4.ivSelect addGestureRecognizer:tapLang2];
//        if (![languageString isEqualToString:@""])
//            cell4.txtInput.text = languageString;
//        
//        
//        return cell4;
//        
//    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return footerView.view;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    
    return 1.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 1.0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 76.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 76.0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    
    return 114.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 114.0;
}

#pragma end

#pragma mark - UIPICKERVIEW

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView.tag == 80) {
        selectedRowCountry = row;
    }else if (pickerView.tag == 81) {
        selectedRowLang = row;
        NSLog(@"selectedRowCountry %ld", (long)selectedRowCountry);
        NSLog(@"row %ld", (long)row);
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView.tag == 81)
        return [[GGGlobalVariable sharedInstance].itemLanguageList count];
    else if (pickerView.tag == 80)
        return [[GGGlobalVariable sharedInstance].itemCountryList[@"data"] count];
    
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView.tag == 81) {
        
        return [GGGlobalVariable sharedInstance].itemLanguageList[row];
    }else if (pickerView.tag == 80) {
        
        return [GGGlobalVariable sharedInstance].itemCountryList[@"data"][row][@"country_name"];
    }
    
    return nil;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}

#pragma end

#pragma mark - TEXTFIELD DELEGATE

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == txtFirst) {
        posField = 1;
        [txtLast becomeFirstResponder];
    } else if (theTextField == txtLast) {
        posField = 2;
        [txtEmail becomeFirstResponder];
    } else if (theTextField == txtEmail) {
        posField = 3;
        [txtPass becomeFirstResponder];
    } else if (theTextField == txtPass) {
        posField = 4;
        [txtConfirm becomeFirstResponder];
    } else if (theTextField == txtConfirm) {
        posField = 5;
        [txtPhone becomeFirstResponder];
    } else if (theTextField == txtPhone) {
        posField = 6;
        [txtPhone resignFirstResponder];
    }
    
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == txtFirst) {
        posField = 1;
    } else if (textField == txtLast) {
        posField = 2;
    } else if (textField == txtEmail) {
        posField = 3;
    } else if (textField == txtPass) {
        posField = 4;
    } else if (textField == txtConfirm) {
        posField = 5;
    } else if (textField == txtPhone) {
        posField = 6;
    }
    [[GGCommonFunc sharedInstance] setViewMovedUp:YES fromView:self.tblSignUp fromPos:posField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == txtFirst) {
        posField = 1;
//        if ([textField.text isEqualToString:@""]) {
//            [self showCommonAlert:@"Alert" message:@"Please insert first name" index:5];
//        }else if ([textField.text length] > 36) {
//            [self showCommonAlert:@"Alert" message:@"The length of first name cannot be more than 35 characters" index:5];
//        }
    } else if (textField == txtLast) {
        posField = 2;
//        if ([textField.text isEqualToString:@""]) {
//            [self showCommonAlert:@"Alert" message:@"Please insert last name" index:5];
//        }else if ([textField.text length] > 36) {
//            [self showCommonAlert:@"Alert" message:@"The length of last name cannot be more than 35 characters" index:5];
//        }
    } else if (textField == txtEmail) {
        posField = 3;
//        if ([textField.text isEqualToString:@""]) {
//            [self showCommonAlert:@"Alert" message:@"Please insert email" index:5];
//        }else if ([textField.text length] > 255) {
//            [self showCommonAlert:@"Alert" message:@"The length of email cannot be more than 255 characters" index:5];
//        }else if (![[GGCommonFunc sharedInstance] isValidEmail:textField.text]) {
//            [self showCommonAlert:@"Alert" message:@"Please insert valid email" index:5];
//        }
    } else if (textField == txtPass) {
        posField = 4;
//        if ([textField.text isEqualToString:@""]) {
//            [self showCommonAlert:@"Alert" message:@"Please insert password" index:5];
//        }else if ([textField.text length] > 20) {
//            [self showCommonAlert:@"Alert" message:@"The length of password cannot be more than 20 characters" index:5];
//        }else if ([textField.text length] < 8) {
//            [self showCommonAlert:@"Alert" message:@"The length of password cannot be less than 8 characters" index:5];
//        }
    } else if (textField == txtConfirm) {
        posField = 5;
//        if (![textField.text isEqualToString:txtPass.text] && ![txtPass.text isEqualToString:@""]) {
//            [self showCommonAlert:@"Alert" message:@"Password Confirm doesn't match with Password" index:5];
//        }else if ([textField.text isEqualToString:@""]) {
//            [self showCommonAlert:@"Alert" message:@"Please insert confirm password" index:5];
//        }
    } else if (textField == txtPhone) {
        posField = 6;
//        if ([textField.text isEqualToString:@""]) {
//            [self showCommonAlert:@"Alert" message:@"Please insert phone number" index:5];
//        }else if ([textField.text length] > 12) {
//            [self showCommonAlert:@"Alert" message:@"The length of phone number cannot be more than 14 characters" index:5];
//        }else if ([textField.text length] < 9) {
//            [self showCommonAlert:@"Alert" message:@"The length of phone number cannot be less than 9 characters" index:5];
//        }
    }
    
    [[GGCommonFunc sharedInstance] setViewMovedUp:NO fromView:self.tblSignUp fromPos:posField];
}

#pragma end

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}
@end
