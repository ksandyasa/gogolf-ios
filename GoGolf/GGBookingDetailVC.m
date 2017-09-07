//
//  GGBookingDetailVC.m
//  GoGolf
//
//  Created by Eddyson Tan on 6/10/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGBookingDetailVC.h"
#import "GGAPIManager.h"

@interface GGBookingDetailVC () {
    UIButton *btnCancelBook;
    UIButton *btnPayNow;
    int pricePlayer;
    NSArray *playerarr;
    GGPaymentStripesVC *paymentStripesVC;
}

@end

@implementation GGBookingDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
    if (self.isHistory == false) {
//        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:4 + [[self.detailArr objectForKey:@"flightarr"] count] inSection:0];
//        UITableViewCell *cell = [self.tblBookingDetail dequeueReusableCellWithIdentifier:@"detailMode4" forIndexPath:indexPath];
//        
//        UIButton *btnCancel = (UIButton *)[cell viewWithTag:55];
    }
    [self reloadDetailTable];
    
}

- (void)calculatePricePlayer {
    playerarr = [[self.detailArr objectForKey:@"flightarr"][0] objectForKey:@"playerarr"];
    pricePlayer = 0;
    for (int i = 0; i < [playerarr count]; i++) {
        pricePlayer = pricePlayer + [[playerarr[i] objectForKey:@"price"] intValue];
    }
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelBooking:(id)sender {
    btnCancelBook = (UIButton *)sender;
    [btnCancelBook setEnabled:false];
    [self showNotification:@"Notification" message:@"Are you sure want to cancel this booking?"];        
}

- (IBAction)goToPaymenView:(id)sender {
    paymentStripesVC = [[GGPaymentStripesVC alloc] initWithNibName:@"GGPaymentStripesVC" bundle:nil];
    paymentStripesVC.paymentStripesDelegate = self;
    paymentStripesVC.priceDp = [[self.detailArr objectForKey:@"deposit_price"] intValue];
    paymentStripesVC.bcode = [self.detailArr objectForKey:@"bcode"];
    paymentStripesVC.bid = [self.detailArr objectForKey:@"bid"];
    
    [self presentViewController:paymentStripesVC animated:YES completion:nil];
    
    
//    GGPaymentVC *paymentView = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentVC"];
//    paymentView.totalAmount = [[self.detailArr objectForKey:@"deposit_price"] intValue];
//    [self.navigationController pushViewController:paymentView animated:YES];
    
//    NSString *flightInfoAll = nil;
//    NSString *flightInfo = nil;
//    NSString *player = nil;
//    NSString *cart = nil;
//    NSString *ttime = nil;
//    NSString *playerArr = nil;
//    NSString *playerArrAll = nil;
//    
//    for (int i = 0; i < [[self.detailArr objectForKey:@"flightarr"] count] ; i++){
//        
//        player = [[[[self.detailArr objectForKey:@"flightarr"] objectAtIndex:i] valueForKey:@"number"] description];
//        ttime = [[[[self.detailArr objectForKey:@"flightarr"] objectAtIndex:i] valueForKey:@"ttime"] description];
//        //membership = [[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:i] valueForKey:@"membership"] description];
//        cart = [[[[self.detailArr objectForKey:@"flightarr"] objectAtIndex:i] valueForKey:@"cart"] description];
//        
//        for (int j=0; j < [[[[self.detailArr objectForKey:@"flightarr"] objectAtIndex:i] objectForKey:@"number"] intValue]; j++) {
//            
//            playerArr = [NSString stringWithFormat:@"{\"type\":\"%@\",\"price\":\"%@\"}", [[[[[[self.detailArr objectForKey:@"flightarr"] objectAtIndex:i] valueForKey:@"playerarr"] objectAtIndex:j] objectForKey:@"type"] description], [[[[[[self.detailArr objectForKey:@"flightarr"] objectAtIndex:i] valueForKey:@"playerarr"] objectAtIndex:j] objectForKey:@"price"] description]];
//            
//            
//            if ([[[[self.detailArr objectForKey:@"flightarr"] objectAtIndex:i] valueForKey:@"number"] intValue] == 1) {
//                
//                playerArrAll = [NSString stringWithFormat:@"[%@]", playerArr];
//            } else {
//                if (j == 0) {
//                    playerArrAll = [NSString stringWithFormat:@"[%@", playerArr];
//                } else if (j > 0 && j < [[[[self.detailArr objectForKey:@"flightarr"] objectAtIndex:i] valueForKey:@"number"] intValue] - 1) {
//                    playerArrAll = [NSString stringWithFormat:@"%@,%@",playerArrAll, playerArr];
//                } else if (j == [[[[self.detailArr objectForKey:@"flightarr"] objectAtIndex:i] valueForKey:@"number"] intValue] - 1) {
//                    playerArrAll = [NSString stringWithFormat:@"%@,%@]",playerArrAll, playerArr];
//                }
//            }
//        }
//        
//        flightInfo = [NSString stringWithFormat:@"{\"player\":\"%@\",\"playerarr\":%@,\"ttime\":\"%@\",\"cart\":\"%@\"}", player, playerArrAll, ttime, cart];
//        
//        if ([[self.detailArr objectForKey:@"flightarr"] count] == 1) {
//            flightInfoAll = [NSString stringWithFormat:@"[%@]", flightInfo];
//            
//        } else {
//            
//            if (i == 0) {
//                flightInfoAll = [NSString stringWithFormat:@"[%@", flightInfo];
//            } else if (i > 0 && i < [[self.detailArr objectForKey:@"flightarr"] count] - 1) {
//                flightInfoAll = [NSString stringWithFormat:@"%@,%@",flightInfoAll, flightInfo];
//            } else if (i == [[self.detailArr objectForKey:@"flightarr"] count] - 1) {
//                flightInfoAll = [NSString stringWithFormat:@"%@,%@]",flightInfoAll, flightInfo];
//            }
//        }
//    }
//    
//    if ([[GGCommonFunc sharedInstance] connected]) {
//        [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
//        [[GGAPIBookingManager sharedInstance] addBookingWithcompletion:[self.detailArr objectForKey:@"gid"] date:[self.detailArr objectForKey:@"date"] dep_price:[NSString stringWithFormat:@"%d", (int)[self.detailArr objectForKey:@"deposit_price"]] flightArr:flightInfoAll use_point:[self.detailArr objectForKey:@"reward_point"] completion:^(NSDictionary *responseDict, NSError *error) {
//            [[GGCommonFunc sharedInstance] hideLoadingImage];
//            if (error == nil && [[responseDict objectForKey:@"code"] intValue] == 200) {
//                NSLog(@"RESPONSE : %@", responseDict);
//                
//                
//                [[NSUserDefaults standardUserDefaults] setValue:[[responseDict objectForKey:@"data"] objectForKey:@"bid"] forKey:@"bid_charge"];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                
//                GGPaymentVC *paymentView = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentVC"];
//                paymentView.totalAmount = [[self.detailArr objectForKey:@"deposit_price"] intValue];
//                [self.navigationController pushViewController:paymentView animated:YES];
//                
//                [self showCommonAlert:@"Booking Notification" message:[responseDict objectForKey:@"message"] status:YES];
//                
//            } else if ([[responseDict objectForKey:@"code"] intValue] == 400) {
//                [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
//                [[GGAPIManager sharedInstance] clearAllData];
//                [self.navigationController popToRootViewControllerAnimated:YES];
//            } else {
//                
//                [self showCommonAlert:@"Booking Notification" message:[responseDict objectForKey:@"message"] status:NO];
//            }
//        }];
//    }else{
//        [self showCommonAlert:@"Alert" message:@"No internet connection." status:false];
//    }

}

- (void) showNotification:(NSString *) title message:(NSString *)msg{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"YES"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   if ([[GGCommonFunc sharedInstance] connected]) {
                                       [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
                                       [[GGAPIBookingManager sharedInstance] cancelBookingWithcompletion:[self.detailArr objectForKey:@"bid"] completion:^(NSDictionary *responseDict, NSError *error) {
                                           [[GGCommonFunc sharedInstance] hideLoadingImage];
                                           if (error == nil) {
                                               if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                                                   [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                                                   [[GGAPIManager sharedInstance] clearAllData];
                                                   [self.navigationController popToRootViewControllerAnimated:YES];
                                               } else {
                                                   [self showCommonAlert:@"Notification" message:[responseDict objectForKey:@"message"] status:false];
                                               }
                                           }
                                           [btnCancelBook setEnabled:true];
                                       }];
                                   }else{
                                       [self showCommonAlert:@"Alert" message:@"No internet connection." status:false];
                                       [btnCancelBook setEnabled:true];
                                   }
                                   
                               }];
    
    UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [btnCancelBook setEnabled:true];
    }];
    
    [alert addAction:cancelButton];
    [alert addAction:okButton];
    
    [self presentViewController:alert  animated:YES completion:nil];
}

