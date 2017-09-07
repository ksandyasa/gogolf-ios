//
//  AppDelegate.m
//  GoGolf
//
//  Created by Eddyson Tan on 6/8/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "AppDelegate.h"

@import GoogleMaps;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [GMSServices provideAPIKey:@"AIzaSyDHzogvA6rWXJh-hNVMb5RwDPTKFvu7s9k"];
    
    // Veritrans SDK
//#ifdef RELEASE
//    [VTConfig setClientKey:[GGGlobal VERITRANS_CLIENT_KEY]
//         merchantServerURL:[GGGlobal VERITRANS_SERVER_URL]
//         serverEnvironment:VTServerEnvironmentProduction];
//#else
    [[MidtransConfig shared] setClientKey:[GGGlobal VERITRANS_CLIENT_KEY] environment:MidtransServerEnvironmentUnknown merchantServerURL:[GGGlobal VERITRANS_SERVER_URL]];
        
//    [VTConfig setClientKey:[GGGlobal VERITRANS_CLIENT_KEY]
//         merchantServerURL:[GGGlobal VERITRANS_SERVER_URL]
//         serverEnvironment:VTServerEnvironmentSandbox];
//#endif
    
//    BOOL enableOneclick = false;
//    [[[NSUserDefaults standardUserDefaults] objectForKey:@"enable_oneclick"] boolValue];
//    [[VTCardControllerConfig sharedInstance] setEnableOneClick:enableOneclick];
    
//    BOOL enable3ds = false;
////    [[[NSUserDefaults standardUserDefaults] objectForKey:@"enable_3ds"] boolValue];
//    [[VTCardControllerConfig sharedInstance] setEnable3DSecure:enable3ds];
    
    
    // Use Firebase library to configure APIs
    
    UIUserNotificationType allNotificationTypes =
    (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
    UIUserNotificationSettings *settings =
    [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
    
    [FIRApp configure];
    [[FIRAnalyticsConfiguration sharedInstance] setAnalyticsCollectionEnabled:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:) name:kFIRInstanceIDTokenRefreshNotification object:nil];
    
    // Facebook SDK
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    // CRASHLYTICS
    [Fabric with:@[[Crashlytics class]]];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
    // Add any custom logic here.
    return handled;
}

// [START refresh_token]
- (void)tokenRefreshNotification:(NSNotification *)notification {
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    
    [[NSUserDefaults standardUserDefaults] setValue:refreshedToken forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    
}
// [END refresh_token]

// [START connect_to_fcm]
- (void)connectToFcm {
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM.");
        }
    }];
}
// [END connect_to_fcm]
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // for development
    [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeUnknown];
//    [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeProd];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // Print message ID.
    NSLog(@"Message ID: %@", userInfo[@"gcm.message_id"]);
    
    // Pring full message.
    NSLog(@"%@", userInfo);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"countBadgeFromNotification" object:self userInfo:userInfo];
    if ([userInfo[@"destination"] isEqualToString:@"weekend"] && [userInfo[@"event"] isEqualToString:@"page"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"openWeekendFromNotification" object:self userInfo:userInfo];

    }
    
//    for (id key in userInfo) {
//        NSLog(@"key: %@, value: %@", key, [userInfo objectForKey:key]);
//        
//    }
    
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = [[[userInfo objectForKey:@"aps"] objectForKey: @"badge"] intValue];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[FIRMessaging messaging] disconnect];
    NSLog(@"Disconnected from FCM");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [FBSDKAppEvents activateApp];
    if ([[GGCommonFunc sharedInstance] connected]) {
        [[GGAPIManager sharedInstance] getVersionAppsWithCompletion:^(NSDictionary *responseDict, NSError *error) {
            
            NSString *serverVersion = [NSString stringWithFormat:@"%@", responseDict[@"data"][@"min_version"]];
            NSString *appVersion = [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
            
            NSArray *servVerArray = [serverVersion componentsSeparatedByString:@"."];
            NSArray *appVerArray = [appVersion componentsSeparatedByString:@"."];
            
            if ([appVerArray[0] intValue] < [servVerArray[0] intValue]) {
                [self showVersionAlert:@"GoGolf Version Update" message:@"GoGolf Version has beed updated, please download the latest version from Apple Store."];
            }else{
                if ([appVerArray[1] intValue] < [servVerArray[1] intValue]) {
                    [self showVersionAlert:@"GoGolf Version Update" message:@"GoGolf Version has beed updated, please download the latest version from Apple Store."];
                }else{
                    if ([appVerArray[2] intValue] < [servVerArray[2] intValue]) {
                        [self showVersionAlert:@"GoGolf Version Update" message:@"GoGolf Version has beed updated, please download the latest version from Apple Store."];
                    }else{
                        
                    }
                }
            }
        }];
    }else{
        [self showCommonAlert:@"Alert" message:@"No internet connection."];
    }

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void) showCommonAlert:(NSString *) title message:(NSString *)msg {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   //Handel no, thanks button
                                   
                               }];
    
    [alert addAction:okButton];
    
    [self.window.rootViewController presentViewController:alert  animated:YES completion:nil];
}

- (void) showVersionAlert:(NSString *) title message:(NSString *)msg {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"Update"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   NSString *iTunesLink = @"itms://itunes.apple.com/us/app/apple-store/id375380948?mt=8";
                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
                               }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"Cancel"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   //Handel no, thanks button
                                   
                               }];
    
    [alert addAction:noButton];
    [alert addAction:okButton];
    
    [self.window.rootViewController presentViewController:alert  animated:YES completion:nil];
}

@end
