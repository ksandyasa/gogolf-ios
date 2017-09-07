//
//  GGSundayPromoVC.h
//  GoGolf
//
//  Created by Eddyson Tan on 9/29/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GGCommonFunc.h"
#import "GGGlobalVariable.h"

#import "GGSearchPromotionVC.h"
#import "GGBookPromotionVC.h"
#import "GGPreBookingVC.h"
#import "GGAPICourseManager.h"

@interface GGSundayPromoVC : UIViewController <UITableViewDataSource, UITableViewDelegate>{
    
    
}

@property NSDictionary *golfArr;

@property (weak, nonatomic) IBOutlet UITableView *tblSundayPromotion;

@property (weak, nonatomic) IBOutlet UIButton *btnSearchPromo;



@end
