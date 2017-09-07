//
//  GGBookingConfirmationVC.m
//  GoGolf
//
//  Created by Eddyson Tan on 8/15/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGBookingConfirmationVC.h"

@interface GGBookingConfirmationVC () {
    int depositPrice;
    float paymentCourse;
    NSString *bcodeConfirm;
    NSString *bidConfirm;
    NSString *acqPoint;
    UIButton *btnConfirmBook;
    GGPaymentStripesVC *paymentStripesVC;
}

@end

@implementation GGBookingConfirmationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"bookInfoDict %@", [[GGGlobalVariable sharedInstance].bookInfoDict description]);
    
    if ([[GGCommonFunc sharedInstance] connected]) {
        [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
        [[GGAPIBookingManager sharedInstance] getPointConfirmationWithcompletion:[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"tprice"] gid:[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"gid"] date:[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"date"] completion:^(NSDictionary *responseDict, NSError *error) {
            [[GGCommonFunc sharedInstance] hideLoadingImage];
            NSLog(@"response code %ld", (long)[[responseDict objectForKey:@"code"] intValue]);
            if (error == nil) {
                if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                    [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                    [[GGAPIManager sharedInstance] clearAllData];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    pointConfirmArr = [[NSDictionary alloc] init];
                    pointConfirmArr = responseDict;
                    
                    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"usePoint"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    
                    NSLog(@"HASIL : %@", responseDict);
                    
                    if ([[pointConfirmArr objectForKey:@"data"] objectForKey:@"spend_case"] != (id)[NSNull null]) {
                        if ([[[[pointConfirmArr objectForKey:@"data"] objectForKey:@"spend_case"] objectForKey:@"spend_point"] intValue] <= [[[GGGlobalVariable sharedInstance].itemUserDetail objectForKey:@"data"][@"point"] intValue] && [[[[pointConfirmArr objectForKey:@"data"] objectForKey:@"spend_case"] objectForKey:@"spend_point"] intValue] != 0) {
                            
                            [self showPointConfirmation];
                        }
                    } else {
                        totalPrice = [[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"tprice"] integerValue];
                        
                        depositPrice = ((float) self.deposit_rate / 100) * [[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"tprice"] intValue];
                        NSLog(@"depositPrice %ld", (long)depositPrice);

                        acqPoint = [[[pointConfirmArr objectForKey:@"data"] objectForKey:@"get_case"] objectForKey:@"reward_point"];
                        NSLog(@"%@", [[[pointConfirmArr objectForKey:@"data"] objectForKey:@"get_case"] objectForKey:@"reward_point"]);
                        NSLog(@"acqPoint %@", acqPoint);
                        
                        paymentCourse = totalPrice - depositPrice;
                        NSLog(@"paymentCourse %f", paymentCourse);
                        
                        [self.tblBookConfirm reloadData];
                    }
                }
            } else {
                NSLog(@"ERROR : %@", error.localizedDescription);
            }
        }];
    }else{
        [self showCommonAlert:@"Alert" message:@"No internet connection" status:false];
    }
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) showPointConfirmation{
    
    self.lblCurrentPoint.text = [NSString stringWithFormat:@"%@ Point", [[GGGlobalVariable sharedInstance].itemUserDetail objectForKey:@"data"][@"point"]];
    
    self.lblNecessaryPoint.text = [NSString stringWithFormat:@"%@ Point", [[[pointConfirmArr objectForKey:@"data"] objectForKey:@"spend_case"] objectForKey:@"spend_point"]];
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Rp. %@", [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[[[pointConfirmArr objectForKey:@"data"] objectForKey:@"spend_case"] objectForKey:@"disc_price"] intValue] + [[[[pointConfirmArr objectForKey:@"data"] objectForKey:@"spend_case"] objectForKey:@"final_price"] intValue]]]];
    [attributeString addAttribute:NSStrikethroughStyleAttributeName
                            value:@2
                            range:NSMakeRange(0, [attributeString length])];
    
    self.lblOldPrice.attributedText = attributeString;
    
    self.lblNewPrice.text = [NSString stringWithFormat:@"Rp. %@", [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[[[pointConfirmArr objectForKey:@"data"] objectForKey:@"spend_case"] objectForKey:@"final_price"] floatValue]]];
    
    self.lblDiscount.text = [NSString stringWithFormat:@"%@%%", [[[pointConfirmArr objectForKey:@"data"] objectForKey:@"spend_case"] objectForKey:@"disc_rate"]];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"usePoint"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.pointConfirmationView.hidden = NO;
    self.blurBackgroundView.hidden = NO;

}

