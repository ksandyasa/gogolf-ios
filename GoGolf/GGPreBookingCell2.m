//
//  GGPreBookingCell2.m
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/2/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGPreBookingCell2.h"

@implementation GGPreBookingCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.txtPreBookDate.layer.cornerRadius = 5.0;
    self.txtPreBookDate.layer.masksToBounds = true;
    self.txtPreBookDate.layer.borderWidth = 1.0;
    self.txtPreBookDate.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    UITapGestureRecognizer *tapDatePicker = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choosePreBookDateFromInput:)];
    [self.txtPreBookDate addGestureRecognizer:tapDatePicker];
    [self.txtPreBookDate setUserInteractionEnabled:true];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)choosePreBookDateFromInput:(UITapGestureRecognizer *)sender {
    NSLog(@"tap show datepicker");
    if ([self.preBookingDelegate isKindOfClass:[GGPreBookingVC class]]) {
        [self.preBookingDelegate showPreBookingCalendarView];
    }
}

- (IBAction)choosePreBookDate:(id)sender {
    NSLog(@"click show datepicker");
    if ([self.preBookingDelegate isKindOfClass:[GGPreBookingVC class]]) {
        [self.preBookingDelegate showPreBookingCalendarView];
    }
}

@end
