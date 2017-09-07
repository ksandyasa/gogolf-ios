//
//  GGBookPromotionVC.m
//  GoGolf
//
//  Created by Eddyson Tan on 7/2/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGBookPromotionVC.h"

@interface GGBookPromotionVC () {
    BOOL afterSelectTTime;
    NSArray *isCarts;
}

@end

@implementation GGBookPromotionVC
//@synthesize itemIndex;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    flightPriceArr = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                      [NSNumber numberWithInt:0], @"1",
                      [NSNumber numberWithInt:0], @"2",
                      nil];
    depRateArr = [[NSMutableDictionary alloc] init];
    condArr = [[NSMutableDictionary alloc] init];
    listTeeTimeArr = [[NSMutableDictionary alloc] init];
    eachFlightDataArr = [[NSMutableArray alloc] init];
    
    countPrice = 0;
    countRate = 0;
    self.txtFlightNumber.text = @"1";
}

- (void)viewWillAppear:(BOOL)animated {
    isCart1 = NO;
    isCart2 = NO;
    isCart3 = NO;
    isCart4 = NO;
    
    typePlayerArr = [[NSMutableArray alloc] init];
    
    if (!self.isHomeList) {
        
        if ([self.detailArr objectForKey:@"date"] != nil) {
            
            self.topHeightConstraint.constant = 53;
            [self loadDetailView:[self.detailArr objectForKey:@"gid"] courseDate:[self.detailArr objectForKey:@"date"]];
        } else {
            self.topHeightConstraint.constant = 0;
            [self loadDetailView:[self.detailArr objectForKey:@"gid"] courseDate:@""];
        }
    } else {
        NSLog(@"ARR : %@", self.detailArr);
        [self loadDetailView:[self.detailArr objectForKey:@"gid"] courseDate:[self.detailArr objectForKey:@"gdate"]];
    }
    
    typePromo = 0;
    typeCondition = 0;
    [self.flightCollection reloadData];
    
}

- (IBAction)clickIsCart:(UIButton *)sender {
    
    UIButton *button = (UIButton *)sender;
    CGPoint rootPoint = [button convertPoint:CGPointZero toView:self.flightCollection];
    NSIndexPath *indexPath = [self.flightCollection indexPathForItemAtPoint:rootPoint];
    UICollectionViewCell *cell = [self.flightCollection cellForItemAtIndexPath:indexPath];
    
    UITextField *txtPlayerNumber = (UITextField *)[cell viewWithTag:4];
    UITextField *txtFlightTime = (UITextField *)[cell viewWithTag:2];
    
    if ([txtPlayerNumber.text length] > 0 && [txtFlightTime.text length] > 0) {
        UIButton *btnYes = (UIButton *)[cell viewWithTag:5];
        UIButton *btnNO = (UIButton *)[cell viewWithTag:6];
        
        UILabel *lblnoCart = (UILabel *)[cell viewWithTag:7];
        
        if (sender == btnYes) {
            [btnYes setSelected:YES];
            [btnNO setSelected:NO];
            NSLog(@"Yes");
        } else if (sender == btnNO) {
            [btnNO setSelected:YES];
            [btnYes setSelected:NO];
            NSLog(@"No");
        }
        
        NSString *price = nil;
        NSString *priceCart = nil;
        NSString *typePlayer = nil;
        
        if ([[[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:0] objectForKey:@"price"] intValue] == 0 && [btnNO isSelected]) {
            for (int x = 0 ; x < [[listTypePlayer objectForKey:@"price_list"] count]; x++) {
                if ([[[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:x] objectForKey:@"price"] intValue] != 0) {
                    price = [[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:x] objectForKey:@"price"];
                    priceCart = [[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:x] objectForKey:@"price_cart"];
                    typePlayer = [[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:x] objectForKey:@"type"];
                    NSLog(@"typePlayer %@", typePlayer);
                    break;
                }
            }
        } else {
            
            price = [[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:0] objectForKey:@"price"];
            priceCart = [[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:0] objectForKey:@"price_cart"];
            typePlayer = [[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:0] objectForKey:@"type"];
            NSLog(@"typePlayer %@", typePlayer);
         
            if ([[[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:0] objectForKey:@"cart_mandatory"] intValue] == 1) {
                lblnoCart.hidden = NO;
                
                if ([txtPlayerNumber.text intValue] == 1) {
                    isCart1 = YES;
                } else if ([txtPlayerNumber.text intValue] == 2) {
                    isCart1 = YES;
                    isCart2 = YES;
                } else if ([txtPlayerNumber.text intValue] == 3) {
                    isCart1 = YES;
                    isCart2 = YES;
                    isCart3 = YES;
                } else if ([txtPlayerNumber.text intValue] == 4) {
                    isCart1 = YES;
                    isCart2 = YES;
                    isCart3 = YES;
                    isCart4 = YES;
                }
            }
        }
        
        UITextField *txtPlayer1 = (UITextField *)[cell viewWithTag:81];
        UITextField *total1 = (UITextField *)[cell viewWithTag:71];
        if ([btnYes isSelected] || ![lblnoCart isHidden]) {
            total1.text = priceCart;
            
            txtPlayer1.text = [NSString stringWithFormat:@"%@ - Rp. %@", typePlayer, [[GGCommonFunc sharedInstance] setSeparatedCurrency:[priceCart floatValue]]];
        } else {
            
            total1.text = price;
            txtPlayer1.text = [NSString stringWithFormat:@"%@ - Rp. %@", typePlayer, [[GGCommonFunc sharedInstance] setSeparatedCurrency:[price floatValue]]];
        }
        
        UITextField *txtPlayer2 = (UITextField *)[cell viewWithTag:82];
        UITextField *total2 = (UITextField *)[cell viewWithTag:72];
        if ([btnYes isSelected] || ![lblnoCart isHidden]) {
            total2.text = priceCart;
            
            txtPlayer2.text = [NSString stringWithFormat:@"%@ - Rp. %@", typePlayer, [[GGCommonFunc sharedInstance] setSeparatedCurrency:[priceCart floatValue]]];
        } else {
            total2.text = price;
            
            txtPlayer2.text = [NSString stringWithFormat:@"%@ - Rp. %@", typePlayer, [[GGCommonFunc sharedInstance] setSeparatedCurrency:[price floatValue]]];
        }
        
        UITextField *txtPlayer3 = (UITextField *)[cell viewWithTag:83];
        UITextField *total3 = (UITextField *)[cell viewWithTag:73];
        if ([btnYes isSelected] || ![lblnoCart isHidden]) {
            total3.text = priceCart;
            
            txtPlayer3.text = [NSString stringWithFormat:@"%@ - Rp. %@", typePlayer, [[GGCommonFunc sharedInstance] setSeparatedCurrency:[priceCart floatValue]]];
        } else {
            total3.text = price;
            
            txtPlayer3.text = [NSString stringWithFormat:@"%@ - Rp. %@", typePlayer, [[GGCommonFunc sharedInstance] setSeparatedCurrency:[price floatValue]]];
        }
        
        UITextField *txtPlayer4 = (UITextField *)[cell viewWithTag:84];
        UITextField *total4 = (UITextField *)[cell viewWithTag:74];
        if ([btnYes isSelected] || ![lblnoCart isHidden]) {
            total4.text = priceCart;
            
            txtPlayer4.text = [NSString stringWithFormat:@"%@ - Rp. %@", typePlayer, [[GGCommonFunc sharedInstance] setSeparatedCurrency:[priceCart floatValue]]];
        } else {
            total4.text = price;
            
            txtPlayer4.text = [NSString stringWithFormat:@"%@ - Rp. %@", typePlayer, [[GGCommonFunc sharedInstance] setSeparatedCurrency:[price floatValue]]];
        }
        
        UILabel *lblTotalCostFlight = (UILabel *)[cell viewWithTag:3];
        lblTotalCostFlight.text = @"0";
        UILabel *lblTotalDepositRateFlight = (UILabel *)[cell viewWithTag:8];
        lblTotalDepositRateFlight.text = @"0";
        lblTotalDepositRateFlight.hidden = YES;
        
        if ([txtPlayerNumber.text isEqualToString:@"1"]) {
            lblTotalCostFlight.text = total1.text;
            
        } else if ([txtPlayerNumber.text isEqualToString:@"2"]) {
            lblTotalCostFlight.text = [NSString stringWithFormat:@"%d", [total1.text intValue] + [total2.text intValue]];
            
        } else if ([txtPlayerNumber.text isEqualToString:@"3"]) {
            lblTotalCostFlight.text = [NSString stringWithFormat:@"%d", [total1.text intValue] + [total2.text intValue] + [total3.text intValue]];
            
        } else if ([txtPlayerNumber.text isEqualToString:@"4"]) {
            lblTotalCostFlight.text = [NSString stringWithFormat:@"%d", [total1.text intValue] + [total2.text intValue] + [total3.text intValue] + [total4.text intValue]];
        }
        
        lblTotalDepositRateFlight.text = [NSString stringWithFormat:@"%f", [lblTotalCostFlight.text intValue] * ([[listTypePlayer objectForKey:@"deposit_rate"] floatValue]/100)];
        
        [flightPriceArr setObject:lblTotalCostFlight.text forKey:[NSString stringWithFormat:@"%ld", (long)(int)collSelectedIndexPath.row]];
        [self saveFlightData];
        [depRateArr setObject: [NSString stringWithFormat:@"%d", [lblTotalDepositRateFlight.text intValue]] forKey:[NSString stringWithFormat:@"%ld", (long)(int) collSelectedIndexPath.row]];
        
        lblTotalCostFlight.text = [[GGCommonFunc sharedInstance] setSeparatedCurrency:[lblTotalCostFlight.text floatValue]];
        
        //if (collSelectedIndexPath.row == [_txtFlightNumber.text intValue] - 1) {
        
        for (int a = 0; a < [self.txtFlightNumber.text intValue]; a++) {
            countPrice = countPrice + [[flightPriceArr objectForKey:[NSString stringWithFormat:@"%d", a]] intValue];
            countRate = countRate + [[depRateArr objectForKey:[NSString stringWithFormat:@"%d", a]] intValue];
        }
        self.lblTotalDepositRate.text = [NSString stringWithFormat:@"%d", countRate];
        self.lblTotalPrice.text = [NSString stringWithFormat:@"%@",[[GGCommonFunc sharedInstance] setSeparatedCurrency:countPrice]];
        countPrice = 0;
        countRate = 0;
        //}
    } else if ([txtFlightTime.text length] == 0) {
        [self showCommonAlert:@"Booking Notification" message:@"Choose Tee Time first!" isTeeTime:NO];
    } else if ([txtPlayerNumber.text length] == 0){
        [self showCommonAlert:@"Booking Notification" message:@"Choose number of player first!" isTeeTime:NO];
    }
    
}

