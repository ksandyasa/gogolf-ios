//
//  GGGlobal.h
//  GoGolf
//
//  Created by Eddyson Tan on 6/10/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGGlobal : NSObject

+ (NSString *) AUTHORIZATION_KEY;

+ (NSString *) CONSUMER_KEY;

+ (NSString *) CONSUMER_SECRET;

+ (NSString *) VERITRANS_CLIENT_KEY;

+ (NSString *) VERITRANS_SERVER_KEY;

+ (NSString *) VERITRANS_SERVER_URL;

+ (NSString *) VERITRANS_MERCHANT_ID;

+ (NSString *) apiGetToken;

+ (NSString *) apiLogin;

+ (NSString *) apiLoginSosmed;

+ (NSString *) apiGetAccessToken;

+ (NSString *) apiRegister;

+ (NSString *) apiForgot;

+ (NSString *) apiLogout;

+ (NSString *) apiPromotionList;

+ (NSString *) apiPromotionDetail;

+ (NSString *) apiAreaList;

+ (NSString *) apiGetMapList;

+ (NSString *) apiGetCountryList;

+ (NSString *) apiGetUserDetail;

+ (NSString *) apiGetPointHistory;

+ (NSString *) apiVerifyPromotionCode;

+ (NSString *) apiGetCourseList;

+ (NSString *) apiGetCourseDetail;

+ (NSString *) apiGetPreBooking;

+ (NSString *) apiGetBookingHistory;

+ (NSString *) apiGetHomeList;

+ (NSString *) apiGetPointConfirmation;

+ (NSString *) apiAddBooking;

+ (NSString *) apiCancelBooking;

+ (NSString *) apiUpdateProfile;

+ (NSString *) apiUpdatePassword;

+ (NSString *) apiGetNotificationLog;

+ (NSString *) apiTermsOfUse;

+ (NSString *) apiVersionApps;

+ (NSString *) apiPaymentToken;

+ (NSString *) apiStripeCharge;

@end
