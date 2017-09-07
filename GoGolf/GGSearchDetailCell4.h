//
//  GGSearchDetailCell4.h
//  GoGolf
//
//  Created by Aprido Sandyasa on 10/31/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGCommonFunc.h"

@interface GGSearchDetailCell4 : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, retain) NSDictionary *courseDetailArr;

@property (weak, nonatomic) IBOutlet UILabel *lblCoursePromo;

@property (weak, nonatomic) IBOutlet UILabel *lblCourseNotAvailable;

@property (weak, nonatomic) IBOutlet UICollectionView *colCoursePromo;

@end
