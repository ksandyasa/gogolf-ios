//
//  GGPaymentVC.m
//  GoGolf
//
//  Created by Eddyson Tan on 8/31/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGPaymentVC.h"

@interface GGPaymentVC () {
    NSString *stringToken;
    NSString *savedTokenId;
    NSString *cardNumber;
    UIButton *btnPayWithCC;
}

@end

NSString *savedToken = @"";
NSString *uid = @"";
int modePayment = 0;
int posPaymentField = 0;

@implementation GGPaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.txtCustomerName.delegate = self;
    self.txtCardNumber.delegate = self;
    self.txtExpiredDate.delegate = self;
    self.txtCVV.delegate = self;
    self.txtMaskCardNumber.delegate = self;
    self.txtSavedCVV.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    if (self.totalAmount != 0)
        self.lblTotalAmount.text = [NSString stringWithFormat:@"Rp. %@", [[GGCommonFunc sharedInstance] setSeparatedCurrency:self.totalAmount]];
    else
        self.lblTotalAmount.text = @"0";
    
    [self doObtainPaymentToken];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.paymenScrollView setContentSize:CGSizeMake(320, 568)];
}

-(void)dismissKeyboard {
    [self.txtCustomerName resignFirstResponder];
    [self.txtCardNumber resignFirstResponder];
    [self.txtCVV resignFirstResponder];
    [self.txtExpiredDate resignFirstResponder];
    [self.txtMaskCardNumber resignFirstResponder];
    [self.txtSavedCVV resignFirstResponder];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction) payBookingNow:(id)sender {
    btnPayWithCC = (UIButton *)sender;
    [btnPayWithCC setEnabled:false];
    NSLog(@"user Detail %@", [[GGGlobalVariable sharedInstance].itemUserDetail description]);
    
    cardNumber = [self.txtCardNumber.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *dates = [self.txtExpiredDate.text componentsSeparatedByString:@"/"];
    NSString *expMonth = dates[0];
    NSString *expYear = dates.count == 2 ? dates[1] : nil;
    
    MidtransTokenizeRequest *tokenRequest;
    if (modePayment == 0) {
        MidtransCreditCard *creditCard = [[MidtransCreditCard alloc] initWithNumber:cardNumber
                                                                        expiryMonth:expMonth
                                                                         expiryYear:expYear
                                                                                cvv:self.txtCVV.text];
        NSLog(@"CC : %@", creditCard.description);
        
        tokenRequest = [[MidtransTokenizeRequest alloc] initWithCreditCard:creditCard
                                                               grossAmount:[NSNumber numberWithInt:(int)self.totalAmount]
                                                                    secure:NO];
        NSLog(@"CC TOTAL : %d", (int)self.totalAmount);
        [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
        [[MidtransClient shared] generateToken:tokenRequest completion:^(NSString *token, NSError *error) {
            if (error) {
                [[GGCommonFunc sharedInstance] hideLoadingImage];
                NSLog(@"Error : %@", error.localizedDescription);
                [self showCommonAlert:@"Transaction Failed" message:error.localizedDescription];
            } else {
                NSLog(@"token %@", token);
                NSLog(@"bid_charge %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"bid_charge"]);
                //            [self payWithToken:token];
                stringToken = token;
                savedToken = @"1";
                [self doTransCharge:[[NSUserDefaults standardUserDefaults] objectForKey:@"bid_charge"] token:token];
            }
        }];
    }else if (modePayment == 1) {
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
        NSNumber *myNumber = [f numberFromString:[NSString stringWithFormat:@"%ld", (long)self.totalAmount]];
        tokenRequest = [[MidtransTokenizeRequest alloc] initWithTwoClickToken:savedTokenId cvv:self.txtSavedCVV.text grossAmount:myNumber];
        
        [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
        [[MidtransClient shared] generateToken:tokenRequest completion:^(NSString *token, NSError *error) {
            if (error) {
                [[GGCommonFunc sharedInstance] hideLoadingImage];
                NSLog(@"Error : %@", error.localizedDescription);
                [self showCommonAlert:@"Transaction Failed" message:error.localizedDescription];
            } else {
                NSLog(@"token %@", token);
                NSLog(@"bid_charge %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"bid_charge"]);
                //            [self payWithToken:token];
                stringToken = token;
                savedToken = @"";
                [self doTransCharge:[[NSUserDefaults standardUserDefaults] objectForKey:@"bid_charge"] token:token];
            }
        }];
    }
    
//    BOOL enable3Ds = [[VTCardControllerConfig sharedInstance] enable3DSecure];
//    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
//    f.numberStyle = NSNumberFormatterNoStyle;
//    NSNumber *grossNumber = [f numberFromString:self.lblTotalAmount.text];
    
}

- (void)doObtainPaymentToken {
    if ([[GGCommonFunc sharedInstance] connected]) {
        [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
        [[GGAPIBookingManager sharedInstance] getPaymentTokenWithCompletion:^(NSDictionary *responseDict, NSError *error) {
            if (error == nil) {
                [[GGCommonFunc sharedInstance] hideLoadingImage];
                
                if([[responseDict objectForKey:@"code"] intValue] == 200) {
                    if (![responseDict[@"message"] isEqualToString:@"No token found"]) {
                        savedTokenId = responseDict[@"data"][@"saved_token_id"];
                        self.txtMaskCardNumber.text = responseDict[@"data"][@"masked_card"];
                        self.heightSavedCard.constant = 72;
                        self.heightNewCreditCard.constant = 0;
                        self.viewSavedCard.hidden = false;
                        self.viewNewCreditCard.hidden = true;
                        self.btnShowSavedCC.hidden = true;
                        modePayment = 1;
                    }else{
                        self.heightSavedCard.constant = 0;
                        self.heightNewCreditCard.constant = 128;
                        self.viewSavedCard.hidden = true;
                        self.viewNewCreditCard.hidden = false;
                        modePayment = 0;
                    }
                } else if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                    [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                    [[GGAPIManager sharedInstance] clearAllData];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }
            } else {
                [self showCommonAlert:@"Request Failed." message:error.localizedDescription];
            }
        }];
    }else{
        [self showCommonAlert:@"Alert" message:@"No internet connection."];
    }
}

- (void) doTransCharge:(NSString *)bid token:(NSString *)token_id{
    [[GGAPIBookingManager sharedInstance] doTransaction:bid token:token_id withSavedToken:savedToken completion:^(NSDictionary *responseDict, NSError *error) {
        if (error == nil) {
            [[GGCommonFunc sharedInstance] hideLoadingImage];
            
            if([[responseDict objectForKey:@"code"] intValue] == 200) {
                
                NSLog(@"Response Charge : %@", responseDict);
                [GGGlobalVariable sharedInstance].itemChargeConfirmList = [[responseDict objectForKey:@"data"] objectForKey:@"response"];
                
//                MidtransPaymentCreditCard *paymentDetail = [[MidtransPaymentCreditCard alloc] initWithCreditCardToken:card_token customerDetails:transaction_token.customerDetails];
//                
//                //set this if you want to save card
//                paymentDetail.saveToken = self.view.saveCardSwitch.on;
//                
//                MidtransTransaction *transaction = [[MidtransTransaction alloc] initWithPaymentDetails:paymentDetail token:transaction_token];
                [[NSUserDefaults standardUserDefaults] setObject:self.txtCardNumber.text forKey:@"cardNumber"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                GGPaymentConfirmationVC *paymentConfView = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentConfirmVC"];
                [self.navigationController pushViewController:paymentConfView animated:YES];
            
            } else if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                [[GGAPIManager sharedInstance] clearAllData];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                
                [self showCommonAlert:@"Transaction Failed" message:[responseDict objectForKey:@"message"]];
            }
        } else {
            [self showCommonAlert:@"Transaction Failed" message:error.localizedDescription];
        }
    }];
}

- (void) showCommonAlert:(NSString *) title message:(NSString *)msg {
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
                                   [btnPayWithCC setEnabled:true];
                                   
                               }];
    
    [alert addAction:okButton];
    
    [self presentViewController:alert  animated:YES completion:nil];
}

#pragma mark - UITextfield Delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.txtCustomerName || textField == self.txtSavedCVV) {
        posPaymentField = 1;
    }else if (textField == self.txtCardNumber) {
        posPaymentField = 2;
    }else if (textField == self.txtExpiredDate || textField == self.txtCVV) {
        posPaymentField = 3;
    }
    
    [[GGCommonFunc sharedInstance] setViewMovedUp:YES fromView:self.paymenScrollView fromPos:posPaymentField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField reason:(UITextFieldDidEndEditingReason)reason {
    if (textField == self.txtCustomerName || textField == self.txtSavedCVV) {
        posPaymentField = 1;
    }else if (textField == self.txtCardNumber) {
        posPaymentField = 2;
    }else if (textField == self.txtExpiredDate || textField == self.txtCVV) {
        posPaymentField = 3;
    }
    
    [[GGCommonFunc sharedInstance] setViewMovedUp:NO fromView:self.paymenScrollView fromPos:posPaymentField];
}

- (BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.txtCardNumber) {
        // All digits entered
        if (range.location == 19) {
            return NO;
        }
        
        // Auto-add space before appending 4rd or 7th digit
        if (range.length == 0 &&
            (range.location == 4 || range.location == 9 || range.location == 14)) {
            textField.text = [NSString stringWithFormat:@"%@ %@", textField.text, string];
            return NO;
        }
        
        // Delete space when deleting its trailing digit
        if (range.length == 1 &&
            (range.location == 5 || range.location == 10 || range.location == 15))  {
            range.location--;
            range.length = 2;
            textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    } else if (textField == self.txtExpiredDate) {
        // All digits entered
        if (range.location == 5) {
            return NO;
        }
        
        // Auto-add / before appending 4rd or 7th digit
        if (range.length == 0 &&
            range.location == 2) {
            textField.text = [NSString stringWithFormat:@"%@/%@", textField.text, string];
            return NO;
        }
        
        // Delete / when deleting its trailing digit
        if (range.length == 1 &&
            range.location == 3)  {
            range.location--;
            range.length = 2;
            textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
            return NO;
        }
    } else if (textField == self.txtCVV) {
        if (range.location == 3) {
            return NO;
        }
    }
    
    return YES;
}

#pragma mark - VTPaymentViewControllerDelegate

- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentSuccess:(MidtransTransactionResult *)result {
    NSLog(@"success: %@", result);
}

- (void)paymentViewController:(MidtransUIPaymentViewController *)viewController paymentFailed:(NSError *)error {
    NSLog(@"error: %@", error);
}

- (IBAction)actionShowFillCC:(id)sender {
    self.heightSavedCard.constant = 0;
    self.heightNewCreditCard.constant = 128;
    self.viewSavedCard.hidden = true;
    self.viewNewCreditCard.hidden = false;
    self.btnShowSavedCC.hidden = false;
    modePayment = 0;
}

- (IBAction)actionShowSavedCC:(id)sender {
    self.heightSavedCard.constant = 72;
    self.heightNewCreditCard.constant = 0;
    self.viewSavedCard.hidden = false;
    self.viewNewCreditCard.hidden = true;
    self.btnShowSavedCC.hidden = true;
    modePayment = 1;
}
@end
