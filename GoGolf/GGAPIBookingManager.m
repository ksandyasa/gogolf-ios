//
//  GGAPIBookingManager.m
//  GoGolf
//
//  Created by Eddyson Tan on 8/4/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGAPIBookingManager.h"

@implementation GGAPIBookingManager

+ (GGAPIBookingManager *) sharedInstance {
    // the instance of this class is stored here
    static GGAPIBookingManager *myInstance = nil;
    
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
        
    }
    // return the instance of this class
    return myInstance;
}

- (void)getBookStatus:(NSString *)status withSDate:(NSString *)sdate andEDate:(NSString *)edate completion:(void (^)(NSDictionary *responseDict, NSError *error))completion {
    NSDictionary *params = @{
                             @"sdate" : sdate,
                             @"edate" : edate,
                             @"status" : status
                             };
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[GGGlobal AUTHORIZATION_KEY] forHTTPHeaderField:@"AUTHORIZATION-KEY"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forHTTPHeaderField:@"ACCESS-TOKEN"];
    
    [manager POST:[GGGlobal apiGetBookingHistory] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject %@", [responseObject description]);
        
        [GGGlobalVariable sharedInstance].itemBookingHistoryList = responseObject;
        
        if (completion != nil) completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (completion != nil) completion(nil, error);
        
    }];
}

- (void)getPointConfirmationWithcompletion:(NSString *)tprice gid:(NSString *)gid date:(NSString *)date completion:(void (^)(NSDictionary *responseDict, NSError *error))completion {
    NSDictionary *params = @{
                             @"tprice" : tprice,
                             @"gid": gid,
                             @"date": date
                             };
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[GGGlobal AUTHORIZATION_KEY] forHTTPHeaderField:@"AUTHORIZATION-KEY"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forHTTPHeaderField:@"ACCESS-TOKEN"];
    
    [manager POST:[GGGlobal apiGetPointConfirmation] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (completion != nil) completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (completion != nil) completion(nil, error);
        
    }];
}

- (void)addBookingWithcompletion:(NSString *)gid date:(NSString *)date dep_price:(NSString *)depositPrice flightArr:(NSString *)flightArr use_point:(NSString *)use_point completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *params = @{
                             @"gid" : gid,
                             @"date": date,
                             @"referral" : @"gogolf_ios",
                             @"deposit_price": depositPrice,
                             @"flightarr" : flightArr,
                             @"use_point": use_point
                             };
    
    NSLog(@"PARAMS : %@", params);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[GGGlobal AUTHORIZATION_KEY] forHTTPHeaderField:@"AUTHORIZATION-KEY"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forHTTPHeaderField:@"ACCESS-TOKEN"];
    
    [manager POST:[GGGlobal apiAddBooking] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (completion != nil) completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (completion != nil) completion(nil, error);
        
    }];
}

- (void)cancelBookingWithcompletion:(NSString *)bid completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *params = @{
                             @"bid" : bid
                             };
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[GGGlobal AUTHORIZATION_KEY] forHTTPHeaderField:@"AUTHORIZATION-KEY"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forHTTPHeaderField:@"ACCESS-TOKEN"];
    
    [manager POST:[GGGlobal apiCancelBooking] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"HASIL CANCEL : %@", responseObject);
        
        if (completion != nil) completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (completion != nil) completion(nil, error);
        
    }];
}

- (void)doTransaction:(NSString *)bid token:(NSString *)token_id withSavedToken:(NSString *)savedToken completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *params = @{
                             @"bid" : bid,
                             @"token_id" : token_id,
                             @"save_token" : savedToken
                             };
    
    NSLog(@"PARAM CHARGE : %@", params);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[GGGlobal AUTHORIZATION_KEY] forHTTPHeaderField:@"AUTHORIZATION-KEY"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forHTTPHeaderField:@"ACCESS-TOKEN"];
    
    [manager POST:[GGGlobal VERITRANS_SERVER_URL] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (completion != nil) completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (completion != nil) completion(nil, error);
        
    }];
}

- (void)getPaymentTokenWithCompletion:(void (^)(NSDictionary *, NSError *))completion {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[GGGlobal AUTHORIZATION_KEY] forHTTPHeaderField:@"AUTHORIZATION-KEY"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forHTTPHeaderField:@"ACCESS-TOKEN"];
    
    [manager POST:[GGGlobal apiPaymentToken] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject %@", [responseObject description]);
        if (completion != nil) completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (completion != nil) completion(nil, error);
        
    }];
}

@end
