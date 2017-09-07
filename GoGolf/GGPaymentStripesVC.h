//
//  GGPaymentStripesVC.h
//  GoGolf
//
//  Created by Aprido Sandyasa on 12/14/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGGlobal.h"
#import "GGBookingConfirmationVC.h"
#import "GGBookingDetailVC.h"

@interface GGPaymentStripesVC : UIViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *wvStripes;

@property (weak, nonatomic) id paymentStripesDelegate;

@property (nonatomic) int priceDp;

@property (nonatomic) NSString *bcode;

@property (nonatomic) NSString *bid;

@end
