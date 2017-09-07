//
//  GGAPIUserManager.h
//  GoGolf
//
//  Created by Eddyson Tan on 6/25/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GGGlobal.h"
#import "GGGlobalVariable.h"

#import "AFNetworking.h"


@interface GGAPIUserManager : NSObject {

}

+ (GGAPIUserManager *)sharedInstance;

- (void)getUserDetailWithcompletion:(void (^)(NSDictionary *responseDict, NSError *error))completion;

- (void)updateUserProfile:(NSString *)firstname lname:(NSString *)lastname email:(NSString *)email phone:(NSString *)phone address:(NSString *)address lang:(NSString *)lang phoneCode:(NSString *)phoneCode withcompletion:(void (^)(NSDictionary *, NSError *))completion;

- (void)updateUserPassword:(NSString *)oldpassword newpassword:(NSString *)newpassword confirmpassword:(NSString *)confirmpassword withcompletion:(void (^)(NSDictionary *responseDict, NSError *error))completion;

@end
