//
//  GGAPIManager.h
//  GoGolf
//
//  Created by Eddyson Tan on 6/10/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGAPIManager : NSObject

+ (GGAPIManager *)sharedInstance;

- (void) signInFBWithAccess_token:(NSString *)access_token provider:(NSString *)social_provider completion:(void (^)(NSError *error))completionBlock;

- (void) signInAccountWithEmail:(NSString *)email password:(NSString *)password completion:(void (^)(NSError *error))completionBlock;

- (void)registerInAccountWithFirstname:(NSString *)fName lastName:(NSString *)lName email:(NSString *)email password:(NSString *)pwd country_ID:(NSString *) countryID gender:(NSString *)gender phone:(NSString *) phoneNumber device_ID:(NSString *)devID langID:(NSString *)langID phoneCode:(NSString *)phoneCode completion:(void (^)(NSError *error))completionBlock;

- (void) logoutOfAccountwithCompletion:(void (^)(NSError *error))completionBlock;

- (void)getHomeListWithcompletion:(void (^)(NSDictionary *responseDict, NSError *error))completion;

- (void) clearAllData;

- (void) getVersionAppsWithCompletion:(void (^)(NSDictionary *, NSError *))completion;

@end
