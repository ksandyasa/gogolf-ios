//
//  GGWeekendPromoVC.h
//  GoGolf
//
//  Created by Eddyson Tan on 9/25/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarbonKit.h"

@interface GGWeekendPromoVC : UIViewController <CarbonTabSwipeNavigationDelegate> {
    
    NSArray *items;
    CarbonTabSwipeNavigation *carbonTabSwipeNavigation;
}


@property(weak, nonatomic) IBOutlet UIToolbar *toolBar;

@property (weak, nonatomic) IBOutlet UIView *bodyView;

@end
