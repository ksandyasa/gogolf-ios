//
//  GGPointHistoryVC.h
//  GoGolf
//
//  Created by Eddyson Tan on 7/15/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GGAPIPointManager.h"
#import "GGGlobalVariable.h"

@interface GGPointHistoryVC : UIViewController <UITableViewDelegate, UITableViewDataSource> {

}
@property (weak, nonatomic) IBOutlet UITableView *tblPointHistory;

@property (weak, nonatomic) IBOutlet UILabel *txtEmptyPointHistory;

@end
