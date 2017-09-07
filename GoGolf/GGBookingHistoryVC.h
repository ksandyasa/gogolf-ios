//
//  GGBookingHistoryVC.h
//  GoGolf
//
//  Created by Eddyson Tan on 6/14/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GGGlobalVariable.h"
#import "GGAPIBookingManager.h"

#import "GGBookingDetailVC.h"
#import "GGCommonFunc.h"


@interface GGBookingHistoryVC : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    NSString *statusApps;
    NSString *sdate;
    NSString *edate;
}

@property (weak, nonatomic) IBOutlet UILabel *lblBookingTeks;

@property (weak, nonatomic) IBOutlet UITableView *tblBookingHistory;

@property (weak, nonatomic) IBOutlet UILabel *txtEmptyBookingHistory;

@end

