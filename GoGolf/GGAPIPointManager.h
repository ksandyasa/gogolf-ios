//
//  GGAPIPointManager.h
//  GoGolf
//
//  Created by Eddyson Tan on 7/16/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GGGlobal.h"
#import "GGGlobalVariable.h"
#import "AFNetworking.h"

@interface GGAPIPointManager : NSObject {

}

+ (GGAPIPointManager *)sharedInstance;

- (void)getPointHistoryWithcompletion:(void (^)(NSDictionary *responseDict, NSError *error))completion;

- (void)verifyPromotionCode:(NSString *) promoCode withCompletion:(void (^)(NSDictionary *responseDict, NSError *error))completion;

@end
