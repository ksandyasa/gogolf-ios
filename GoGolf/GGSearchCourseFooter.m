//
//  GGSearchCourseFooter.m
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/10/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGSearchCourseFooter.h"

@interface GGSearchCourseFooter ()

@end

@implementation GGSearchCourseFooter

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.btnSearch.layer.cornerRadius = 5.0;
    self.btnSearch.layer.masksToBounds = true;
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

- (IBAction)actionSearch:(id)sender {
    if ([self.searchDelegate isKindOfClass:[GGSearchGolfCourseVC class]]) {
        [self.searchDelegate searchGolfCourse];
    }else if ([self.searchDelegate isKindOfClass:[GGSearchGolfCoursePromotionVC class]]) {
        [self.searchDelegate searchPromoGolfCourse];
    }
}
@end
