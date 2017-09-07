//
//  GGHomePageVC.h
//  GoGolf
//
//  Created by Eddyson Tan on 6/10/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "JASidePanelController.h"
#import "GGAPIManager.h"
#import "GGAPIHomeManager.h"
#import "GGAPICourseManager.h"
#import "GGCommonFunc.h"

@interface GGHomePageVC : JASidePanelController

@property (weak, nonatomic) UIView *homePageView;

@end
