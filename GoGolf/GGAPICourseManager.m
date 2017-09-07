//
//  GGAPICourseManager.m
//  GoGolf
//
//  Created by Eddyson Tan on 7/25/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGAPICourseManager.h"

@implementation GGAPICourseManager

+ (GGAPICourseManager *) sharedInstance {
    // the instance of this class is stored here
    static GGAPICourseManager *myInstance = nil;
    
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
        
    }
    // return the instance of this class
    return myInstance;
}

- (void)getCourseListWithcompletion:(void (^)(NSDictionary *responseDict, NSError *error))completion {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[GGGlobal AUTHORIZATION_KEY] forHTTPHeaderField:@"AUTHORIZATION-KEY"];
    
    [manager GET:[GGGlobal apiGetCourseList] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [GGGlobalVariable sharedInstance].itemCourseList = responseObject;
        
        if (completion != nil) completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (completion != nil) completion(nil, error);
        
    }];
}

- (void)getCourseDetailWithID:(NSString *)gid completion:(void (^)(NSDictionary *responseDict, NSError *error))completion {
    NSDictionary *params = @{
                             @"gid": gid
                             };
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[GGGlobal AUTHORIZATION_KEY] forHTTPHeaderField:@"AUTHORIZATION-KEY"];
    
    [manager POST:[GGGlobal apiGetCourseDetail] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //        [GGGlobalVariable sharedInstance].itemPromotionList = responseObject;
        
        if (completion != nil) completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (completion != nil) completion(nil, error);
        
    }];
}


- (void) searchCourseWithPriceMin:(NSString *) minPrice priceMax:(NSString *) maxPrice areaID:(NSString *) areaID courseName:(NSString *)gname completion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *params = @{
                             @"pricemin": minPrice,
                             @"pricemax": maxPrice,
                             @"area_id": areaID,
                             @"gname": gname
                             };
    
    NSLog(@"PARAMS COURSE : %@", params);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[GGGlobal AUTHORIZATION_KEY] forHTTPHeaderField:@"AUTHORIZATION-KEY"];
    
    [manager POST:[GGGlobal apiGetCourseList] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if ([responseObject[@"data"] count] > 0) {
            [GGGlobalVariable sharedInstance].itemCourseList = responseObject;
        }        
//        NSLog(@"RESPONSE SEARCH PROMO LIST : %@",responseObject);
        
        if (completion != nil) completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"ERROR SEARCH PROMO : %@", error.localizedDescription);
        if (completion != nil) completion(nil, error);
        
    }];

}

- (void) getPreBookingListWithGID:(NSString *)GID courseDate:(NSString *)date completion:(void (^)(NSDictionary *, NSError *))completion {
    
    NSDictionary *params = @{
                             @"gid": GID,
                             @"gdate": date
                             };
    
    NSLog(@"params : %@", params);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[GGGlobal AUTHORIZATION_KEY] forHTTPHeaderField:@"AUTHORIZATION-KEY"];
    
    [manager POST:[GGGlobal apiGetPreBooking] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [GGGlobalVariable sharedInstance].itemPreBookingList = responseObject;
        
        if (completion != nil) completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"ERROR PREBOOKING : %@", error.localizedDescription);
        if (completion != nil) completion(nil, error);
        
    }];
    
}

- (void) getWeekendCourseWithDay:(NSString *)date completion:(void (^)(NSDictionary *, NSError *))completion {
    
    NSDictionary *params = @{
                             @"date": date
                             };
    
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[GGGlobal AUTHORIZATION_KEY] forHTTPHeaderField:@"AUTHORIZATION-KEY"];
    
    [manager POST:[GGGlobal apiGetCourseList] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
        if (completion != nil) completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"ERROR WEEKEND : %@", error.localizedDescription);
        if (completion != nil) completion(nil, error);
        
    }];
    
}

@end
