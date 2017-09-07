//
//  GGSearchDetailCell1.h
//  GoGolf
//
//  Created by Aprido Sandyasa on 10/31/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GGSearchDetailCell1 : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *lblCourseName;

@property (weak, nonatomic) IBOutlet UILabel *lblCourseAddress;

@property (strong, nonatomic) NSString *courseName;

@property (strong, nonatomic) NSString *courseAddress;

@end
