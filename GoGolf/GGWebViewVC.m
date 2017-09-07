//
//  GGWebViewVC.m
//  GoGolf
//
//  Created by Eddyson Tan on 9/23/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGWebViewVC.h"

@interface GGWebViewVC ()

@end

@implementation GGWebViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
}
    
- (void)viewWillAppear:(BOOL)animated {
    [self loadUIWebView];
}
    
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction) goBack:(id) sender {
    [self.navigationController popViewControllerAnimated:YES];
}
    
- (void)loadUIWebView
{
    if ([[GGCommonFunc sharedInstance] connected]) {
        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
        self.webview.hidden = NO;
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

@end
