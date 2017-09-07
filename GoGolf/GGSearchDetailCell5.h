//
//  GGSearchDetailCell5.h
//  GoGolf
//
//  Created by Aprido Sandyasa on 10/31/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GGSearchDetailVC.h"

@interface GGSearchDetailCell5 : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btnCourseBook;

@property (weak, nonatomic) id searchDetailDelegate;

- (IBAction)bookNow:(id)sender;

@end
