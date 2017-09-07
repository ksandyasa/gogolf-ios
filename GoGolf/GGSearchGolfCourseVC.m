//
//  GGSearchGolfCourseVC.m
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/11/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGSearchGolfCourseVC.h"

@interface GGSearchGolfCourseVC () {
    GGSearchCourseCell2 *cell2;
    GGSearchCourseCell3 *cell3;
    GGSearchCourseCell4 *cell4;
    GGSearchCourseFooter *footerView;
    UITextField *txtCourseName;
    GGAreaCell *cellArea;
    NSIndexPath *colSelectedIndexPath;
    NSArray *courseDict;
    NSIndexPath *rangeSliderIndexPath;
    NSString *search_CoursePriceMin;
    NSString *search_CoursePriceMax;
}

@end

NSString *areaID = @"";
NSInteger selecCourse = 0;
NSString *courNameString = @"";
static NSString *colCellIdentifier1 = @"areaCell";
static NSString *cellIdentifier2 = @"searchCourseCell2";
static NSString *cellIdentifier3 = @"searchCourseCell3";
static NSString *cellIdentifier4 = @"searchCourseCell4";

@implementation GGSearchGolfCourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tblSearchGolfCourse registerNib:[UINib nibWithNibName:@"GGSearchCourseCell2" bundle:nil] forCellReuseIdentifier:cellIdentifier2];
    [self.tblSearchGolfCourse registerNib:[UINib nibWithNibName:@"GGSearchCourseCell3" bundle:nil] forCellReuseIdentifier:cellIdentifier3];
    [self.tblSearchGolfCourse registerNib:[UINib nibWithNibName:@"GGSearchCourseCell4" bundle:nil] forCellReuseIdentifier:cellIdentifier4];
    
    [self.tblSearchGolfCourse setDelegate:self];
    [self.tblSearchGolfCourse setDataSource:self];
    [self.tblSearchGolfCourse setDelaysContentTouches:false];
    
    //[self setupFooterView];
}

- (void)setupFooterView {
    footerView = [[GGSearchCourseFooter alloc] initWithNibName:@"GGSearchCourseFooter" bundle:nil];
    [self addChildViewController:footerView];
    footerView.searchDelegate = self;
    [self.tblSearchGolfCourse setTableFooterView:footerView.view];
    [footerView didMoveToParentViewController:self];
}

- (void)setupCourseListBasedOnAreaID {
    
    if ([[GGCommonFunc sharedInstance] connected]) {
        [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
        [[GGAPIHomeManager sharedInstance] getMapListWithID:areaID Completion:^(NSDictionary *responseDict, NSError *error) {
            [[GGCommonFunc sharedInstance] hideLoadingImage];
            if (error == nil) {
                if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                    [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                    [[GGAPIManager sharedInstance] clearAllData];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    if ([[responseDict objectForKey:@"data"] count] > 0) {
                        
                        courseDict = [[GGGlobalVariable sharedInstance].itemMapList objectForKey:@"data"];
                        selecCourse = 0;
                        NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:2 inSection:0];
                        NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
                        [self.tblSearchGolfCourse reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationAutomatic];
                        
                    }
//                    else {
//                        [self showCommonAlert:@"Notification" message:@"No Spot Available for this Area."];
//                    }
                }
            } else {
                NSLog(@"ERROR : %@", error.localizedDescription);
            }
        }];
    }else{
        [self showCommonAlert:@"Alert" message:@"No internet connetion."];
    }
}

