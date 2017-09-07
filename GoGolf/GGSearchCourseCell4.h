//
//  GGSearchCourseCell4.h
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/9/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GGCourseCell.h"
#import "GGCommonFunc.h"
#import "GGSearchGolfCourseVC.h"
#import "GGSearchGolfCoursePromotionVC.h"

@interface GGSearchCourseCell4 : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UITextField *txtCourse;

@property (weak, nonatomic) IBOutlet UICollectionView *colCourseList;

@property (strong, nonatomic) NSArray *courseDict;

@property (weak, nonatomic) id searchDelegate;

- (void)reloadCourseList:(NSInteger)selectedIndex;

@end
