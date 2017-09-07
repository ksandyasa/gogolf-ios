//
//  GGSearchCourseVC.h
//  GoGolf
//
//  Created by Eddyson Tan on 6/29/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GGAPICourseManager.h"
#import "GGCommonFunc.h"
#import "TTRangeSlider.h"
#import "GGGlobalVariable.h"
#import "GGAPIHomeManager.h"

@interface GGSearchCourseVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, TTRangeSliderDelegate>{
    
    NSInteger typePicker;
    NSIndexPath *selectedIndexPath;
    
    NSInteger pickerRow;
    NSInteger minPickerRow;
    
    NSString *search_CoursePriceMin;
    NSString *search_CoursePriceMax;
    NSString *search_CourseAreaID;
    NSString *search_CourseName;
}

@property (weak, nonatomic) IBOutlet UITableView *tblSearchCourse;

- (void)setupCourseListBasedOnAreaID;

- (void)fillCourseNameInput:(NSString *)courseName fromIndeks:(NSInteger)index;

@end
