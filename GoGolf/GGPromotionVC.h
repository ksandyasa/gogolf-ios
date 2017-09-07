//
//  GGPromotionVC.h
//  GoGolf
//
//  Created by Eddyson Tan on 6/20/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GGCommonFunc.h"
#import "GGGlobalVariable.h"
#import "GGSearchPromotionVC.h"
#import "GGSearchGolfCoursePromotionVC.h"
#import "GGBookPromotionVC.h"
#import "GGPreBookingVC.h"
#import "GGAPIHomeManager.h"

//@protocol promotionDelegate;

@interface GGPromotionVC : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
}


@property (weak, nonatomic) IBOutlet UITableView *tblPromotion;

@property (weak, nonatomic) IBOutlet UILabel *txtEmptyPromotion;

@property (weak, nonatomic) IBOutlet UIButton *btnSearchPromo;

@property (nonatomic, weak) id promotionVCDelegate;

@property (nonatomic) BOOL isPromoEmpty;

- (void) reloadSearchTable;

- (void)refreshPromotionList;

- (void) showCommonAlert:(NSString *) title message:(NSString *)msg;

@end

//@protocol promotionDelegate <NSObject>
//
//- (void) showSearchPromotion;
//- (void) showBookPromo:(NSInteger) index;
//
//@end
