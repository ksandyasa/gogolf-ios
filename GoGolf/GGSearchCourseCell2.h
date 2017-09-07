//
//  GGSearchCourseCell2.h
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/9/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <TTRangeSlider/TTRangeSlider.h>

@interface GGSearchCourseCell2 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet TTRangeSlider *rsPrice;

@property (weak, nonatomic) IBOutlet UILabel *lblMinPrice;

@property (weak, nonatomic) IBOutlet UILabel *lblMaxPrice;

@end
