//
//  UIPageViewControllerWithOverlayIndicator.m
//  GoGolf
//
//  Created by Aprido Sandyasa on 10/31/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "UIPageViewControllerWithOverlayIndicator.h"

@interface UIPageViewControllerWithOverlayIndicator ()

@end

@implementation UIPageViewControllerWithOverlayIndicator

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidLayoutSubviews {
    
    for (UIView *subView in self.view.subviews) {
        if ([subView isKindOfClass:[UIScrollView class]]) {
            subView.frame = self.view.bounds;
        } else if ([subView isKindOfClass:[UIPageControl class]]) {
            [self.view bringSubviewToFront:subView];
        }
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
