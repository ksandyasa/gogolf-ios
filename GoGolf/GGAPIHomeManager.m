//
//  GGAPIHomeManager.m
//  GoGolf
//
//  Created by Eddyson Tan on 6/21/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGAPIHomeManager.h"


@implementation GGAPIHomeManager

+ (GGAPIHomeManager *)sharedInstance
{
    // the instance of this class is stored here
    static GGAPIHomeManager *myInstance = nil;
    
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];

    }
    // return the instance of this class
    return myInstance;
}

- (void)getPromotionListWithcompletion:(void (^)(NSDictionary *responseDict, NSError *error))completion {
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[GGGlobal AUTHORIZATION_KEY] forHTTPHeaderField:@"AUTHORIZATION-KEY"];
//    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forHTTPHeaderField:@"ACCESS-TOKEN"];
    
    [manager POST:[GGGlobal apiPromotionList] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [GGGlobalVariable sharedInstance].itemPromotionList = responseObject;
        
        if (completion != nil) completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (completion != nil) completion(nil, error);
        
    }];
}

- (void)getPromotionDetailWithID:(NSString *) pid completion:(void (^)(NSDictionary *responseDict, NSError *error))completion {
    NSDictionary *params = @{
                             @"pid": pid
                             };
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[GGGlobal AUTHORIZATION_KEY] forHTTPHeaderField:@"AUTHORIZATION-KEY"];
    
    [manager POST:[GGGlobal apiPromotionDetail] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        [GGGlobalVariable sharedInstance].itemPromotionList = responseObject;
        
        if (completion != nil) completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (completion != nil) completion(nil, error);
        
    }];
}

- (void) searchPromotionWithDate:(NSString *)date priceMin:(NSString *) minPrice priceMax:(NSString *) maxPrice start:(NSString *) stime end:(NSString *) etime areaID:(NSString *) areaID courseName:(NSString *)gname completion:(void (^)(NSDictionary *, NSError *))completion{
    
    NSDictionary *params = @{
                             @"pricemin": minPrice,
                             @"pricemax": maxPrice,
                             @"date": date,
                             @"stime": stime,
                             @"etime": etime,
                             @"area_id": areaID,
                             @"gname": gname
                             };
    
    
    NSLog(@"PARAMS PROMO : %@", params);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[GGGlobal AUTHORIZATION_KEY] forHTTPHeaderField:@"AUTHORIZATION-KEY"];
//    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forHTTPHeaderField:@"ACCESS-TOKEN"];
    
    [manager POST:[GGGlobal apiPromotionList] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"responseObject %@", [responseObject description]);
        
        if ([responseObject[@"data"] count] > 0) {
            [GGGlobalVariable sharedInstance].itemPromotionList = responseObject;
        }
                
        if (completion != nil) completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"ERROR SEARCH PROMO : %@", error.localizedDescription);
        if (completion != nil) completion(nil, error);
        
    }];
}

- (void) getCountryWithCompletion:(void (^)(NSDictionary *, NSError *))completion {
    
//    NSDictionary *params = @{
//                             @"lang" : @"id"
//                             };
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:[GGGlobal AUTHORIZATION_KEY] forHTTPHeaderField:@"AUTHORIZATION-KEY"];
    
    [manager POST:[GGGlobal apiGetCountryList] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        [GGGlobalVariable sharedInstance].itemCountryList = responseObject;
        
        if (completion != nil) completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"ERROR COUNTRY : %@", error.localizedDescription);
        if (completion != nil) completion(nil, error);
        
    }];
}

- (void) getAreaWithCompletion:(void (^)(NSDictionary *, NSError *))completion {
    
    NSDictionary *params = @{
                             @"country_id" : @"1",
                             @"lang" : @"en"
                             };
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[GGGlobal AUTHORIZATION_KEY] forHTTPHeaderField:@"AUTHORIZATION-KEY"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forHTTPHeaderField:@"ACCESS-TOKEN"];
    
    
    [manager POST:[GGGlobal apiAreaList] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        [GGGlobalVariable sharedInstance].itemAreaList = responseObject;
        
        if (completion != nil) completion(responseObject, nil);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"ERROR AREA : %@", error.localizedDescription);
        if (completion != nil) completion(nil, error);
        
    }];
}

- (void)getMapListWithID:(NSString *)idArea Completion:(void (^)(NSDictionary *responseDict, NSError *error))completion {
    NSDictionary *params = @{
                             @"area_id" : idArea,
                             @"lang" : @"en"
                             };
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[GGGlobal AUTHORIZATION_KEY] forHTTPHeaderField:@"AUTHORIZATION-KEY"];
    
    [manager POST:[GGGlobal apiGetMapList] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"RESPONSE : %@", responseObject);
        
        [GGGlobalVariable sharedInstance].itemMapList = responseObject;
        
        if (completion != nil) completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"ERROR MAP : %@", error.localizedDescription);
        if (completion != nil) completion(nil, error);
        
    }];
}

- (void)getNotificationWithCompletion:(void (^)(NSDictionary *, NSError *))completion {
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[GGGlobal AUTHORIZATION_KEY] forHTTPHeaderField:@"AUTHORIZATION-KEY"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forHTTPHeaderField:@"ACCESS-TOKEN"];
    
    [manager GET:[GGGlobal apiGetNotificationLog] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (completion != nil) completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"ERROR Notif : %@", error.localizedDescription);
        if (completion != nil) completion(nil, error);
        
    }];
}


@end
