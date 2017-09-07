//
//  GGHomeVC.h
//  GoGolf
//
//  Created by Eddyson Tan on 6/10/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GGCommonFunc.h"
#import "GGProfileVC.h"
#import "GGBookingHistoryVC.h"
#import "GGTutorialVC.h"

#import "GGAPIManager.h"
#import "GGAPIPointManager.h"
#import "GGAPIUserManager.h"

#import "GGNotificationLogVC.h"
#import "GGPaymentVC.h"
#import "GGPaymentConfirmationVC.h"
#import "GGSearchCourseVC.h"
#import "GGBookPromotionVC.h"
#import "GGWeekendPromoVC.h"

#import "UIViewController+JASidePanel.h"
#import "JASidePanelController.h"

#import "CarbonKit.h"

@interface GGHomeVC : UIViewController <UIActionSheetDelegate, CarbonTabSwipeNavigationDelegate, UITextFieldDelegate> {
    NSArray *items;
    CarbonTabSwipeNavigation *carbonTabSwipeNavigation;
    UITextField *txtPromoCode;
}

@property(weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UIView *homeView;

@property (weak, nonatomic) IBOutlet UIButton *btnNotification;

@property (weak, nonatomic) IBOutlet UIView *headerView;

@property (weak, nonatomic) id homeDelegate;

@end
