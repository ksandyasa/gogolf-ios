//
//  GGSearchCourseFooter.h
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/10/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GGSearchGolfCourseVC.h"
#import "GGSearchGolfCoursePromotionVC.h"

@interface GGSearchCourseFooter : UIViewController

@property (weak, nonatomic) IBOutlet UIButton *btnSearch;

@property (weak, nonatomic) id searchDelegate;

- (IBAction)actionSearch:(id)sender;

@end
