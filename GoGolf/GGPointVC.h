//
//  GGPointVC.h
//  GoGolf
//
//  Created by Eddyson Tan on 7/15/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GGGlobalVariable.h"
#import "GGAPIUserManager.h"
#import "GGPointHistoryVC.h"

//@protocol pointDelegate;

@interface GGPointVC : UIViewController {

}


//@property (nonatomic, weak) id<pointDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *lblCurrentPoints;

@property (weak, nonatomic) IBOutlet UILabel *lblLastUpdate;

@property (weak, nonatomic) id pointVCDelegate;

@end

//@protocol pointDelegate <NSObject>
//
//- (void) showPointHistory;
//
//@end
