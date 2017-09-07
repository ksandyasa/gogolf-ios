//
//  GGSearchCourseCell1.m
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/9/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGSearchCourseCell1.h"

@implementation GGSearchCourseCell1

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UITapGestureRecognizer *tapShowDate = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showDatePickerFromCell:)];
    
    [self.ivSelect addGestureRecognizer:tapShowDate];
    [self.ivSelect setUserInteractionEnabled:true];
    self.ivSelect.image = [self.ivSelect.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.ivSelect setTintColor:[[GGCommonFunc sharedInstance] colorWithHexString:@"FFFFFF"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showDatePickerFromCell:(UITapGestureRecognizer *)sender {
    if ([self.searchPromoDelegate isKindOfClass:[GGSearchGolfCoursePromotionVC class]]) {
        [self.searchPromoDelegate showCalendarView];
    }
}

@end