- (void) loadDetailView:(NSString *) GID courseDate:(NSString *)date {// isFirstLoad:(BOOL)isFirstLoad{
    
    [[GGAPICourseManager sharedInstance] getPreBookingListWithGID:GID courseDate:date completion:^(NSDictionary *responseDict, NSError *error) {
        
        if (error == nil) {
            if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                [[GGAPIManager sharedInstance] clearAllData];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                self.timeArr = [responseDict objectForKey:@"data"];
                
                if([[responseDict objectForKey:@"data"] objectForKey:@"image"] != (id)[NSNull null])
                    [[GGCommonFunc sharedInstance] setLazyLoadImage:self.imgBookPromo urlString:[[responseDict objectForKey:@"data"] objectForKey:@"image"]];
                else
                    self.imgBookPromo.image = [UIImage imageNamed:@"def_big_img"];
                
                self.lblCourseTitle.text = [[responseDict objectForKey:@"data"] objectForKey:@"gname"];
                
                self.lblCourseDate.text = [[GGCommonFunc sharedInstance] changeDateFormat:[responseDict objectForKey:@"data"][@"date"]];
                
                self.txtDate.text = self.lblCourseDate.text;
                
                if ([[[responseDict objectForKey:@"data"] objectForKey:@"promotion"] count] > 0) {
                    
                    self.lblCoursePrice.hidden = NO;
                    self.lblCourseDisc.hidden = NO;
                    
                    self.lblCoursePrice.text = [NSString stringWithFormat:@"Rp. %@", [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[[[[responseDict objectForKey:@"data"] objectForKey:@"promotion"] objectAtIndex:0] objectForKey:@"pprice"] floatValue]]];
                    self.lblCourseDisc.text = [NSString stringWithFormat:@"Disc %@%%", [[[[responseDict objectForKey:@"data"] objectForKey:@"promotion"] objectAtIndex:0] objectForKey:@"discount"]];
                    
                    self.lblCourseTime.text = [NSString stringWithFormat:@"%@ - %@", [[responseDict objectForKey:@"data"] objectForKey:@"promotion"][0][@"stime"], [[responseDict objectForKey:@"data"] objectForKey:@"promotion"][0][@"etime"]];
                    
                    self.lblCourseLimit.text = [NSString stringWithFormat:@"Rest of limit : %@ flight", [[[[responseDict objectForKey:@"data"] objectForKey:@"promotion"] objectAtIndex:0] objectForKey:@"limit_num"]];
                    
                    self.topHeightConstraint.constant = 53;
                    
                } else {
                    
                    self.topHeightConstraint.constant = 0;
                    self.lblCoursePrice.hidden = YES;
                    self.lblCourseDisc.hidden = YES;
                    
                }
                
                [self.pickerView reloadAllComponents];
            }
        }
    }];
}

- (void) fillFlightInfo:(NSIndexPath *) indexPathCollection selectedIndexPath:(NSIndexPath *) indexPathTable {
    
    UICollectionViewCell *cell = [self.flightCollection cellForItemAtIndexPath:indexPathCollection];
    
    UITextField *txtFlightTime = (UITextField *)[cell viewWithTag:2];
    txtFlightTime.text = [[[self.timeArr objectForKey:@"timearr"] objectAtIndex:indexPathTable.row] objectForKey:@"ttime"];
    
    UILabel *lblTotalCostFlight = (UILabel *)[cell viewWithTag:3];
    lblTotalCostFlight.text = @"0";
    UILabel *lblTotalDepositRateFlight = (UILabel *)[cell viewWithTag:8];
    lblTotalDepositRateFlight.text = @"0";
    lblTotalDepositRateFlight.hidden = YES;
    
    UITextField *txtPlayerNumber = (UITextField *)[cell viewWithTag:4];
    txtPlayerNumber.text = @"";
    
    UILabel *lblnoCart = (UILabel *)[cell viewWithTag:7];
    if ([[[[self.timeArr objectForKey:@"conditionarr"] objectAtIndex:typeCondition] objectForKey:@"cart_mandatory"] isEqualToString:@"1"])
        lblnoCart.hidden = NO;
    else
        lblnoCart.hidden = YES;
    
    UILabel *lblVisitonly = (UILabel *)[cell viewWithTag:8];
    if ([[listTypePlayer objectForKey:@"visit_only"] isEqualToString:@"0"])
        lblVisitonly.hidden = NO;
    else
        lblVisitonly.hidden = YES;
    
    UITextField *txtPlayer1 = (UITextField *)[cell viewWithTag:81];
    UITextField *txtPlayer2 = (UITextField *)[cell viewWithTag:82];
    UITextField *txtPlayer3 = (UITextField *)[cell viewWithTag:83];
    UITextField *txtPlayer4 = (UITextField *)[cell viewWithTag:84];
    UITextField *total1 = (UITextField *)[cell viewWithTag:71];
    UITextField *total2 = (UITextField *)[cell viewWithTag:72];
    UITextField *total3 = (UITextField *)[cell viewWithTag:73];
    UITextField *total4 = (UITextField *)[cell viewWithTag:74];
    
    txtPlayer1.text = nil;
    txtPlayer2.text = nil;
    txtPlayer3.text = nil;
    txtPlayer4.text = nil;
    total1.text = nil;
    total2.text = nil;
    total3.text = nil;
    total4.text = nil;
    
    UIView *view1 = (UIView *)[cell viewWithTag:11];
    UIView *view2 = (UIView *)[cell viewWithTag:12];
    UIView *view3 = (UIView *)[cell viewWithTag:13];
    UIView *view4 = (UIView *)[cell viewWithTag:14];
    
    view1.hidden = NO;
    view2.hidden = NO;
    view3.hidden = NO;
    view4.hidden = NO;
    
//    UIView *view1 = (UIView *)[cell viewWithTag:11];
//    UIView *view2 = (UIView *)[cell viewWithTag:12];
//    UIView *view3 = (UIView *)[cell viewWithTag:13];
//    UIView *view4 = (UIView *)[cell viewWithTag:14];
//    
//    UIButton *btnYes = (UIButton *)[cell viewWithTag:5];
//    UIButton *btnNO = (UIButton *)[cell viewWithTag:6];
//    
//    [btnYes setSelected:YES];
//    [btnNO setSelected:NO];
//    
//    NSString *price = [[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:0] objectForKey:@"price"];
//    
//    NSString *priceCart = [[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:0] objectForKey:@"price_cart"];
//
//    
//    UITextField *txtPlayer1 = (UITextField *)[cell viewWithTag:81];
//    UITextField *total1 = (UITextField *)[cell viewWithTag:71];
//    
//    if ([btnYes isSelected] || ![lblnoCart isHidden]) {
//        total1.text = priceCart;
//        
//        txtPlayer1.text = [NSString stringWithFormat:@"%@ - Rp. %@", [[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:0] objectForKey:@"type"], [[GGCommonFunc sharedInstance] setSeparatedCurrency:[priceCart floatValue]]];
//    } else {
//        total1.text = price;
//        
//        txtPlayer1.text = [NSString stringWithFormat:@"%@ - Rp. %@", [[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:0] objectForKey:@"type"], [[GGCommonFunc sharedInstance] setSeparatedCurrency:[price floatValue]]];
//    }
//    view1.hidden = NO;
//    
//    UITextField *txtPlayer2 = (UITextField *)[cell viewWithTag:82];
//    UITextField *total2 = (UITextField *)[cell viewWithTag:72];
//    if ([btnYes isSelected] || ![lblnoCart isHidden]) {
//        total2.text = priceCart;
//        
//        txtPlayer2.text = [NSString stringWithFormat:@"%@ - Rp. %@", [[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:0] objectForKey:@"type"], [[GGCommonFunc sharedInstance] setSeparatedCurrency:[priceCart floatValue]]];
//    } else {
//        total2.text = price;
//        
//        txtPlayer2.text = [NSString stringWithFormat:@"%@ - Rp. %@", [[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:0] objectForKey:@"type"], [[GGCommonFunc sharedInstance] setSeparatedCurrency:[price floatValue]]];
//    }
//    view2.hidden = NO;
//    
//    UITextField *txtPlayer3 = (UITextField *)[cell viewWithTag:83];
//    UITextField *total3 = (UITextField *)[cell viewWithTag:73];
//    if ([btnYes isSelected] || ![lblnoCart isHidden]) {
//        total3.text = priceCart;
//        
//        txtPlayer3.text = [NSString stringWithFormat:@"%@ - Rp. %@", [[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:0] objectForKey:@"type"], [[GGCommonFunc sharedInstance] setSeparatedCurrency:[priceCart floatValue]]];
//    } else {
//        total3.text = price;
//        
//        txtPlayer3.text = [NSString stringWithFormat:@"%@ - Rp. %@", [[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:0] objectForKey:@"type"], [[GGCommonFunc sharedInstance] setSeparatedCurrency:[price floatValue]]];
//    }
//    view3.hidden = NO;
//    
//    UITextField *txtPlayer4 = (UITextField *)[cell viewWithTag:84];
//    UITextField *total4 = (UITextField *)[cell viewWithTag:74];
//    if ([btnYes isSelected] || ![lblnoCart isHidden]) {
//        total4.text = priceCart;
//        
//        txtPlayer4.text = [NSString stringWithFormat:@"%@ - Rp. %@", [[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:0] objectForKey:@"type"], [[GGCommonFunc sharedInstance] setSeparatedCurrency:[priceCart floatValue]]];
//    } else {
//        total4.text = price;
//        
//        txtPlayer4.text = [NSString stringWithFormat:@"%@ - Rp. %@", [[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:0] objectForKey:@"type"], [[GGCommonFunc sharedInstance] setSeparatedCurrency:[price floatValue]]];
//    }
//    view4.hidden = NO;
    
    [flightPriceArr setObject:[[GGCommonFunc sharedInstance] getCurrencyFromString:lblTotalCostFlight.text] forKey:[NSString stringWithFormat:@"%ld", (long)(int)collSelectedIndexPath.row]];
    [self updateAllPrice];
//    [self saveFlightData];
}

