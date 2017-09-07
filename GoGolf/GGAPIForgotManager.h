//
//  GGAPIForgotManager.h
//  GoGolf
//
//  Created by Aprido Sandyasa on 10/30/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GGGlobal.h"
#import "GGGlobalVariable.h"
#import "AFNetworking.h"

@interface GGAPIForgotManager : NSObject {
    
}

+ (GGAPIForgotManager *)sharedInstance;

- (void) sendLinkForgotPassword:(NSString *)email completion:(void (^)(NSError *error))completionBlock;

@end
