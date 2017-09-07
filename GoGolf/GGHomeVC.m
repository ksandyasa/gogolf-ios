//
//  GGHomeVC.m
//  GoGolf
//
//  Created by Eddyson Tan on 6/10/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGHomeVC.h"
#import "GGBerandaVC.h"
#import "GGGoogleMapsVC.h"
#import "GGSearchVC.h"
#import "GGPromotionVC.h"
#import "GGPointVC.h"

@interface GGHomeVC () {
    GGGoogleMapsVC *googleMapsVC;
    GGSearchVC *searchVC;
    GGBerandaVC *berandaVC;
    GGPromotionVC *promotionVC;
    GGPointVC *pointVC;
    UILabel *badgeLabel;
}

@end

int badgeCount = 0;

@implementation GGHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    
    // ====================== CARBON KIT ===========================
    items = @[
              @"MAP",
              @"SEARCH",
              @"HOME",
              @"PROMOTION",
              @"POINT"
              ];
    
    [self setupTabChildVC];
    [self setupBadgeLabel];
    
    carbonTabSwipeNavigation =
    [[CarbonTabSwipeNavigation alloc] initWithItems:items toolBar:self.toolBar delegate:self];
    [carbonTabSwipeNavigation setCurrentTabIndex:2];
    [carbonTabSwipeNavigation insertIntoRootViewController:self andTargetView:self.homeView];
    
    [self style];
    
    // ====================== CARBON KIT ===========================
    
    
    NSLog(@"ACCES_TOKEN : %@", [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sideBarClick:) name:@"sideBarNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTabIndex:) name:@"changeTabNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showWeekendView) name:@"openWeekendFromNotification" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(calculateBadgeNumber) name:@"countBadgeFromNotification" object:nil];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeTabIndex:) name:@"changePageNotification" object:nil];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    if ([[GGCommonFunc sharedInstance] connected]) {
        [[GGAPIUserManager sharedInstance] getUserDetailWithcompletion:^(NSDictionary *responseDict, NSError *error) {
            if (error == nil) {
                if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                    [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                    [[GGAPIManager sharedInstance] clearAllData];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateUserNotification" object:self userInfo:nil];
                }
            }
        }];
    }else{
        [self showCommonAlert:@"Alert" message:@"No internet connection."];
    }
    
}

- (void)setupTabChildVC {
    googleMapsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"googleMapVC"];
    googleMapsVC.googleMapVCDelegate = self;
    [self addChildViewController:googleMapsVC];
    [googleMapsVC didMoveToParentViewController:self];
    
    searchVC = [self.storyboard instantiateViewControllerWithIdentifier:@"searchVC"];
    searchVC.searchVCDelegate = self;
    [self addChildViewController:searchVC];
    [searchVC didMoveToParentViewController:self];
    
    berandaVC = [self.storyboard instantiateViewControllerWithIdentifier:@"berandaVC"];
    berandaVC.berandaVCDelegate = self;
    [self addChildViewController:berandaVC];
    [berandaVC didMoveToParentViewController:self];
    
    promotionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"promotionVC"];
    promotionVC.promotionVCDelegate = self;
    [self addChildViewController:promotionVC];
    [promotionVC didMoveToParentViewController:self];
    
    pointVC = [self.storyboard instantiateViewControllerWithIdentifier:@"pointVC"];
    pointVC.pointVCDelegate = self;
    [self addChildViewController:pointVC];
    [pointVC didMoveToParentViewController:self];
}

- (void)setupBadgeLabel {
    badgeLabel = [[UILabel alloc]initWithFrame:CGRectMake([[GGCommonFunc sharedInstance] obtainScreenWidth] - 20, 33, 13, 13)];
    badgeLabel.textColor = [UIColor whiteColor];
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    badgeLabel.text = [NSString stringWithFormat:@"1"];
    badgeLabel.layer.borderWidth = 1;
    badgeLabel.layer.cornerRadius = 8;
    badgeLabel.layer.masksToBounds = YES;
    badgeLabel.layer.borderColor =[[UIColor clearColor] CGColor];
    badgeLabel.layer.shadowColor = [[UIColor clearColor] CGColor];
    badgeLabel.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    badgeLabel.layer.shadowOpacity = 0.0;
    badgeLabel.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:45.0/255.0 blue:143.0/255.0 alpha:1.0];
    badgeLabel.font = [UIFont fontWithName:@"CharlevoixPro-Medium" size:11];
    badgeLabel.hidden = true;
    [self.headerView addSubview:badgeLabel];
}

- (void)calculateBadgeNumber {
    badgeCount += 1;
    if (badgeCount > 0)
        badgeLabel.hidden = false;
    badgeLabel.text = [NSString stringWithFormat:@"%ld", (long)badgeCount];
}

- (void)showWeekendView {
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground || [[UIApplication sharedApplication] applicationState] == UIApplicationStateInactive) {
        GGWeekendPromoVC *weekendPromoView = [self.storyboard instantiateViewControllerWithIdentifier:@"weekendPromoVC"];
        [self.navigationController pushViewController:weekendPromoView animated:YES];
    }else if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        NSLog(@"application is active");
    }
}

