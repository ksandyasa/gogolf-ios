//
//  GGAPIForgotManager.m
//  GoGolf
//
//  Created by Aprido Sandyasa on 10/30/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGAPIForgotManager.h"

@implementation GGAPIForgotManager

+ (GGAPIForgotManager *)sharedInstance
{
    // the instance of this class is stored here
    static GGAPIForgotManager *myInstance = nil;
    
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
        
    }
    // return the instance of this class
    return myInstance;
}

- (void)sendLinkForgotPassword:(NSString *)email completion:(void (^)(NSError *))completionBlock {
    NSDictionary *params = @{
                             @"email" : email,
                             };
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded; charset=UTF-8" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:[GGGlobal AUTHORIZATION_KEY] forHTTPHeaderField:@"AUTHORIZATION-KEY"];
    
    [manager POST:[GGGlobal apiForgot] parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [GGGlobalVariable sharedInstance].itemForgot = responseObject;
        
        [[NSUserDefaults standardUserDefaults] setValue:[responseObject objectForKey:@"code"]  forKey:@"code"];
        [[NSUserDefaults standardUserDefaults] setValue:[responseObject objectForKey:@"message"]  forKey:@"message"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (completionBlock != nil) completionBlock(nil);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (completionBlock != nil) completionBlock(error);
        
    }];

}


@end
