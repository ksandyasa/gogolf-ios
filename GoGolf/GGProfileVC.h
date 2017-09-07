//
//  GGProfileVC.h
//  GoGolf
//
//  Created by Eddyson Tan on 6/14/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GGUpdateProfileVC.h"

#import "GGGlobalVariable.h"

@interface GGProfileVC : UIViewController <UITableViewDelegate, UITableViewDataSource> {

}

@property (weak, nonatomic) IBOutlet UITableView *tblProfile;



@end
