//
//  GGBookingConfirmationVC.h
//  GoGolf
//
//  Created by Eddyson Tan on 8/15/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GGGlobalVariable.h"
#import "GGAPIBookingManager.h"
#import "GGCommonFunc.h"

#import "GGPaymentVC.h"
#import "GGPaymentStripesVC.h"

@interface GGBookingConfirmationVC : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    NSDictionary *pointConfirmArr;
    NSInteger totalPrice;
}
    
@property int deposit_rate;
    
@property (weak, nonatomic) IBOutlet UILabel *lblCurrentPoint;

@property (weak, nonatomic) IBOutlet UILabel *lblNecessaryPoint;

@property (weak, nonatomic) IBOutlet UIView *pointConfirmationView;

@property (weak, nonatomic) IBOutlet UILabel *lblDiscount;

@property (weak, nonatomic) IBOutlet UILabel *lblOldPrice;

@property (weak, nonatomic) IBOutlet UILabel *lblNewPrice;

@property (weak, nonatomic) IBOutlet UIView *blurBackgroundView;

@property (weak, nonatomic) IBOutlet UITableView *tblBookConfirm;

- (void)goToPaymentConfirmation;


@end