- (void)fillCourseNameInput:(NSString *)courseName fromIndeks:(NSInteger)index {
    selecCourse = index;
    courNameString = courseName;
    txtCourseName.text = courseName;
    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:2 inSection:0];
    NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
    [self.tblSearchGolfCourse reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)searchGolfCourse {
    
    if ([[GGCommonFunc sharedInstance] connected]) {
        [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
        [[GGAPICourseManager sharedInstance] searchCourseWithPriceMin:search_CoursePriceMin priceMax:search_CoursePriceMax areaID:areaID courseName:courNameString completion:^(NSDictionary *responseDict, NSError *error) {
            [[GGCommonFunc sharedInstance] hideLoadingImage];
            if (error == nil) {
                if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                    [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                    [[GGAPIManager sharedInstance] clearAllData];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    if ([[responseDict objectForKey:@"data"] count] > 0) {
                        NSLog(@"responseDict %@", [responseDict description]);
                        [GGGlobalVariable sharedInstance].itemCourseList = responseDict;
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"searchCourseNotification" object:self userInfo:nil];
                        
                        [self dismissViewControllerAnimated:YES completion:^{
                            if ([self.searchDelegate isKindOfClass:[GGSearchVC class]]) {
                                ((GGSearchVC*)self.searchDelegate).isSearchEmpty = NO;
                                ((GGSearchVC*)self.searchDelegate).txtEmptySearch.hidden = YES;
                                [self.searchDelegate reloadSearchTable];
                            }
                        }];
                        
                    } else {
                        [self dismissViewControllerAnimated:YES completion:^{
                            if ([self.searchDelegate isKindOfClass:[GGSearchVC class]]) {
//                                [self.searchDelegate showCommonAlert:@"Search Error" message:@"Search Not Found."];
                                ((GGSearchVC*)self.searchDelegate).isSearchEmpty = YES;
                                ((GGSearchVC*)self.searchDelegate).txtEmptySearch.hidden = NO;
                                ((GGSearchVC*)self.searchDelegate).txtEmptySearch.text = [NSString stringWithFormat:@"Search not found."];
                                [self.searchDelegate reloadSearchTable];
                            }                            
                        }];
                    }
                }
            } else {
                [self showCommonAlert:@"Search Error" message:error.localizedDescription];
            }
        }];
    }else{
        [self showCommonAlert:@"Alert" message:@"No internet connection."];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITABLEVIEW

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        rangeSliderIndexPath = indexPath;
        
        cell2 = (GGSearchCourseCell2 *)[self.tblSearchGolfCourse dequeueReusableCellWithIdentifier:cellIdentifier2];
        if (cell2 == nil) {
            NSArray *cellArray2 = [[NSBundle mainBundle] loadNibNamed:@"GGSearchCourseCell2" owner:self options:nil];
            cell2 = [cellArray2 objectAtIndex:0];
        }
        
        cell2.rsPrice.delegate = self;
        search_CoursePriceMin = [NSString stringWithFormat:@"%d", (int)cell2.rsPrice.selectedMinimum];
        search_CoursePriceMax = [NSString stringWithFormat:@"%d", (int)cell2.rsPrice.selectedMaximum];
        
        return cell2;
        
    } else if (indexPath.row == 1) {
        cell3 = (GGSearchCourseCell3 *)[self.tblSearchGolfCourse dequeueReusableCellWithIdentifier:cellIdentifier3];
        if (cell3 == nil) {
            NSArray *cellArray2 = [[NSBundle mainBundle] loadNibNamed:@"GGSearchCourseCell3" owner:self options:nil];
            cell3 = [cellArray2 objectAtIndex:0];
        }
                
        [cell3.colAreaList registerNib:[UINib nibWithNibName:@"GGAreaCell" bundle:nil] forCellWithReuseIdentifier:colCellIdentifier1];
        [cell3.colAreaList setDelegate:self];
        [cell3.colAreaList setDataSource:self];
        [cell3.colAreaList setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        return cell3;
        
    } else if (indexPath.row == 2) {
        
        cell4 = (GGSearchCourseCell4 *)[self.tblSearchGolfCourse dequeueReusableCellWithIdentifier:cellIdentifier4];
        if (cell2 == nil) {
            NSArray *cellArray2 = [[NSBundle mainBundle] loadNibNamed:@"GGSearchCourseCell4" owner:self options:nil];
            cell4 = [cellArray2 objectAtIndex:0];
        }
        
        cell4.searchDelegate = self;
        cell4.txtCourse.text = courNameString;
        txtCourseName = cell4.txtCourse;
        txtCourseName.delegate = self;
        cell4.courseDict = courseDict;
        [cell4 reloadCourseList:selecCourse];
        
        return cell4;
        
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    footerView = [[GGSearchCourseFooter alloc] initWithNibName:@"GGSearchCourseFooter" bundle:nil];
    [self addChildViewController:footerView];
    footerView.searchDelegate = self;
    [footerView didMoveToParentViewController:self];

    return footerView.view;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 2)
        return 133.0;
    
    return 95.0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 2)
        return 133.0;
    
    return 95.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 60;
}

#pragma end

#pragma mark TTRangeSliderViewDelegate
-(void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum{
    NSLog(@"didChange");
    search_CoursePriceMin = [NSString stringWithFormat:@"%d", (int)selectedMinimum];
    search_CoursePriceMax = [NSString stringWithFormat:@"%d", (int)selectedMaximum];
    
    GGSearchCourseCell2 *rangeCell = [self.tblSearchGolfCourse cellForRowAtIndexPath:rangeSliderIndexPath];
    
    rangeCell.lblMinPrice.text = [NSString stringWithFormat:@"Rp.%@",[[GGCommonFunc sharedInstance] setSeparatedCurrency:(int)cell2.rsPrice.selectedMinimum]];
    rangeCell.lblMaxPrice.text = [NSString stringWithFormat:@"Rp.%@",[[GGCommonFunc sharedInstance] setSeparatedCurrency:(int)cell2.rsPrice.selectedMaximum]];
    
}

#pragma end

#pragma mark - UITEXTFIELD DELEGATE

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [[GGCommonFunc sharedInstance] setViewMovedUp:NO fromView:self.view fromPos:2];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [[GGCommonFunc sharedInstance] setViewMovedUp:YES fromView:self.view fromPos:2];
}

#pragma end

#pragma mark - UICOLLECTIONVIEW

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [[GGGlobalVariable sharedInstance].itemAreaList[@"data"] count];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    GGAreaCell *selectedCell = (GGAreaCell *)cell;
    
    if (selectedCell == nil) {
        return;
    }
    
    if (selectedCell.selected == true) {
        selectedCell.lblArea.textColor = [[GGCommonFunc sharedInstance] colorWithHexString:@"7ED321"];
    }else{
        selectedCell.lblArea.textColor = [[GGCommonFunc sharedInstance] colorWithHexString:@"FFFFFF"];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    cellArea = (GGAreaCell *)[collectionView dequeueReusableCellWithReuseIdentifier:colCellIdentifier1 forIndexPath:indexPath];
    
    cellArea.lblArea.text = [GGGlobalVariable sharedInstance].itemAreaList[@"data"][indexPath.row][@"area_name"];
    
    return cellArea;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"clicked");
    GGAreaCell *selectedCell = (GGAreaCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (selectedCell == nil) {
        return;
    }
    
    selectedCell.selected = true;
    selectedCell.lblArea.textColor = [[GGCommonFunc sharedInstance] colorWithHexString:@"7ED321"];
    
    areaID = [GGGlobalVariable sharedInstance].itemAreaList[@"data"][indexPath.row][@"area_id"];
    [self setupCourseListBasedOnAreaID];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    GGAreaCell *selectedCell = (GGAreaCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    if (selectedCell == nil) {
        return;
    }
    
    selectedCell.selected = false;
    selectedCell.lblArea.textColor = [[GGCommonFunc sharedInstance] colorWithHexString:@"FFFFFF"];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(100, 37);
}

#pragma end

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actionGoBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

@end
