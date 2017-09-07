//
//  GGSearchGolfCoursePromotionVC.m
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/13/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGSearchGolfCoursePromotionVC.h"

@interface GGSearchGolfCoursePromotionVC () {
    GGSearchCourseCell1 *cell1;
    GGSearchCourseCell2 *cell2;
    GGSearchCourseCell3 *cell3;
    GGSearchCourseCell4 *cell4;
    GGSearchCourseCell5 *cell5;
    GGSearchCourseFooter *footerView;
    MDDatePickerDialog *calendarView;
    UIAlertController *datePickerPopup;
    UIDatePicker *datePicker;
    UITextField *txtCourseName;
    GGAreaCell *cellArea;
    NSArray *coursePromoDict;
    NSIndexPath *rangePromoSliderIndexPath;
    NSString *promoCoursePriceMin;
    NSString *promoCoursePriceMax;
    NSIndexPath *rangePromoTTimeIndexPath;
    NSString *promoCourseTTimeMin;
    NSString *promoCourseTTimeMax;
}

@end

static NSString *cellIdentifier1 = @"searchCourseCell1";
static NSString *cellIdentifier2 = @"searchCourseCell2";
static NSString *cellIdentifier3 = @"searchCourseCell3";
static NSString *cellIdentifier4 = @"searchCourseCell4";
static NSString *cellIdentifier5 = @"searchCourseCell5";
static NSString *colCellIdentifier1 = @"areaCell";
NSString *areaPromoID = @"";
NSInteger selecPromoCourse = 0;
NSString *courNamePromoString = @"";
NSString *promoDate = @"";

@implementation GGSearchGolfCoursePromotionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    promoDate = @"";
    courNamePromoString = @"";
    selecPromoCourse = 0;
    areaPromoID = @"";
    // Do any additional setup after loading the view.
    
    [self.tblSearchGolfPromo registerNib:[UINib nibWithNibName:@"GGSearchCourseCell1" bundle:nil] forCellReuseIdentifier:cellIdentifier1];
    [self.tblSearchGolfPromo registerNib:[UINib nibWithNibName:@"GGSearchCourseCell2" bundle:nil] forCellReuseIdentifier:cellIdentifier2];
    [self.tblSearchGolfPromo registerNib:[UINib nibWithNibName:@"GGSearchCourseCell3" bundle:nil] forCellReuseIdentifier:cellIdentifier3];
    [self.tblSearchGolfPromo registerNib:[UINib nibWithNibName:@"GGSearchCourseCell4" bundle:nil] forCellReuseIdentifier:cellIdentifier4];
    [self.tblSearchGolfPromo registerNib:[UINib nibWithNibName:@"GGSearchCourseCell5" bundle:nil] forCellReuseIdentifier:cellIdentifier5];
    
    [self.tblSearchGolfPromo setDelegate:self];
    [self.tblSearchGolfPromo setDataSource:self];
    [self.tblSearchGolfPromo setDelaysContentTouches:false];

    //[self setupFooterView];
//    [self setupDatePickerView];
    [self setupCalendarView];
}

- (void)setupFooterView {
    footerView = [[GGSearchCourseFooter alloc] initWithNibName:@"GGSearchCourseFooter" bundle:nil];
    [self addChildViewController:footerView];
    footerView.searchDelegate = self;
    [self.tblSearchGolfPromo setTableFooterView:footerView.view];
    [footerView didMoveToParentViewController:self];
}

