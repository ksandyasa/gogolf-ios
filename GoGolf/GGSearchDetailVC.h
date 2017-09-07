//
//  GGSearchDetailVC.h
//  GoGolf
//
//  Created by Aprido Sandyasa on 10/31/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "GGCourseHeader.h"
#import "GGCourseHeaderDetail.h"
#import "GGSearchDetailCell1.h"
#import "GGSearchDetailCell2.h"
#import "GGSearchDetailCell3.h"
#import "GGSearchDetailCell4.h"
#import "GGSearchDetailCell5.h"
#import "GGSearchDetailCell6.h"
#import "GGSearchDetailCell7.h"
#import "GGBookPromotionVC.h"
#import "GGPreBookingVC.h"
#import "GGGoogleMapsVC.h"
#import "UIPageViewControllerWithOverlayIndicator.h"

@interface GGSearchDetailVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblDetailGourse;

@property (nonatomic, retain) NSDictionary *courseDetailArr;

@property (strong, nonatomic) UIPageViewControllerWithOverlayIndicator *slideVC;

@property (strong, nonatomic) GGCourseHeaderDetail *slideContentVC;

@property (strong, nonatomic) NSArray *slideArray;

@property (strong, nonnull) GMSMapView *mapCourseView;

@property (nonatomic) BOOL isMapLoaded;

@property (weak, nonatomic) id searchListDelegate;

- (void)backToSearchView;

- (void)bookGolfCourse;

@end
