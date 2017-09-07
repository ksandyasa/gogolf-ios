//
//  GGSidebarVC.h
//  GoGolf
//
//  Created by Eddyson Tan on 6/10/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GGAPIUserManager.h"

@interface GGSidebarVC : UIViewController <UITableViewDelegate, UITableViewDataSource> {

}

@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblCountry;
@property (weak, nonatomic) IBOutlet UITableView *tableTop;
@property (weak, nonatomic) IBOutlet UITableView *tableBottom;
@property (weak, nonatomic) id sidebarDelegate;

@end
