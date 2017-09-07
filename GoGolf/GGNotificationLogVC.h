//
//  GGNotificationLogVC.h
//  GoGolf
//
//  Created by Eddyson Tan on 9/3/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GGAPIHomeManager.h"
#import "GGGlobalVariable.h"

@interface GGNotificationLogVC : UIViewController <UITableViewDelegate, UITableViewDataSource>{

}

@property (weak, nonatomic) IBOutlet UITableView *tblNotificationLog;

@property (weak, nonatomic) IBOutlet UILabel *txtEmptyNotificationLog;

@end
