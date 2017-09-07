//
//  GGInstallationVC.h
//  GoGolf
//
//  Created by Eddyson Tan on 9/18/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "pageContentViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface GGInstallationVC : UIViewController<UIPageViewControllerDataSource> {
    int currentPage;
}
    
@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) NSArray<NSString *> *titles;
@property (nonatomic, strong) NSArray<NSString *> *texts;
@property (nonatomic, strong) NSArray<NSString *> *wireframes;
@property (nonatomic, strong) NSArray<NSString *> *colors;
@property (nonatomic, strong) NSArray<NSString *> *shadows;

@property (strong, nonatomic) UIPageViewController *pageViewController;
    
@property (weak, nonatomic) IBOutlet UIButton *btnStart;

@property (weak, nonatomic) IBOutlet UIView *bodyView;

@property (weak, nonatomic) IBOutlet UIButton *btnSkipInstall;

@property (weak, nonatomic) IBOutlet UIButton *btnNextInstall;

- (IBAction)skipOrDoneInstall:(id)sender;

- (IBAction)showNextInstall:(id)sender;

@end
