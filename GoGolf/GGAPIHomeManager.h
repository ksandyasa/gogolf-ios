//
//  GGAPIHomeManager.h
//  GoGolf
//
//  Created by Eddyson Tan on 6/21/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GGGlobal.h"
#import "GGGlobalVariable.h"

#import "AFNetworking.h"

@interface GGAPIHomeManager : NSObject {

}

+ (GGAPIHomeManager *)sharedInstance;

- (void)getPromotionListWithcompletion:(void (^)(NSDictionary *responseDict, NSError *error))completion;

- (void)getPromotionDetailWithID:(NSString *) pid completion:(void (^)(NSDictionary *responseDict, NSError *error))completion;

- (void) searchPromotionWithDate:(NSString *)date priceMin:(NSString *) minPrice priceMax:(NSString *) maxPrice start:(NSString *) stime end:(NSString *) etime areaID:(NSString *) areaID courseName:(NSString *)gname completion:(void (^)(NSDictionary *, NSError *))completion;

- (void)getAreaWithCompletion:(void (^)(NSDictionary *responseDict, NSError *error))completion;

- (void)getMapListWithID:(NSString *)idArea Completion:(void (^)(NSDictionary *responseDict, NSError *error))completion;

- (void) getCountryWithCompletion:(void (^)(NSDictionary *, NSError *))completion;

- (void) getNotificationWithCompletion:(void (^)(NSDictionary *, NSError *))completion;

@end
