//
//  GGCommonFunc.h
//  GoGolf
//
//  Created by Eddyson Tan on 6/12/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"
#import "Reachability.h"

@interface GGCommonFunc : NSObject


+ (GGCommonFunc *)sharedInstance;

- (NSString *) setLocaleDateFormat:(NSDate *)date;

- (NSString *) changeDateFormat:(NSString *) date;

- (NSString *) changeDateFormatForAPI:(NSString *) date;

- (NSString *) changeDateFormatForSearch:(NSDate *) date;

- (NSString *) changeCurrencyFormat:(float) value;

- (NSString *) changeDateFormatForCourseDetail:(NSString *) date;

- (NSString *) changeFormatTimeForCourseDetail:(NSString *) time;

- (NSString *) getCurrencyFromString:(NSString *) value;

- (NSString *)getDateFromSystem;

- (NSString *)getNextYearDate;

- (NSString *)getLastYearDate;

- (NSString *)getDateFromDatePicker:(NSDate *)dateValue;

- (NSString *) setSeparatedCurrency:(float) value;

- (void) hideMenuView : (UIView *) sender;

- (void) showMenuView : (UIView *) sender;

- (void)showLoadingImage:(UIView *)view;

- (void)hideLoadingImage;

- (void)hideLoadingImage:(UIView *)view;

- (void) setLazyLoadImage:(__weak UIImageView *)imageCell urlString:(NSString *) urlImage;

- (UIColor*)colorWithHexString:(NSString*)hex;

- (void) setAlert:(NSString *)title message:(NSString *)message;

- (CGFloat)obtainScreenWidth;

- (BOOL)isValidEmail:(NSString *)checkEmailString;

- (BOOL)isValidPhoneNumber:(NSString *)checkPhoneString;

- (NSMutableDictionary *)setupBookingParams:(NSDictionary *)responseDict initWithFlight:(NSInteger)flightNumber;

- (NSMutableDictionary *)setupFlightDetail:(NSDictionary *)responseDict index:(NSInteger)index rowConditionarr:(NSInteger)rowConditionarr;

- (NSMutableArray *)setupPlayerArr:(NSDictionary *)responseDict withCount:(NSInteger)count fromConditionarr:(NSInteger)rowConditionarr fromPlayerIndex:(NSInteger)playerIndex withTypePrice:(NSString *)priceType andPlayerType:(NSString *)playerType;

- (NSMutableArray *)setupPlayerNumber:(int)max fromIndex:(int)min;

- (NSMutableArray *)setupPlayerType:(NSDictionary *)responseDict withRowConditionarr:(NSInteger)rowConditionarr;

- (NSMutableDictionary *)getFlightDetailFromTeeTime:(NSString *)teeTime responseDict:(NSDictionary *)responseDict rowConditionarr:(NSInteger)rowConditionarr teeTimePos:(NSInteger)pos;

- (void)updateFlightDetail:(NSMutableDictionary *)flightDetail withDetail:(NSMutableDictionary *)data;

- (void)addPlayerArr:(NSMutableDictionary *)flightDetail withPrice:(NSString *)price andType:(NSString *)type withCount:(int)count andCartMandatory:(NSString *)cartMandatory;

- (void)updateAllPlayerArr:(NSMutableDictionary *)flightDetail fromPlayerType:(NSMutableArray *)playerType withCartOpt:(BOOL)cartOpt;

- (void)updateAllPlayerArrFromTeeTime:(NSMutableDictionary *)flightDetail fromPlayerType:(NSMutableArray *)playerType withCartOpt:(BOOL)cartOpt;

- (void)updatePlayerArr:(NSMutableDictionary *)flightDetail withPrice:(NSString *)price andType:(NSString *)type atIndex:(int)index withCartOpt:(BOOL)cartOpt andCartMandatory:(NSString *)cartMandatory andPlayerType:(NSMutableArray *)playerType;

- (void)updatePreBookTotPrice:(NSMutableDictionary *)preBookDict;

- (BOOL)connected;

-(void)setViewMovedUp:(BOOL)movedUp fromView:(UIView *)view fromPos:(int)pos;

@end
