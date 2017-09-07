//
//  GGPreBookingCell6.m
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/2/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGPreBookingCell6.h"

@implementation GGPreBookingCell6

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.btnPreBookNow.layer.cornerRadius = 5.9;
    self.btnPreBookNow.layer.masksToBounds = true;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionBookNow:(id)sender {
    if ([self.preBookingDelegate isKindOfClass:[GGPreBookingVC class]]) {
        [self.btnPreBookNow setEnabled:false];
        [self.preBookingDelegate goToBookingConfirmationView];
    }
}

@end
