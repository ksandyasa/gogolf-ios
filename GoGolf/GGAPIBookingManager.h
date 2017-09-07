//
//  GGAPIBookingManager.h
//  GoGolf
//
//  Created by Eddyson Tan on 8/4/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGGlobal.h"
#import "GGGlobalVariable.h"

#import "AFNetworking.h"

@interface GGAPIBookingManager : NSObject


+ (GGAPIBookingManager *) sharedInstance;

- (void)getBookStatus:(NSString *)status withSDate:(NSString *)sdate andEDate:(NSString *)edate completion:(void (^)(NSDictionary *responseDict, NSError *error))completion;

- (void)getPointConfirmationWithcompletion:(NSString *)tprice gid:(NSString *)gid date:(NSString *)date completion:(void (^)(NSDictionary *responseDict, NSError *error))completion;

- (void)addBookingWithcompletion:(NSString *)gid date:(NSString *)date dep_price:(NSString *) depositPrice flightArr:(NSString *)flightArr use_point:(NSString *)use_point completion:(void (^)(NSDictionary *responseDict, NSError *error))completion;

- (void)cancelBookingWithcompletion:(NSString *)bid completion:(void (^)(NSDictionary *responseDict, NSError *error))completion;

- (void)doTransaction:(NSString *)bid token:(NSString *)token_id withSavedToken:(NSString *)savedToken completion:(void (^)(NSDictionary *, NSError *))completion;

- (void)getPaymentTokenWithCompletion:(void (^)(NSDictionary *, NSError *))completion;

@end
