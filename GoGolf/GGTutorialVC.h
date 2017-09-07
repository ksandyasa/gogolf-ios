//
//  GGTutorialVC.h
//  GoGolf
//
//  Created by Eddyson Tan on 6/14/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "pageContentViewController.h"

@interface GGTutorialVC : UIViewController <UIPageViewControllerDataSource> {
    int currentPage;
}

@property (retain, nonatomic) IBOutlet UIPageControl *pageControl;

@property (nonatomic, strong) NSArray<NSString *> *titles;
@property (nonatomic, strong) NSArray<NSString *> *texts;
@property (nonatomic, strong) NSArray<NSString *> *wireframes;
@property (nonatomic, strong) NSArray<NSString *> *colors;
@property (nonatomic, strong) NSArray<NSString *> *shadows;

@property (strong, nonatomic) UIPageViewController *pageViewController;

@property (weak, nonatomic) IBOutlet UIView *bodyView;
@property (weak, nonatomic) IBOutlet UIButton *btnDoneTut;
@property (weak, nonatomic) IBOutlet UIButton *btnNextTut;

- (IBAction)skipOrDoneTutorial:(id)sender;
- (IBAction)showNextTutorial:(id)sender;

@end
