//
//  GGPromotionVC.m
//  GoGolf
//
//  Created by Eddyson Tan on 6/20/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGPromotionVC.h"
#import "GGHomeVC.h"
#import "GGHomePageVC.h"

@interface GGPromotionVC () {
    UIRefreshControl *promoRefresh;
    UITableViewCell *cell;
}

@end

static NSString *reuseIdentifier = @"promotionCell";

@implementation GGPromotionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSearchTable) name:@"searchNotification" object:nil];
    self.isPromoEmpty = NO;
    
    [self.tblPromotion setDelegate:self];
    [self.tblPromotion setDataSource:self];
    
    promoRefresh = [[UIRefreshControl alloc] init];
    [promoRefresh addTarget:self action:@selector(refreshPromotionList) forControlEvents:UIControlEventValueChanged];
    [self.tblPromotion addSubview:promoRefresh];
    
    [self refreshPromotionList];
}

- (void)refreshPromotionList {
    self.isPromoEmpty = NO;
    self.txtEmptyPromotion.hidden = YES;
    if ([[GGCommonFunc sharedInstance] connected]) {
        [[GGCommonFunc sharedInstance] showLoadingImage:((GGHomePageVC*)((GGHomeVC*)self.promotionVCDelegate).homeDelegate).homePageView];
        
        [[GGAPIHomeManager sharedInstance] getPromotionListWithcompletion:^(NSDictionary *responseDict, NSError *error) {
            
            [[GGCommonFunc sharedInstance] hideLoadingImage:((GGHomePageVC*)((GGHomeVC*)self.promotionVCDelegate).homeDelegate).homePageView];
            
            if (error == nil) {
                if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                    [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                    [[GGAPIManager sharedInstance] clearAllData];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    NSLog(@"%@", [[[GGGlobalVariable sharedInstance].itemPromotionList objectForKey:@"data"] description]);
                    [self.tblPromotion reloadData];
                    if ([promoRefresh isRefreshing]) {
                        [promoRefresh endRefreshing];
                    }
                }
            } else {
                NSLog(@"ERROR : %@", error.localizedDescription);
            }
        }];
    }else{
        [self showCommonAlert:@"Alert" message:@"No internet conneciton."];
    }
}

- (void) reloadSearchTable {
    [self.tblPromotion reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tblPromotion setContentOffset:CGPointZero animated:YES];
}

- (IBAction)goSearch:(id)sender {
    [(UIButton *)sender setEnabled:false];
    
//    GGSearchPromotionVC *searchPromoView = [self.storyboard instantiateViewControllerWithIdentifier:@"searchPromotionVC"];
//    
//    searchPromoView.isWeekend = 0;
    
    GGSearchGolfCoursePromotionVC *searchGolfPromoView = [self.storyboard instantiateViewControllerWithIdentifier:@"searchGolfCoursePromotionVC"];
    searchGolfPromoView.isWeekend = 0;
    searchGolfPromoView.promoDelegate = self;
    
    [self presentViewController:searchGolfPromoView animated:YES completion:^{
        [(UIButton *)sender setEnabled:true];
    }];
    
}

