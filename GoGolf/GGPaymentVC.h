//
//  GGPaymentVC.h
//  GoGolf
//
//  Created by Eddyson Tan on 8/31/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MidtransKit/MidtransKit.h>
#import "GGAPIBookingManager.h"
#import "GGGlobalVariable.h"
#import "GGPaymentConfirmationVC.h"
#import "GGCommonFunc.h"

@interface GGPaymentVC : UIViewController <UITextFieldDelegate>{

}

@property NSInteger totalAmount;
@property (weak, nonatomic) IBOutlet UIScrollView *paymenScrollView;

@property (weak, nonatomic) IBOutlet UIView *viewNewCreditCard;

@property (weak, nonatomic) IBOutlet UIView *viewSavedCard;

@property (weak, nonatomic) IBOutlet UITextField *txtCustomerName;

@property (weak, nonatomic) IBOutlet UITextField *txtCardNumber;

@property (weak, nonatomic) IBOutlet UITextField *txtExpiredDate;

@property (weak, nonatomic) IBOutlet UITextField *txtCVV;

@property (weak, nonatomic) IBOutlet UILabel *lblTotalAmount;

@property (weak, nonatomic) IBOutlet UITextField *txtMaskCardNumber;

@property (weak, nonatomic) IBOutlet UITextField *txtSavedCVV;

@property (weak, nonatomic) IBOutlet UIButton *btnShowSavedCC;

@property (nonatomic, strong) MidtransTransactionTokenResponse *transactionToken;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightNewCreditCard;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightSavedCard;

- (IBAction)actionShowFillCC:(id)sender;

- (IBAction)actionShowSavedCC:(id)sender;

@end
