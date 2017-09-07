//
//  GGProfileVC.m
//  GoGolf
//
//  Created by Eddyson Tan on 6/14/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGProfileVC.h"
#import "GGAPIManager.h"
#import "GGCommonFunc.h"

@interface GGProfileVC ()

@end

@implementation GGProfileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
    [self setNeedsStatusBarAppearanceUpdate];
    
    NSLog(@"User detail %@", [[[GGGlobalVariable sharedInstance].itemUserDetail objectForKey:@"data"] description]);
}

- (void)viewWillAppear:(BOOL)animated {
    
    if ([[GGCommonFunc sharedInstance] connected]) {
        [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
        [[GGAPIUserManager sharedInstance] getUserDetailWithcompletion:^(NSDictionary *responseDict, NSError *error) {
            [[GGCommonFunc sharedInstance] hideLoadingImage];
            if (error == nil) {
                if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                    [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                    [[GGAPIManager sharedInstance] clearAllData];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUserNotification" object:self userInfo:nil];
                    [self.tblProfile reloadData];
                }
            }
        }];
    }else{
        [self showCommonAlert:@"Alert" message:@"No internet connection."];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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

#pragma mark - UITABLEVIEW DELEGATE AND DATASOURCE

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 4;
    } else if(section == 1) {
        return 1;
    } else if (section == 2) {
        return 1;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.0f;
    }
    
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseIdentifier = @"profileCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    UIImageView *imgIcon = (UIImageView *)[cell viewWithTag:1];
    UILabel *lblTeks = (UILabel *)[cell viewWithTag:2];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            imgIcon.image = [UIImage imageNamed:@"profile_user"];
            lblTeks.text = [NSString stringWithFormat:@"%@ %@", [[GGGlobalVariable sharedInstance].itemUserDetail objectForKey:@"data"][@"fname"], [[GGGlobalVariable sharedInstance].itemUserDetail objectForKey:@"data"][@"lname"]];
            
        } else if(indexPath.row == 1){
            imgIcon.image = [UIImage imageNamed:@"profile_email"];
            lblTeks.text = @"Email";
            
        } else if (indexPath.row == 2) {
            imgIcon.image = [UIImage imageNamed:@"profile_phone"];
            lblTeks.text = @"Phone";
            
        } else if(indexPath.row == 3){
            imgIcon.image = [UIImage imageNamed:@"profile_address"];
            lblTeks.text = @"Address";
            
        }
        
    } else if (indexPath.section == 1) {
//        if (indexPath.row == 0) {
//            imgIcon.image = [UIImage imageNamed:@"profile_language"];
//            lblTeks.text = @"Language";
//            
//        } else
            if (indexPath.row == 0) {
            imgIcon.image = [UIImage imageNamed:@"profile_password"];
            lblTeks.text = @"Password";
            
        }
    } else if (indexPath.section == 2) {
        imgIcon.image = [UIImage imageNamed:@"profile_notif"];
        lblTeks.text = @"Push Notification";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0) {
        GGUpdateProfileVC *updateProfileView = [self.storyboard instantiateViewControllerWithIdentifier:@"updateProfileVC"];
        updateProfileView.clickSection = indexPath.section;
        updateProfileView.clickIndex = indexPath.row;
        
        [self.navigationController pushViewController:updateProfileView animated:YES];
    } else if (indexPath.section == 1) {
        GGUpdateProfileVC *updateProfileView = [self.storyboard instantiateViewControllerWithIdentifier:@"updateProfileVC"];
        updateProfileView.clickSection = indexPath.section;
        updateProfileView.clickIndex = indexPath.row;
        
        [self.navigationController pushViewController:updateProfileView animated:YES];
    }
}


@end