- (IBAction)hidePointConfirmation:(id)sender {
    self.pointConfirmationView.hidden = YES;
    self.blurBackgroundView.hidden = YES;
    
    [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"usePoint"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    totalPrice = [[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"tprice"] integerValue];
    
    totalPrice = [[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"tprice"] integerValue];
    
    depositPrice = ((float) self.deposit_rate / 100) * [[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"tprice"] intValue];
    NSLog(@"depositPrice %ld", (long)depositPrice);
    
    acqPoint = [[[pointConfirmArr objectForKey:@"data"] objectForKey:@"get_case"] objectForKey:@"reward_point"];
    NSLog(@"%@", [[[pointConfirmArr objectForKey:@"data"] objectForKey:@"get_case"] objectForKey:@"reward_point"]);
    NSLog(@"acqPoint %@", acqPoint);
    
    paymentCourse = totalPrice - depositPrice;
    NSLog(@"paymentCourse %f", paymentCourse);
    
    [self.tblBookConfirm reloadData];
}

- (IBAction)goUsePointForDiscount:(id)sender {
    self.pointConfirmationView.hidden = YES;
    self.blurBackgroundView.hidden = YES;
    
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"usePoint"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    totalPrice = [[[[pointConfirmArr objectForKey:@"data"] objectForKey:@"spend_case"] objectForKey:@"final_price"] integerValue];
    float ttotalPrice = [[[[pointConfirmArr objectForKey:@"data"] objectForKey:@"spend_case"] objectForKey:@"final_price"] floatValue];
    
    depositPrice = ((float)self.deposit_rate / 100) * ttotalPrice;
    NSLog(@"depositPrice %ld", (long)depositPrice);
    
    acqPoint = @"0";
    NSLog(@"%@", [[[pointConfirmArr objectForKey:@"data"] objectForKey:@"get_case"] objectForKey:@"reward_point"]);
    NSLog(@"acqPoint %@", acqPoint);
    
    paymentCourse = totalPrice - depositPrice;
    NSLog(@"paymentCourse %f", paymentCourse);
    
    [self.tblBookConfirm reloadData];
}

- (IBAction)goBookGolf:(id)sender {
    btnConfirmBook = (UIButton *)sender;
    [btnConfirmBook setEnabled:false];
    NSLog(@"BOOK");
    NSString *flightInfoAll = nil;
    NSString *flightInfo = nil;
    NSString *player = nil;
    NSString *cart = nil;
    NSString *ttime = nil;
    NSString *playerArr = nil;
    NSString *playerArrAll = nil;

    for (int i = 0; i < [[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] count] ; i++){
        
        player = [[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:i] valueForKey:@"player"] description];
        ttime = [[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:i] valueForKey:@"ttime"] description];
        //membership = [[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:i] valueForKey:@"membership"] description];
        cart = [[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:i] valueForKey:@"cart"] description];
        
        if ([[GGGlobalVariable sharedInstance].bookInfoDict[@"flights"][i][@"cartOpt"] isEqualToString:@"1"])
            cart = @"1";
        else if ([[GGGlobalVariable sharedInstance].bookInfoDict[@"flights"][i][@"cartOpt"] isEqualToString:@"0"])
            cart = @"0";
        
        for (int j=0; j < [[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:i] valueForKey:@"player"] intValue]; j++) {
            
            playerArr = [NSString stringWithFormat:@"{\"type\":\"%@\",\"price\":\"%@\"}", [[[[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:i] valueForKey:@"playerarr"] objectAtIndex:j] objectForKey:@"type"] description], [[[[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:i] valueForKey:@"playerarr"] objectAtIndex:j] objectForKey:@"price"] description]];
            
            
            if ([[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:i] valueForKey:@"player"] intValue] == 1) {
                
                playerArrAll = [NSString stringWithFormat:@"[%@]", playerArr];
            } else {
                if (j == 0) {
                    playerArrAll = [NSString stringWithFormat:@"[%@", playerArr];
                } else if (j > 0 && j < [[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:i] valueForKey:@"player"] intValue] - 1) {
                    playerArrAll = [NSString stringWithFormat:@"%@,%@",playerArrAll, playerArr];
                } else if (j == [[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:i] valueForKey:@"player"] intValue] - 1) {
                    playerArrAll = [NSString stringWithFormat:@"%@,%@]",playerArrAll, playerArr];
                }
            }
        }
        
        flightInfo = [NSString stringWithFormat:@"{\"player\":\"%@\",\"playerarr\":%@,\"ttime\":\"%@\",\"cart\":\"%@\"}", player, playerArrAll, ttime, cart];
        
        if ([[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] count] == 1) {
            flightInfoAll = [NSString stringWithFormat:@"[%@]", flightInfo];
        
        } else {
        
            if (i == 0) {
                flightInfoAll = [NSString stringWithFormat:@"[%@", flightInfo];
            } else if (i > 0 && i < [[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] count] - 1) {
                flightInfoAll = [NSString stringWithFormat:@"%@,%@",flightInfoAll, flightInfo];
            } else if (i == [[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] count] - 1) {
                flightInfoAll = [NSString stringWithFormat:@"%@,%@]",flightInfoAll, flightInfo];
            }
        }
    }
    
    if ([[GGCommonFunc sharedInstance] connected]) {
        [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
        [[GGAPIBookingManager sharedInstance] addBookingWithcompletion:[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"gid"] date:[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"date"] dep_price:[NSString stringWithFormat:@"%d", (int)depositPrice] flightArr:flightInfoAll use_point:[[NSUserDefaults standardUserDefaults] objectForKey:@"usePoint"] completion:^(NSDictionary *responseDict, NSError *error) {
            [[GGCommonFunc sharedInstance] hideLoadingImage];
            if (error == nil && [[responseDict objectForKey:@"code"] intValue] == 200) {
                NSLog(@"RESPONSE : %@", responseDict);
                
                bidConfirm = [NSString stringWithFormat:@"%@", [[responseDict objectForKey:@"data"] objectForKey:@"bid"]];
                bcodeConfirm = [NSString stringWithFormat:@"%@", [[responseDict objectForKey:@"data"] objectForKey:@"bcode"]];
                [[NSUserDefaults standardUserDefaults] setValue:[[responseDict objectForKey:@"data"] objectForKey:@"bid"] forKey:@"bid_charge"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [self showCommonAlert:@"Booking Notification" message:[responseDict objectForKey:@"message"] status:YES];
                
            } else if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                [[GGAPIManager sharedInstance] clearAllData];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                
                [self showCommonAlert:@"Booking Notification" message:[responseDict objectForKey:@"message"] status:NO];
            }
        }];
    }else{
        [self showCommonAlert:@"Alert" message:@"No internet connection." status:false];
    }
    
}

