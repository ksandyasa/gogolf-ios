//
//  GGSignUpCell3.m
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/9/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGSignUpCell3.h"

@implementation GGSignUpCell3

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.btnMale.selected = true;
    self.btnFemale.selected = false;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionMale:(id)sender {
    self.btnMale.selected = true;
    self.btnFemale.selected = false;
    if ([self.signUpDelegate isKindOfClass:[GGSignUpVC class]]) {
        [self.signUpDelegate setupMaleGender];
    }
}

- (IBAction)actionFemale:(id)sender {
    self.btnFemale.selected = true;
    self.btnMale.selected = false;
    if ([self.signUpDelegate isKindOfClass:[GGSignUpVC class]]) {
        [self.signUpDelegate setupFemaleGender];
    }
}
@end