- (void) logoutAction {
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];

    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Logout" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        // Distructive button tapped.
        [self dismissViewControllerAnimated:YES completion:^{
        }];
        
        [self doLogOut];
    }]];
    
    // Present action sheet.
    [self presentViewController:actionSheet animated:YES completion:nil];
}

- (void) doLogOut {
    
    if ([[GGCommonFunc sharedInstance] connected]) {
        [[GGCommonFunc sharedInstance] showLoadingImage:self.parentViewController.parentViewController.view];
        [[GGAPIManager sharedInstance] logoutOfAccountwithCompletion:^(NSError *error) {
            [[GGCommonFunc sharedInstance] hideLoadingImage];
            if (error == nil) {
                NSLog(@"Success");
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            } else {
                NSLog(@"Error : %@", error.localizedDescription);
            }
        }];
    }else{
        [self showCommonAlert:@"Alert" message:@"No internet connection."];
    }
}

- (IBAction)openSideBar:(id)sender {
    [self.sidePanelController showLeftPanelAnimated:YES];
}

-(void)sideBarClick:(NSNotification*)notification {
    
    [self.sidePanelController showCenterPanelAnimated:YES];
    if ([[[notification userInfo] objectForKey:@"tableType"] intValue] == 1) {   // Top Table
        
        if ([[[notification userInfo] objectForKey:@"row"] intValue] == 0) {
            
            GGProfileVC *profileView = [self.storyboard instantiateViewControllerWithIdentifier:@"profileVC"];
            [self.navigationController pushViewController:profileView animated:YES];
            
        } else if ([[[notification userInfo] objectForKey:@"row"] intValue] == 1 || [[[notification userInfo] objectForKey:@"row"] intValue] == 2) {
            
            GGBookingHistoryVC *bookingStatusView = [self.storyboard instantiateViewControllerWithIdentifier:@"bookingHistoryVC"];
            
            [GGGlobalVariable sharedInstance].bookingTitle = [[[notification userInfo] objectForKey:@"row"] stringValue];
            
            [self.navigationController pushViewController:bookingStatusView animated:YES];
            
            
        } else if ([[[notification userInfo] objectForKey:@"row"] intValue] == 3) {
            
            GGTutorialVC *tutorialView = [self.storyboard instantiateViewControllerWithIdentifier:@"tutorialVC"];
            [self.navigationController pushViewController:tutorialView animated:YES];
            
        }  else if ([[[notification userInfo] objectForKey:@"row"] intValue] == 4) {
            
            [self showInputPromotion];
        }
        
    } else if ([[[notification userInfo] objectForKey:@"tableType"] intValue] == 2) { // Bottom Table
    
        if ([[[notification userInfo] objectForKey:@"row"] intValue] == 0) {
            [self logoutAction];
        }
    }
}

- (void) showInputPromotion {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Promotion Code" message:@"Please insert your Promotion Code here." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        txtPromoCode = alert.textFields.firstObject;
        txtPromoCode.delegate = self;
        txtPromoCode.returnKeyType = UIReturnKeySend;
        
        if ([txtPromoCode.text isEqualToString:@""]) {
            [self showCommonAlert:@"Alert" message:@"Please insert promotion code"];
        }else if ([txtPromoCode.text length] > 20) {
            [self showCommonAlert:@"Alert" message:@"Promotion Code is too long"];
        }else{
            [[GGCommonFunc sharedInstance] showLoadingImage:self.parentViewController.parentViewController.view];
            
            if ([[GGCommonFunc sharedInstance] connected]) {
                [[GGAPIPointManager sharedInstance] verifyPromotionCode:txtPromoCode.text withCompletion:^(NSDictionary *responseDict, NSError *error) {
                    
                    [[GGCommonFunc sharedInstance] hideLoadingImage];
                    
                    if (error == nil) {
                        if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                            [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                            [[GGAPIManager sharedInstance] clearAllData];
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        } else {
                            [self showCommonAlert:@"Notification" message:[responseDict objectForKey:@"message"]];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"pointActionNotification" object:self userInfo:nil];
                        }
                    } else
                        [self showCommonAlert:@"Notification" message:error.localizedDescription];
                    
                }];
            }else{
                [self showCommonAlert:@"Alert" message:@"No internet connection."];
            }
        }
    }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction * action)
                                   {
                                       UITextField *alertTextField = alert.textFields.firstObject;
                                       [alertTextField resignFirstResponder];
                                       
                                   }];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        textField.placeholder = @"Promotion Code";
    }];
    
    [self presentViewController:alert animated:YES completion:nil];
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
    
