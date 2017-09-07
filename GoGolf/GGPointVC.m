//
//  GGPointVC.m
//  GoGolf
//
//  Created by Eddyson Tan on 7/15/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGPointVC.h"
#import "GGAPIManager.h"
#import "GGCommonFunc.h"
#import "GGHomeVC.h"
#import "GGHomePageVC.h"

@interface GGPointVC ()

@end

@implementation GGPointVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadPoint) name:@"pointActionNotification" object:nil];
    [self reloadPoint];
}

- (void) reloadPoint {
    
    if ([[GGCommonFunc sharedInstance] connected]) {
        [[GGCommonFunc sharedInstance] showLoadingImage:((GGHomePageVC*)((GGHomeVC*)self.pointVCDelegate).homeDelegate).homePageView];
        [[GGAPIUserManager sharedInstance] getUserDetailWithcompletion:^(NSDictionary *responseDict, NSError *error) {
            
            [[GGCommonFunc sharedInstance] hideLoadingImage:((GGHomePageVC*)((GGHomeVC*)self.pointVCDelegate).homeDelegate).homePageView];
            
            if (error != nil){
                NSLog(@"ERROR : %@", error.localizedDescription);
            } else {
                if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                    [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                    [[GGAPIManager sharedInstance] clearAllData];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    NSLog(@"POINT : %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"userPoint"]);
                    self.lblCurrentPoints.text = [[responseDict objectForKey:@"data"] objectForKey:@"point"];
                }
            }
        }];
    }else{
        [self showCommonAlert:@"Alert" message:@"No internet connection."];
    }
}

- (IBAction)goCheckHistory:(id)sender {
    
//    id<pointDelegate> strongDelegate = self.delegate;
//    if ([strongDelegate respondsToSelector:@selector(showPointHistory)]) {
//        [strongDelegate showPointHistory];
//    }
    
    GGPointHistoryVC * pointHistoryView = [self.storyboard instantiateViewControllerWithIdentifier:@"pointHistoryVC"];
    
    [self.navigationController pushViewController:pointHistoryView animated:YES];
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
