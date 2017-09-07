//
//  GGSearchCourseCell5.h
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/13/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <TTRangeSlider/TTRangeSlider.h>

@interface GGSearchCourseCell5 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblMinTTime;
@property (weak, nonatomic) IBOutlet UILabel *lblMaxTTime;
@property (weak, nonatomic) IBOutlet TTRangeSlider *rsTTime;
@end
