//
//  GGBookingHistoryVC.m
//  GoGolf
//
//  Created by Eddyson Tan on 6/14/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGBookingHistoryVC.h"
#import "GGAPIManager.h"

@interface GGBookingHistoryVC ()

@end

@implementation GGBookingHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.tblBookingHistory.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self reloadBookingHistoryData];
    
}

- (void)reloadBookingHistoryData {
    if ([[GGGlobalVariable sharedInstance].bookingTitle isEqualToString:@"1"]) {
        
        self.lblBookingTeks.text = @"Booking Status";
        statusApps = @"0,1,2";
        sdate = [[GGCommonFunc sharedInstance] getDateFromSystem];
        edate = [[GGCommonFunc sharedInstance] getNextYearDate];
        
    } else if ([[GGGlobalVariable sharedInstance].bookingTitle isEqualToString:@"2"]) {
        
        self.lblBookingTeks.text = @"Booking History";
        statusApps = @"2,3,4";
        sdate = [[GGCommonFunc sharedInstance] getLastYearDate];
        edate = [[GGCommonFunc sharedInstance] getDateFromSystem];
    }
    
    NSLog(@"sdate %@", sdate);
    NSLog(@"edate %@", edate);
    NSLog(@"status %@", statusApps);
    
    self.tblBookingHistory.allowsSelection = YES;
    NSLog(@"responseDict : %@", [GGGlobalVariable sharedInstance].bookingTitle);
    
    if ([[GGCommonFunc sharedInstance] connected]) {
        [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
        [[GGAPIBookingManager sharedInstance] getBookStatus:statusApps withSDate:sdate andEDate:edate completion:^(NSDictionary *responseDict, NSError *error) {
            [[GGCommonFunc sharedInstance] hideLoadingImage];
            if (error == nil) {
                if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                    [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                    [[GGAPIManager sharedInstance] clearAllData];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    if ([[responseDict objectForKey:@"data"] count] > 0) {
                        NSLog(@"itemBookingHistoryList %@", [[GGGlobalVariable sharedInstance].itemBookingHistoryList description]);
                        self.txtEmptyBookingHistory.hidden = YES;
                        [self.tblBookingHistory reloadData];
                    }else{
                        self.txtEmptyBookingHistory.hidden = NO;
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
    return [[[GGGlobalVariable sharedInstance].itemBookingHistoryList objectForKey:@"data"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseIdentifier = @"bookHistoryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    
    UIImageView *ivCourse = (UIImageView *)[cell.contentView viewWithTag:1];
    UILabel *lblTitle = (UILabel *)[cell.contentView viewWithTag:2];
    UILabel *lblDate = (UILabel *)[cell.contentView viewWithTag:3];
    UILabel *lblFlightAndPlayer = (UILabel *)[cell.contentView viewWithTag:4];
    UILabel *lblPrice = (UILabel *)[cell.contentView viewWithTag:5];
    UILabel *lblStatus = (UILabel *)[cell.contentView viewWithTag:6];
    
    if ([[[GGGlobalVariable sharedInstance].itemBookingHistoryList objectForKey:@"data"] count] > 0) {
        if ([[GGCommonFunc sharedInstance] connected]) {
            [[GGCommonFunc sharedInstance] setLazyLoadImage:ivCourse urlString:[[[GGGlobalVariable sharedInstance].itemBookingHistoryList objectForKey:@"data"][indexPath.row] objectForKey:@"image"]];
        }
        
        if ([[[[GGGlobalVariable sharedInstance].itemBookingHistoryList objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"gname"] == nil || [[[[GGGlobalVariable sharedInstance].itemBookingHistoryList objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"gname"] == (id) [NSNull null]) {
            lblTitle.text = @"<not available>";
        } else {
            lblTitle.text = [[[[GGGlobalVariable sharedInstance].itemBookingHistoryList objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"gname"];
        }
        
        if ([[[[GGGlobalVariable sharedInstance].itemBookingHistoryList objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"date"] == nil || [[[[GGGlobalVariable sharedInstance].itemBookingHistoryList objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"date"] == (id) [NSNull null]) {
            lblDate.text = @"<not available>";
        } else {
            lblDate.text = [[GGCommonFunc sharedInstance] changeDateFormat:[[[[GGGlobalVariable sharedInstance].itemBookingHistoryList objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"date"]];
        }
        
        int flightCount = (int)[[[[[GGGlobalVariable sharedInstance].itemBookingHistoryList objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"flightarr"] count];
        lblFlightAndPlayer.text = [NSString stringWithFormat:@"Flight : %ld    Booking Code : %@", (long)flightCount, [[[[GGGlobalVariable sharedInstance].itemBookingHistoryList objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"bcode"]];
        
        if ([[[[GGGlobalVariable sharedInstance].itemBookingHistoryList objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"tprice"] == nil || [[[[GGGlobalVariable sharedInstance].itemBookingHistoryList objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"tprice"] == (id) [NSNull null]) {
            lblPrice.text = @"<not available>";
        } else {
            lblPrice.text = [NSString stringWithFormat:@"Rp. %@", [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[[[[GGGlobalVariable sharedInstance].itemBookingHistoryList objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"tprice"] floatValue]]];
        }
        
        lblStatus.text = [[[[GGGlobalVariable sharedInstance].itemBookingHistoryList objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"status"];
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    GGBookingDetailVC *bookingDetailView = [self.storyboard instantiateViewControllerWithIdentifier:@"bookingDetailVC"];
    
    bookingDetailView.detailArr = [[[GGGlobalVariable sharedInstance].itemBookingHistoryList objectForKey:@"data"] objectAtIndex:indexPath.row];
    if ([self.lblBookingTeks.text isEqualToString:@"Booking History"])
        bookingDetailView.isHistory = YES;
    else
        bookingDetailView.isHistory = NO;
    
    [self.navigationController pushViewController:bookingDetailView animated:YES];
    
}

@end