- (NSArray *) getStringBeforeChar:(NSString *) character teks:(NSString *)teksString{
    NSArray *textArray = [teksString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:character]];
    
    return textArray;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)GoBookingConfirmation:(id)sender {
    
    bool isEmpty = YES;
    
//    if ([self.txtFlightNumber.text intValue] > [eachFlightDataArr count]) {
//        isEmpty = YES;
//    } else {
    
//        for (int i = 0; i < [self.txtFlightNumber.text intValue]; i++) {
//            
//            if ([[[eachFlightDataArr objectAtIndex:i] objectForKey:@"playerarr"] count] == 0) {
//                isEmpty = YES;
//                break;
//            } else {
//                isEmpty = NO;
//            }
//        }
//    }
    
    for (int a = 0; a < [self.txtFlightNumber.text intValue]; a++) {
        
        if([[flightPriceArr objectForKey:[NSString stringWithFormat:@"%d", a]] intValue] != 0) {
            isEmpty = NO;
        } else {
            isEmpty = YES;
            break;
        }
        
    }
    
    NSLog(@"HARGA LOKAL FLIGHT : %@", flightPriceArr);
    
    if (!isEmpty) {
        NSLog(@"date %@", self.txtDate.text);
        NSMutableDictionary *bookInfoDict = [[NSMutableDictionary alloc] init];
        [bookInfoDict setValue:self.lblCourseTitle.text forKey:@"gname"];
        [bookInfoDict setValue:[self.timeArr objectForKey:@"gid"] forKey:@"gid"];
        [bookInfoDict setValue:[[GGCommonFunc sharedInstance] getCurrencyFromString:self.lblTotalPrice.text] forKey:@"tprice"];
        [bookInfoDict setValue:[[GGCommonFunc sharedInstance] changeDateFormatForAPI:self.txtDate.text] forKey:@"date"];
        
        
//        NSArray *arrayOfIndexPaths = [self.flightCollection indexPathsForVisibleItems];
        
        // Adding dictionary for flight
        NSMutableArray *playerParams = [NSMutableArray array];
        
        for (int i = 0; i < [self.txtFlightNumber.text intValue]; i++) {
            
//            UICollectionViewCell *cell = [self.flightCollection cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
//            
//            NSMutableArray *playerArr = [NSMutableArray array];
//            
//            UILabel *lblFlightTeeTime = (UILabel *)[cell viewWithTag:2];
//            UILabel *lblFlightPrice = (UILabel *)[cell viewWithTag:3];
//            UILabel *lblPlayerNumber = (UILabel *)[cell viewWithTag:4];
//            
//            UIButton *btnYes = (UIButton *)[cell viewWithTag:5];
//            UIButton *btnNO = (UIButton *)[cell viewWithTag:6];
//            UILabel *lblnoCart = (UILabel *)[cell viewWithTag:7];
//            NSString *isCart = @"1";
//            
//            if (lblnoCart.hidden == YES) {
//                if (btnYes.isSelected == YES)
//                    isCart = @"1";
//                else if (btnNO.isSelected == YES)
//                    isCart = @"0";
//            } else
//                isCart = @"1";
//            
//            UITextField *txtPlayer1 = (UITextField *)[cell viewWithTag:81];
//            UITextField *txtPlayer2 = (UITextField *)[cell viewWithTag:82];
//            UITextField *txtPlayer3 = (UITextField *)[cell viewWithTag:83];
//            UITextField *txtPlayer4 = (UITextField *)[cell viewWithTag:84];
//            UITextField *total1 = (UITextField *)[cell viewWithTag:71];
//            UITextField *total2 = (UITextField *)[cell viewWithTag:72];
//            UITextField *total3 = (UITextField *)[cell viewWithTag:73];
//            UITextField *total4 = (UITextField *)[cell viewWithTag:74];
//            
//            for (int j = 0 ; j < [lblPlayerNumber.text intValue] ; j++) {
//                if ([lblPlayerNumber.text intValue] == 1) {
//                    typeArr = [txtPlayer1.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" - "]];
//                    [playerArr addObject:@{
//                                           @"type" : typeArr[0],
//                                           @"price" : total1.text
//                                           }];
//                } else if ([lblPlayerNumber.text intValue] == 2) {
//                    if (j == 0) {
//                        typeArr = [txtPlayer1.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" - "]];
//
//                        [playerArr addObject:@{@"type" : typeArr[0],
//                                               @"price" : total1.text}];
//                    } else if (j == 1) {
//                        
//                        typeArr = [txtPlayer2.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" - "]];
//                        [playerArr addObject:@{@"type" : typeArr[0],
//                                               @"price" : total2.text}];
//                    }
//                } else if ([lblPlayerNumber.text intValue] == 3) {
//                    if (j == 0) {
//                        
//                        typeArr = [txtPlayer1.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" - "]];
//                        [playerArr addObject:@{@"type" : typeArr[0],
//                                               @"price" : total1.text}];
//                    } else if (j == 1) {
//                        
//                        typeArr = [txtPlayer2.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" - "]];
//                        [playerArr addObject:@{@"type" : typeArr[0],
//                                               @"price" : total2.text}];
//                    } else if (j == 2) {
//                        typeArr = [txtPlayer3.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" - "]];
//                        [playerArr addObject:@{@"type" : typeArr[0],
//                                               @"price" : total3.text}];
//                    }
//                } else if ([lblPlayerNumber.text intValue] == 4) {
//                    if (j == 0) {
//                        typeArr = [txtPlayer1.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" - "]];
//                        [playerArr addObject:@{@"type" : typeArr[0],
//                                               @"price" : total1.text}];
//                    } else if (j == 1) {
//                        typeArr = [txtPlayer2.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" - "]];
//                        [playerArr addObject:@{@"type" : typeArr[0],
//                                               @"price" : total2.text}];
//                    } else if (j == 2) {
//                        typeArr = [txtPlayer3.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" - "]];
//                        [playerArr addObject:@{@"type" : typeArr[0],
//                                               @"price" : total3.text}];
//                    } else if (j == 3) {
//                        typeArr = [txtPlayer4.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" - "]];
//                        [playerArr addObject:@{@"type" : typeArr[0],
//                                               @"price" : total4.text}];
//                    }
//                }
//            }
//            
//            [playerParams addObject: @{
//                                    @"id" : [NSString stringWithFormat:@"%d", i + 1],
//                                    @"player" : lblPlayerNumber.text,
//                                    @"playerarr" : playerArr,
//                                    @"ttime": lblFlightTeeTime.text,
//                                    @"price": [[GGCommonFunc sharedInstance] getCurrencyFromString:lblFlightPrice.text],
//                                    @"cart": isCart
//                                    }];
            [playerParams addObject:[eachFlightDataArr objectAtIndex:i]];
        }
        
        [bookInfoDict addEntriesFromDictionary:[NSMutableDictionary dictionaryWithObjectsAndKeys: playerParams,@"flights", nil]];

        NSLog(@"BOOK PARAMS : %@", bookInfoDict);

        [GGGlobalVariable sharedInstance].bookInfoDict = bookInfoDict;
        
        GGBookingConfirmationVC *bookConfirmView = [self.storyboard instantiateViewControllerWithIdentifier:@"bookConfirmVC"];

        bookConfirmView.deposit_rate = [self.lblTotalDepositRate.text intValue];
        
        [self.navigationController pushViewController:bookConfirmView animated:YES];
    } else {
        [self showCommonAlert:@"Notification" message:@"Please fill all information first!" isTeeTime:NO];
    }
    
}

