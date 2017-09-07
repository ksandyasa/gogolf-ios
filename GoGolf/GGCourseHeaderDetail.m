//
//  GGCourseHeaderDetail.m
//  GoGolf
//
//  Created by Aprido Sandyasa on 10/31/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGCourseHeaderDetail.h"

@interface GGCourseHeaderDetail ()

@end

@implementation GGCourseHeaderDetail

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (![self.courseImage isEqualToString:@""]) {
        if ([[GGCommonFunc sharedInstance] connected]) {
            [[GGCommonFunc sharedInstance] setLazyLoadImage:self.ivCourse urlString:self.courseImage];
        }
    } else {
        self.ivCourse.image = [UIImage imageNamed:@"def_big_img"];
    }
    [self.ivCourse setContentMode:UIViewContentModeScaleToFill];
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
