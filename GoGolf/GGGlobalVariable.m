//
//  GGGlobalVariable.m
//  GoGolf
//
//  Created by Eddyson Tan on 6/10/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGGlobalVariable.h"

@implementation GGGlobalVariable

@synthesize itemLogin;

+ (GGGlobalVariable *)sharedInstance
{
    // the instance of this class is stored here
    static GGGlobalVariable *myInstance = nil;
    
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];

        [GGGlobalVariable sharedInstance].itemLogin = [[NSDictionary alloc] init];
        [GGGlobalVariable sharedInstance].itemRegister = [[NSDictionary alloc] init];
        [GGGlobalVariable sharedInstance].itemForgot = [[NSDictionary alloc] init];
        [GGGlobalVariable sharedInstance].itemPromotionList = [[NSDictionary alloc] init];
        [GGGlobalVariable sharedInstance].itemAreaList = [[NSDictionary alloc] init];
        [GGGlobalVariable sharedInstance].itemMapList = [[NSDictionary alloc] init];
        [GGGlobalVariable sharedInstance].itemCountryList = [[NSDictionary alloc] init];
        [GGGlobalVariable sharedInstance].itemLanguageList = [[NSArray alloc] initWithObjects:@"English", @"Bahasa Indonesia", @"Japanese", nil];
        [GGGlobalVariable sharedInstance].itemFlightList = [[NSArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", nil];
        [GGGlobalVariable sharedInstance].itemUserDetail = [[NSDictionary alloc] init];
        
        [GGGlobalVariable sharedInstance].itemPointHistoryList = [[NSDictionary alloc] init];
        [GGGlobalVariable sharedInstance].itemPreBookingList = [[NSDictionary alloc] init];
        [GGGlobalVariable sharedInstance].itemBookingHistoryList = [[NSDictionary alloc] init];
        
        [GGGlobalVariable sharedInstance].itemCourseList = [[NSDictionary alloc] init];
        [GGGlobalVariable sharedInstance].itemHomeList = [[NSDictionary alloc] init];
        
        [GGGlobalVariable sharedInstance].bookingTitle = [[NSString alloc] init];
        
        [GGGlobalVariable sharedInstance].itemNotificationList = [[NSMutableArray alloc] init];
        
        [GGGlobalVariable sharedInstance].itemChargeConfirmList = [[NSDictionary alloc] init];
        
        [GGGlobalVariable sharedInstance].typePlayer = [[NSArray alloc] initWithObjects:@"Standard", @"Member", @"Senior", @"Junior", @"Prestige", @"QGolf", nil];
        
        [GGGlobalVariable sharedInstance].bookInfoDict = [[NSMutableDictionary alloc] init];
        
        [GGGlobalVariable sharedInstance].itemVersionDict = [[NSDictionary alloc] init];
    }
    // return the instance of this class
    return myInstance;
}

@end
