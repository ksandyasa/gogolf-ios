//
//  GGSearchCourseCell1.h
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/9/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GGSearchGolfCoursePromotionVC.h"
#import "GGCommonFunc.h"

@interface GGSearchCourseCell1 : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *txtDate;

@property (weak, nonatomic) IBOutlet UIImageView *ivSelect;

@property (weak, nonatomic) id searchPromoDelegate;

- (void)showDatePickerFromCell:(UITapGestureRecognizer *)sender;

@end
