//
//  GGSearchVC.m
//  GoGolf
//
//  Created by Eddyson Tan on 6/20/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGSearchVC.h"
#import "GGHomeVC.h"
#import "GGHomePageVC.h"

@interface GGSearchVC () {
    UIRefreshControl *searchRefresh;
    UITableViewCell *cell;
}

@end

static NSString *reuseIdentifier = @"searchCell";

@implementation GGSearchVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isSearchEmpty = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadSearchTable) name:@"searchCourseNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(goSearchCourse:) name:@"searchGolfCourse" object:nil];
    
    searchRefresh = [[UIRefreshControl alloc] init];
    [searchRefresh addTarget:self action:@selector(refreshSearchList) forControlEvents:UIControlEventValueChanged];
    [self.tblSearch addSubview:searchRefresh];
    
    [self refreshSearchList];
}

- (void)refreshSearchList {
    self.isSearchEmpty = NO;
    self.txtEmptySearch.hidden = YES;
    if ([[GGCommonFunc sharedInstance] connected]) {
        
        [[GGCommonFunc sharedInstance] showLoadingImage:((GGHomePageVC*)((GGHomeVC*)self.searchVCDelegate).homeDelegate).homePageView];
        
        [[GGAPICourseManager sharedInstance] getCourseListWithcompletion:^(NSDictionary *responseDict, NSError *error) {
            
            [[GGCommonFunc sharedInstance] hideLoadingImage:((GGHomePageVC*)((GGHomeVC*)self.searchVCDelegate).homeDelegate).homePageView];
            
            if (error == nil) {
                if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                    [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                    [[GGAPIManager sharedInstance] clearAllData];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    [self.tblSearch reloadData];
                    if ([searchRefresh isRefreshing]) {
                        [searchRefresh endRefreshing];
                    }
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
    [self.tblSearch reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 1)] withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tblSearch setContentOffset:CGPointZero animated:YES];
    
    //self.btnSearch.layer.cornerRadius = self.btnSearch.frame.size.width / 2;
    //self.btnSearch.clipsToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (IBAction)goSearchCourse:(id)sender {
    
//    GGSearchCourseVC *searchCourseView = [self.storyboard instantiateViewControllerWithIdentifier:@"searchCourseVC"];
    GGSearchGolfCourseVC *searchGolfCourseView = [self.storyboard instantiateViewControllerWithIdentifier:@"searchGolfCourseVC"];
    searchGolfCourseView.searchDelegate = self;
    
    [self presentViewController:searchGolfCourseView animated:YES completion:nil];
}

- (IBAction)bookCourse:(id)sender {

    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tblSearch];
    NSIndexPath *indexPath = [self.tblSearch indexPathForRowAtPoint:buttonPosition];
    
    if (indexPath != nil) {
        
//        GGBookPromotionVC *bookPromoView  = [self.storyboard instantiateViewControllerWithIdentifier:@"bookPromoVC"];
//        bookPromoView.isHomeList = NO;
//        [bookPromoView setDetailArr:[[[GGGlobalVariable sharedInstance].itemCourseList objectForKey:@"data"] objectAtIndex:indexPath.row]];
        
        GGPreBookingVC *preBookingView  = [self.storyboard instantiateViewControllerWithIdentifier:@"preBookingView"];
        preBookingView.isHomeList = NO;
        preBookingView.detailArr = [[[GGGlobalVariable sharedInstance].itemCourseList objectForKey:@"data"] objectAtIndex:indexPath.row];
        
        [self.navigationController pushViewController:preBookingView animated:YES];
    }

}

- (IBAction)goDetailCourse:(id)sender {
    [(UIButton *)sender setEnabled:false];
    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tblSearch];
    NSIndexPath *indexPath = [self.tblSearch indexPathForRowAtPoint:buttonPosition];
    
    if ([[GGCommonFunc sharedInstance] connected]) {
        [[GGCommonFunc sharedInstance] showLoadingImage:self.parentViewController.parentViewController.parentViewController.view];
        
        [[GGAPICourseManager sharedInstance] getCourseDetailWithID:[[[[GGGlobalVariable sharedInstance].itemCourseList objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"gid"] completion:^(NSDictionary *responseDict, NSError *error) {
            if (error == nil) {
                
                [[GGCommonFunc sharedInstance] hideLoadingImage];
                
                if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                    [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                    [[GGAPIManager sharedInstance] clearAllData];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    //                GGGolfDetailVC *detailCourseView = [self.storyboard instantiateViewControllerWithIdentifier:@"detailView"];
                    //                detailCourseView.courseDetailArr = responseDict;
                    //
                    //                [self.navigationController pushViewController:detailCourseView animated:YES];
                    
                    GGSearchDetailVC *searchDetailView = [self.storyboard instantiateViewControllerWithIdentifier:@"searchDetailCourse"];
                    searchDetailView.courseDetailArr = responseDict;
                    
                    [self.navigationController pushViewController:searchDetailView animated:YES];
                    [(UIButton *)sender setEnabled:true];
                }
            } else {
                NSLog(@"Error : %@", error.localizedDescription);
                [(UIButton *)sender setEnabled:true];
            }
        }];
    }else{
        [self showCommonAlert:@"Alert" message:@"No internet connection."];
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
    if ([[GGGlobalVariable sharedInstance].itemCourseList[@"data"] count] > 0) {
        if (self.isSearchEmpty == NO) {
            return [[GGGlobalVariable sharedInstance].itemCourseList[@"data"] count];
        }else{
            return 0;
        }
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
    UILabel *lblCourseTitle = (UILabel *)[cell viewWithTag:2];
    UILabel *lblAreaName = (UILabel *)[cell viewWithTag:3];
    
    if ([[GGGlobalVariable sharedInstance].itemCourseList[@"data"] count] > 0) {

        if ([[GGCommonFunc sharedInstance] connected]) {
            [[GGCommonFunc sharedInstance] setLazyLoadImage:imgRow urlString:[GGGlobalVariable sharedInstance].itemCourseList[@"data"][indexPath.row][@"image"]];
        }
        
        lblCourseTitle.text = [GGGlobalVariable sharedInstance].itemCourseList[@"data"][indexPath.row][@"gname"];

        lblAreaName.text = [GGGlobalVariable sharedInstance].itemCourseList[@"data"][indexPath.row][@"area_name"];

    }

//    if([[[[GGGlobalVariable sharedInstance].itemCourseList objectForKey:@"data"] objectAtIndex:indexPath.row] objectForKey:@"image"] != (id)[NSNull null])
//    else
//        imgRow.image = [UIImage imageNamed:@"def_big_img"];
    
    return cell;
}

@end
