//
//  GGCourseHeader.h
//  GoGolf
//
//  Created by Aprido Sandyasa on 10/31/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <GSKStretchyHeaderView/GSKStretchyHeaderView.h>
#import <GSKStretchyHeaderView/GSKGeometry.h>
#import "GGSearchDetailVC.h"

@interface GGCourseHeader : GSKStretchyHeaderView

@property (weak, nonatomic) IBOutlet UIView *viewSlide;

@property (weak, nonatomic) IBOutlet UIView *viewBelt;

@property (weak, nonatomic) IBOutlet UILabel *lblBelt;

@property (weak, nonatomic) id detailCourseDelegate;

- (IBAction)actionBack:(id)sender;

@end