- (void) saveFlightData {
    NSMutableDictionary *newUpdate = [[NSMutableDictionary alloc] init];
    
    UICollectionViewCell *cell = [self.flightCollection cellForItemAtIndexPath:collSelectedIndexPath];
    
    NSMutableArray *playerArr = [NSMutableArray array];
    
    UILabel *lblFlightTeeTime = (UILabel *)[cell viewWithTag:2];
    UILabel *lblFlightPrice = (UILabel *)[cell viewWithTag:3];
    UILabel *lblPlayerNumber = (UILabel *)[cell viewWithTag:4];
    
    UIButton *btnYes = (UIButton *)[cell viewWithTag:5];
    UIButton *btnNO = (UIButton *)[cell viewWithTag:6];
    UILabel *lblnoCart = (UILabel *)[cell viewWithTag:7];
    NSString *isCart = @"1";
    
    if (lblnoCart.hidden == YES) {
        if (btnYes.isSelected == YES)
            isCart = @"1";
        else if (btnNO.isSelected == YES)
            isCart = @"0";
    } else
        isCart = @"1";
    
    UITextField *txtPlayer1 = (UITextField *)[cell viewWithTag:81];
    UITextField *txtPlayer2 = (UITextField *)[cell viewWithTag:82];
    UITextField *txtPlayer3 = (UITextField *)[cell viewWithTag:83];
    UITextField *txtPlayer4 = (UITextField *)[cell viewWithTag:84];
    UITextField *total1 = (UITextField *)[cell viewWithTag:71];
    UITextField *total2 = (UITextField *)[cell viewWithTag:72];
    UITextField *total3 = (UITextField *)[cell viewWithTag:73];
    UITextField *total4 = (UITextField *)[cell viewWithTag:74];
    
    for (int j = 0 ; j < [lblPlayerNumber.text intValue] ; j++) {
        if ([lblPlayerNumber.text intValue] == 1) {
            typeArr = [txtPlayer1.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" - "]];
            [playerArr addObject:@{
                                   @"type" : typeArr[0],
                                   @"price" : total1.text
                                   }];
        } else if ([lblPlayerNumber.text intValue] == 2) {
            if (j == 0) {
                typeArr = [txtPlayer1.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" - "]];
                
                [playerArr addObject:@{@"type" : typeArr[0],
                                       @"price" : total1.text}];
            } else if (j == 1) {
                
                typeArr = [txtPlayer2.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" - "]];
                [playerArr addObject:@{@"type" : typeArr[0],
                                       @"price" : total2.text}];
            }
        } else if ([lblPlayerNumber.text intValue] == 3) {
            if (j == 0) {
                
                typeArr = [txtPlayer1.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" - "]];
                [playerArr addObject:@{@"type" : typeArr[0],
                                       @"price" : total1.text}];
            } else if (j == 1) {
                
                typeArr = [txtPlayer2.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" - "]];
                [playerArr addObject:@{@"type" : typeArr[0],
                                       @"price" : total2.text}];
            } else if (j == 2) {
                typeArr = [txtPlayer3.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" - "]];
                [playerArr addObject:@{@"type" : typeArr[0],
                                       @"price" : total3.text}];
            }
        } else if ([lblPlayerNumber.text intValue] == 4) {
            if (j == 0) {
                typeArr = [txtPlayer1.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" - "]];
                [playerArr addObject:@{@"type" : typeArr[0],
                                       @"price" : total1.text}];
            } else if (j == 1) {
                typeArr = [txtPlayer2.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" - "]];
                [playerArr addObject:@{@"type" : typeArr[0],
                                       @"price" : total2.text}];
            } else if (j == 2) {
                typeArr = [txtPlayer3.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" - "]];
                [playerArr addObject:@{@"type" : typeArr[0],
                                       @"price" : total3.text}];
            } else if (j == 3) {
                typeArr = [txtPlayer4.text componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" - "]];
                [playerArr addObject:@{@"type" : typeArr[0],
                                       @"price" : total4.text}];
            }
        }
    }
    
    @try {
        [newUpdate addEntriesFromDictionary: @{
                                               @"id" : [NSString stringWithFormat:@"%ld", (long)(int)collSelectedIndexPath.row + 1],
                                               @"player" : lblPlayerNumber.text,
                                               @"playerarr" : playerArr,
                                               @"ttime": lblFlightTeeTime.text,
                                               @"price": [[GGCommonFunc sharedInstance] getCurrencyFromString:lblFlightPrice.text],
                                               @"cart": isCart
                                               }];
    } @catch (NSException *exception) {
        NSLog(@"ERROR EXCEP : %@", exception.description);
    } @finally {
        NSLog(@"FINAL");
    }
    
    
    if ([eachFlightDataArr count] > 0) {
        for (int c = 0; c < [eachFlightDataArr count]; c++) {
            if ([[newUpdate objectForKey:@"id"] isEqualToString:[[eachFlightDataArr objectAtIndex:c] objectForKey:@"id"]]) {
                [eachFlightDataArr replaceObjectAtIndex:c withObject:newUpdate];
                break;
            } else if (![[newUpdate objectForKey:@"id"] isEqualToString:[[eachFlightDataArr objectAtIndex:c] objectForKey:@"id"]] && c == [eachFlightDataArr count] - 1 ) {
                
                [eachFlightDataArr addObject:newUpdate];
                break;
            }
        }
    } else {
        
        [eachFlightDataArr addObject:newUpdate];
    }
    
//    int calculateTotalPrice = 0;
//    for (int a = 0; a < [self.txtFlightNumber.text intValue]; a++) {
//        
//        UICollectionViewCell *cell = [self.flightCollection cellForItemAtIndexPath:[NSIndexPath indexPathForItem:a inSection:0]];
//        UILabel *lblPrice = (UILabel *) [cell viewWithTag:3];
//        UILabel *lblPriceRate = (UILabel *) [cell viewWithTag:8];
//        
//        self.lblTotalDepositRate.text = [NSString stringWithFormat:@"%d", [self.lblTotalDepositRate.text intValue] + [lblPriceRate.text intValue]];
//        //        if ([eachFlightDataArr count] >= [self.txtFlightNumber.text intValue]) {
//        //            calculateTotalPrice = calculateTotalPrice + [[[eachFlightDataArr objectAtIndex:a] objectForKey:@"price"] intValue];
//        //        } else {
//        calculateTotalPrice = calculateTotalPrice + [[[GGCommonFunc sharedInstance] getCurrencyFromString:lblPrice.text] intValue];
//        //        }
//    }
    
    NSLog(@"EACH FLIGHT DATA : %@", eachFlightDataArr);
}

#pragma mark - UITABLEVIEW DELEGATE & DATASOURCE

