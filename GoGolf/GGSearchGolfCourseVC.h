//
//  GGSearchGolfCourseVC.h
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/11/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GGCommonFunc.h"
#import "GGGlobalVariable.h"
#import "GGSearchCourseCell2.h"
#import "GGSearchCourseCell3.h"
#import "GGSearchCourseCell4.h"
#import "GGSearchCourseFooter.h"
#import "GGAreaCell.h"
#import "GGAPIManager.h"
#import "GGCommonFunc.h"
#import "GGSearchVC.h"

@interface GGSearchGolfCourseVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, TTRangeSliderDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UITableView *tblSearchGolfCourse;

@property (weak, nonatomic) id searchDelegate;

- (IBAction)actionGoBack:(id)sender;

- (void)setupCourseListBasedOnAreaID;

- (void)fillCourseNameInput:(NSString *)courseName fromIndeks:(NSInteger)index;

- (void)searchGolfCourse;

@end
