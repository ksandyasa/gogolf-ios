//
//  GGPreBookingHeader.h
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/2/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GGPreBookingHeader : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *ivPreCourse;

@property (weak, nonatomic) IBOutlet UILabel *lblPreCourseName;

@property (weak, nonatomic) IBOutlet UILabel *lblPreCoursePrice;

@property (weak, nonatomic) IBOutlet UILabel *lblPreCoursePPrice;

@property (weak, nonatomic) IBOutlet UILabel *lblPreCourseDisc;

@end
