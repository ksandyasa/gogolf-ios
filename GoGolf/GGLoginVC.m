//
//  GGLoginVC.m
//  GoGolf
//
//  Created by Eddyson Tan on 6/8/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGLoginVC.h"
#import "GGHomePageVC.h"
#import "GGSignUpVC.h"
#import "GGAPIManager.h"
#import "GGGlobal.h"
#import "GGGlobalVariable.h"
#import "GGInstallationVC.h"
#import "GGForgotPassword.h"
#import "GGAPIHomeManager.h"
#import "GGAPIManager.h"

//#import "oAuth1/OAuth1Controller.h"

@interface GGLoginVC () {
    GGForgotPassword *ggForgotPassword;
}

//@property (nonatomic, strong) OAuth1Controller *oauth1Controller;
@end

int posLoginField = 0;

@implementation GGLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.txtEmail.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Email" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.txtPassword.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    UITapGestureRecognizer *forgotTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(forgotPasswordView)];
    
    [self.lblForgotPassword addGestureRecognizer:forgotTap];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.btnSignIn setUserInteractionEnabled:YES];
    [self.loginButton setUserInteractionEnabled:YES];
    [self setupCheckAppVersion];
}

- (void)setupCheckAppVersion {
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        GGInstallationVC *tutorialPage = [self.storyboard instantiateViewControllerWithIdentifier:@"installationVC"];
        [self.navigationController pushViewController:tutorialPage animated:NO];
        
        //GGTutorialVC *tutorialPage = [self.storyboard instantiateViewControllerWithIdentifier:@"tutorialVC"];
        //[self.navigationController pushViewController:tutorialPage animated:NO];
        
    } else {
        
        if ([[GGCommonFunc sharedInstance] connected]) {
            [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
            [[GGAPIHomeManager sharedInstance] getCountryWithCompletion:^(NSDictionary *responseDict, NSError *error) {
                [[GGCommonFunc sharedInstance] hideLoadingImage:self.view];
            }];
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"hasLogin"] != nil) {
                if ([[NSUserDefaults standardUserDefaults] boolForKey:@"hasLogin"])
                {
                    GGHomePageVC *homePage = [self.storyboard instantiateViewControllerWithIdentifier:@"homePage"];
                    [self.navigationController pushViewController:homePage animated:NO];
                }else{
                    [[GGAPIManager sharedInstance] getVersionAppsWithCompletion:^(NSDictionary *responseDict, NSError *error) {
                        
                        [[GGCommonFunc sharedInstance] hideLoadingImage:self.view];
                        
                        NSString *serverVersion = [NSString stringWithFormat:@"%@", responseDict[@"data"][@"min_version"]];
                        NSString *appVersion = [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
                        
                        if ([appVersion isEqualToString:serverVersion]) {
                        }else{
                            [self showVersionAlert:@"Alert" message:@"Please update with GoGolf new version."];
                        }
                    }];
                }
            }else{
                [[GGAPIManager sharedInstance] getVersionAppsWithCompletion:^(NSDictionary *responseDict, NSError *error) {
                    
                    [[GGCommonFunc sharedInstance] hideLoadingImage:self.view];
                    
                    NSString *serverVersion = [NSString stringWithFormat:@"%@", responseDict[@"data"][@"min_version"]];
                    NSString *appVersion = [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
                    
                    NSArray *servVerArray = [serverVersion componentsSeparatedByString:@"."];
                    NSArray *appVerArray = [appVersion componentsSeparatedByString:@"."];
                    
                    if ([appVerArray[0] intValue] < [servVerArray[0] intValue]) {
                        [self showVersionAlert:@"GoGolf Version Update" message:@"GoGolf Version has beed updated, please download the latest version from Apple Store."];
                    }else{
                        if ([appVerArray[1] intValue] < [servVerArray[1] intValue]) {
                            [self showVersionAlert:@"GoGolf Version Update" message:@"GoGolf Version has beed updated, please download the latest version from Apple Store."];
                        }else{
                            if ([appVerArray[2] intValue] < [servVerArray[2] intValue]) {
                                [self showVersionAlert:@"GoGolf Version Update" message:@"GoGolf Version has beed updated, please download the latest version from Apple Store."];
                            }else{
                                
                            }
                        }
                    }
                }];
            }
            
        }else{
            [self showCommonAlert:@"Alert" message:@"No internet connection."];
        }
    }
}

-(void)forgotPasswordView {
    ggForgotPassword = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GGForgotPassword"];
    [self.navigationController pushViewController:ggForgotPassword animated:true];
}

-(void)dismissKeyboard {
    [self.txtPassword resignFirstResponder];
    [self.txtEmail resignFirstResponder];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction) loginFB:(id)sender {
    
    if ([[GGCommonFunc sharedInstance] connected]) {
        [self.loginButton setUserInteractionEnabled:NO];
        FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
        login.loginBehavior = FBSDKLoginBehaviorWeb;
        [login logInWithReadPermissions: @[@"public_profile", @"email", @"user_friends"] fromViewController:self handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
            
            NSLog(@"result %@", result);
            if (error) {
                NSLog(@"Process error");
            } else if (result.isCancelled) {
                NSLog(@"Cancelled");
            } else {
                NSLog(@"FB accesstoken %@", [FBSDKAccessToken currentAccessToken].tokenString);
                if ([FBSDKAccessToken currentAccessToken]) {
                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:nil]
                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                         
                         if (!error) {
                             NSLog(@"fetched user:%@ - TOKEN : %@", result, [FBSDKAccessToken currentAccessToken].tokenString);
                             [self postFBValue:[FBSDKAccessToken currentAccessToken].tokenString provider:@"Facebook"];
                         }
                     }];
                    
                }
            }
        }];
    }else{
        [self showCommonAlert:@"Alert" message:@"No internet connection."];
    }
}

