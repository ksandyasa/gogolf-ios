//
//  GGPreBookingCell3.m
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/2/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGPreBookingCell3.h"

@implementation GGPreBookingCell3

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.txtPreBookingFlightNumber.delegate = self;
    
    self.txtPreBookingFlightNumber.layer.cornerRadius = 5.0;
    self.txtPreBookingFlightNumber.layer.masksToBounds = true;
    self.txtPreBookingFlightNumber.layer.borderWidth = 1.0;
    self.txtPreBookingFlightNumber.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    UITapGestureRecognizer *tapFlight = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseFlightNumberFromInput:)];
    [self.lblTitleFilght addGestureRecognizer:tapFlight];
    [self.lblTitleFilght setUserInteractionEnabled:true];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)chooseFlightNumberFromInput:(UITapGestureRecognizer *)sender {
    NSLog(@"tap show flight picker");
    if ([self.preBookingDelegate isKindOfClass:[GGPreBookingVC class]]) {
        [self.preBookingDelegate showPreBookingFlightPicker];
    }
}

- (IBAction)chooseFlightNumber:(id)sender {
    NSLog(@"click show flight picker");
    if ([self.preBookingDelegate isKindOfClass:[GGPreBookingVC class]]) {
        [self.preBookingDelegate showPreBookingFlightPicker];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.txtPreBookingFlightNumber) {
        NSLog(@"aaaaa");
        [self chooseFlightNumberFromInput:nil];
        
        return NO;
    }
    
    return YES;
}

@end
