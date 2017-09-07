//
//  GGSearchVC.h
//  GoGolf
//
//  Created by Eddyson Tan on 6/20/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GGGlobalVariable.h"
#import "GGCommonFunc.h"
#import "GGGolfDetailVC.h"
#import "GGSearchCourseVC.h"
#import "GGSearchDetailVC.h"
#import "GGBookPromotionVC.h"
#import "GGPreBookingVC.h"
#import "GGAPICourseManager.h"
#import "GGSearchGolfCourseVC.h"

//@protocol searchDelegate;

@interface GGSearchVC : UIViewController <UITableViewDataSource, UITableViewDelegate> {

}

//@property (nonatomic, weak) id<searchDelegate> delegate;

@property (weak, nonatomic) IBOutlet UITableView *tblSearch;

@property (weak, nonatomic) IBOutlet UIButton *btnSearch;

@property (weak, nonatomic) IBOutlet UILabel *txtEmptySearch;

@property (weak, nonatomic) id searchVCDelegate;

@property (nonatomic) BOOL isSearchEmpty;

- (void) reloadSearchTable;

- (void) showCommonAlert:(NSString *) title message:(NSString *)msg;

@end

//@protocol searchDelegate <NSObject>
//
//- (void) showSearchCourse;
//- (void) showDetailCourse:(NSString *) gid;
//
//@end
