//
//  GGSearchPromotionVC.m
//  GoGolf
//
//  Created by Eddyson Tan on 6/21/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGSearchPromotionVC.h"
#import "GGAPIManager.h"

@interface GGSearchPromotionVC ()

@end

@implementation GGSearchPromotionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    
}

-(void)dismissKeyboard {
    
    selectedIndexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    UITableViewCell *cell = [self.tblSearchPromo cellForRowAtIndexPath:selectedIndexPath];
    UITextField *txtCourseName = (UITextField *)[cell viewWithTag:1];
    [txtCourseName resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [_picker reloadAllComponents];
    [_picker selectRow:0 inComponent:0 animated:NO];
    
    search_areaID = @"";
    search_date = @"";
    search_stime = @"00:00";
    search_etime = @"24:00";
    search_priceMin = @"0";
    search_priceMax = @"1000000";
    
}

- (IBAction)rangeSliderValueDidChange:(TTRangeSlider *)slider {
    
    if ([slider tag] == 4) {
        
        selectedIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        UITableViewCell *cell = [self.tblSearchPromo cellForRowAtIndexPath:selectedIndexPath];
        TTRangeSlider *sliderPrice = (TTRangeSlider *)[cell viewWithTag:4];
        
        UILabel *lblMinPrice = (UILabel *) [cell viewWithTag:1];
        UILabel *lblMaxPrice = (UILabel *) [cell viewWithTag:2];
        
        lblMinPrice.text = [NSString stringWithFormat:@"Rp.%@",[[GGCommonFunc sharedInstance] setSeparatedCurrency:(int)sliderPrice.selectedMinimum]];
        lblMaxPrice.text = [NSString stringWithFormat:@"Rp.%@",[[GGCommonFunc sharedInstance] setSeparatedCurrency:(int)sliderPrice.selectedMaximum]];
        
        search_priceMin = [NSString stringWithFormat:@"%d", (int)sliderPrice.selectedMinimum];
        search_priceMax = [NSString stringWithFormat:@"%d", (int)sliderPrice.selectedMaximum];
        
        
    } else if([slider tag] == 5) {
        
        selectedIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
        UITableViewCell *cell = [self.tblSearchPromo cellForRowAtIndexPath:selectedIndexPath];
        TTRangeSlider *sliderTime = (TTRangeSlider *)[cell viewWithTag:5];
        
        UILabel *lblMinTime = (UILabel *) [cell viewWithTag:1];
        UILabel *lblMaxTime = (UILabel *) [cell viewWithTag:2];
        
        if ((int)sliderTime.selectedMinimum < 10)
            lblMinTime.text = [NSString stringWithFormat:@"0%d:00", (int)sliderTime.selectedMinimum];
        else
            lblMinTime.text = [NSString stringWithFormat:@"%d:00", (int)sliderTime.selectedMinimum];
        lblMaxTime.text = [NSString stringWithFormat:@"%d:00", (int)sliderTime.selectedMaximum];
        
        search_stime = lblMinTime.text;
        search_etime = lblMaxTime.text;
        
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)goBack:(id)sender {
    
    if (self.isWeekend == 0) {
        if ([[GGCommonFunc sharedInstance] connected]) {
            [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
            [[GGAPIHomeManager sharedInstance] getPromotionListWithcompletion:^(NSDictionary *responseDict, NSError *error) {
                if (error == nil) {
                    [[GGCommonFunc sharedInstance] hideLoadingImage];
                    if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                        [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                        [[GGAPIManager sharedInstance] clearAllData];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    } else {
                        if ([[responseDict objectForKey:@"data"] count] > 0) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"searchNotification" object:self userInfo:nil];
                            [self dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)goSearchPromo:(id)sender {
    
    
    selectedIndexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    UITableViewCell *cell = [self.tblSearchPromo cellForRowAtIndexPath:selectedIndexPath];
    UILabel *lblAreaName = (UILabel *)[cell viewWithTag:1];
    search_courseName = lblAreaName.text;
    
    if([search_date length] == 0)
        search_date = @"";
    
    else if([search_areaID length] == 0)
        search_areaID = @"";
    
    if ([[GGCommonFunc sharedInstance] connected]) {
        [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
        [[GGAPIHomeManager sharedInstance] searchPromotionWithDate:search_date priceMin:search_priceMin priceMax:search_priceMax start:search_stime end:search_etime areaID:search_areaID courseName:search_courseName completion:^(NSDictionary * responseDict, NSError *error) {
            [[GGCommonFunc sharedInstance] hideLoadingImage];
            if (error == nil) {
                if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                    [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                    [[GGAPIManager sharedInstance] clearAllData];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    if ([[responseDict objectForKey:@"data"] count] > 0) {
                        
                        if (self.isWeekend == 0) {
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"searchNotification" object:self userInfo:nil];
                        } else if (self.isWeekend == 1) {
                            
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"searchWeekendNotification" object:self userInfo:nil];
                        }
                        
                        [self dismissViewControllerAnimated:YES completion:nil];
                        
                    } else {
                        [self showCommonAlert:@"Search Error" message:@"Search Not Found."];
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

- (NSArray *) getStringBeforeChar:(NSString *) character teks:(NSString *)teksString{
    NSArray *textArray = [teksString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:character]];
    
    return textArray;
}

#pragma mark - PickerView

- (IBAction)showListArea:(id)sender {

    [_picker reloadAllComponents];
    [_picker selectRow:0 inComponent:0 animated:NO];
    [self.picker setHidden:NO];
    
    [self showList:sender];
}

- (IBAction)showDatePicker:(id)sender {
    
    [self.picker setHidden:YES];
    
    [self showList:sender];
}

- (IBAction)hideList:(id)sender {
    
    if ([sender tag] == 2) {
        
        pickerRow = [_picker selectedRowInComponent:0];
        
        if (typePicker == 1) {
            
            selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            UITableViewCell *cell = [self.tblSearchPromo cellForRowAtIndexPath:selectedIndexPath];
            UITextField *txtDate = (UITextField *)[cell viewWithTag:1];
            NSDate *date = self.datePicker.date;
            txtDate.text = [[GGCommonFunc sharedInstance] changeDateFormatForSearch:date];
            search_date = txtDate.text;
            
        } else if (typePicker == 6) {
            
            selectedIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
            UITableViewCell *cell = [self.tblSearchPromo cellForRowAtIndexPath:selectedIndexPath];
            UITextField *txtArea = (UITextField *)[cell viewWithTag:1];
            
            if (pickerRow == 0) {
                search_areaID = @"";
                txtArea.text = @"All";
            } else {
                search_areaID = [GGGlobalVariable sharedInstance].itemAreaList[@"data"][pickerRow-1][@"area_id"];
                txtArea.text = [GGGlobalVariable sharedInstance].itemAreaList[@"data"][pickerRow-1][@"area_name"];
            }
        }
    }
    
    
    [self hideBackGround];
}

- (IBAction)showList:(id)sender {
    
    [self dismissKeyboard];
    typePicker = [sender tag];
    
    
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
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.viewPicker.frame = CGRectMake(0, screenRect.size.height + self.viewPicker.frame.size.height, self.viewPicker.frame.size.width, self.viewPicker.frame.size.height);
}

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

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];
    
    return YES;
}

#pragma mark - UITABLEVIEW DELEGATE AND DATASOURCE
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *reCell;
    
    if (indexPath.row == 0) {
        NSString *reuseIdentifier = @"cell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        
        reCell = cell;
        
    } else if (indexPath.row == 1) {
        NSString *reuseIdentifier = @"cell2";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        
        reCell = cell;
    } else if (indexPath.row == 2) {
        NSString *reuseIdentifier = @"cell3";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        
        reCell = cell;
    } else if (indexPath.row == 3) {
        NSString *reuseIdentifier = @"cell4";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        
        reCell = cell;
    } else if (indexPath.row == 4) {
        NSString *reuseIdentifier = @"cell5";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        
        reCell = cell;
    } else if (indexPath.row == 5) {
        NSString *reuseIdentifier = @"cell6";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        
        reCell = cell;
    }
    
    
    return reCell;
}

@end
