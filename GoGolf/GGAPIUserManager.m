//
//  GGAPIUserManager.m
//  GoGolf
//
//  Created by Eddyson Tan on 6/25/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGAPIUserManager.h"

@implementation GGAPIUserManager



+ (GGAPIUserManager *)sharedInstance
{
    // the instance of this class is stored here
    static GGAPIUserManager *myInstance = nil;
    
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
        
    }
    // return the instance of this class
    return myInstance;
}

- (void)getUserDetailWithcompletion:(void (^)(NSDictionary *responseDict, NSError *error))completion {
    
    NSDictionary *params = @{
                             @"user_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"userID"]                             };
    
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[GGGlobal AUTHORIZATION_KEY] forHTTPHeaderField:@"AUTHORIZATION-KEY"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forHTTPHeaderField:@"ACCESS-TOKEN"];
    
    [manager POST:[GGGlobal apiGetUserDetail] parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        [[NSUserDefaults standardUserDefaults] setValue:[[responseObject objectForKey:@"data"] objectForKey:@"uid"] forKey:@"userID"];
        [[NSUserDefaults standardUserDefaults] setValue:[[responseObject objectForKey:@"data"] objectForKey:@"point"] forKey:@"userPoint"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [GGGlobalVariable sharedInstance].itemUserDetail = responseObject;
        
        if (completion != nil) completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"ERROR User : %@", error);
        if (completion != nil) completion(nil, error);
        
    }];
}

- (void)updateUserProfile:(NSString *)firstname lname:(NSString *)lastname email:(NSString *)email phone:(NSString *)phone address:(NSString *)address lang:(NSString *)lang phoneCode:(NSString *)phoneCode withcompletion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *params;
    if ([address isEqualToString:@""]) {
        params  = @{
                    @"fname" : firstname,
                    @"lname" : lastname,
                    @"email" : email,
                    @"phone" : phone,
                    @"lang" : lang,
                    @"phone_country" : phoneCode
                    };
    }else{
        params  = @{
                    @"fname" : firstname,
                    @"lname" : lastname,
                    @"email" : email,
                    @"phone" : phone,
                    @"address" : address,
                    @"lang" : lang,
                    @"phone_country" : phoneCode
                    };
    }
    
    NSLog(@"PARAM : %@", params);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[GGGlobal AUTHORIZATION_KEY] forHTTPHeaderField:@"AUTHORIZATION-KEY"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forHTTPHeaderField:@"ACCESS-TOKEN"];
    
    [manager POST:[GGGlobal apiUpdateProfile] parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        if (completion != nil) completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"ERROR User : %@", error);
        if (completion != nil) completion(nil, error);
        
    }];
}

- (void)updateUserPassword:(NSString *)oldpassword newpassword:(NSString *)newpassword confirmpassword:(NSString *)confirmpassword withcompletion:(void (^)(NSDictionary *, NSError *))completion {
    NSDictionary *params = @{
                             @"old_password" : oldpassword,
                             @"new_password" : newpassword,
                             @"confirm_new_password" : confirmpassword
                             };
    
    NSLog(@"PARAM : %@", params);
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager.requestSerializer setValue:[GGGlobal AUTHORIZATION_KEY] forHTTPHeaderField:@"AUTHORIZATION-KEY"];
    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"] forHTTPHeaderField:@"ACCESS-TOKEN"];
    
    [manager POST:[GGGlobal apiUpdatePassword] parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        if ([[responseObject objectForKey:@"code"] intValue] == 200) {
            [[NSUserDefaults standardUserDefaults] setObject:newpassword forKey:@"userPassword"];
            [[NSUserDefaults standardUserDefaults] synchronize];            
        }
        
        if (completion != nil) completion(responseObject, nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"ERROR User : %@", error);
        if (completion != nil) completion(nil, error);
        
    }];
    
}

@end
