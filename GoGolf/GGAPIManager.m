//
//  GGAPIManager.m
//  GoGolf
//
//  Created by Eddyson Tan on 6/10/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGAPIManager.h"

#import "GGGlobal.h"
#import "GGGlobalVariable.h"
#import "AFNetworking.h"

@implementation GGAPIManager

+ (GGAPIManager *)sharedInstance
{
    // the instance of this class is stored here
    static GGAPIManager *myInstance = nil;
    
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
        
    }
    // return the instance of this class
    return myInstance;
}

- (void)signInAccountWithEmail:(NSString *)email
                    password:(NSString *)password
                    completion:(void (^)(NSError *error))completionBlock
{
    
    NSDictionary *params = @{
                             @"email" : email,
                             @"password" : password,
                             @"device_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]
                             };
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];

    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[GGGlobal AUTHORIZATION_KEY] forHTTPHeaderField:@"AUTHORIZATION-KEY"];
    
    [manager POST:[GGGlobal apiLogin] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [GGGlobalVariable sharedInstance].itemLogin = responseObject;
                
        [[NSUserDefaults standardUserDefaults] setValue:[[responseObject objectForKey:@"data"] objectForKey:@"access_token"] forKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults] setValue:[[responseObject objectForKey:@"data"][@"user"] objectForKey:@"uid"] forKey:@"userID"];
        [[NSUserDefaults standardUserDefaults] setValue:[[responseObject objectForKey:@"data"][@"user"] objectForKey:@"point"] forKey:@"userPoint"];
        [[NSUserDefaults standardUserDefaults] setValue:password forKey:@"userPassword"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (completionBlock != nil) completionBlock(nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (completionBlock != nil) completionBlock(error);
        
    }];
}

- (void)signInFBWithAccess_token:(NSString *)access_token provider:(NSString *)social_provider completion:(void (^)(NSError *))completionBlock
{
    
    NSDictionary *params = @{
                             @"access_token" : access_token,
                             @"provider" : social_provider,
                             @"device_id" : [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"]
                             };
    
    NSLog(@"PARAM : %@", params);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[GGGlobal AUTHORIZATION_KEY] forHTTPHeaderField:@"AUTHORIZATION-KEY"];
    
    [manager POST:[GGGlobal apiLoginSosmed] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [GGGlobalVariable sharedInstance].itemLogin = responseObject;
        
        NSLog(@"RESPONSE : %@", responseObject);
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setValue:[[responseObject objectForKey:@"data"] objectForKey:@"access_token"] forKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults] setValue:[[responseObject objectForKey:@"data"][@"user"] objectForKey:@"uid"] forKey:@"userID"];
        [[NSUserDefaults standardUserDefaults] setValue:[[responseObject objectForKey:@"data"][@"user"] objectForKey:@"point"] forKey:@"userPoint"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (completionBlock != nil) completionBlock(nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (completionBlock != nil) completionBlock(error);
        
    }];
}


- (void)registerInAccountWithFirstname:(NSString *)fName lastName:(NSString *)lName email:(NSString *)email password:(NSString *)pwd country_ID:(NSString *) countryID gender:(NSString *)gender phone:(NSString *) phoneNumber device_ID:(NSString *)devID langID:(NSString *)langID phoneCode:(NSString *)phoneCode completion:(void (^)(NSError *error))completionBlock{

    NSDictionary *params = @{
                             @"fname": fName,
                             @"lname": lName,
                             @"email": email,
                             @"password": pwd,
                             @"country_id": countryID,
                             @"gender": gender,
                             @"phone": phoneNumber,
                             @"device_id": devID,
                             @"lang": langID,
                             @"phone_country" : phoneCode
                             };
    
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:[GGGlobal AUTHORIZATION_KEY] forHTTPHeaderField:@"AUTHORIZATION-KEY"];
    
    [manager POST:[GGGlobal apiRegister] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [GGGlobalVariable sharedInstance].itemRegister = responseObject;
        
        if (completionBlock != nil) completionBlock(nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error Register : %@", error.localizedDescription);
        if (completionBlock != nil) completionBlock(error);
        
    }];
}

- (void) logoutOfAccountwithCompletion:(void (^)(NSError *error))completionBlock
{
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:[GGGlobal AUTHORIZATION_KEY] forHTTPHeaderField:@"AUTHORIZATION-KEY"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forHTTPHeaderField:@"ACCESS-TOKEN"];
    
    [manager POST:[GGGlobal apiLogout] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"RESPONSE LOGOUT : %@",responseObject);
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"access_token"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"hasLogin"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userID"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userPoint"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (completionBlock != nil) completionBlock(nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (completionBlock != nil) completionBlock(error);
        
    }];
    
}

- (void)clearAllData {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"hasLogin"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userPoint"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void) getHomeListWithcompletion:(void (^)(NSDictionary *, NSError *))completion {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[GGGlobal AUTHORIZATION_KEY] forHTTPHeaderField:@"AUTHORIZATION-KEY"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forHTTPHeaderField:@"ACCESS-TOKEN"];
    
    [manager GET:[GGGlobal apiGetHomeList] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [GGGlobalVariable sharedInstance].itemHomeList = responseObject;
        
        if (completion != nil) completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (completion != nil) completion(nil, error);
        
    }];
}

- (void) getVersionAppsWithCompletion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *params = @{
                             @"operating_system" : @"ios"
                             };
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[GGGlobal AUTHORIZATION_KEY] forHTTPHeaderField:@"AUTHORIZATION-KEY"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forHTTPHeaderField:@"ACCESS-TOKEN"];
    
    [manager POST:[GGGlobal apiVersionApps] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"responseObject %@", [responseObject description]);
        [GGGlobalVariable sharedInstance].itemVersionDict = responseObject;
        
        if (completion != nil) completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (completion != nil) completion(nil, error);
        
    }];
}

@end
