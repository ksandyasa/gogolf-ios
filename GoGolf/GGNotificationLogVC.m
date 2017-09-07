//
//  GGNotificationLogVC.m
//  GoGolf
//
//  Created by Eddyson Tan on 9/3/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGNotificationLogVC.h"
#import "GGAPIManager.h"
#import "GGCommonFunc.h"

@interface GGNotificationLogVC ()

@end

@implementation GGNotificationLogVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.tblNotificationLog.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    
    if ([[GGCommonFunc sharedInstance] connected]) {
        [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
        [[GGAPIHomeManager sharedInstance] getNotificationWithCompletion:^(NSDictionary *responseDict, NSError *error) {
            if (error == nil) {
                [[GGCommonFunc sharedInstance] hideLoadingImage];
                if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                    [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                    [[GGAPIManager sharedInstance] clearAllData];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    if ([[responseDict objectForKey:@"data"] count] > 0) {
                        [GGGlobalVariable sharedInstance].itemNotificationList = [responseDict objectForKey:@"data"];
                        self.txtEmptyNotificationLog.hidden = YES;
                        [self.tblNotificationLog reloadData];
                    }else{
                        self.txtEmptyNotificationLog.hidden = NO;
                    }
                }
            }
        }];
    }else{
        [self showCommonAlert:@"Alert" message:@"No internet connection."];
    }
}

- (IBAction)goBack:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark - UITABLEVIEW DELEGATE & DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[GGGlobalVariable sharedInstance].itemNotificationList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseIdentifier = @"notificationCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    UILabel *lblDate = (UILabel *)[cell viewWithTag:1];
    lblDate.text = [[[GGGlobalVariable sharedInstance].itemNotificationList objectAtIndex:indexPath.row] objectForKey:@"pushed_date"];
    
    UILabel *lblTitle = (UILabel *)[cell viewWithTag:2];
    lblTitle.text = [[[GGGlobalVariable sharedInstance].itemNotificationList objectAtIndex:indexPath.row] objectForKey:@"title"];
    
    UILabel *lblContent = (UILabel *)[cell viewWithTag:3];
    lblContent.text = [[[GGGlobalVariable sharedInstance].itemNotificationList objectAtIndex:indexPath.row] objectForKey:@"body"];
    
    return cell;
}

#pragma end

@end
