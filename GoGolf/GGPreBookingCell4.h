//
//  GGPreBookingCell4.h
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/2/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGPreBookingDetailFlight.h"
#import "GGPreBookingVC.h"
#import "GGCommonFunc.h"

@interface GGPreBookingCell4 : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource> {
    GGPreBookingDetailFlight *cell;
}

@property (strong, nonatomic) NSDictionary *preBookDataFromServer;

@property (strong, nonatomic) NSMutableDictionary *preBookDict;

@property (weak, nonatomic) IBOutlet UICollectionView *colFlightDetail;

@property (weak, nonatomic) IBOutlet UIButton *btnPrevFlight;

@property (weak, nonatomic) IBOutlet UIButton *btnNextFlight;

@property (weak, nonatomic) id preBookingDelegate;

- (void)showDetailFlight;

- (void)showTeeTimeFromCell:(int)index;

- (void)showPlayerNumberFromCell:(int)index;

- (void)showPlayerTypeFromCell:(BOOL)optCart fromIndex:(int)index atFlightIndex:(int)flightIndex;

- (void)updateFlightDataBasedOnCartOptFromCell:(int)flightIndex;

- (IBAction)showPrevFlight:(id)sender;

- (IBAction)showNextFlight:(id)sender;

@end
