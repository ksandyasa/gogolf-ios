//
//  GGSignUpCell3.h
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/9/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GGSignUpVC.h"

@interface GGSignUpCell3 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UIButton *btnMale;

@property (weak, nonatomic) IBOutlet UIButton *btnFemale;

@property (weak, nonatomic) id signUpDelegate;

- (IBAction)actionMale:(id)sender;

- (IBAction)actionFemale:(id)sender;

@end
