//
//  GGPreBookingDetailFlight.h
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/2/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GGCommonFunc.h"
#import "GGTeeTimeCell.h"
#import "GGPlayerTypeCell.h"

@interface GGPreBookingDetailFlight : UICollectionViewCell <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    GGPlayerTypeCell *cellPlayerType;
    float pricePlayer;
    NSString *playerType;
    NSInteger playerNumber;
}

@property (strong, nonatomic) NSDictionary *preBookDataFromServer;

@property (strong, nonatomic) NSMutableDictionary *preBookDict;

@property (strong, nonatomic) NSMutableArray *playerArr;

@property (weak, nonatomic) IBOutlet UILabel *lblFlight;

@property (weak, nonatomic) IBOutlet UITextField *txtTeeTime;

@property (weak, nonatomic) IBOutlet UILabel *lblTotPrice;

@property (weak, nonatomic) IBOutlet UITextField *txtPlayerNumber;

@property (weak, nonatomic) IBOutlet UILabel *lblCartMandatory;

@property (weak, nonatomic) IBOutlet UIView *viewOptCart;

@property (weak, nonatomic) IBOutlet UIButton *btnCartYes;

@property (weak, nonatomic) IBOutlet UIButton *btnCartNo;

@property (weak, nonatomic) IBOutlet UITableView *tblPlayerType;

@property (weak, nonatomic) IBOutlet UIView *vwContent;

@property (assign, nonatomic) BOOL isCartOpt;

@property (assign, nonatomic) int flightIndex;

@property (weak, nonatomic) id preBookingCell4Delegate;

- (IBAction)actionSelectTeeTime:(id)sender;

- (IBAction)actionSelectPlayerNumber:(id)sender;

- (IBAction)actionOptYes:(id)sender;

- (IBAction)actionOptNo:(id)sender;

- (IBAction)actionShowTeeTime:(id)sender;

- (IBAction)actionShowPlayerNumber:(id)sender;

@end
