//
//  GGHomePageVC.m
//  GoGolf
//
//  Created by Eddyson Tan on 6/10/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGHomePageVC.h"
#import "GGHomeVC.h"
#import "GGSidebarVC.h"

@interface GGHomePageVC () {
    GGHomeVC *homeVC;
    GGSidebarVC *sideBarVC;
    
}

@end


@implementation GGHomePageVC
@synthesize homePageView = _homePageView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.homePageView = self.view;
    
    if ([[GGCommonFunc sharedInstance] connected]) {
        [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
        [[GGAPIManager sharedInstance] getVersionAppsWithCompletion:^(NSDictionary *responseDict, NSError *error) {
            [[GGCommonFunc sharedInstance] hideLoadingImage:self.view];
            NSLog(@"responseDict %@", [responseDict description]);

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
                        [[GGAPIHomeManager sharedInstance] getAreaWithCompletion:^(NSDictionary *responseDict, NSError *error) {
                            
                            NSLog(@"areaList from Home %@", [responseDict description]);
                            
                            [[GGCommonFunc sharedInstance] hideLoadingImage];
                            
                            if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                                [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                                [[GGAPIManager sharedInstance] clearAllData];
                                [self.navigationController popToRootViewControllerAnimated:YES];
                            } else {
                                
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"mapsActionNotification" object:self userInfo:nil];
                            }
                        }];                        
                    }
                }
            }            
        }];
    }else{
        [self showCommonAlert:@"Alert" message:@"No internet connection."];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
//    GGAPIManager *apiManager = [[GGAPIManager alloc] init];
//    [apiManager requestAccessToken:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauth_token"] token_secret:[[NSUserDefaults standardUserDefaults] objectForKey:@"oauth_token_secret"]];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    sideBarVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sidebarVC"];
    sideBarVC.sidebarDelegate = self;
    [self addChildViewController:sideBarVC];
    [sideBarVC didMoveToParentViewController:self];
    
    homeVC = [self.storyboard instantiateViewControllerWithIdentifier:@"homeViewVC"];
    homeVC.homeDelegate = self;
    [self addChildViewController:homeVC];
    [homeVC didMoveToParentViewController:self];
    
    [self setLeftPanel:sideBarVC];
    [self setCenterPanel:homeVC];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
    
    [self presentViewController:alert  animated:YES completion:nil];
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
                                   if ([[GGCommonFunc sharedInstance] connected]) {
                                       [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
                                       [[GGAPIHomeManager sharedInstance] getAreaWithCompletion:^(NSDictionary *responseDict, NSError *error) {
                                           [[GGCommonFunc sharedInstance] hideLoadingImage];
                                           if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                                               [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                                               [[GGAPIManager sharedInstance] clearAllData];
                                               [self.navigationController popToRootViewControllerAnimated:YES];
                                           } else {
                                               
                                               [[NSNotificationCenter defaultCenter] postNotificationName:@"mapsActionNotification" object:self userInfo:nil];
                                           }
                                       }];
                                   }
                               }];
    
    [alert addAction:noButton];
    [alert addAction:okButton];
    
    [self presentViewController:alert  animated:YES completion:nil];
}

@end
