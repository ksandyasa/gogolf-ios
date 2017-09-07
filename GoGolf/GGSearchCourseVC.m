//
//  GGSearchCourseVC.m
//  GoGolf
//
//  Created by Eddyson Tan on 6/29/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGSearchCourseVC.h"
#import "GGAPIManager.h"
#import "GGSearchCourseCell2.h"
#import "GGSearchCourseCell3.h"
#import "GGSearchCourseCell4.h"
#import "GGSearchCourseFooter.h"
#import "GGAreaCell.h"

@interface GGSearchCourseVC () {
    GGSearchCourseCell2 *cell2;
    GGSearchCourseCell3 *cell3;
    GGSearchCourseCell4 *cell4;
    GGSearchCourseFooter *footerView;
    UITextField *txtCourseName;
    GGAreaCell *cellArea;
    NSIndexPath *colSelectedIndexPath;
    NSString *areaID;
    NSArray *courseDict;
    NSIndexPath *rangeSliderIndexPath;
}

@end

NSInteger selectedCourse = 0;
NSString *courseNameString = @"";
static NSString *colCellIdentifier1 = @"areaCell";
static NSString *cellIdentifier2 = @"searchCourseCell2";
static NSString *cellIdentifier3 = @"searchCourseCell3";
static NSString *cellIdentifier4 = @"searchCourseCell4";

@implementation GGSearchCourseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tblSearchCourse registerNib:[UINib nibWithNibName:@"GGSearchCourseCell2" bundle:nil] forCellReuseIdentifier:cellIdentifier2];
    [self.tblSearchCourse registerNib:[UINib nibWithNibName:@"GGSearchCourseCell3" bundle:nil] forCellReuseIdentifier:cellIdentifier3];
    [self.tblSearchCourse registerNib:[UINib nibWithNibName:@"GGSearchCourseCell4" bundle:nil] forCellReuseIdentifier:cellIdentifier4];
    
    [self.tblSearchCourse setDelegate:self];
    [self.tblSearchCourse setDataSource:self];
    
    [self setupFooterView];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)viewWillAppear:(BOOL)animated {
    
    search_CourseAreaID = @"";
    search_CoursePriceMin = @"0";
    search_CoursePriceMax = @"1000000";
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)dismissKeyboard {
    [txtCourseName resignFirstResponder];
}

- (void)setupFooterView {
    footerView = [[GGSearchCourseFooter alloc] initWithNibName:@"GGSearchCourseFooter" bundle:nil];
    footerView.searchDelegate = self;
    [self.tblSearchCourse setTableFooterView:footerView.view];
}

- (void)setupCourseListBasedOnAreaID {
    [[GGAPIHomeManager sharedInstance] getMapListWithID:areaID Completion:^(NSDictionary *responseDict, NSError *error) {
        if (error == nil) {
            if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                [[GGAPIManager sharedInstance] clearAllData];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                if ([[responseDict objectForKey:@"data"] count] > 0) {
                    
                    courseDict = [[GGGlobalVariable sharedInstance].itemMapList objectForKey:@"data"];
                    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:2 inSection:0];
                    NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
                    [self.tblSearchCourse reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationAutomatic];

                } else {
                    [self showCommonAlert:@"Notification" message:@"No Spot Available for this Area."];
                }
            }
        } else {
            NSLog(@"ERROR : %@", error.localizedDescription);
        }
    }];
}

- (IBAction)goBack:(id)sender {
    
    [[GGAPICourseManager sharedInstance] getCourseListWithcompletion:^(NSDictionary *responseDict, NSError *error) {
        if (error == nil) {
            if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                [[GGAPIManager sharedInstance] clearAllData];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                if ([[responseDict objectForKey:@"data"] count] > 0) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"searchCourseNotification" object:self userInfo:nil];
                
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }
        } else {
            NSLog(@"ERROR : %@", error.localizedDescription);
        }
    }];
    
}

