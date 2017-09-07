//
//  GGCourseHeaderDetail.h
//  GoGolf
//
//  Created by Aprido Sandyasa on 10/31/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGBookPromotionVC.h"
#import "GGCommonFunc.h"

@interface GGCourseHeaderDetail : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *ivCourse;

@property (strong, nonatomic) NSString *courseImage;

@property (nonatomic) NSUInteger imageIndex;

@end
