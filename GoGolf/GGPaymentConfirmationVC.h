//
//  GGPaymentConfirmationVC.h
//  GoGolf
//
//  Created by Eddyson Tan on 9/13/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GGHomePageVC.h"
#import "GGCommonFunc.h"
#import "GGGlobalVariable.h"

@interface GGPaymentConfirmationVC : UIViewController <UITableViewDelegate, UITableViewDataSource> {

}

@property (weak, nonatomic) IBOutlet UITableView *tblConfirmInfo;

@property (nonatomic) NSString *bookingCode;

@property (nonatomic) int grossAmount;

@end
