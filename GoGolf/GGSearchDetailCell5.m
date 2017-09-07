//
//  GGSearchDetailCell5.m
//  GoGolf
//
//  Created by Aprido Sandyasa on 10/31/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGSearchDetailCell5.h"

@implementation GGSearchDetailCell5

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.btnCourseBook.layer.cornerRadius = 5;
    self.btnCourseBook.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)bookNow:(id)sender {
    NSLog(@"clicked from cell5");
    if ([self.searchDetailDelegate isKindOfClass:[GGSearchDetailVC class]]) {
        [self.searchDetailDelegate bookGolfCourse];
    }
}

@end