- (void)goToPaymentConfirmation {
    [self dismissViewControllerAnimated:YES completion:^{
        GGPaymentConfirmationVC *paymentConfView = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentConfirmVC"];
        paymentConfView.grossAmount = depositPrice;
        paymentConfView.bookingCode = bcodeConfirm;
        [self.navigationController pushViewController:paymentConfView animated:YES];
    }];    
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
                                       
                                       paymentStripesVC = [[GGPaymentStripesVC alloc] initWithNibName:@"GGPaymentStripesVC" bundle:nil];
                                       paymentStripesVC.paymentStripesDelegate = self;
                                       paymentStripesVC.priceDp = depositPrice;
                                       paymentStripesVC.bcode = bcodeConfirm;
                                       paymentStripesVC.bid = bidConfirm;
                                       
                                       [self presentViewController:paymentStripesVC animated:YES completion:nil];
                                       
//                                       GGPaymentVC *paymentView = [self.storyboard instantiateViewControllerWithIdentifier:@"paymentVC"];
//                                       paymentView.totalAmount = (int)depositPrice;
//                                       [self.navigationController pushViewController:paymentView animated:YES];
                                   }
                                   [btnConfirmBook setEnabled:true];
                                   
                               }];
    
    [alert addAction:okButton];
    
    [self presentViewController:alert  animated:YES completion:nil];
}

