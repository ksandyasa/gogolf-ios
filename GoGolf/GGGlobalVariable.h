//
//  GGGlobalVariable.h
//  GoGolf
//
//  Created by Eddyson Tan on 6/10/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGGlobalVariable : NSObject

@property (nonatomic, retain) NSDictionary *itemLogin;

@property (nonatomic, retain) NSDictionary *itemRegister;

@property (nonatomic, retain) NSDictionary *itemForgot;

@property (nonatomic, retain) NSDictionary *itemPromotionList;

@property (nonatomic, retain) NSDictionary *itemAreaList;

@property (nonatomic, retain) NSDictionary *itemMapList;

@property (nonatomic, retain) NSDictionary *itemCountryList;

@property (nonatomic, retain) NSArray *itemLanguageList;

@property (nonatomic, retain) NSArray *itemFlightList;

@property (nonatomic, retain) NSDictionary *itemUserDetail;

@property (nonatomic, retain) NSDictionary *itemCourseList;

@property (nonatomic, retain) NSDictionary *itemPointHistoryList;

@property (nonatomic, retain) NSDictionary *itemPreBookingList;

@property (nonatomic, retain) NSDictionary *itemBookingHistoryList;

@property (nonatomic, retain) NSDictionary *itemHomeList;

@property (nonatomic, retain) NSArray *typePlayer;

@property (nonatomic, retain) NSString *bookingTitle;

@property (nonatomic, retain) NSMutableDictionary *bookInfoDict;

@property (nonatomic, retain) NSMutableArray *itemNotificationList;

@property (nonatomic, retain) NSDictionary *itemChargeConfirmList;

@property (nonatomic, retain) NSDictionary *itemVersionDict;

+ (GGGlobalVariable *)sharedInstance;

@end