- (IBAction)rangeSliderValueDidChange:(TTRangeSlider *)slider {
    
    selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UITableViewCell *cell = [self.tblSearchCourse cellForRowAtIndexPath:selectedIndexPath];
    TTRangeSlider *sliderPrice = (TTRangeSlider *)[cell viewWithTag:4];
    
    UILabel *lblMinPrice = (UILabel *) [cell viewWithTag:1];
    UILabel *lblMaxPrice = (UILabel *) [cell viewWithTag:2];
    
    lblMinPrice.text = [NSString stringWithFormat:@"Rp.%@",[[GGCommonFunc sharedInstance] setSeparatedCurrency:(int)sliderPrice.selectedMinimum]];
    lblMaxPrice.text = [NSString stringWithFormat:@"Rp.%@",[[GGCommonFunc sharedInstance] setSeparatedCurrency:(int)sliderPrice.selectedMaximum]];
    
    search_CoursePriceMin = [NSString stringWithFormat:@"%d", (int)sliderPrice.selectedMinimum];
    search_CoursePriceMax = [NSString stringWithFormat:@"%d", (int)sliderPrice.selectedMaximum];
    
}

- (IBAction)goSearchCourse:(id)sender {
    
    selectedIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    UITableViewCell *cell = [self.tblSearchCourse cellForRowAtIndexPath:selectedIndexPath];
    UILabel *lblCourseName = (UILabel *)[cell viewWithTag:1];
    search_CourseName = lblCourseName.text;
    
    if([search_CourseAreaID length] == 0)
        search_CourseAreaID = @"";
    
    [[GGAPICourseManager sharedInstance] searchCourseWithPriceMin:search_CoursePriceMin priceMax:search_CoursePriceMax areaID:search_CourseAreaID courseName:search_CourseName completion:^(NSDictionary *responseDict, NSError *error) {
        if (error == nil) {
            if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                [[GGAPIManager sharedInstance] clearAllData];
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                if ([[responseDict objectForKey:@"data"] count] > 0) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"searchCourseNotification" object:self userInfo:nil];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
                } else {
                    [self showCommonAlert:@"Search Error" message:@"Search Not Found."];
                }
            }
        } else {
            [self showCommonAlert:@"Search Error" message:error.localizedDescription];
        }
    }];
}

- (void)fillCourseNameInput:(NSString *)courseName fromIndeks:(NSInteger)index {
    selectedCourse = index;
    courseNameString = courseName;
    txtCourseName.text = courseName;
    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:2 inSection:0];
    NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
    [self.tblSearchCourse reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationAutomatic];
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

#pragma mark - PickerView

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return [[GGGlobalVariable sharedInstance].itemAreaList[@"data"] count] + 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row == 0) {
        return @"All";
    } else {
        return [GGGlobalVariable sharedInstance].itemAreaList[@"data"][row-1][@"area_name"];
    }
    
    return nil;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

#pragma end

#pragma mark - UITEXTFIELD DELEGATE

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    
    return YES;
}

#pragma end