#pragma mark - UITABLEVIEW DELEGATE & DATASOURCE
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4 + [[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flight"] intValue];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *reCell;
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"confirmMode0"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"confirmMode0"];
        }
        
        UILabel * lblCourseName = (UILabel *)[cell viewWithTag:1];
        lblCourseName.text = [[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"gname"];
        
        reCell = cell;
    } else if (indexPath.row < 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"confirmMode1"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"confirmMode1"];
        }
        
        UILabel *lblTitle = (UILabel *)[cell viewWithTag:1];
        UILabel *lblTeks = (UILabel *)[cell viewWithTag:2];
        
        if (indexPath.row == 1) {
            
            lblTitle.text = @"Date";
            lblTeks.text = [[GGCommonFunc sharedInstance] changeDateFormat:[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"date"]];
        } else if (indexPath.row == 2) {
            
            lblTitle.text = @"Flights Number";
            lblTeks.text = [NSString stringWithFormat:@"%ld", (long)[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flight"] intValue]];
        }
        
        reCell = cell;
    } else if (indexPath.row >= 3 && indexPath.row < (3 + [[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flight"] intValue])) {
    
        UITableViewCell *cell = [self.tblBookConfirm dequeueReusableCellWithIdentifier:@"confirmMode2"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"confirmMode2"];
        }
        
        UILabel *lblFlightsTitle = (UILabel *)[cell.contentView viewWithTag:1];
        UILabel *lblFlightsTeeTime = (UILabel *)[cell.contentView viewWithTag:2];
        UILabel *lblFlightsPrice = (UILabel *)[cell.contentView viewWithTag:3];
        UILabel *lblFlightsPlayerNumber = (UILabel *)[cell.contentView viewWithTag:4];
        UILabel *lblFlightsCart = (UILabel *)[cell.contentView viewWithTag:5];
        
        UILabel *lblPlayer1 = (UILabel *)[cell.contentView viewWithTag:21];
        UILabel *lblPlayer2 = (UILabel *)[cell.contentView viewWithTag:22];
        UILabel *lblPlayer3 = (UILabel *)[cell.contentView viewWithTag:23];
        UILabel *lblPlayer4 = (UILabel *)[cell.contentView viewWithTag:24];
        
        lblFlightsTitle.text = [NSString stringWithFormat:@"Flights %@", [[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:indexPath.row-3] objectForKey:@"id"]];
        lblFlightsTeeTime.text = [[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:indexPath.row-3] objectForKey:@"ttime"];
        lblFlightsPrice.text = [NSString stringWithFormat:@"Rp. %@", [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:indexPath.row-3] objectForKey:@"price"] floatValue]]];
        lblFlightsPlayerNumber.text = [[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:indexPath.row-3] objectForKey:@"player"];
        
        if ([[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:indexPath.row-3] objectForKey:@"cart"] isEqualToString:@"0"]) {
            
            if ([[GGGlobalVariable sharedInstance].bookInfoDict[@"flights"][indexPath.row-3][@"cartOpt"] isEqualToString:@"1"]) {
                lblFlightsCart.text = @"Yes";
            }else if ([[GGGlobalVariable sharedInstance].bookInfoDict[@"flights"][indexPath.row-3][@"cartOpt"] isEqualToString:@"0"]) {
                lblFlightsCart.text = @"No";
            }
            
        } else if ([[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:indexPath.row-3] objectForKey:@"cart"] isEqualToString:@"1"]) {
            lblFlightsCart.text = @"Yes";
        }
        
        if ([[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:indexPath.row-3] objectForKey:@"player"] intValue] == 1) {
            lblPlayer1.hidden = NO;
            
            lblPlayer1.text = [NSString stringWithFormat:@"- %@ (Rp. %@)", [[[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:indexPath.row-3] objectForKey:@"playerarr"] objectAtIndex:0] objectForKey:@"type"], [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[[[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:indexPath.row-3] objectForKey:@"playerarr"] objectAtIndex:0] objectForKey:@"price"] floatValue]]];
            
        } else if ([[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:indexPath.row-3] objectForKey:@"player"] intValue] == 2) {
            lblPlayer1.hidden = NO;
            lblPlayer2.hidden = NO;
            
            lblPlayer1.text = [NSString stringWithFormat:@"- %@ (Rp. %@)",[[[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:indexPath.row-3] objectForKey:@"playerarr"] objectAtIndex:0] objectForKey:@"type"], [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[[[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:indexPath.row-3] objectForKey:@"playerarr"] objectAtIndex:0] objectForKey:@"price"] floatValue]]];;
            
            lblPlayer2.text = [NSString stringWithFormat:@"- %@ (Rp. %@)",[[[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:indexPath.row-3] objectForKey:@"playerarr"] objectAtIndex:1] objectForKey:@"type"], [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[[[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:indexPath.row-3] objectForKey:@"playerarr"] objectAtIndex:1] objectForKey:@"price"] floatValue]]];
            
        }  else if ([[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:indexPath.row-3] objectForKey:@"player"] intValue] == 3) {
            lblPlayer1.hidden = NO;
            lblPlayer2.hidden = NO;
            lblPlayer3.hidden = NO;
            
            lblPlayer1.text = [NSString stringWithFormat:@"- %@ (Rp. %@)",[[[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:indexPath.row-3] objectForKey:@"playerarr"] objectAtIndex:0] objectForKey:@"type"], [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[[[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:indexPath.row-3] objectForKey:@"playerarr"] objectAtIndex:0] objectForKey:@"price"] floatValue]]];

            lblPlayer2.text = [NSString stringWithFormat:@"- %@ (Rp. %@)",[[[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:indexPath.row-3] objectForKey:@"playerarr"] objectAtIndex:1] objectForKey:@"type"], [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[[[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:indexPath.row-3] objectForKey:@"playerarr"] objectAtIndex:1] objectForKey:@"price"] floatValue]]];
            
            lblPlayer3.text =  [NSString stringWithFormat:@"- %@ (Rp. %@)",[[[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:indexPath.row-3] objectForKey:@"playerarr"] objectAtIndex:2] objectForKey:@"type"], [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[[[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:indexPath.row-3] objectForKey:@"playerarr"] objectAtIndex:2] objectForKey:@"price"] floatValue]]];
            
        } else if ([[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:indexPath.row-3] objectForKey:@"player"] intValue] == 4) {
            lblPlayer1.hidden = NO;
            lblPlayer2.hidden = NO;
            lblPlayer3.hidden = NO;
            lblPlayer4.hidden = NO;
            
            lblPlayer1.text = [NSString stringWithFormat:@"- %@ (Rp. %@)",[[[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:indexPath.row-3] objectForKey:@"playerarr"] objectAtIndex:0] objectForKey:@"type"], [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[[[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:indexPath.row-3] objectForKey:@"playerarr"] objectAtIndex:0] objectForKey:@"price"] floatValue]]];
            
            lblPlayer2.text = [NSString stringWithFormat:@"- %@ (Rp. %@)",[[[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:indexPath.row-3] objectForKey:@"playerarr"] objectAtIndex:1] objectForKey:@"type"], [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[[[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:indexPath.row-3] objectForKey:@"playerarr"] objectAtIndex:1] objectForKey:@"price"] floatValue]]];
            
            lblPlayer3.text = [NSString stringWithFormat:@"- %@ (Rp. %@)",[[[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:indexPath.row-3] objectForKey:@"playerarr"] objectAtIndex:2] objectForKey:@"type"], [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[[[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:indexPath.row-3] objectForKey:@"playerarr"] objectAtIndex:2] objectForKey:@"price"] floatValue]]];
            
            lblPlayer4.text =  [NSString stringWithFormat:@"- %@ (Rp. %@)",[[[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:indexPath.row-3] objectForKey:@"playerarr"] objectAtIndex:3] objectForKey:@"type"], [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[[[[[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] objectAtIndex:indexPath.row-3] objectForKey:@"playerarr"] objectAtIndex:3] objectForKey:@"price"] floatValue]]];
            
        }
        
        reCell = cell;
    } else if (indexPath.row == 3 + [[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"] count]) {
        
        UITableViewCell *cell = [self.tblBookConfirm dequeueReusableCellWithIdentifier:@"confirmMode3"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"confirmMode3"];
        }
        
        UILabel * lblTotalPrice = (UILabel *)[cell.contentView viewWithTag:50];
        lblTotalPrice.text = [NSString stringWithFormat:@"Rp. %@", [[GGCommonFunc sharedInstance] setSeparatedCurrency:(float)totalPrice]];
        
        UILabel * lblDepositPrice = (UILabel *)[cell.contentView viewWithTag:51];
        NSLog(@"depositPrice %ld", (long)depositPrice);
        lblDepositPrice.text = [NSString stringWithFormat:@"Rp. %@ (%@ %%)", [[GGCommonFunc sharedInstance] setSeparatedCurrency:(float)depositPrice], [[GGCommonFunc sharedInstance] setSeparatedCurrency:(float)self.deposit_rate]];
        
        UILabel *lblAcquisitionPoint = (UILabel *)[cell.contentView viewWithTag:52];
        lblAcquisitionPoint.text = [NSString stringWithFormat:@"%@ Points",acqPoint];
        
        UILabel *lblPaymentCourse = (UILabel *)[cell.contentView viewWithTag:53];
        lblPaymentCourse.text = [NSString stringWithFormat:@"Rp. %@", [[GGCommonFunc sharedInstance] setSeparatedCurrency:paymentCourse]];
        
        UILabel *lblLimit = (UILabel *)[cell.contentView viewWithTag:54];
        lblLimit.text = [NSString stringWithFormat:@"If you cancel %@ hours before the tee time, you may cancel your booking free. If you cancel less than %@ hours before the tee time or no-show, we will charge deposit price as cancellation fee.", [[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"][0] objectForKey:@"cancel_limit_hours"], [[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flights"][0] objectForKey:@"cancel_limit_hours"]];
        
        reCell = cell;
    }
    
    return reCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 60;
    } else if (indexPath.row < 3) {
        return 50;
    } else if (indexPath.row >= 3 && indexPath.row < (3 + [[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flight"] intValue])) {
        return 200;
    } else if (indexPath.row == 3 + [[[GGGlobalVariable sharedInstance].bookInfoDict objectForKey:@"flight"] intValue]) {
        return 320;
    }
    return 0;
}

@end
