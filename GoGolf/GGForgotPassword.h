//
//  GGForgotPassword.h
//  GoGolf
//
//  Created by Aprido Sandyasa on 10/30/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGCommonFunc.h"
#import "GGAPIForgotManager.h"
#import "GGGlobal.h"
#import "GGGlobalVariable.h"

@interface GGForgotPassword : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtEmailAddr;

@property (weak, nonatomic) IBOutlet UIButton *btnSend;

- (IBAction)sendLink:(UIButton *)sender;

- (IBAction)backToLogin:(UIButton *)sender;

@end
