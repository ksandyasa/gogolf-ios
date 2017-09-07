//
//  GGPointHistoryVC.m
//  GoGolf
//
//  Created by Eddyson Tan on 7/15/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGPointHistoryVC.h"
#import "GGAPIManager.h"
#import "GGCommonFunc.h"

@interface GGPointHistoryVC ()

@end

@implementation GGPointHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
    
    self.tblPointHistory.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated {
    
    if ([[GGCommonFunc sharedInstance] connected]) {
        [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
        [[GGAPIPointManager sharedInstance] getPointHistoryWithcompletion:^(NSDictionary *responseDict, NSError *error) {
            NSLog(@"responseDict : %@", responseDict);
            [[GGCommonFunc sharedInstance] hideLoadingImage];
            if (error == nil) {
                if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                    [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                    [[GGAPIManager sharedInstance] clearAllData];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    if ([[responseDict objectForKey:@"data"] count] > 0) {
                        self.txtEmptyPointHistory.hidden = YES;
                        [self.tblPointHistory reloadData];
                    }else{
                        self.txtEmptyPointHistory.hidden = NO;
                    }
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

- (IBAction)GoBack:(id)sender {
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[[GGGlobalVariable sharedInstance].itemPointHistoryList objectForKey:@"data"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseIdentifier = @"pointHistoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    UILabel *lblDate = (UILabel *)[cell viewWithTag:1];
    lblDate.text = [[[[GGGlobalVariable sharedInstance].itemPointHistoryList objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"date"];
    
    UILabel *lblTransType = (UILabel *)[cell viewWithTag:2];
    lblTransType.text = [[[[GGGlobalVariable sharedInstance].itemPointHistoryList objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"po_type"];
    
    UILabel *lblTotalPoint = (UILabel *)[cell viewWithTag:3];
    lblTotalPoint.text = [NSString stringWithFormat:@"%@ Point", [[[[GGGlobalVariable sharedInstance].itemPointHistoryList objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"historical_point"]];
    
    UILabel *lblTransPoint = (UILabel *)[cell viewWithTag:4];
    lblTransPoint.text = [NSString stringWithFormat:@"%@", [[[[GGGlobalVariable sharedInstance].itemPointHistoryList objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"transaction"]];
    
    
    
    return cell;
}

#pragma end

@end