- (IBAction) goBookingPromo:(id)sender {
    [(UIButton *)sender setEnabled:false];
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tblPromotion];
    NSIndexPath *indexPath = [self.tblPromotion indexPathForRowAtPoint:buttonPosition];
    
    if (indexPath != nil) {
        
//        GGBookPromotionVC *bookPromoView  = [self.storyboard instantiateViewControllerWithIdentifier:@"bookPromoVC"];
//        bookPromoView.isHomeList = NO;
//        [bookPromoView setDetailArr:[[[GGGlobalVariable sharedInstance].itemPromotionList objectForKey:@"data"] objectAtIndex:indexPath.row]];
//        
//        [self.navigationController pushViewController:bookPromoView animated:YES];

        GGPreBookingVC *preBookingView  = [self.storyboard instantiateViewControllerWithIdentifier:@"preBookingView"];
        preBookingView.isHomeList = NO;
        preBookingView.detailArr = [[[GGGlobalVariable sharedInstance].itemPromotionList objectForKey:@"data"] objectAtIndex:indexPath.row];
        
        [self.navigationController pushViewController:preBookingView animated:YES];
        [(UIButton *)sender setEnabled:true];
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
    if ([[GGGlobalVariable sharedInstance].itemPromotionList[@"data"] count] > 0) {
        if (self.isPromoEmpty == NO) {
            return [[GGGlobalVariable sharedInstance].itemPromotionList[@"data"] count];
        }else
            return 0;
    }else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }

    UIImageView *imgRow = (UIImageView *)[cell viewWithTag:1];
    UILabel *lblTitle = (UILabel *)[cell viewWithTag:2];
    UILabel *lblPrice = (UILabel *)[cell viewWithTag:3];
    UILabel *lblDiscount = (UILabel *)[cell viewWithTag:4];
    lblDiscount.layer.cornerRadius = 5.0;
    lblDiscount.layer.masksToBounds = true;
    UILabel *lblDate = (UILabel *)[cell viewWithTag:5];
    UILabel *lblTime = (UILabel *)[cell viewWithTag:6];
    UILabel *lblLimit = (UILabel *)[cell viewWithTag:7];
    UILabel *lblAreaName = (UILabel *)[cell viewWithTag:9];

    if ([[GGGlobalVariable sharedInstance].itemPromotionList[@"data"] count] > 0) {

        if ([[GGCommonFunc sharedInstance] connected]) {
            [[GGCommonFunc sharedInstance] setLazyLoadImage:imgRow urlString:[GGGlobalVariable sharedInstance].itemPromotionList[@"data"][indexPath.row][@"image"]];
        }

        lblTitle.text = [GGGlobalVariable sharedInstance].itemPromotionList[@"data"][indexPath.row][@"gname"];

        lblPrice.text = [NSString stringWithFormat:@"Rp. %@", [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[GGGlobalVariable sharedInstance].itemPromotionList[@"data"][indexPath.row][@"pprice"] floatValue]]];

        lblDiscount.text = [NSString stringWithFormat:@"Disc %ld%%", [[GGGlobalVariable sharedInstance].itemPromotionList[@"data"][indexPath.row][@"discount"] integerValue]];

        lblDate.text = [[GGCommonFunc sharedInstance] changeDateFormat:[GGGlobalVariable sharedInstance].itemPromotionList[@"data"][indexPath.row][@"date"]];
        NSString *start = [GGGlobalVariable sharedInstance].itemPromotionList[@"data"][indexPath.row][@"stime"];
        
        NSString *end = [GGGlobalVariable sharedInstance].itemPromotionList[@"data"][indexPath.row][@"etime"];
        
        lblTime.text = [NSString stringWithFormat:@"%@ - %@", start, end];
        
        lblLimit.text = [NSString stringWithFormat:@"Rest of limit : %ld Flight", [[GGGlobalVariable sharedInstance].itemPromotionList[@"data"][indexPath.row][@"limit_num"] integerValue]];

        lblAreaName.text = [GGGlobalVariable sharedInstance].itemPromotionList[@"data"][indexPath.row][@"area_name"];
        
    }
    
//    if([GGGlobalVariable sharedInstance].itemPromotionList[@"data"][indexPath.row][@"image"] != (id)[NSNull null])
//    else
//        imgRow.image = [UIImage imageNamed:@"def_big_img"];
//    
//    if ([GGGlobalVariable sharedInstance].itemPromotionList[@"data"][indexPath.row][@"gname"] == nil || [GGGlobalVariable sharedInstance].itemPromotionList[@"data"][indexPath.row][@"gname"] == (id) [NSNull null]) {
//        lblTitle.text = @"";
//    } else {
//    }
//    
//    if ([GGGlobalVariable sharedInstance].itemPromotionList[@"data"][indexPath.row][@"pprice"] == nil || [GGGlobalVariable sharedInstance].itemPromotionList[@"data"][indexPath.row][@"pprice"] == (id) [NSNull null]) {
//        lblPrice.text = @"Rp. 0";
//    } else {
//    }
//    
//    if ([GGGlobalVariable sharedInstance].itemPromotionList[@"data"][indexPath.row][@"discount"] == nil || [GGGlobalVariable sharedInstance].itemPromotionList[@"data"][indexPath.row][@"discount"] == (id) [NSNull null]) {
//        lblDiscount.text = @"Disc 0%";
//    } else {
//    }
//    
//    if ([GGGlobalVariable sharedInstance].itemPromotionList[@"data"][indexPath.row][@"date"] == nil || [GGGlobalVariable sharedInstance].itemPromotionList[@"data"][indexPath.row][@"date"] == (id) [NSNull null]) {
//        lblDate.text = @"<not available>";
//    } else {
//    }
//        
//    
//    if ([GGGlobalVariable sharedInstance].itemPromotionList[@"data"][indexPath.row][@"stime"] == nil || [GGGlobalVariable sharedInstance].itemPromotionList[@"data"][indexPath.row][@"stime"] == (id) [NSNull null]) {
//        lblTime.text = @"<not available>";
//    } else {
//        
//    }
//        
//    if ([GGGlobalVariable sharedInstance].itemPromotionList[@"data"][indexPath.row][@"limit_num"] == nil || [GGGlobalVariable sharedInstance].itemPromotionList[@"data"][indexPath.row][@"limit_num"] == (id) [NSNull null]) {
//        lblLimit.text = @"Rest of Limit : 0 Flight";
//    } else {
//    }
//    
//    if ([GGGlobalVariable sharedInstance].itemPromotionList[@"data"][indexPath.row][@"area_name"] == nil || [GGGlobalVariable sharedInstance].itemPromotionList[@"data"][indexPath.row][@"area_name"] == (id) [NSNull null]) {
//        lblAreaName.text = @"";
//    } else {
//    }
    
    return cell;
}

- (NSArray *) getStringBeforeChar:(NSString *) character teks:(NSString *)teksString{
    NSArray *textArray = [teksString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:character]];
    
    return textArray;
}


@end