- (IBAction) showTimeArr:(id)sender {
    [self.tblTimeBook reloadData];
    self.backGroundTransparant.hidden = NO;
    self.timeVIew.hidden = NO;
    
    CGPoint rootPoint = [sender convertPoint:CGPointZero toView:self.flightCollection];
    collSelectedIndexPath = [self.flightCollection indexPathForItemAtPoint:rootPoint];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.timeArr objectForKey:@"timearr"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *reuseIdentifier = @"timeCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    UILabel *lblTime = (UILabel *)[cell viewWithTag:1];
    lblTime.text = [NSString stringWithFormat:@"%@", [[[self.timeArr objectForKey:@"timearr"] objectAtIndex:indexPath.row] objectForKey:@"ttime"]];
    
    UIButton *btnPromo = (UIButton *) [cell viewWithTag:2];
    btnPromo.userInteractionEnabled = NO;
    if ([[[[self.timeArr objectForKey:@"timearr"] objectAtIndex:indexPath.row] objectForKey:@"promo"] intValue] != 0) {
        btnPromo.hidden = NO;
    } else {
        btnPromo.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    self.timeVIew.hidden = YES;
    self.backGroundTransparant.hidden = YES;
    
    typePromo = [[[[self.timeArr objectForKey:@"timearr"] objectAtIndex:indexPath.row] objectForKey:@"promo"] intValue];
    typeCondition = [[[[self.timeArr objectForKey:@"timearr"] objectAtIndex:indexPath.row] objectForKey:@"condition"] intValue];
    
    listTypePlayer = [[self.timeArr objectForKey:@"conditionarr"] objectAtIndex:typeCondition];
    
    [condArr setValue:listTypePlayer forKey:[NSString stringWithFormat:@"%ld",(long)collSelectedIndexPath.row]];
    
    [self fillFlightInfo:collSelectedIndexPath selectedIndexPath:indexPath];
    
    NSString *selectedTime = [[[self.timeArr objectForKey:@"timearr"] objectAtIndex:indexPath.row] objectForKey:@"ttime"];
    [listTeeTimeArr setValue: [[[self.timeArr objectForKey:@"timearr"] objectAtIndex:indexPath.row] objectForKey:@"ttime"] forKey:[NSString stringWithFormat:@"%ld", (long)(int)collSelectedIndexPath.row]];
    
    for (int a = 0; a < [self.txtFlightNumber.text intValue]; a++) {
        if (a != collSelectedIndexPath.row) {
            if ([selectedTime isEqualToString:[listTeeTimeArr objectForKey:[NSString stringWithFormat:@"%d", a]]]) {
                [self showCommonAlert:@"Notification" message:@"You have already chosen same tee time in different flight. Please choose other tee time." isTeeTime:YES];
            }
        }
    }
    
    
}
    
- (void) showCommonAlert:(NSString *) title message:(NSString *)msg isTeeTime:(bool)isTeeTime{
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
                                   if (isTeeTime) {
                                       self.backGroundTransparant.hidden = NO;
                                       self.timeVIew.hidden = NO;
                                   }
                               }];
    
    [alert addAction:okButton];
    
    [self presentViewController:alert  animated:YES completion:nil];
}

- (void) updateAllPrice {
    UICollectionViewCell *cell = [self.flightCollection cellForItemAtIndexPath:collSelectedIndexPath];
    
    UILabel *lblTotalCostFlight = (UILabel *)[cell viewWithTag:3];
    UILabel *lblTotalDepositRateFlight = (UILabel *)[cell viewWithTag:8];
    lblTotalDepositRateFlight.hidden = YES;
    lblTotalDepositRateFlight.text = @"0";
    
    
    if ([lblTotalCostFlight.text intValue] > 0) {
        
        lblTotalDepositRateFlight.text = [NSString stringWithFormat:@"%f", [[[GGCommonFunc sharedInstance] getCurrencyFromString:lblTotalCostFlight.text] intValue] * ([[listTypePlayer objectForKey:@"deposit_rate"] floatValue]/100)];
        
        [flightPriceArr setObject:[[GGCommonFunc sharedInstance] getCurrencyFromString:lblTotalCostFlight.text] forKey:[NSString stringWithFormat:@"%ld", (long)(int)collSelectedIndexPath.row]];
        [self saveFlightData];
        [depRateArr setObject: [NSString stringWithFormat:@"%d", [lblTotalDepositRateFlight.text intValue]] forKey:[NSString stringWithFormat:@"%ld", (long)(int)collSelectedIndexPath.row]];
    }
    
    int calculateTotalPrice = 0;
    
//    if ([self.txtFlightNumber.text intValue] < 3) {
        for (int a = 0; a < [self.txtFlightNumber.text intValue]; a++) {
            
            UICollectionViewCell *cell = [self.flightCollection cellForItemAtIndexPath:[NSIndexPath indexPathForItem:a inSection:0]];
            UILabel *lblPrice = (UILabel *) [cell viewWithTag:3];
            UILabel *lblPriceRate = (UILabel *) [cell viewWithTag:8];
            
            self.lblTotalDepositRate.text = [NSString stringWithFormat:@"%d", [self.lblTotalDepositRate.text intValue] + [lblPriceRate.text intValue]];
            
//            calculateTotalPrice = calculateTotalPrice + [[[GGCommonFunc sharedInstance] getCurrencyFromString:lblPrice.text] intValue];
            calculateTotalPrice = calculateTotalPrice + [[flightPriceArr objectForKey:[NSString stringWithFormat:@"%d", a]] intValue];

        }
    
    self.lblTotalPrice.text = [[GGCommonFunc sharedInstance] setSeparatedCurrency:calculateTotalPrice];
    
    NSLog(@"HARGA TOTAL : %@ - FLIGHT : %@", self.lblTotalPrice.text, flightPriceArr);
    
}

#pragma mark - UICOLLECTION DELEGATE & DATASOURCE

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.txtFlightNumber.text intValue] ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"flightCell" forIndexPath:indexPath];
    
    UILabel *lblFlightNumber = (UILabel *)[cell viewWithTag:1];
    lblFlightNumber.text = [NSString stringWithFormat:@"Flight %ld", (long)(int)indexPath.row + 1];
    
    if (cell == nil) {
        
        UITextField *txtTeeTime = (UITextField *) [cell viewWithTag:2];
        txtTeeTime.text = @"";
        txtTeeTime.placeholder = @"Choose Time";
        
        UILabel *lblPrice = (UILabel *) [cell viewWithTag:3];
        lblPrice.text = @"0";
        UILabel *lblPriceRate = (UILabel *) [cell viewWithTag:8];
        lblPriceRate.text = @"0";
        lblPriceRate.hidden = YES;
        
        UIButton *btnYes = (UIButton *)[cell viewWithTag:5];
        UIButton *btnNO = (UIButton *)[cell viewWithTag:6];
        
        [btnYes setSelected:YES];
        [btnNO setSelected:NO];
    }
    
    UIButton *btnYes = (UIButton *)[cell viewWithTag:5];
    UIButton *btnNO = (UIButton *)[cell viewWithTag:6];
    
    [btnYes setSelected:YES];
    [btnNO setSelected:NO];
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    int left = (screenRect.size.width - 320)/2;
    
    return UIEdgeInsetsMake(5, left + 15, 5, left + 15);
}

#pragma mark - DATEPICKER

- (IBAction) showPlayerType:(id)sender {
    
    [self.pickerView setHidden:NO];
    
    CGPoint rootPoint = [sender convertPoint:CGPointZero toView:self.flightCollection];
    collSelectedIndexPath = [self.flightCollection indexPathForItemAtPoint:rootPoint];
    
    UICollectionViewCell *cell = [self.flightCollection cellForItemAtIndexPath:collSelectedIndexPath];
    UIButton *btnYes = (UIButton *)[cell viewWithTag:5];
    UILabel *lblnoCart = (UILabel *)[cell viewWithTag:7];
    
    if ([btnYes isSelected] || ![lblnoCart isHidden])
        isPriceCart = YES;
    else
        isPriceCart = NO;
    
    UITextField *txtPlayerNumber = (UITextField *)[cell viewWithTag:4];
    if ([txtPlayerNumber.text length] <= 0) {
        [self showCommonAlert:@"Booking Notification" message:@"Choose number of player first!" isTeeTime:NO];
    } else {
        
        if ([[[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:0] objectForKey:@"price"] intValue] == 0 && !isPriceCart) {
            for (int x = 0 ; x < [[listTypePlayer objectForKey:@"price_list"] count]; x++) {
                if ([[[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:x] objectForKey:@"price"] intValue] != 0) {
                    
                    [typePlayerArr addObject:[NSString stringWithFormat:@"%@ - %@", [[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:x] objectForKey:@"type"], [[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:x] objectForKey:@"price"]]];
                }
            }
        }
        [self showList:sender];
    }
}

- (IBAction) showPlayerNumber:(id)sender {
    [self.pickerView setHidden:NO];
    
    CGPoint rootPoint = [sender convertPoint:CGPointZero toView:self.flightCollection];
    collSelectedIndexPath = [self.flightCollection indexPathForItemAtPoint:rootPoint];
    
    UICollectionViewCell *cell = [self.flightCollection cellForItemAtIndexPath:collSelectedIndexPath];
    UITextField *txtFlightTime = (UITextField *)[cell viewWithTag:2];
    if ([txtFlightTime.text length] <= 0) {
        [self showCommonAlert:@"Booking Notification" message:@"Choose Tee Time first!" isTeeTime:NO];
    } else {
        [self showList:sender];
    }
}

- (IBAction)showFlightNumber:(id)sender {
    [self.pickerView setHidden:NO];
    
    [self showList:sender];
}

- (IBAction)showDatePicker:(id)sender {
    
    [self.pickerView setHidden:YES];
    [self showList:sender];
}

