//
//  GGSearchDetailCell2.m
//  GoGolf
//
//  Created by Aprido Sandyasa on 10/31/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGSearchDetailCell2.h"

@implementation GGSearchDetailCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.lblTitle.text = @"About";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
