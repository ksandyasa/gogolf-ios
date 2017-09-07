//
//  GGBookPromotionVC.h
//  GoGolf
//
//  Created by Eddyson Tan on 7/2/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGCommonFunc.h"

#import "GGGlobalVariable.h"
#import "GGAPICourseManager.h"

#import "GGBookingConfirmationVC.h"

@interface GGBookPromotionVC : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate>{
    NSInteger typePicker, typeCondition, typePromo;
    
    NSInteger totalFlightPrice, totalAllPrice;
    
    int countPrice, countRate;
    NSMutableDictionary *listTeeTimeArr;
    NSMutableDictionary *flightPriceArr, *depRateArr, *condArr;
    NSDictionary *listTypePlayer;
    
    NSMutableArray *typePlayerArr,  *eachFlightDataArr;
    
    NSIndexPath *collSelectedIndexPath;
    
    bool isPriceCart;
    NSArray *typeArr;
    
    bool isCart1, isCart2, isCart3, isCart4;
}

@property bool isHomeList;

@property (weak, nonatomic) IBOutlet UICollectionView *flightCollection;
@property (weak, nonatomic) IBOutlet UIView *timeVIew;
@property (weak, nonatomic) IBOutlet UITableView *tblTimeBook;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flightCollHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeightConstraint;

@property (weak, nonatomic) IBOutlet UITextField *txtFlightNumber;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *imgBookPromo;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIView *flightView;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (weak, nonatomic) IBOutlet UIView *backGroundTransparant;

@property (weak, nonatomic) IBOutlet UIView *viewPicker;

@property (weak, nonatomic) IBOutlet UITextField *txtDate;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;

@property (weak, nonatomic) IBOutlet UILabel *lblCourseTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblCoursePrice;
@property (weak, nonatomic) IBOutlet UILabel *lblCourseDisc;
@property (weak, nonatomic) IBOutlet UILabel *lblCourseDate;
@property (weak, nonatomic) IBOutlet UILabel *lblCourseTime;
@property (weak, nonatomic) IBOutlet UILabel *lblCourseLimit;

@property (weak, nonatomic) NSDictionary *detailArr;
@property (weak, nonatomic) NSDictionary *timeArr;

//@property (nonatomic, readwrite) NSInteger itemIndex;

@property (weak, nonatomic) IBOutlet UILabel *lblTotalPrice;
@property (weak, nonatomic) IBOutlet UILabel *lblTotalDepositRate;

@end