- (IBAction)hideList:(id)sender {
    
    if ([sender tag] == 2) {
        
        if (typePicker == 1) { // DATE PICKER
            
            NSArray *dateStringArr = [[NSString stringWithFormat:@"%@", self.datePicker.date] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" "]];

            self.txtDate.text = [[GGCommonFunc sharedInstance] changeDateFormat:dateStringArr[0]];
            
            [self loadDetailView:[self.detailArr objectForKey:@"gid"] courseDate:dateStringArr[0]];
            
            [self resetAllFlightValue];
            
            self.txtFlightNumber.text = [NSString stringWithFormat:@"%ld", (long)(int)[self.pickerView selectedRowInComponent:0] + 1];

            afterSelectTTime = false;

            [self.flightCollection reloadData];
        } else if (typePicker == 55) { // FLIGHT NUMBER
            
            self.txtFlightNumber.text = [NSString stringWithFormat:@"%ld", (long)(int)[self.pickerView selectedRowInComponent:0] + 1];
//            
//            if ([eachFlightDataArr count] < [self.txtFlightNumber.text intValue]) {
//                for (int i = (int)[eachFlightDataArr count]; i < [self.txtFlightNumber.text intValue]; i++) {
//                    [eachFlightDataArr addObject:@{
//                                                   @"id" : [NSString stringWithFormat:@"%ld", collSelectedIndexPath.row + 1],
//                                                   @"player" : @"",
//                                                   @"playerarr" : @"",
//                                                   @"ttime": @"",
//                                                   @"price": @"0",
//                                                   @"cart": @"1"
//                                                   }];
//                }
//            }
            
            [self updateAllPrice];
            afterSelectTTime = false;
            [self.flightCollection reloadData];
            
        } else if (typePicker == 66) { // PLAYER NUMBER
            
            afterSelectTTime = false;
            
            UICollectionViewCell *cell = [self.flightCollection cellForItemAtIndexPath:collSelectedIndexPath];
            
            UITextField *txtPlayerNumber = (UITextField *)[cell viewWithTag:4];
            txtPlayerNumber.text = [NSString stringWithFormat:@"%ld",[[[condArr objectForKey:[NSString stringWithFormat:@"%ld", (long)collSelectedIndexPath.row]] objectForKey:@"min_number"] intValue] + [self.pickerView selectedRowInComponent:0]];
            
            UILabel *lblTotalCostFlight = (UILabel *)[cell viewWithTag:3];
            lblTotalCostFlight.text = @"0";
            UILabel *lblTotalDepositRateFlight = (UILabel *)[cell viewWithTag:8];
            lblTotalDepositRateFlight.text = @"0";
            lblTotalDepositRateFlight.hidden = YES;
            
            UIView *view1 = (UIView *)[cell viewWithTag:11];
            UIView *view2 = (UIView *)[cell viewWithTag:12];
            UIView *view3 = (UIView *)[cell viewWithTag:13];
            UIView *view4 = (UIView *)[cell viewWithTag:14];
            
            UITextField *txtPlayer1 = (UITextField *)[cell viewWithTag:81];
            UITextField *txtPlayer2 = (UITextField *)[cell viewWithTag:82];
            UITextField *txtPlayer3 = (UITextField *)[cell viewWithTag:83];
            UITextField *txtPlayer4 = (UITextField *)[cell viewWithTag:84];
            UITextField *total1 = (UITextField *)[cell viewWithTag:71];
            UITextField *total2 = (UITextField *)[cell viewWithTag:72];
            UITextField *total3 = (UITextField *)[cell viewWithTag:73];
            UITextField *total4 = (UITextField *)[cell viewWithTag:74];
            
            txtPlayer1.text = nil;
            txtPlayer2.text = nil;
            txtPlayer3.text = nil;
            txtPlayer4.text = nil;
            total1.text = nil;
            total2.text = nil;
            total3.text = nil;
            total4.text = nil;
            
            UILabel *lblnoCart = (UILabel *)[cell viewWithTag:7];
            
            NSString *priceCart = [[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:0] objectForKey:@"price_cart"];
            NSString *type = [[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:0] objectForKey:@"type"];

            
            if ([txtPlayerNumber.text intValue] == 1) {
                view1.hidden = NO;
                view2.hidden = YES;
                view3.hidden = YES;
                view4.hidden = YES;
                
                if ([txtPlayer1.text length] < 2) {
                    total1.text = priceCart;
                    
                    txtPlayer1.text = [NSString stringWithFormat:@"%@ - Rp. %@", type, [[GGCommonFunc sharedInstance] setSeparatedCurrency:[priceCart floatValue]]];
                }
                
                if ([[[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:0] objectForKey:@"cart_mandatory"] intValue] == 1) {
                    lblnoCart.hidden = NO;
                    isCart1 = YES;
                } else {
                    lblnoCart.hidden = YES;
                    isCart1 = NO;
                }
                
            } else if ([txtPlayerNumber.text intValue] == 2) {
                view1.hidden = NO;
                view2.hidden = NO;
                view3.hidden = YES;
                view4.hidden = YES;
                
                if ([txtPlayer1.text length] < 2) {
                    total1.text = priceCart;
                    txtPlayer1.text = [NSString stringWithFormat:@"%@ - Rp. %@", type, [[GGCommonFunc sharedInstance] setSeparatedCurrency:[priceCart floatValue]]];
                    
                    total2.text = priceCart;
                    txtPlayer2.text = [NSString stringWithFormat:@"%@ - Rp. %@", type, [[GGCommonFunc sharedInstance] setSeparatedCurrency:[priceCart floatValue]]];
                }
                
                if ([[[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:0] objectForKey:@"cart_mandatory"] intValue] == 1) {
                    lblnoCart.hidden = NO;
                    isCart1 = YES;
                    isCart2 = YES;
                } else {
                    lblnoCart.hidden = YES;
                    isCart1 = NO;
                    isCart2 = NO;
                }
                
            } else if ([txtPlayerNumber.text intValue] == 3) {
                view1.hidden = NO;
                view2.hidden = NO;
                view3.hidden = NO;
                view4.hidden = YES;
                
                if ([txtPlayer1.text length] < 2) {
                    total1.text = priceCart;
                    txtPlayer1.text = [NSString stringWithFormat:@"%@ - Rp. %@", type, [[GGCommonFunc sharedInstance] setSeparatedCurrency:[priceCart floatValue]]];
                    
                    total2.text = priceCart;
                    txtPlayer2.text = [NSString stringWithFormat:@"%@ - Rp. %@", type, [[GGCommonFunc sharedInstance] setSeparatedCurrency:[priceCart floatValue]]];
                    
                    total3.text = priceCart;
                    txtPlayer3.text = [NSString stringWithFormat:@"%@ - Rp. %@", type, [[GGCommonFunc sharedInstance] setSeparatedCurrency:[priceCart floatValue]]];
                }
                
                if ([[[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:0] objectForKey:@"cart_mandatory"] intValue] == 1) {
                    lblnoCart.hidden = NO;
                    isCart1 = YES;
                    isCart2 = YES;
                    isCart3 = YES;
                } else {
                    lblnoCart.hidden = YES;
                    isCart1 = NO;
                    isCart2 = NO;
                    isCart3 = NO;
                }
                
            } else if ([txtPlayerNumber.text intValue] == 4) {
                view1.hidden = NO;
                view2.hidden = NO;
                view3.hidden = NO;
                view4.hidden = NO;
                
                if ([txtPlayer1.text length] < 2) {
                    total1.text = priceCart;
                    txtPlayer1.text = [NSString stringWithFormat:@"%@ - Rp. %@", type, [[GGCommonFunc sharedInstance] setSeparatedCurrency:[priceCart floatValue]]];
                    
                    total2.text = priceCart;
                    txtPlayer2.text = [NSString stringWithFormat:@"%@ - Rp. %@", type, [[GGCommonFunc sharedInstance] setSeparatedCurrency:[priceCart floatValue]]];
                    
                    total3.text = priceCart;
                    txtPlayer3.text = [NSString stringWithFormat:@"%@ - Rp. %@", type, [[GGCommonFunc sharedInstance] setSeparatedCurrency:[priceCart floatValue]]];
                    
                    total4.text = priceCart;
                    txtPlayer4.text = [NSString stringWithFormat:@"%@ - Rp. %@", type, [[GGCommonFunc sharedInstance] setSeparatedCurrency:[priceCart floatValue]]];
                }
                
                if ([[[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:0] objectForKey:@"cart_mandatory"] intValue] == 1) {
                    lblnoCart.hidden = NO;
                    isCart1 = YES;
                    isCart2 = YES;
                    isCart3 = YES;
                    isCart4 = YES;
                } else {
                    lblnoCart.hidden = YES;
                    isCart1 = NO;
                    isCart2 = NO;
                    isCart3 = NO;
                    isCart4 = NO;
                }
            }
            
            
            if ([txtPlayerNumber.text isEqualToString:@"1"]) {
                lblTotalCostFlight.text = total1.text;
                
            } else if ([txtPlayerNumber.text isEqualToString:@"2"]) {
                lblTotalCostFlight.text = [NSString stringWithFormat:@"%d", [total1.text intValue] + [total2.text intValue]];
                
            } else if ([txtPlayerNumber.text isEqualToString:@"3"]) {
                lblTotalCostFlight.text = [NSString stringWithFormat:@"%d", [total1.text intValue] + [total2.text intValue] + [total3.text intValue]];
                
            } else if ([txtPlayerNumber.text isEqualToString:@"4"]) {
                lblTotalCostFlight.text = [NSString stringWithFormat:@"%d", [total1.text intValue] + [total2.text intValue] + [total3.text intValue] + [total4.text intValue]];
            }
            
            lblTotalDepositRateFlight.text = [NSString stringWithFormat:@"%f", [lblTotalCostFlight.text intValue] * ([[listTypePlayer objectForKey:@"deposit_rate"] floatValue]/100)];
            
            [flightPriceArr setObject:lblTotalCostFlight.text forKey:[NSString stringWithFormat:@"%ld", collSelectedIndexPath.row]];
            [self saveFlightData];
            [depRateArr setObject: [NSString stringWithFormat:@"%d", [lblTotalDepositRateFlight.text intValue]] forKey:[NSString stringWithFormat:@"%ld", collSelectedIndexPath.row]];
            
            lblTotalCostFlight.text = [[GGCommonFunc sharedInstance] setSeparatedCurrency:[lblTotalCostFlight.text floatValue]];
            
            //if (collSelectedIndexPath.row == [_txtFlightNumber.text intValue] - 1) {
                
                for (int a = 0; a < [self.txtFlightNumber.text intValue]; a++) {
                    countPrice = countPrice + [[flightPriceArr objectForKey:[NSString stringWithFormat:@"%d", a]] intValue];
                    countRate = countRate + [[depRateArr objectForKey:[NSString stringWithFormat:@"%d", a]] intValue];
                }
                self.lblTotalDepositRate.text = [NSString stringWithFormat:@"%d", countRate];
                self.lblTotalPrice.text = [NSString stringWithFormat:@"%@",[[GGCommonFunc sharedInstance] setSeparatedCurrency:countPrice]];
                countPrice = 0;
                countRate = 0;
            //}
            
        } else if (typePicker > 90 && typePicker < 95) { // PLAYER TYPE
            
            UICollectionViewCell *cell = [self.flightCollection cellForItemAtIndexPath:collSelectedIndexPath];
            
            UITextField *txtPlayerNumber = (UITextField *)[cell viewWithTag:4];
            
            UITextField *txtPlayer1 = (UITextField *)[cell viewWithTag:81];
            UITextField *txtPlayer2 = (UITextField *)[cell viewWithTag:82];
            UITextField *txtPlayer3 = (UITextField *)[cell viewWithTag:83];
            UITextField *txtPlayer4 = (UITextField *)[cell viewWithTag:84];
            UITextField *total1 = (UITextField *)[cell viewWithTag:71];
            UITextField *total2 = (UITextField *)[cell viewWithTag:72];
            UITextField *total3 = (UITextField *)[cell viewWithTag:73];
            UITextField *total4 = (UITextField *)[cell viewWithTag:74];
            
            UIButton *btnYes = (UIButton *)[cell viewWithTag:5];
            UILabel *lblnoCart = (UILabel *)[cell viewWithTag:7];
            
            NSString *price = nil;
            NSString *priceCart = [[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:[self.pickerView selectedRowInComponent:0]] objectForKey:@"price_cart"];
            NSString *typePlayer = nil;
            
            
            if (!isPriceCart && [[[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:0] objectForKey:@"price"] intValue] == 0) {
                
                NSArray *full = [[typePlayerArr objectAtIndex:[self.pickerView selectedRowInComponent:0]] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@" - "]];
                
                price = full[3];
                typePlayer = full[0];
                
                NSLog(@"PRICE : %@ - TYPE : %@ - FULL : %@", price, typePlayer, full);
                
            } else {
                
                price = [[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:[self.pickerView selectedRowInComponent:0]] objectForKey:@"price"];
                typePlayer = [[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:[self.pickerView selectedRowInComponent:0]] objectForKey:@"type"];
            }
            
            if (typePicker == 91) {
                
                if ([btnYes isSelected] || ![lblnoCart isHidden]) {
                    total1.text = priceCart;
                    txtPlayer1.text = [NSString stringWithFormat:@"%@ - Rp. %@", typePlayer, [[GGCommonFunc sharedInstance] setSeparatedCurrency:[priceCart floatValue]]];
                    
                } else {
                    total1.text = price;
                    txtPlayer1.text = [NSString stringWithFormat:@"%@ - Rp. %@", typePlayer, [[GGCommonFunc sharedInstance] setSeparatedCurrency:[price floatValue]]];
                }
                
                if (isPriceCart) {
                    if ([[[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:[self.pickerView selectedRowInComponent:0]] objectForKey:@"cart_mandatory"] intValue] == 0 && !isCart2 && !isCart3 && !isCart4){
                        lblnoCart.hidden = YES;
                        isCart1 = NO;
                    } else if ([[[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:[self.pickerView selectedRowInComponent:0]] objectForKey:@"cart_mandatory"] intValue] == 1) {
                        lblnoCart.hidden = NO;
                        isCart1 = YES;
                    } else {
                        lblnoCart.hidden = NO;
                        isCart1 = NO;
                    }
                }
                
            } else if (typePicker == 92) {
                
                if ([btnYes isSelected] || ![lblnoCart isHidden]) {
                    total2.text = priceCart;
                    
                    txtPlayer2.text = [NSString stringWithFormat:@"%@ - Rp. %@", typePlayer, [[GGCommonFunc sharedInstance] setSeparatedCurrency:[priceCart floatValue]]];
                } else {
                    total2.text = price;
                    
                    txtPlayer2.text = [NSString stringWithFormat:@"%@ - Rp. %@", typePlayer, [[GGCommonFunc sharedInstance] setSeparatedCurrency:[price floatValue]]];
                }
                
                if (isPriceCart) {
                    
                    if ([[[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:[self.pickerView selectedRowInComponent:0]] objectForKey:@"cart_mandatory"] intValue] == 0 && !isCart1 && !isCart3 && !isCart4){
                        lblnoCart.hidden = YES;
                        isCart2 = NO;
                    } else if ([[[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:[self.pickerView selectedRowInComponent:0]] objectForKey:@"cart_mandatory"] intValue] == 1) {
                        lblnoCart.hidden = NO;
                        isCart2 = YES;
                    } else {
                        lblnoCart.hidden = NO;
                        isCart2 = NO;
                    }
                }
                
            } else if (typePicker == 93) {
                if ([btnYes isSelected] || ![lblnoCart isHidden]) {
                    total3.text = priceCart;
                    
                    txtPlayer3.text = [NSString stringWithFormat:@"%@ - Rp. %@", typePlayer, [[GGCommonFunc sharedInstance] setSeparatedCurrency:[priceCart floatValue]]];
                } else {
                    total3.text = price;
                    
                    txtPlayer3.text = [NSString stringWithFormat:@"%@ - Rp. %@", typePlayer, [[GGCommonFunc sharedInstance] setSeparatedCurrency:[price floatValue]]];
                }
                
                if (isPriceCart) {
                    
                    if ([[[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:[self.pickerView selectedRowInComponent:0]] objectForKey:@"cart_mandatory"] intValue] == 0 && !isCart1 && !isCart2 && !isCart4){
                        lblnoCart.hidden = YES;
                        isCart3 = NO;
                    } else if ([[[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:[self.pickerView selectedRowInComponent:0]] objectForKey:@"cart_mandatory"] intValue] == 1) {
                        lblnoCart.hidden = NO;
                        isCart3 = YES;
                    } else {
                        lblnoCart.hidden = NO;
                        isCart3 = NO;
                    }
                }
                
            } else if (typePicker == 94) {
                if ([btnYes isSelected] || ![lblnoCart isHidden]) {
                    total4.text = priceCart;
                    
                    txtPlayer4.text = [NSString stringWithFormat:@"%@ - Rp. %@", typePlayer, [[GGCommonFunc sharedInstance] setSeparatedCurrency:[priceCart floatValue]]];
                } else {
                    total4.text = price;
                    
                    txtPlayer4.text = [NSString stringWithFormat:@"%@ - Rp. %@", typePlayer, [[GGCommonFunc sharedInstance] setSeparatedCurrency:[price floatValue]]];
                }
                
                if (isPriceCart) {
                    
                    if ([[[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:[self.pickerView selectedRowInComponent:0]] objectForKey:@"cart_mandatory"] intValue] == 0 && !isCart1 && !isCart2 && !isCart3){
                        lblnoCart.hidden = YES;
                        isCart4 = NO;
                    } else if ([[[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:[self.pickerView selectedRowInComponent:0]] objectForKey:@"cart_mandatory"] intValue] == 1) {
                        lblnoCart.hidden = NO;
                        isCart4 = YES;
                    } else {
                        lblnoCart.hidden = NO;
                        isCart4 = NO;
                    }
                }
            }
            
            UILabel *lblTotalCostFlight = (UILabel *)[cell viewWithTag:3];
            UILabel *lblTotalDepositRateFlight = (UILabel *)[cell viewWithTag:8];
            lblTotalDepositRateFlight.hidden = YES;
            
            if ([txtPlayerNumber.text isEqualToString:@"1"]) {
                lblTotalCostFlight.text = total1.text;
                
            } else if ([txtPlayerNumber.text isEqualToString:@"2"]) {
                lblTotalCostFlight.text = [NSString stringWithFormat:@"%d", [total1.text intValue] + [total2.text intValue]];

            } else if ([txtPlayerNumber.text isEqualToString:@"3"]) {
                lblTotalCostFlight.text = [NSString stringWithFormat:@"%d", [total1.text intValue] + [total2.text intValue] + [total3.text intValue]];

            } else if ([txtPlayerNumber.text isEqualToString:@"4"]) {
                lblTotalCostFlight.text = [NSString stringWithFormat:@"%d", [total1.text intValue] + [total2.text intValue] + [total3.text intValue] + [total4.text intValue]];
            }
            
            
            lblTotalDepositRateFlight.text = [NSString stringWithFormat:@"%f", [lblTotalCostFlight.text intValue] * ([[listTypePlayer objectForKey:@"deposit_rate"] floatValue]/100)];
            
            [flightPriceArr setObject:lblTotalCostFlight.text forKey:[NSString stringWithFormat:@"%ld", collSelectedIndexPath.row]];
            [self saveFlightData];
            [depRateArr setObject: [NSString stringWithFormat:@"%d", [lblTotalDepositRateFlight.text intValue]] forKey:[NSString stringWithFormat:@"%ld", collSelectedIndexPath.row]];
            
            
            lblTotalCostFlight.text = [[GGCommonFunc sharedInstance] setSeparatedCurrency:[lblTotalCostFlight.text floatValue]];
            //if (collSelectedIndexPath.row == [_txtFlightNumber.text intValue] - 1) {
                
                for (int a = 0; a < [self.txtFlightNumber.text intValue]; a++) {
                    countPrice = countPrice + [[flightPriceArr objectForKey:[NSString stringWithFormat:@"%d", a]] intValue];
                    countRate = countRate + [[depRateArr objectForKey:[NSString stringWithFormat:@"%d", a]] intValue];
                }
                self.lblTotalDepositRate.text = [NSString stringWithFormat:@"%d", countRate];
                self.lblTotalPrice.text = [NSString stringWithFormat:@"%@", [[GGCommonFunc sharedInstance] setSeparatedCurrency:countPrice]];
                countPrice = 0;
                countRate = 0;
            //}
            
            [typePlayerArr removeAllObjects];
        }
    }
    
    [self hideBackGround];
}

