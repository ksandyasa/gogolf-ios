//
//  GGForgotPassword.m
//  GoGolf
//
//  Created by Aprido Sandyasa on 10/30/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGForgotPassword.h"

@interface GGForgotPassword ()

@end

@implementation GGForgotPassword

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.txtEmailAddr.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)sendLink:(UIButton *)sender {
    [self requestLinkForgotPassword:nil];
}

- (void)requestLinkForgotPassword:(id)sender {
    if ([[GGCommonFunc sharedInstance] connected]) {
        [self.btnSend setEnabled:false];
        [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            [[GGAPIForgotManager sharedInstance] sendLinkForgotPassword:self.txtEmailAddr.text
                                                             completion:^(NSError *error) {
                                                                 if (error != nil) {
                                                                     
                                                                     [self showCommonAlert:@"Error Notification" message:error.description];
                                                                     
                                                                 } else {
                                                                     
                                                                     if ([[[GGGlobalVariable sharedInstance].itemForgot objectForKey:@"code"] integerValue] != 200) {
                                                                         
                                                                         [self showCommonAlert:@"Error Notification" message:[[GGGlobalVariable sharedInstance].itemForgot objectForKey:@"message"]];
                                                                         
                                                                     } else {
                                                                         
                                                                         [self showCommonAlert:@"Success Notification" message:[[GGGlobalVariable sharedInstance].itemForgot objectForKey:@"message"]];
                                                                         
                                                                         self.txtEmailAddr.text = nil;
                                                                     }
                                                                 }
                                                             }];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[GGCommonFunc sharedInstance] hideLoadingImage];
                [self.btnSend setEnabled:true];
            });
        });
    }else {
        [self showCommonAlert:@"Alert" message:@"No internet connection."];
    }
}

- (IBAction)backToLogin:(UIButton *)sender {
    NSLog(@"clicked");
    [self.navigationController popViewControllerAnimated:true];
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


#pragma mark - TEXTFIELD DELEGATE

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    if (theTextField == self.txtEmailAddr) {
        [theTextField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    [[GGCommonFunc sharedInstance] setViewMovedUp:YES fromView:self.view fromPos:1];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.txtEmailAddr) {
        if ([textField.text isEqualToString:@""]) {
            [self showCommonAlert:@"Alert" message:@"Please insert email"];
        }else if ([textField.text length] > 255) {
            [self showCommonAlert:@"Alert" message:@"The length of email cannot be more that 254 characters"];
        }else if (![[GGCommonFunc sharedInstance] isValidEmail:textField.text]) {
            [self showCommonAlert:@"Alert" message:@"Please insert valid email"];
        }else {
            [self requestLinkForgotPassword:nil];
        }
    }
    
    [[GGCommonFunc sharedInstance] setViewMovedUp:NO fromView:self.view fromPos:1];
}

#pragma end

@end