#pragma mark - UITABLEVIEW

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        rangeSliderIndexPath = indexPath;
        
        cell2 = (GGSearchCourseCell2 *)[self.tblSearchCourse dequeueReusableCellWithIdentifier:cellIdentifier2];
        if (cell2 == nil) {
            NSArray *cellArray2 = [[NSBundle mainBundle] loadNibNamed:@"GGSearchCourseCell2" owner:self options:nil];
            cell2 = [cellArray2 objectAtIndex:0];
        }
        
        cell2.rsPrice.delegate = self;
        
        return cell2;
        
    } else if (indexPath.row == 1) {
        colSelectedIndexPath = indexPath;
        
        cell3 = (GGSearchCourseCell3 *)[self.tblSearchCourse dequeueReusableCellWithIdentifier:cellIdentifier3];
        if (cell3 == nil) {
            NSArray *cellArray2 = [[NSBundle mainBundle] loadNibNamed:@"GGSearchCourseCell3" owner:self options:nil];
            cell3 = [cellArray2 objectAtIndex:0];
        }

        [cell3.colAreaList registerNib:[UINib nibWithNibName:@"GGAreaCell" bundle:nil] forCellWithReuseIdentifier:colCellIdentifier1];
        [cell3.colAreaList setDelegate:self];
        [cell3.colAreaList setDataSource:self];
        [cell3.colAreaList setContentInset:UIEdgeInsetsMake(1.25, 1.25, 1.25, 1.25)];
        
        cell3.userInteractionEnabled = true;
        
        return cell3;
        
    } else if (indexPath.row == 2) {
        
        cell4 = (GGSearchCourseCell4 *)[self.tblSearchCourse dequeueReusableCellWithIdentifier:cellIdentifier4];
        if (cell2 == nil) {
            NSArray *cellArray2 = [[NSBundle mainBundle] loadNibNamed:@"GGSearchCourseCell4" owner:self options:nil];
            cell4 = [cellArray2 objectAtIndex:0];
        }
        
        cell4.searchDelegate = self;
        cell4.txtCourse.text = courseNameString;
        txtCourseName = cell4.txtCourse;
        txtCourseName.delegate = self;
        cell4.courseDict = courseDict;
        [cell4 reloadCourseList:selectedCourse];
        
        return cell4;
        
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 2)
        return 133.0;
    
    return 95.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 2)
        return 133.0;
    
    return 95.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selected");
    if (indexPath.row == 1) {
        colSelectedIndexPath = indexPath;
    }
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
    GGSearchCourseCell3 *colAreaCell = [self.tblSearchCourse cellForRowAtIndexPath:colSelectedIndexPath];
    cellArea = (GGAreaCell *)[colAreaCell.colAreaList dequeueReusableCellWithReuseIdentifier:colCellIdentifier1 forIndexPath:indexPath];
    
    cellArea.lblArea.text = [GGGlobalVariable sharedInstance].itemAreaList[@"data"][indexPath.row][@"area_name"];
    
    return cellArea;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"clicked");
    GGSearchCourseCell3 *colAreaCell = [self.tblSearchCourse cellForRowAtIndexPath:colSelectedIndexPath];
    GGAreaCell *selectedCell = (GGAreaCell *)[colAreaCell.colAreaList cellForItemAtIndexPath:indexPath];
    
    if (selectedCell == nil) {
        return;
    }
    
    selectedCell.selected = true;
    selectedCell.lblArea.textColor = [[GGCommonFunc sharedInstance] colorWithHexString:@"7ED321"];
    
    areaID = [GGGlobalVariable sharedInstance].itemAreaList[@"data"][indexPath.row][@"area_id"];
    [self setupCourseListBasedOnAreaID];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    GGSearchCourseCell3 *colAreaCell = [self.tblSearchCourse cellForRowAtIndexPath:colSelectedIndexPath];
    GGAreaCell *selectedCell = (GGAreaCell *)[colAreaCell.colAreaList cellForItemAtIndexPath:indexPath];
    
    if (selectedCell == nil) {
        return;
    }
    
    selectedCell.selected = false;
    selectedCell.lblArea.textColor = [[GGCommonFunc sharedInstance] colorWithHexString:@"FFFFFF"];
}

#pragma end

#pragma mark TTRangeSliderViewDelegate
-(void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum{
    NSLog(@"didChange");
    search_CoursePriceMin = [NSString stringWithFormat:@"%d", (int)selectedMinimum];
    search_CoursePriceMax = [NSString stringWithFormat:@"%d", (int)selectedMaximum];
    
    GGSearchCourseCell2 *rangeCell = [self.tblSearchCourse cellForRowAtIndexPath:rangeSliderIndexPath];
    
    rangeCell.lblMinPrice.text = [NSString stringWithFormat:@"Rp.%@",[[GGCommonFunc sharedInstance] setSeparatedCurrency:(int)cell2.rsPrice.selectedMinimum]];
    rangeCell.lblMaxPrice.text = [NSString stringWithFormat:@"Rp.%@",[[GGCommonFunc sharedInstance] setSeparatedCurrency:(int)cell2.rsPrice.selectedMaximum]];
    
}

#pragma end


@end