- (void) showCommonAlert:(NSString *) title message:(NSString *)msg status:(bool) isSuccess{
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   if (isSuccess) {
                                       
                                       GGPaymentVC *paymentView = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentVC"];
                                       paymentView.totalAmount = [[self.detailArr objectForKey:@"deposit_price"] intValue];
                                       [self.navigationController pushViewController:paymentView animated:YES];
                                   }else{
                                       [self goBack:nil];
                                   }
                                   
                               }];
    
    [alert addAction:okButton];
    
    [self presentViewController:alert  animated:YES completion:nil];
}

- (void)goToPaymentConfirmationView {
    [self dismissViewControllerAnimated:YES completion:^{
        GGPaymentConfirmationVC *paymentConfView = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentConfirmVC"];
        paymentConfView.grossAmount = [[self.detailArr objectForKey:@"deposit_price"] intValue];
        paymentConfView.bookingCode = [self.detailArr objectForKey:@"bcode"];
        [self.navigationController pushViewController:paymentConfView animated:YES];
    }];
}

- (void) reloadDetailTable {
    
    [self.tblBookingDetail reloadData];
    [self.tblBookingDetail setContentOffset:CGPointZero animated:YES];
}

#pragma mark - UITABLEVIEW DELEGATE & DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isHistory == false) {
        if ([[self.detailArr objectForKey:@"status"] isEqualToString:@"Unpaid"])
            return 7 + [[self.detailArr objectForKey:@"flightarr"] count];
        else
            return 6 + [[self.detailArr objectForKey:@"flightarr"] count];
    }else{
        return 5 + [[self.detailArr objectForKey:@"flightarr"] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *reCell;
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailMode0"];
        
        UILabel * lblCourseName = (UILabel *)[cell viewWithTag:1];
        lblCourseName.text = [self.detailArr objectForKey:@"gname"];
        
        reCell = cell;
    } else if (indexPath.row == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailMode1"];
        
        UILabel *lblTitle = (UILabel *)[cell viewWithTag:1];
        UILabel *lblTeks = (UILabel *)[cell viewWithTag:2];
        
        lblTitle.text = @"Booking Code";
        lblTeks.text = [self.detailArr objectForKey:@"bcode"];
        
        reCell = cell;
    } else if (indexPath.row == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailMode1"];
        
        UILabel *lblTitle = (UILabel *)[cell viewWithTag:1];
        UILabel *lblTeks = (UILabel *)[cell viewWithTag:2];
        
        lblTitle.text = @"Date";
        lblTeks.text = [[GGCommonFunc sharedInstance] changeDateFormat:[self.detailArr objectForKey:@"date"]];
        
        reCell = cell;
        
    } else if (indexPath.row == 4) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailMode1"];
        
        UILabel *lblTitle = (UILabel *)[cell viewWithTag:1];
        UILabel *lblTeks = (UILabel *)[cell viewWithTag:2];
        
        lblTitle.text = @"Flights Number";
        lblTeks.text = [NSString stringWithFormat:@"%ld", [[self.detailArr objectForKey:@"flightarr"] count]];
        
        reCell = cell;

    }
    else if (indexPath.row >= 5 && indexPath.row < (5 + [[self.detailArr objectForKey:@"flightarr"] count])) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailMode2"];
                
        UILabel *lblFlightsTitle = (UILabel *)[cell.contentView viewWithTag:1];
        UILabel *lblFlightsTeeTime = (UILabel *)[cell.contentView viewWithTag:56];
        UILabel *lblFlightsPrice = (UILabel *)[cell.contentView viewWithTag:57];
        UILabel *lblFlightsPlayerNumber = (UILabel *)[cell.contentView viewWithTag:58];
        UILabel *lblFlightsCart = (UILabel *)[cell.contentView viewWithTag:59];
        UILabel *lblPlayer1 = (UILabel *)[cell.contentView viewWithTag:60];
        UILabel *lblPlayer2 = (UILabel *)[cell.contentView viewWithTag:61];
        UILabel *lblPlayer3 = (UILabel *)[cell.contentView viewWithTag:62];
        UILabel *lblPlayer4 = (UILabel *)[cell.contentView viewWithTag:63];
        
        lblFlightsTitle.text = [NSString stringWithFormat:@"Flights %ld", indexPath.row - 4];
        lblFlightsTeeTime.text = [[[self.detailArr objectForKey:@"flightarr"] objectAtIndex:indexPath.row-5] objectForKey:@"ttime"];
        [self calculatePricePlayer];
        lblFlightsPrice.text = [NSString stringWithFormat:@"Rp. %@", [[GGCommonFunc sharedInstance] setSeparatedCurrency:(float)pricePlayer]];
        lblFlightsPlayerNumber.text = [[[self.detailArr objectForKey:@"flightarr"] objectAtIndex:indexPath.row-5] objectForKey:@"number"];
        
        if ([playerarr count] == 1) {
            lblPlayer1.hidden = false;
            
            lblPlayer1.text = [NSString stringWithFormat:@"%@ - Rp. %@", [playerarr[0] objectForKey:@"type"], [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[playerarr[0] objectForKey:@"price"] floatValue]]];
        }else if ([playerarr count] == 2) {
            lblPlayer1.hidden = false;
            lblPlayer2.hidden = false;
            
            lblPlayer1.text = [NSString stringWithFormat:@"%@ - Rp. %@", [playerarr[0] objectForKey:@"type"], [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[playerarr[0] objectForKey:@"price"] floatValue]]];
            lblPlayer2.text = [NSString stringWithFormat:@"%@ - Rp. %@", [playerarr[1] objectForKey:@"type"], [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[playerarr[1] objectForKey:@"price"] floatValue]]];
        }else if ([playerarr count] == 3) {
            lblPlayer1.hidden = false;
            lblPlayer2.hidden = false;
            lblPlayer3.hidden = false;
            
            lblPlayer1.text = [NSString stringWithFormat:@"%@ - Rp. %@", [playerarr[0] objectForKey:@"type"], [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[playerarr[0] objectForKey:@"price"] floatValue]]];
            lblPlayer2.text = [NSString stringWithFormat:@"%@ - Rp. %@", [playerarr[1] objectForKey:@"type"], [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[playerarr[1] objectForKey:@"price"] floatValue]]];
            lblPlayer3.text = [NSString stringWithFormat:@"%@ - Rp. %@", [playerarr[2] objectForKey:@"type"], [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[playerarr[2] objectForKey:@"price"] floatValue]]];
        }else if ([playerarr count] == 4) {
            lblPlayer1.hidden = false;
            lblPlayer2.hidden = false;
            lblPlayer3.hidden = false;
            lblPlayer4.hidden = false;
            
            lblPlayer1.text = [NSString stringWithFormat:@"%@ - Rp. %@", [playerarr[0] objectForKey:@"type"], [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[playerarr[0] objectForKey:@"price"] floatValue]]];
            lblPlayer2.text = [NSString stringWithFormat:@"%@ - Rp. %@", [playerarr[1] objectForKey:@"type"], [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[playerarr[1] objectForKey:@"price"] floatValue]]];
            lblPlayer3.text = [NSString stringWithFormat:@"%@ - Rp. %@", [playerarr[2] objectForKey:@"type"], [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[playerarr[2] objectForKey:@"price"] floatValue]]];
            lblPlayer4.text = [NSString stringWithFormat:@"%@ - Rp. %@", [playerarr[3] objectForKey:@"type"], [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[playerarr[3] objectForKey:@"price"] floatValue]]];
        }
        
        if ([[[[self.detailArr objectForKey:@"flightarr"] objectAtIndex:indexPath.row-5] objectForKey:@"cart"] isEqualToString:@"0"]) {
            lblFlightsCart.text = @"No";
        } else if ([[[[self.detailArr objectForKey:@"flightarr"] objectAtIndex:indexPath.row-5] objectForKey:@"cart"] isEqualToString:@"1"]) {
            lblFlightsCart.text = @"Yes";
        } else if ([[[[self.detailArr objectForKey:@"flightarr"] objectAtIndex:indexPath.row-5] objectForKey:@"cart"] isEqualToString:@"2"]) {
            lblFlightsCart.text = @"Included";
        }
        
        cell.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, cell.bounds.size.width);
        
        reCell = cell;
    }
    else if (indexPath.row == 1) {
        
        UITableViewCell *cell = [self.tblBookingDetail dequeueReusableCellWithIdentifier:@"detailMode3"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailMode3"];
        }
        
        NSString *totalPrice = [self.detailArr objectForKey:@"tprice"];
        NSString *depositPrice = [self.detailArr  objectForKey:@"deposit_price"];
        NSString *paymentInGolf = [NSString stringWithFormat:@"%ld", (long)([totalPrice intValue] - [depositPrice intValue])];;
        NSLog(@"paymentInGolf %@", paymentInGolf);
        NSString *pointReward = [self.detailArr objectForKey:@"reward_point"];
        UILabel *lblPaymentInGolf = (UILabel *)[cell.contentView viewWithTag:53];
        UILabel *lblDepositPrice = (UILabel *)[cell.contentView viewWithTag:51];
        UILabel *lblPoint = (UILabel *)[cell.contentView viewWithTag:52];
        UILabel *lblTotalPrice = (UILabel *)[cell.contentView viewWithTag:50];
        
        lblPaymentInGolf.text = [NSString stringWithFormat:@"Rp. %@", [[GGCommonFunc sharedInstance] setSeparatedCurrency:[paymentInGolf floatValue]]];
        lblDepositPrice.text = [NSString stringWithFormat:@"Rp. %@", [[GGCommonFunc sharedInstance] setSeparatedCurrency:[depositPrice floatValue]]];
        lblTotalPrice.text = [NSString stringWithFormat:@"Rp. %@", [[GGCommonFunc sharedInstance] setSeparatedCurrency:[totalPrice floatValue]]];
        lblPoint.text = [NSString stringWithFormat:@"%@ Points", pointReward];
        
        reCell = cell;
    }
    else if (self.isHistory == false) {
        if ([[self.detailArr objectForKey:@"status"] isEqualToString:@"Unpaid"]) {
            if (indexPath.row == 5 + [[self.detailArr objectForKey:@"flightarr"] count]) {
                
                UITableViewCell *cell = [self.tblBookingDetail dequeueReusableCellWithIdentifier:@"detailMode5"];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailMode5"];
                }
                
                btnPayNow = (UIButton *)[cell.contentView viewWithTag:64];
                btnPayNow.layer.cornerRadius = 5.0;
                btnPayNow.layer.masksToBounds = true;
                
                cell.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, cell.bounds.size.width);
                
                reCell = cell;
            }
            if (indexPath.row == 6 + [[self.detailArr objectForKey:@"flightarr"] count]) {
                
                UITableViewCell *cell = [self.tblBookingDetail dequeueReusableCellWithIdentifier:@"detailMode4"];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailMode4"];
                }
                
                btnCancelBook = (UIButton *)[cell.contentView viewWithTag:55];
                btnCancelBook.layer.cornerRadius = 5.0;
                btnCancelBook.layer.masksToBounds = true;
                
                cell.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, cell.bounds.size.width);
                
                reCell = cell;
            }
        }else{
            if (indexPath.row == 5 + [[self.detailArr objectForKey:@"flightarr"] count]) {
                
                UITableViewCell *cell = [self.tblBookingDetail dequeueReusableCellWithIdentifier:@"detailMode4"];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailMode4"];
                }
                
                btnCancelBook = (UIButton *)[cell.contentView viewWithTag:55];
                btnCancelBook.layer.cornerRadius = 5.0;
                btnCancelBook.layer.masksToBounds = true;
                
                cell.separatorInset = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, cell.bounds.size.width);
                
                reCell = cell;
            }
        }
    }
    
    return reCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 60;
    } else if (indexPath.row == 1) {
        return 133;
    } else if (indexPath.row < 5) {
        return 50;
    }
    else if (indexPath.row >= 5 && indexPath.row < (5 + [[self.detailArr objectForKey:@"flightarr"] count])) {
        return 200;
    }else if (self.isHistory == false) {
        if ([[self.detailArr objectForKey:@"status"] isEqualToString:@"Unpaid"]) {
            if (indexPath.row == 6 + [[self.detailArr objectForKey:@"flightarr"] count]) {
                return 57;
            }
        }
        if (indexPath.row == 5 + [[self.detailArr objectForKey:@"flightarr"] count]) {
            return 57;
        }

    }
    return 0;
}


@end