- (void) postFBValue:(NSString *) token provider:(NSString *) provider{
    [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
    
    dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        
        [[GGAPIManager sharedInstance] signInFBWithAccess_token:token provider:provider
                                                     completion:^(NSError *error) {
                                                         if (error != nil) {
                                                             
                                                             [self showCommonAlert:@"Error Notification" message:error.description];
                                                             [self.loginButton setEnabled:true];
                                                             
                                                         } else {
                                                             
                                                             if ([[[GGGlobalVariable sharedInstance].itemLogin objectForKey:@"code"] integerValue] != 200) {
                                                                 
                                                                 [self showCommonAlert:@"Error Notification" message:[[GGGlobalVariable sharedInstance].itemLogin objectForKey:@"message"]];
                                                                 [self.loginButton setEnabled:true];
                                                                 
                                                             } else {
                                                                 
                                                                 GGHomePageVC *homePage = [self.storyboard instantiateViewControllerWithIdentifier:@"homePage"];
                                                                 [self.navigationController pushViewController:homePage animated:YES];
                                                                 
                                                             }
                                                         }
                                                     }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[GGCommonFunc sharedInstance] hideLoadingImage];
        });
    });

}

- (IBAction)login:(id)sender {
    if ([[GGCommonFunc sharedInstance] connected]) {
        [self.btnSignIn setUserInteractionEnabled:NO];
        [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            // code to execute
            [[GGAPIManager sharedInstance] signInAccountWithEmail:self.txtEmail.text password:self.txtPassword.text completion:^(NSError *error) {
                
                [self.txtEmail resignFirstResponder];
                [self.txtPassword resignFirstResponder];
                [self.txtEmail setText:@""];
                [self.txtPassword setText:@""];
                
                if (error != nil) {
                    [self showCommonAlert:@"Error Notification" message:error.description];
                } else {
                    if ([[[GGGlobalVariable sharedInstance].itemLogin objectForKey:@"code"] integerValue] != 200) {
                        [self showCommonAlert:@"Error Notification" message:[[GGGlobalVariable sharedInstance].itemLogin objectForKey:@"message"]];
                    } else {
                        GGHomePageVC *homePage = [self.storyboard instantiateViewControllerWithIdentifier:@"homePage"];
                        [self.navigationController pushViewController:homePage animated:YES];
                    }
                }
            }];
            
        }
        completion:^(BOOL finished){
            // code to execute
            [[GGCommonFunc sharedInstance] hideLoadingImage:self.view];
            [self.btnSignIn setUserInteractionEnabled:YES];
        }];
    }else{
        [self showCommonAlert:@"Alert" message:@"No internet connection."];
    }
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
                                   
                               }];
    
    [alert addAction:okButton];
    
    [self presentViewController:alert  animated:YES completion:nil];
}

- (void) showVersionAlert:(NSString *) title message:(NSString *)msg {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Update"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   NSString *iTunesLink = @"itms://itunes.apple.com/us/app/apple-store/id375380948?mt=8";
                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
                               }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Cancel"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   //Handel no, thanks button
                                   
                               }];
    
    [alert addAction:noButton];
    [alert addAction:okButton];
    
    [self presentViewController:alert  animated:YES completion:nil];
}

- (IBAction)actionSignUp:(id)sender {
    GGSignUpVC *signUpVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"signUpView"];
    signUpVC.loginDelegate = self;
    [self.navigationController pushViewController:signUpVC animated:true];
}

#pragma mark - TEXTFIELD DELEGATE

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.txtPassword) {
        [theTextField resignFirstResponder];
        [self login:nil];
    } else if (theTextField == self.txtEmail) {
        [self.txtPassword becomeFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.txtEmail) {
        posLoginField = 1;
    } else if (textField == self.txtPassword) {
        posLoginField = 2;
    }
    
    [[GGCommonFunc sharedInstance] setViewMovedUp:YES fromView:self.view fromPos:posLoginField];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.txtEmail) {
        posLoginField = 1;
//        if ([textField.text isEqualToString:@""]) {
//            [self showCommonAlert:@"Alert" message:@"Please insert email"];
//        }else if ([textField.text length] > 255) {
//            [self showCommonAlert:@"Alert" message:@"The length of email cannot be more than 254 characters"];
//        }else if (![[GGCommonFunc sharedInstance] isValidEmail:textField.text]){
//            [self showCommonAlert:@"Alert" message:@"Please insert a valid email"];
//        }
    }else if (textField == self.txtPassword) {
        posLoginField = 2;
//        if ([textField.text isEqualToString:@""]) {
//            [self showCommonAlert:@"Alert" message:@"Please insert password"];
//        }
    }
    
    [[GGCommonFunc sharedInstance] setViewMovedUp:NO fromView:self.view fromPos:posLoginField];
}

#pragma end

@end
