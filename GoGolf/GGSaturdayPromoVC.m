//
//  GGSaturdayPromoVC.m
//  GoGolf
//
//  Created by Eddyson Tan on 9/29/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGSaturdayPromoVC.h"

@implementation GGSaturdayPromoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNeedsStatusBarAppearanceUpdate];
    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSearchTable) name:@"searchWeekendNotification" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    if ([[GGCommonFunc sharedInstance] connected]) {
        [[GGCommonFunc sharedInstance] showLoadingImage:self.parentViewController.view];
        [[GGAPICourseManager sharedInstance] getWeekendCourseWithDay:@"this_saturday" completion:^(NSDictionary * responseDict, NSError *error) {
            [[GGCommonFunc sharedInstance] hideLoadingImage];
            if (error == nil) {
                if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                    [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                    [[GGAPIManager sharedInstance] clearAllData];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    self.golfArr1 = responseDict;
                    [self.tblSaturdayPromotion reloadData];
                }
            } else {
                NSLog(@"ERROR : %@", error.localizedDescription);
            }
        }];
    }else{
        [self showCommonAlert:@"Alert" message:@"No internet connection."];
    }
}

- (void) reloadSearchTable {
    [self.tblSaturdayPromotion reloadData];
    [self.tblSaturdayPromotion setContentOffset:CGPointZero animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction) goSearch:(id)sender {
    
    GGSearchPromotionVC *searchPromoView = [self.storyboard instantiateViewControllerWithIdentifier:@"searchPromotionVC"];
    searchPromoView.isWeekend = 1;
    
    [self presentViewController:searchPromoView animated:YES completion:nil];
}


- (IBAction) goBookingPromo:(id)sender {
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tblSaturdayPromotion];
    NSIndexPath *indexPath = [self.tblSaturdayPromotion indexPathForRowAtPoint:buttonPosition];
    
    if (indexPath != nil) {
//        GGBookPromotionVC *bookPromoView  = [self.storyboard instantiateViewControllerWithIdentifier:@"bookPromoVC"];
//        bookPromoView.isHomeList = NO;
//        [bookPromoView setDetailArr:[[self.golfArr1 objectForKey:@"data"] objectAtIndex:indexPath.row]];
        
        GGPreBookingVC *bookPromoView  = [self.storyboard instantiateViewControllerWithIdentifier:@"preBookingView"];
        bookPromoView.isHomeList = NO;
        [bookPromoView setDetailArr:[[self.golfArr1 objectForKey:@"data"] objectAtIndex:indexPath.row]];
        [self.navigationController pushViewController:bookPromoView animated:YES];
        
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

#pragma mark - UITABLEVIEW DELEGATE AND DATASOURCE

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"TOTAL : %lu", [[self.golfArr1 objectForKey:@"data"] count]);
    return [[self.golfArr1 objectForKey:@"data"] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseIdentifier = @"saturdayPromoCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    
    UIImageView *imgRow = (UIImageView *)[cell viewWithTag:1];
    if([[[self.golfArr1 objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"image"] != (id)[NSNull null])
        [[GGCommonFunc sharedInstance] setLazyLoadImage:imgRow urlString:[[[self.golfArr1 objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"image"]];
    else
        imgRow.image = [UIImage imageNamed:@"def_big_img"];
    
    UILabel *lblTitle = (UILabel *)[cell viewWithTag:2];
    if (self.golfArr1[@"data"][indexPath.row][@"gname"] == nil || self.golfArr1[@"data"][indexPath.row][@"gname"] == (id) [NSNull null]) {
        lblTitle.text = @"";
    } else {
        lblTitle.text = self.golfArr1[@"data"][indexPath.row][@"gname"];
    }
    
    UILabel *lblArea = (UILabel *)[cell viewWithTag:9];
    if (self.golfArr1[@"data"][indexPath.row][@"area_name"] == nil || self.golfArr1[@"data"][indexPath.row][@"area_name"] == (id) [NSNull null]) {
        lblArea.text = @"";
    } else {
        lblArea.text = self.golfArr1[@"data"][indexPath.row][@"area_name"];
    }
    
    UILabel *lblLimit = (UILabel *)[cell viewWithTag:4];
    lblLimit.layer.cornerRadius = 5.0;
    lblLimit.layer.masksToBounds = true;
    if (self.golfArr1[@"data"][indexPath.row][@"limit_num"] == nil || self.golfArr1[@"data"][indexPath.row][@"limit_num"] == (id) [NSNull null]) {
        lblLimit.text = @"Limit : 0 Flight";
    } else {
        lblLimit.text = [NSString stringWithFormat:@"Limit : %ld Flight", [self.golfArr1[@"data"][indexPath.row][@"limit_num"] integerValue]];
    }
    
    UILabel *lblDate = (UILabel *)[cell viewWithTag:5];
    if (self.golfArr1[@"data"][indexPath.row][@"date"] == nil || self.golfArr1[@"data"][indexPath.row][@"date"] == (id) [NSNull null]) {
        lblDate.text = @"<not available>";
    } else {
        lblDate.text = [[GGCommonFunc sharedInstance] changeDateFormat:self.golfArr1[@"data"][indexPath.row][@"date"]];
    }
    
    return cell;
}

- (NSArray *) getStringBeforeChar:(NSString *) character teks:(NSString *)teksString{
    NSArray *textArray = [teksString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:character]];
    
    return textArray;
}

@end