- (void) changeTabIndex :(NSNotification*)notification {
    
    if ([[[notification userInfo] objectForKey:@"tab"] intValue] == 3 && [[[notification userInfo] objectForKey:@"type"] isEqualToString:@"weekend"]) {
        
        GGWeekendPromoVC *weekendPromoView = [self.storyboard instantiateViewControllerWithIdentifier:@"weekendPromoVC"];
        [self.navigationController pushViewController:weekendPromoView animated:YES];
        
    } else if ([[[notification userInfo] objectForKey:@"tab"] intValue] == 1 && [[[notification userInfo] objectForKey:@"type"] isEqualToString:@"search"]) {
        
        [carbonTabSwipeNavigation setCurrentTabIndex:[[[notification userInfo] objectForKey:@"tab"] intValue] withAnimation:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"searchGolfCourse" object:self userInfo:nil];
        
    } else if ([[[notification userInfo] objectForKey:@"tab"] intValue] == 3 && [[[notification userInfo] objectForKey:@"type"] isEqualToString:@"booking"]) {
        
        [carbonTabSwipeNavigation setCurrentTabIndex:[[[notification userInfo] objectForKey:@"tab"] intValue] withAnimation:YES];
        
        GGBookPromotionVC *bookPromoView  = [self.storyboard instantiateViewControllerWithIdentifier:@"bookPromoVC"];
        bookPromoView.isHomeList = YES;
        [bookPromoView setDetailArr:[[[[[[GGGlobalVariable sharedInstance].itemHomeList objectForKey:@"data"] objectForKey:@"toparr"] objectAtIndex:[[[notification userInfo] objectForKey:@"row"] intValue]] objectForKey:@"request"] objectForKey:@"data"]];
        [self.navigationController pushViewController:bookPromoView animated:YES];
        
    } else {
        
        [carbonTabSwipeNavigation setCurrentTabIndex:[[[notification userInfo] objectForKey:@"tab"] intValue] withAnimation:YES];
    }
}

- (IBAction)goShowNotif:(id)sender {
    badgeLabel.hidden = true;
    badgeCount = 0;
    
    GGNotificationLogVC *notifView = [self.storyboard instantiateViewControllerWithIdentifier:@"notificationLogVC"];
    [self.navigationController pushViewController:notifView animated:YES];

}

#pragma mark - CARBON KIT
- (void)style {
    
    UIColor *color = [UIColor colorWithRed:82/255.0 green:154/255.0 blue:4/255.0 alpha:1];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = color;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    carbonTabSwipeNavigation.toolbar.translucent = NO;
    [carbonTabSwipeNavigation setIndicatorColor:color];
    [carbonTabSwipeNavigation setTabExtraWidth:30];
    for (int i = 0; i < 5; i++) {
        [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:120 forSegmentAtIndex:i];
    }
    
    // Custimize segmented control
    [carbonTabSwipeNavigation setNormalColor:[color colorWithAlphaComponent:0.6]
                                        font:[UIFont boldSystemFontOfSize:14]];
    [carbonTabSwipeNavigation setSelectedColor:color font:[UIFont boldSystemFontOfSize:14]];
}

#pragma mark - CarbonTabSwipeNavigation Delegate
// required
- (nonnull UIViewController *)carbonTabSwipeNavigation:
(nonnull CarbonTabSwipeNavigation *)carbontTabSwipeNavigation
                                 viewControllerAtIndex:(NSUInteger)index {
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"profileVC" bundle:nil];
    switch (index) {
        case 0:
            return googleMapsVC;
            
        case 1:
            return searchVC;
            
        case 2:
            return berandaVC;
            
        case 3:
            return promotionVC;
            
        case 4:
            return pointVC;
            
        default:
            return berandaVC;
    }
}

// optional
- (void)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
                 willMoveAtIndex:(NSUInteger)index {
}

- (void)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
                  didMoveAtIndex:(NSUInteger)index {
}

- (UIBarPosition)barPositionForCarbonTabSwipeNavigation:
(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation {
    return UIBarPositionTop; // default UIBarPositionTop
}

#pragma mark - UITEXTFIELD

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSLog(@"INPUT TEXT : %@", textField.text);
    
    if (textField == txtPromoCode) {
        if ([textField.text isEqualToString:@""]) {
            [self showCommonAlert:@"Alert" message:@"Please insert promotion code"];
        }else if ([textField.text length] > 20) {
            [self showCommonAlert:@"Alert" message:@"Promotion Code is too long"];
        }else{
            if ([[GGCommonFunc sharedInstance] connected]) {
                [[GGAPIPointManager sharedInstance] verifyPromotionCode:txtPromoCode.text withCompletion:^(NSDictionary *responseDict, NSError *error) {
                    
                    if (error == nil) {
                        if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                            [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                            [[GGAPIManager sharedInstance] clearAllData];
                            [self.navigationController popToRootViewControllerAnimated:YES];
                        } else {
                            [self showCommonAlert:@"Notification" message:[responseDict objectForKey:@"message"]];
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"pointActionNotification" object:self userInfo:nil];
                        }
                    } else
                        [self showCommonAlert:@"Notification" message:error.localizedDescription];
                    
                }];
            }else{
                [self showCommonAlert:@"Alert" message:@"No internet connection."];
            }
        }
    }
}

#pragma end

@end
