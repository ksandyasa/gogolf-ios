//
//  GGSearchPromotionVC.h
//  GoGolf
//
//  Created by Eddyson Tan on 6/21/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GGAPIHomeManager.h"
#import "GGCommonFunc.h"

#import "GGGlobalVariable.h"
#import "TTRangeSlider.h"

@interface GGSearchPromotionVC : UIViewController <UITableViewDelegate, UITableViewDataSource>{
    NSInteger typePicker;
    NSIndexPath *selectedIndexPath;

    NSInteger pickerRow;
    NSInteger minPickerRow;
    
    NSString *search_date;
    NSString *search_priceMin;
    NSString *search_priceMax;
    NSString *search_stime;
    NSString *search_etime;
    NSString *search_areaID;
    NSString *search_courseName;
}

@property int isWeekend;

@property (weak, nonatomic) IBOutlet UITableView *tblSearchPromo;

@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UIView *backGroundTransparant;

@property (weak, nonatomic) IBOutlet UIView *viewPicker;


@end
