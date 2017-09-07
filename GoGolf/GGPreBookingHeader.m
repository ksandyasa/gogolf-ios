//
//  GGPreBookingHeader.m
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/2/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGPreBookingHeader.h"

@interface GGPreBookingHeader ()

@end

@implementation GGPreBookingHeader

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.lblPreCourseDisc.layer.cornerRadius = 5.0;
    self.lblPreCourseDisc.layer.masksToBounds = true;
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
