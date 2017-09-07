//
//  GGSidebarVC.m
//  GoGolf
//
//  Created by Eddyson Tan on 6/10/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGSidebarVC.h"
#import "GGAPIManager.h"
#import "GGGlobalVariable.h"
#import "GGCommonFunc.h"

@interface GGSidebarVC ()

@end

@implementation GGSidebarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUserData) name:@"updateUserNotification" object:nil];
    
    if ([[GGCommonFunc sharedInstance] connected]) {
        [[GGAPIUserManager sharedInstance] getUserDetailWithcompletion:^(NSDictionary *responseDict, NSError *error) {
            if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                [[GGAPIManager sharedInstance] clearAllData];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                [self loadUserData];
            }
        }];
    }else{
        [self showCommonAlert:@"Alert" message:@"No internet connection."];
    }

}

- (void)viewWillAppear:(BOOL)animated {
    //self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.width / 2;
    //self.imgProfile.clipsToBounds = YES;
    
}

- (void) loadUserData {
    
    self.lblUsername.text = [NSString stringWithFormat:@"%@ %@", [[GGGlobalVariable sharedInstance].itemUserDetail objectForKey:@"data"][@"fname"], [[GGGlobalVariable sharedInstance].itemUserDetail objectForKey:@"data"][@"lname"]];
    
    self.lblCountry.text = [GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"country_name"];
    
//    for (int i=0; i < [[GGGlobalVariable sharedInstance].itemCountryList[@"data"] count]; i++) {
//        if ([[GGGlobalVariable sharedInstance].itemUserDetail[@"data"][@"country_id"] isEqual:[GGGlobalVariable sharedInstance].itemCountryList[@"data"][i][@"country_id"]]) {
//            self.lblCountry.text = [GGGlobalVariable sharedInstance].itemCountryList[@"data"][i][@"country_name"];
//            break;
//        }
//    }
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

#pragma mark - UITableview delegate & datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == _tableTop) {
        return 5;
    } else if (tableView == _tableBottom) {
        return 1;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *recell;
    if (tableView == _tableTop) {
        
        NSString *reuseIdentifier = @"topCell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        
        UIImageView *imgRow = (UIImageView *)[cell viewWithTag:2];
        UILabel *lblRow = (UILabel *)[cell viewWithTag:1];
        
        if (indexPath.row == 0) {
            
            imgRow.image = [UIImage imageNamed:@"icon1"];
            lblRow.text = @"My Profile";
            
        } else if (indexPath.row == 1) {
            
            imgRow.image = [UIImage imageNamed:@"icon2"];
            lblRow.text = @"Booking Status";
            
        } else if (indexPath.row == 2) {
            
            imgRow.image = [UIImage imageNamed:@"icon2"];
            lblRow.text = @"Booking History";
            
        } else if (indexPath.row == 3) {
            
            imgRow.image = [UIImage imageNamed:@"icon4"];
            lblRow.text = @"Tutorial";
            
        } else if (indexPath.row == 4) {
            
            imgRow.image = [UIImage imageNamed:@"icon3"];
            lblRow.text = @"Promotion Code";
            
        }
        
        imgRow = nil;
        lblRow = nil;
        
        recell = cell;
        
    } else if (tableView == _tableBottom) {
        
        NSString *reuseIdentifier = @"bottomCell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        
        UIImageView *imgRow = (UIImageView *)[cell viewWithTag:2];
        UILabel *lblRow = (UILabel *)[cell viewWithTag:1];
        
        if (indexPath.row == 0) {
            
            imgRow.image = [UIImage imageNamed:@"icon6"];
            lblRow.text = @"Log out";
            
        }
        
        imgRow = nil;
        lblRow = nil;
        
        recell = cell;
        
    }
    
    return recell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObject:
                                 [NSNumber numberWithLong:indexPath.row]
                                                                   forKey:@"row"];
    [dict setValue:[NSNumber numberWithLong:tableView.tag] forKey:@"tableType"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"sideBarNotification" object:self userInfo:dict];
}

#pragma end

@end
