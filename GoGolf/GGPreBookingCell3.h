//
//  GGPreBookingCell3.h
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/2/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GGPreBookingVC.h"

@interface GGPreBookingCell3 : UITableViewCell <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *lblTitleFilght;

@property (weak, nonatomic) IBOutlet UITextField *txtPreBookingFlightNumber;

@property (weak, nonatomic) id preBookingDelegate;

- (IBAction)chooseFlightNumber:(id)sender;

@end
