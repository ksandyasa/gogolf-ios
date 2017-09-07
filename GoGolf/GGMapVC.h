//
//  GGMapVC.h
//  GoGolf
//
//  Created by Eddyson Tan on 6/20/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GGGolfDetailVC.h"
#import "GGSearchDetailVC.h"
#import "GGAPIHomeManager.h"
#import "GGAPICourseManager.h"
#import "GGGlobalVariable.h"

#import "GGCommonFunc.h"
#import "GGGlobalVariable.h"

#import "MBProgressHUD.h"

@import GoogleMaps;

//@protocol mapsDelegate;

@interface GGMapVC : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, GMSMapViewDelegate>{
    GMSMapView *mapView_;
    NSString *areaID;
}

//@property (nonatomic, weak) id<mapsDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *viewBodyMaps;

@property (weak, nonatomic) IBOutlet UITextField *txtMapsArea;

@property (weak, nonatomic) IBOutlet UIButton *btnShowArea;

@property (weak, nonatomic) IBOutlet UIButton *btnSearchMap;

@property (weak, nonatomic) IBOutlet UIPickerView *pickerArea;

@property (weak, nonatomic) IBOutlet UIView *backGroundTransparant;

@property (weak, nonatomic) IBOutlet UIView *viewPicker;

@end

//@protocol mapsDelegate <NSObject>
//
//- (void) showDetailCourse:(NSString *) gid;
//
//@end
