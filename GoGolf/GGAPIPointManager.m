//
//  GGAPIPointManager.m
//  GoGolf
//
//  Created by Eddyson Tan on 7/16/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGAPIPointManager.h"

@implementation GGAPIPointManager


+ (GGAPIPointManager *)sharedInstance
{
    // the instance of this class is stored here
    static GGAPIPointManager *myInstance = nil;
    
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
        
    }
    // return the instance of this class
    return myInstance;
}

- (void)getPointHistoryWithcompletion:(void (^)(NSDictionary *, NSError *))completion {
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[GGGlobal AUTHORIZATION_KEY] forHTTPHeaderField:@"AUTHORIZATION-KEY"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forHTTPHeaderField:@"ACCESS-TOKEN"];
    
    NSLog(@"URL : %@", [GGGlobal apiGetPointHistory]);
    
    [manager POST:[GGGlobal apiGetPointHistory] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [GGGlobalVariable sharedInstance].itemPointHistoryList = responseObject;
        
//        NSLog(@"Point Log : %@", responseObject);
        
        if (completion != nil) completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"ERROR Point Log : %@", error.localizedDescription);
        if (completion != nil) completion(nil, error);
        
    }];
}

- (void)verifyPromotionCode:(NSString *) promoCode withCompletion:(void (^)(NSDictionary *, NSError *))completion {
    
    NSDictionary *params = @{
                             @"code": promoCode
                             };
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[GGGlobal AUTHORIZATION_KEY] forHTTPHeaderField:@"AUTHORIZATION-KEY"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forHTTPHeaderField:@"ACCESS-TOKEN"];
    
    NSLog(@"ACCESS TOKEN : %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]);
    
//    NSLog(@"URL : %@", [GGGlobal apiVerifyPromotionCode]);
    
    [manager POST:[GGGlobal apiVerifyPromotionCode] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSLog(@"Promo Code Log : %@", responseObject);
        
        if (completion != nil) completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"ERROR Promo Code Log : %@", error.localizedDescription);
        if (completion != nil) completion(nil, error);
        
    }];
}

@end
