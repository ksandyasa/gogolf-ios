//
//  GGPreBookingVC.h
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/2/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MaterialControls/NSDate+MDExtension.h>
#import <MaterialControls/MDDatePickerDialog.h>
#import "GGCommonFunc.h"
#import "GGPreBookingHeader.h"
#import "GGPreBookingCell1.h"
#import "GGPreBookingCell2.h"
#import "GGPreBookingCell3.h"
#import "GGPreBookingCell4.h"
#import "GGPreBookingCell5.h"
#import "GGPreBookingCell6.h"
#import "GGAPICourseManager.h"
#import "GGBookingConfirmationVC.h"

@interface GGPreBookingVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, MDDatePickerDialogDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tblPreBooking;

@property (strong, nonatomic) NSMutableDictionary *preBookDict;

@property (strong, nonatomic) NSDictionary *preBookDataFromServer;

@property (strong, nonatomic) NSDictionary *detailArr;

@property BOOL isHomeList;

- (IBAction)goBack:(id)sender;

- (void) loadDetailView:(NSString *) GID courseDate:(NSString *)date flightCount:(int)flightCount;

- (void)showPreBookingCalendarView;

- (void)showPreBookingDatePicker;

- (void)showPreBookingFlightPicker;

- (void)showPreBookingTeeTimePicker:(int)ttimePos fromFlightIndex:(int)index;

- (void)showPreBookingPlayerNumberPicker:(int)ttimePos fromFlightIndex:(int)index withSelectedPlayerNumber:(int)playerIndex;

- (void)showPreBookingPlayerTypePicker:(BOOL)optCart fromIndex:(int)index atFlightIndex:(int)flightIndex;

- (void)updateFlightDetailBasedOnCartOpt:(int)indeks;

- (void)goToBookingConfirmationView;

@end
