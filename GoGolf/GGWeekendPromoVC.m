//
//  GGWeekendPromoVC.m
//  GoGolf
//
//  Created by Eddyson Tan on 9/25/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGWeekendPromoVC.h"

@interface GGWeekendPromoVC ()

@end

@implementation GGWeekendPromoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // ====================== CARBON KIT ===========================
    items = @[
              @"Saturday",
              @"Sunday"
              ];
    
    carbonTabSwipeNavigation =
    [[CarbonTabSwipeNavigation alloc] initWithItems:items toolBar:self.toolBar delegate:self];
    [carbonTabSwipeNavigation setCurrentTabIndex:0];
    [carbonTabSwipeNavigation insertIntoRootViewController:self andTargetView:self.bodyView];
    
    [self style];
    
    
    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
    [self setNeedsStatusBarAppearanceUpdate];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (IBAction) goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CARBON KIT
- (void)style {
    
    UIColor *color = [UIColor colorWithRed:82/255.0 green:154/255.0 blue:4/255.0 alpha:1];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = color;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    carbonTabSwipeNavigation.toolbar.translucent = NO;
    [carbonTabSwipeNavigation setIndicatorColor:color];
    [carbonTabSwipeNavigation setTabExtraWidth:30];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    for (int i = 0; i < [items count]; i++) {
        [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:screenRect.size.width/[items count] forSegmentAtIndex:i];
    }
    
    // Custimize segmented control
    [carbonTabSwipeNavigation setNormalColor:[color colorWithAlphaComponent:0.6]
                                        font:[UIFont boldSystemFontOfSize:14]];
    [carbonTabSwipeNavigation setSelectedColor:color font:[UIFont boldSystemFontOfSize:14]];
}

#pragma mark - CarbonTabSwipeNavigation Delegate
// required
- (nonnull UIViewController *)carbonTabSwipeNavigation:
(nonnull CarbonTabSwipeNavigation *)carbontTabSwipeNavigation
                                 viewControllerAtIndex:(NSUInteger)index {
    switch (index) {
        case 0:
            return [self.storyboard instantiateViewControllerWithIdentifier:@"saturdayPromoVC"];
            
        case 1:
            return [self.storyboard instantiateViewControllerWithIdentifier:@"sundayPromoVC"];
            
        default:
            return [self.storyboard instantiateViewControllerWithIdentifier:@"weekendPromoVC"];
    }
}

// optional
- (void)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
                 willMoveAtIndex:(NSUInteger)index {
    switch (index) {
        case 0:
            self.title = @"Saturday";
            break;
        case 1:
            self.title = @"Sunday";
            break;
        default:
            self.title = items[index];
            break;
    }
}

- (void)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
                  didMoveAtIndex:(NSUInteger)index {
}

- (UIBarPosition)barPositionForCarbonTabSwipeNavigation:
(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation {
    return UIBarPositionTop; // default UIBarPositionTop
}

@end
