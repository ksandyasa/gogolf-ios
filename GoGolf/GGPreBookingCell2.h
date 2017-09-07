//
//  GGPreBookingCell2.h
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/2/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GGPreBookingVC.h"

@interface GGPreBookingCell2 : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *txtPreBookDate;

@property (weak, nonatomic) id preBookingDelegate;

- (IBAction)choosePreBookDate:(id)sender;

@end
