//
//  GGGlobal.m
//  GoGolf
//
//  Created by Eddyson Tan on 6/10/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGGlobal.h"

@implementation GGGlobal {
}

#ifdef DEBUG
    NSString *urlTermsOfUse = @"http://dev.gogolfindonesia.com/legal/terms";
    NSString *baseURL = @"https://api.gogolf.co.id/v1";//@"http://golf-api.yocto-international.com/v1";
#else
    NSString *urlTermsOfUse = @"http://gogolf.co.id/legal/terms";
    NSString *baseURL = @"https://api.gogolf.co.id/v1";
#endif

+ (NSString *) AUTHORIZATION_KEY {
    return @"a175bac26ba2bd3e0a2eafb88e3a418c28be6cf0";
}

+ (NSString *) CONSUMER_KEY {
    return @"db73ff479d66313ab4d36f7295d3a7360573429a4";
}

+ (NSString *) CONSUMER_SECRET {
    return @"db5eb7b0626ca43214683a63dd81af10";
}

+ (NSString *) apiGetToken {
    return [NSString stringWithFormat:@"%@/auth/getToken", baseURL];
}

+ (NSString *) apiLogin {
    return [NSString stringWithFormat:@"%@/auth/login", baseURL];
}

+ (NSString *) apiLoginSosmed {
    return [NSString stringWithFormat:@"%@/auth/socialLogin", baseURL];
}

+ (NSString *) apiGetAccessToken {
    return [NSString stringWithFormat:@"%@/auth/getAccessToken", baseURL];
}

+ (NSString *) apiRegister {
    return [NSString stringWithFormat:@"%@/user/register", baseURL];
}

+ (NSString *) apiForgot {
    return [NSString stringWithFormat:@"%@/user/forgot_password", baseURL];
}

+ (NSString *) apiLogout {
    return [NSString stringWithFormat:@"%@/auth/logout", baseURL];
}

+ (NSString *) apiGetNotificationLog {
    return [NSString stringWithFormat:@"%@/notification/log", baseURL];
}

+ (NSString *) apiTermsOfUse {
    return urlTermsOfUse;
}

+ (NSString *) apiVersionApps {
    return [NSString stringWithFormat:@"%@/version/check", baseURL];
}

+ (NSString *) apiStripeCharge {
    return [NSString stringWithFormat:@"%@/stripe/charge/view", baseURL];
}

#pragma mark - VERITRANS API
+ (NSString *) VERITRANS_CLIENT_KEY {
    return @"VT-client-G6fMEXO_V3esGwGg";
}

+ (NSString *) VERITRANS_MERCHANT_ID {
    return @"M091971";
}

+ (NSString *) VERITRANS_SERVER_KEY {
    return @"VT-server-F6fcazP6GaX-NPgOUePsl6_Y";
}

+ (NSString *) VERITRANS_SERVER_URL {
    return @"http://golf-api.yocto-international.com/veritrans/vtdirect/charge_payment";
}

#pragma mark - HOME API

+ (NSString *) apiGetHomeList {
    return [NSString stringWithFormat:@"%@/photo/home", baseURL];
}

+ (NSString *) apiPromotionList {
    return [NSString stringWithFormat:@"%@/promotion/lists", baseURL];
}

+ (NSString *) apiPromotionDetail {
    return [NSString stringWithFormat:@"%@/promotion/detail", baseURL];
}

+ (NSString *) apiAreaList {
    return [NSString stringWithFormat:@"%@/area/get", baseURL];
}

+ (NSString *) apiGetMapList {
    return [NSString stringWithFormat:@"%@/golf/map", baseURL];
}

+ (NSString *) apiGetCountryList {
    return [NSString stringWithFormat:@"%@/country/get", baseURL];
}

#pragma mark - USER PROFILE API

+ (NSString *) apiGetUserDetail {
    return [NSString stringWithFormat:@"%@/user/detail", baseURL];
}

+ (NSString *) apiUpdateProfile {
    return [NSString stringWithFormat:@"%@/user/update", baseURL];
}

+ (NSString *) apiUpdatePassword {
    return [NSString stringWithFormat:@"%@/user/change_password", baseURL];
}

#pragma mark - COURSE API
+ (NSString *) apiGetCourseList {
    return [NSString stringWithFormat:@"%@/golf/lists", baseURL];
}

+ (NSString *) apiGetCourseDetail {
    return [NSString stringWithFormat:@"%@/golf/detail", baseURL];
}

#pragma mark - BOOKING API

+ (NSString *) apiGetPreBooking {
    return [NSString stringWithFormat:@"%@/golf/getPreBookingData", baseURL];
}

+ (NSString *) apiAddBooking {
    return [NSString stringWithFormat:@"%@/booking/add", baseURL];
}

#pragma mark - POINT API

+ (NSString *) apiGetPointHistory {
    return [NSString stringWithFormat:@"%@/point/getPointLog", baseURL];
}

+ (NSString *) apiVerifyPromotionCode {
    return [NSString stringWithFormat:@"%@/point/verifyPromotionCode", baseURL];
}

#pragma mark - BOOKING
+ (NSString *) apiGetBookingHistory {
    return [NSString stringWithFormat:@"%@/booking/history", baseURL];
}

+ (NSString *) apiGetPointConfirmation {
    return [NSString stringWithFormat:@"%@/point/getPointConfirmation", baseURL];
}

+ (NSString *) apiCancelBooking {
    return [NSString stringWithFormat:@"%@/booking/delete", baseURL];
}

+ (NSString *) apiPaymentToken {
    return [NSString stringWithFormat:@"%@/user/getPaymentToken", baseURL];
}

@end
