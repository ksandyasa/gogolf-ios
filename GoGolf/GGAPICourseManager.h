//
//  GGAPICourseManager.h
//  GoGolf
//
//  Created by Eddyson Tan on 7/25/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGGlobal.h"
#import "GGGlobalVariable.h"

#import "AFNetworking.h"

@interface GGAPICourseManager : NSObject {

}

+ (GGAPICourseManager *) sharedInstance;

- (void)getCourseListWithcompletion:(void (^)(NSDictionary *responseDict, NSError *error))completion;

- (void)getCourseDetailWithID:(NSString *)gid completion:(void (^)(NSDictionary *responseDict, NSError *error))completion;

- (void) searchCourseWithPriceMin:(NSString *) minPrice priceMax:(NSString *) maxPrice areaID:(NSString *) areaID courseName:(NSString *)gname completion:(void (^)(NSDictionary *, NSError *))completion;

- (void) getWeekendCourseWithDay:(NSString *) date completion:(void (^)(NSDictionary *responseDict, NSError *error))completion;

- (void) getPreBookingListWithGID:(NSString *) GID courseDate:(NSString *)date completion:(void (^)(NSDictionary *responseDict, NSError *error))completion;

@end
