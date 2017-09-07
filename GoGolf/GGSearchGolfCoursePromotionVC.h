//
//  GGSearchGolfCoursePromotionVC.h
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/13/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <MaterialControls/NSDate+MDExtension.h>
#import <MaterialControls/MDDatePickerDialog.h>
#import "GGSearchCourseCell1.h"
#import "GGSearchCourseCell2.h"
#import "GGSearchCourseCell3.h"
#import "GGSearchCourseCell4.h"
#import "GGSearchCourseCell5.h"
#import "GGSearchCourseFooter.h"
#import "GGCommonFunc.h"
#import "GGAPIManager.h"
#import "GGPromotionVC.h"

@interface GGSearchGolfCoursePromotionVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITextFieldDelegate, TTRangeSliderDelegate,
    UIPickerViewDelegate, UIPickerViewDataSource, MDDatePickerDialogDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblSearchGolfPromo;

@property (weak, nonatomic) id promoDelegate;

@property int isWeekend;

- (IBAction)actionGoBack:(id)sender;

- (void)setupCourseListBasedOnAreaID;

- (void)fillCourseNameInput:(NSString *)courseName fromIndeks:(NSInteger)index;

- (void)showDatePickerView;

- (void)showCalendarView;

- (void)searchPromoGolfCourse;

@end
