//
//  GGBookingDetailVC.h
//  GoGolf
//
//  Created by Eddyson Tan on 6/10/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GGGlobalVariable.h"
#import "GGCommonFunc.h"
#import "GGAPIBookingManager.h"
#import "GGPaymentVC.h"
#import "GGPaymentStripesVC.h"

@interface GGBookingDetailVC : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
}

@property (weak, nonatomic) IBOutlet UITableView *tblBookingDetail;

@property (nonatomic, retain) NSMutableDictionary *detailArr;

@property bool isHistory;

- (void)goToPaymentConfirmationView;

@end
