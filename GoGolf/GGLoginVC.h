//
//  GGLoginVC.h
//  GoGolf
//
//  Created by Eddyson Tan on 6/8/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface GGLoginVC : UIViewController <UITextFieldDelegate> {

}

@property (weak, nonatomic) IBOutlet UITextField *txtEmail;

@property (weak, nonatomic) IBOutlet UITextField *txtPassword;

@property (weak, nonatomic) IBOutlet UIButton *btnSignIn;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;

@property (weak, nonatomic) IBOutlet UILabel *lblForgotPassword;

- (IBAction)actionSignUp:(id)sender;

@end