- (IBAction)showList:(id)sender {
    
//    [self dismissKeyboard];
    typePicker = [sender tag];
    [self.pickerView reloadAllComponents];
    [self.pickerView selectRow:0 inComponent:0 animated:NO];
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         
                         self.backGroundTransparant.hidden = NO;
                         [NSTimer scheduledTimerWithTimeInterval:0.3
                                                          target:self
                                                        selector:@selector(showDropDown)
                                                        userInfo:nil
                                                         repeats:NO];
                     }];
}

- (void) showDropDown {
    [[GGCommonFunc sharedInstance] showMenuView:self.viewPicker];
}

- (void) hideBackGround {
    self.backGroundTransparant.hidden = YES;
    self.timeVIew.hidden = YES;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.viewPicker.frame = CGRectMake(0, screenRect.size.height + self.viewPicker.frame.size.height, self.viewPicker.frame.size.width, self.viewPicker.frame.size.height);
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (typePicker > 90 && typePicker < 95) {
        
        if (isPriceCart) {
            return [[[condArr objectForKey:[NSString stringWithFormat:@"%ld", (long)collSelectedIndexPath.row]] objectForKey:@"price_list"] count];
        } else if ([[[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:0] objectForKey:@"price"] intValue] == 0 && !isPriceCart) {
                return [typePlayerArr count];
        } else {
            int countType = 0;
            for (int i = 0; i < [[[condArr objectForKey:[NSString stringWithFormat:@"%ld", (long)collSelectedIndexPath.row]] objectForKey:@"price_list"] count]; i++) {
                
                if ([[[[[condArr objectForKey:[NSString stringWithFormat:@"%ld", (long)collSelectedIndexPath.row]] objectForKey:@"price_list"] objectAtIndex:i] objectForKey:@"price"] intValue] != 0)
                    countType = countType + 1;
                
            }
            return countType;
        }
    } else if (typePicker == 66) {
        return [[[condArr objectForKey:[NSString stringWithFormat:@"%ld", (long)collSelectedIndexPath.row]] objectForKey:@"max_number"] intValue] - [[[condArr objectForKey:[NSString stringWithFormat:@"%ld", (long)collSelectedIndexPath.row]] objectForKey:@"min_number"] intValue] + 1;
    }
    
    return [[self.timeArr objectForKey:@"timearr"] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (typePicker > 90 && typePicker < 95) {
        NSString *type = [[[[condArr objectForKey:[NSString stringWithFormat:@"%ld", (long)collSelectedIndexPath.row]] objectForKey:@"price_list"] objectAtIndex:row] objectForKey:@"type"];
        
        if (isPriceCart) {
            
            return [NSString stringWithFormat:@"%@ - Rp. %@", type, [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[[[[condArr objectForKey:[NSString stringWithFormat:@"%ld", (long)collSelectedIndexPath.row]] objectForKey:@"price_list"] objectAtIndex:row] objectForKey:@"price_cart"] floatValue]]];
        } else if ([[[[listTypePlayer objectForKey:@"price_list"] objectAtIndex:0] objectForKey:@"price"] intValue] == 0 && !isPriceCart) {
            
            return [typePlayerArr objectAtIndex:row];
        } else {
            return [NSString stringWithFormat:@"%@ - Rp. %@", type, [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[[[[condArr objectForKey:[NSString stringWithFormat:@"%ld", (long)collSelectedIndexPath.row]] objectForKey:@"price_list"] objectAtIndex:row] objectForKey:@"price"] floatValue]]];
        }
    } else if (typePicker == 66) {
        return [NSString stringWithFormat:@"%ld",[[[condArr objectForKey:[NSString stringWithFormat:@"%ld", (long)collSelectedIndexPath.row]] objectForKey:@"min_number"] intValue] + row];
    }
    
    return [NSString stringWithFormat:@"%ld", (long)row + 1];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