- (void)setupCourseListBasedOnAreaID {
    
    if ([[GGCommonFunc sharedInstance] connected]) {
        [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
        [[GGAPIHomeManager sharedInstance] getMapListWithID:areaPromoID Completion:^(NSDictionary *responseDict, NSError *error) {
            [[GGCommonFunc sharedInstance] hideLoadingImage];
            if (error == nil) {
                if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                    [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                    [[GGAPIManager sharedInstance] clearAllData];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    if ([[responseDict objectForKey:@"data"] count] > 0) {
                        
                        coursePromoDict = [[GGGlobalVariable sharedInstance].itemMapList objectForKey:@"data"];
                        selecPromoCourse = 0;
                        NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:4 inSection:0];
                        NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
                        [self.tblSearchGolfPromo reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationAutomatic];
                        
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
        [self showCommonAlert:@"Alert" message:@"No internet connection."];
    }
}

- (void)fillCourseNameInput:(NSString *)courseName fromIndeks:(NSInteger)index {
    selecPromoCourse = index;
    courNamePromoString = courseName;
    txtCourseName.text = courNamePromoString;
    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:4 inSection:0];
    NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
    [self.tblSearchGolfPromo reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)setupDatePickerView {
    datePickerPopup = [UIAlertController alertControllerWithTitle:@"Choose Date" message:@"\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Done"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    promoDate = [[GGCommonFunc sharedInstance] getDateFromDatePicker:datePicker.date];
                                    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:0 inSection:0];
                                    NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
                                    [self.tblSearchGolfPromo reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationAutomatic];

                                }];
    
    [datePickerPopup addAction:yesButton];
    
    datePicker = [[UIDatePicker alloc] init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setMinimumDate:[NSDate date]];
    datePicker.tag = 90;
    
    [datePickerPopup.view addSubview:datePicker];
}

- (void)showDatePickerView {
    [self presentViewController:datePickerPopup animated:true completion:nil];    
}

- (void)setupCalendarView {
    calendarView = [[MDDatePickerDialog alloc] init];
    calendarView.minimumDate = [NSDate date];
    calendarView.selectedDate = [NSDate date];
    calendarView.delegate = self;
}

- (void)showCalendarView {
    [calendarView show];
}

- (void)searchPromoGolfCourse {
    NSLog(@"promoDate %@", promoDate);
    NSLog(@"promoCoursePriceMin %@", promoCoursePriceMin);
    NSLog(@"promoCoursePriceMax %@", promoCoursePriceMax);
    NSLog(@"promoCourseTTimeMin %@", promoCourseTTimeMin);
    NSLog(@"promoCourseTTimeMax %@", promoCourseTTimeMax);
    NSLog(@"areaPromoID %@", areaPromoID);
    NSLog(@"courNameString %@", courNamePromoString);
    
    if ([[GGCommonFunc sharedInstance] connected]) {
        [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
        [[GGAPIHomeManager sharedInstance] searchPromotionWithDate:promoDate priceMin:promoCoursePriceMin priceMax:promoCoursePriceMax start:promoCourseTTimeMin end:promoCourseTTimeMax areaID:areaPromoID courseName:courNamePromoString completion:^(NSDictionary * responseDict, NSError *error) {
            [[GGCommonFunc sharedInstance] hideLoadingImage];
            if (error == nil) {
                if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                    [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                    [[GGAPIManager sharedInstance] clearAllData];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    if ([[responseDict objectForKey:@"data"] count] > 0) {
                        NSLog(@"responseDict %@", [responseDict description]);
                        [GGGlobalVariable sharedInstance].itemPromotionList = responseDict;
                        
                        if (self.isWeekend == 0) {
                            
                            //                        [[NSNotificationCenter defaultCenter] postNotificationName:@"searchNotification" object:self userInfo:nil];
                        } else if (self.isWeekend == 1) {
                            
                            //                        [[NSNotificationCenter defaultCenter] postNotificationName:@"searchWeekendNotification" object:self userInfo:nil];
                        }
                        
                        [self dismissViewControllerAnimated:true completion:^{
                            if ([self.promoDelegate isKindOfClass:[GGPromotionVC class]]) {
                                ((GGPromotionVC *)self.promoDelegate).isPromoEmpty = NO;
                                ((GGPromotionVC *)self.promoDelegate).txtEmptyPromotion.hidden = YES;
                                [self.promoDelegate reloadSearchTable];
                            }
                        }];
                    } else {
                        [self dismissViewControllerAnimated:true completion:^{
                            if ([self.promoDelegate isKindOfClass:[GGPromotionVC class]]) {
//                                [self.promoDelegate showCommonAlert:@"Search Error" message:@"Search Not Found."];
                                ((GGPromotionVC *)self.promoDelegate).isPromoEmpty = YES;
                                ((GGPromotionVC *)self.promoDelegate).txtEmptyPromotion.hidden = NO;
                                ((GGPromotionVC *)self.promoDelegate).txtEmptyPromotion.text = [NSString stringWithFormat:@"Search not found."];
                                [self.promoDelegate reloadSearchTable];
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
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        cell1 = (GGSearchCourseCell1 *)[self.tblSearchGolfPromo dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (cell1 == nil) {
            NSArray *cellArray2 = [[NSBundle mainBundle] loadNibNamed:@"GGSearchCourseCell1" owner:self options:nil];
            cell1 = [cellArray2 objectAtIndex:0];
        }
        
        cell1.searchPromoDelegate = self;
        cell1.txtDate.delegate = self;
        cell1.txtDate.text = promoDate;
        
        return cell1;
        
    } else if (indexPath.row == 1) {
        rangePromoSliderIndexPath = indexPath;
        
        cell2 = (GGSearchCourseCell2 *)[self.tblSearchGolfPromo dequeueReusableCellWithIdentifier:cellIdentifier2];
        if (cell2 == nil) {
            NSArray *cellArray2 = [[NSBundle mainBundle] loadNibNamed:@"GGSearchCourseCell2" owner:self options:nil];
            cell2 = [cellArray2 objectAtIndex:0];
        }
        
        cell2.lblTitle.text = @"Price Range";
        cell2.rsPrice.tag = 20;
        cell2.rsPrice.delegate = self;
        promoCoursePriceMin = [NSString stringWithFormat:@"%d", (int)cell2.rsPrice.selectedMinimum];
        promoCoursePriceMax = [NSString stringWithFormat:@"%d", (int)cell2.rsPrice.selectedMaximum];
        
        return cell2;
        
    } else if (indexPath.row == 2) {
        rangePromoTTimeIndexPath = indexPath;
        
        cell5 = (GGSearchCourseCell5 *)[self.tblSearchGolfPromo dequeueReusableCellWithIdentifier:cellIdentifier5];
        if (cell5 == nil) {
            NSArray *cellArray2 = [[NSBundle mainBundle] loadNibNamed:@"GGSearchCourseCell5" owner:self options:nil];
            cell5 = [cellArray2 objectAtIndex:0];
        }
        
        cell5.lblTitle.text = @"Tee Time";
        cell5.rsTTime.tag = 21;
        cell5.rsTTime.delegate = self;
        promoCourseTTimeMin = [NSString stringWithFormat:@"0%d:00", (int)cell5.rsTTime.selectedMinimum];
        promoCourseTTimeMax = [NSString stringWithFormat:@"%d:00", (int)cell5.rsTTime.selectedMaximum];
        
        return cell5;
        
    } else if (indexPath.row == 3) {
        
        cell3 = (GGSearchCourseCell3 *)[self.tblSearchGolfPromo dequeueReusableCellWithIdentifier:cellIdentifier3];
        if (cell3 == nil) {
            NSArray *cellArray2 = [[NSBundle mainBundle] loadNibNamed:@"GGSearchCourseCell3" owner:self options:nil];
            cell3 = [cellArray2 objectAtIndex:0];
        }
        
        [cell3.colAreaList registerNib:[UINib nibWithNibName:@"GGAreaCell" bundle:nil] forCellWithReuseIdentifier:colCellIdentifier1];
        [cell3.colAreaList setDelegate:self];
        [cell3.colAreaList setDataSource:self];
        [cell3.colAreaList setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        return cell3;
        
    } else if (indexPath.row == 4) {
        
        cell4 = (GGSearchCourseCell4 *)[self.tblSearchGolfPromo dequeueReusableCellWithIdentifier:cellIdentifier4];
        if (cell2 == nil) {
            NSArray *cellArray2 = [[NSBundle mainBundle] loadNibNamed:@"GGSearchCourseCell4" owner:self options:nil];
            cell4 = [cellArray2 objectAtIndex:0];
        }
        
        cell4.searchDelegate = self;
        cell4.txtCourse.text = courNamePromoString;
        txtCourseName = cell4.txtCourse;
        txtCourseName.delegate = self;
        cell4.courseDict = coursePromoDict;
        [cell4 reloadCourseList:selecPromoCourse];
        
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
    if (indexPath.row == 4)
        return 133.0;
    
    return 95.0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    
    return 60;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        return 133.0;
    }
    
    return 95.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 60;
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
    
    areaPromoID = [GGGlobalVariable sharedInstance].itemAreaList[@"data"][indexPath.row][@"area_id"];
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

#pragma mark TTRangeSliderViewDelegate
-(void)rangeSlider:(TTRangeSlider *)sender didChangeSelectedMinimumValue:(float)selectedMinimum andMaximumValue:(float)selectedMaximum{
    NSLog(@"didChange");
    if (sender.tag == 20) {
        promoCoursePriceMin = [NSString stringWithFormat:@"%d", (int)selectedMinimum];
        promoCoursePriceMax = [NSString stringWithFormat:@"%d", (int)selectedMaximum];
        
        GGSearchCourseCell2 *rangeCell = [self.tblSearchGolfPromo cellForRowAtIndexPath:rangePromoSliderIndexPath];
        
        rangeCell.lblMinPrice.text = [NSString stringWithFormat:@"Rp.%@",[[GGCommonFunc sharedInstance] setSeparatedCurrency:(int)rangeCell.rsPrice.selectedMinimum]];
        rangeCell.lblMaxPrice.text = [NSString stringWithFormat:@"Rp.%@",[[GGCommonFunc sharedInstance] setSeparatedCurrency:(int)rangeCell.rsPrice.selectedMaximum]];
    }else if (sender.tag == 21) {
        GGSearchCourseCell5 *rangeTTimeCell = [self.tblSearchGolfPromo cellForRowAtIndexPath:rangePromoTTimeIndexPath];
        
        if ((int)rangeTTimeCell.rsTTime.selectedMinimum < 10)
            rangeTTimeCell.lblMinTTime.text = [NSString stringWithFormat:@"0%d:00", (int)rangeTTimeCell.rsTTime.selectedMinimum];
        else
            rangeTTimeCell.lblMinTTime.text = [NSString stringWithFormat:@"%d:00", (int)rangeTTimeCell.rsTTime.selectedMinimum];
        if ((int)rangeTTimeCell.rsTTime.selectedMaximum < 10)
            rangeTTimeCell.lblMaxTTime.text = [NSString stringWithFormat:@"0%d:00", (int)rangeTTimeCell.rsTTime.selectedMaximum];
        else
            rangeTTimeCell.lblMaxTTime.text = [NSString stringWithFormat:@"%d:00", (int)rangeTTimeCell.rsTTime.selectedMaximum];
        
        promoCourseTTimeMin = rangeTTimeCell.lblMinTTime.text;
        promoCourseTTimeMax = rangeTTimeCell.lblMaxTTime.text;

    }
}

#pragma end

#pragma mark - UIPICKER
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    
    return 0;
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [[GGCommonFunc sharedInstance] setViewMovedUp:YES fromView:self.view fromPos:4];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [[GGCommonFunc sharedInstance] setViewMovedUp:NO fromView:self.view fromPos:4];
}

#pragma end

#pragma mark - MDDATEPICKERDIALOGDELEGATE

- (void)datePickerDialogDidSelectDate:(NSDate *)date {
    promoDate = [[GGCommonFunc sharedInstance] getDateFromDatePicker:date];
    NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:0 inSection:0];
    NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
    [self.tblSearchGolfPromo reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationAutomatic];
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
    [self dismissViewControllerAnimated:true completion:^{
        if ([self.promoDelegate isKindOfClass:[GGPromotionVC class]]) {
            [self.promoDelegate reloadSearchTable];
        }
    }];
}

@end