#pragma mark - UITEXTFIELD DELEGATE

- (void) resetAllFlightValue {
    
    for (int i = 0; i < [self.txtFlightNumber.text intValue]; i++) {
        
        UICollectionViewCell *cell = [self.flightCollection cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        
        UITextField *txtTeeTime = (UITextField *) [cell viewWithTag:2];
        txtTeeTime.text = @"";
        txtTeeTime.placeholder = @"Choose Time";
        
        UILabel *lblPrice = (UILabel *) [cell viewWithTag:3];
        lblPrice.text = @"0";
        UILabel *lblPriceRate = (UILabel *) [cell viewWithTag:8];
        lblPriceRate.text = @"0";
        lblPriceRate.hidden = YES;
        
        UITextField *txtPlayerNumber = (UITextField *)[cell viewWithTag:4];
        txtPlayerNumber.text = @"";
        
        UIButton *btnYes = (UIButton *)[cell viewWithTag:5];
        UIButton *btnNO = (UIButton *)[cell viewWithTag:6];
        
        [btnYes setSelected:YES];
        [btnNO setSelected:NO];
        
        UITextField *txtPlayer1 = (UITextField *)[cell viewWithTag:81];
        UITextField *txtPlayer2 = (UITextField *)[cell viewWithTag:82];
        UITextField *txtPlayer3 = (UITextField *)[cell viewWithTag:83];
        UITextField *txtPlayer4 = (UITextField *)[cell viewWithTag:84];
        UITextField *total1 = (UITextField *)[cell viewWithTag:71];
        UITextField *total2 = (UITextField *)[cell viewWithTag:72];
        UITextField *total3 = (UITextField *)[cell viewWithTag:73];
        UITextField *total4 = (UITextField *)[cell viewWithTag:74];
        
        txtPlayer1.text = nil;
        txtPlayer2.text = nil;
        txtPlayer3.text = nil;
        txtPlayer4.text = nil;
        total1.text = nil;
        total2.text = nil;
        total3.text = nil;
        total4.text = nil;
        
        UIView *view1 = (UIView *)[cell viewWithTag:11];
        UIView *view2 = (UIView *)[cell viewWithTag:12];
        UIView *view3 = (UIView *)[cell viewWithTag:13];
        UIView *view4 = (UIView *)[cell viewWithTag:14];
        
        view1.hidden = NO;
        view2.hidden = NO;
        view3.hidden = NO;
        view4.hidden = NO;
    }
    
    self.lblTotalPrice.text = @"0";
    self.lblTotalDepositRate.text = @"0";
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    
    return YES;
}

@end
