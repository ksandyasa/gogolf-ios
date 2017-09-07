//
//  GGMapVC.m
//  GoGolf
//
//  Created by Eddyson Tan on 6/20/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGMapVC.h"

@interface GGMapVC ()

@end

@implementation GGMapVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btnSearchMap.layer.cornerRadius = self.btnSearchMap.frame.size.width / 2;
    self.btnSearchMap.clipsToBounds = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMapsPage) name:@"mapsActionNotification" object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.pickerArea reloadAllComponents];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self hideCountryList:nil];
}

- (void) reloadMapsPage {
    if ([[[GGGlobalVariable sharedInstance].itemAreaList objectForKey:@"data"] count] > 0) {
        self.txtMapsArea.placeholder = @"Choose Area";
        self.txtMapsArea.text = [[[[GGGlobalVariable sharedInstance].itemAreaList objectForKey:@"data"] objectAtIndex:0] objectForKey:@"area_name"];
        
        [[GGAPIHomeManager sharedInstance] getMapListWithID:[NSString stringWithFormat:@"%@", [[[[GGGlobalVariable sharedInstance].itemAreaList objectForKey:@"data"] objectAtIndex:0] objectForKey:@"area_id"]] Completion:^(NSDictionary *responseDict, NSError *error) {
            if (error == nil) {
                if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                    [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                    [[GGAPIManager sharedInstance] clearAllData];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    if([[responseDict objectForKey:@"data"] count] > 0)
                        [self generateMaps];
                }
            } else {
                NSLog(@"ERROR : %@", error.localizedDescription);
            }
        }];
    }
}

- (void) generateMaps {

    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    NSArray *mapsDict = nil;
    
    mapsDict = [[GGGlobalVariable sharedInstance].itemMapList objectForKey:@"data"];
    
    GMSCameraPosition *camera = nil;
    
    camera = [GMSCameraPosition cameraWithLatitude:[[mapsDict objectAtIndex:0][@"lat"] doubleValue]
                                         longitude:[[mapsDict objectAtIndex:0][@"ing"] doubleValue]
                                              zoom:11];
    
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 0, screenRect.size.width, screenRect.size.height) camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.delegate = self;
    
    for(int i = 0; i < [mapsDict count]; i++)
    {
        
        CLLocationCoordinate2D position = { [[mapsDict objectAtIndex:i][@"lat"] doubleValue], [[mapsDict objectAtIndex:i][@"ing"] doubleValue] };
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        marker.title = [mapsDict objectAtIndex:i][@"gname"];
        marker.appearAnimation = YES;
        marker.flat = YES;
        
        UIImage *markerIcon = [UIImage imageNamed:@"marker_icon"];
        markerIcon = [markerIcon imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, (markerIcon.size.height/4), 0)];

        
        marker.icon = markerIcon;
        marker.snippet = @"";
        marker.map = mapView_;
    }
    
    for (UIView *subView in self.viewBodyMaps.subviews)
    {
        [subView removeFromSuperview];
    }
    
    [self.viewBodyMaps addSubview:mapView_];
    
}

#pragma mark - UIMAPVIEW
- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(nonnull GMSMarker *)marker {
    NSLog(@"JUDUL : %@", marker.title);
    
    for (int i=0; i < [[[GGGlobalVariable sharedInstance].itemMapList objectForKey:@"data"] count]; i++) {
        if ([marker.title isEqual:[[GGGlobalVariable sharedInstance].itemMapList objectForKey:@"data"][i][@"gname"]]) {
            
            [[GGAPICourseManager sharedInstance] getCourseDetailWithID:[[GGGlobalVariable sharedInstance].itemMapList objectForKey:@"data"][i][@"gid"] completion:^(NSDictionary *responseDict, NSError *error) {
                if (error == nil) {
                    if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                        [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                        [[GGAPIManager sharedInstance] clearAllData];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    } else {
//                        GGGolfDetailVC *detailCourseView = [self.storyboard instantiateViewControllerWithIdentifier:@"detailView"];
//                        detailCourseView.courseDetailArr = responseDict;
                        
                        GGSearchDetailVC *searchDetailView = [self.storyboard instantiateViewControllerWithIdentifier:@"searchDetailCourse"];
                        searchDetailView.courseDetailArr = responseDict;
                        
                        [self.navigationController pushViewController:searchDetailView animated:YES];
                    }
                } else {
                    NSLog(@"Error : %@", error.localizedDescription);
                }
            }];
            
            break;
        }
    }
    
}

#pragma mark - UIPICKERVIEW DELEGATE & DATASOURCE

- (IBAction)hideCountryList:(id)sender {
    
    if ([sender tag] == 2) {
        
        NSInteger row = [_pickerArea selectedRowInComponent:0];
        areaID = [GGGlobalVariable sharedInstance].itemAreaList[@"data"][row][@"area_id"];

        [[GGAPIHomeManager sharedInstance] getMapListWithID:areaID Completion:^(NSDictionary *responseDict, NSError *error) {
            if (error == nil) {
                if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                    [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                    [[GGAPIManager sharedInstance] clearAllData];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    if ([[responseDict objectForKey:@"data"] count] > 0) {
                        
                        [self generateMaps];
                        self.txtMapsArea.text = [GGGlobalVariable sharedInstance].itemAreaList[@"data"][row][@"area_name"];
                    } else {
                        [self showCommonAlert:@"Notification" message:@"No Spot Available for this Area."];
                    }
                }
            } else {
                NSLog(@"ERROR : %@", error.localizedDescription);
            }
        }];
        
    }
    
    
    [self hideBackGround];
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

- (IBAction)showCountryList:(id)sender {
    
    [UIView animateWithDuration:0.4
                     animations:^{
                         
                         
                         self.backGroundTransparant.hidden = NO;
                         [NSTimer scheduledTimerWithTimeInterval:0.3
                                                          target:self
                                                        selector:@selector(showDropDown)
                                                        userInfo:nil
                                                         repeats:NO];
                     }];
}

- (void) showDropDown {
    [[GGCommonFunc sharedInstance] showMenuView:self.viewPicker];
}

- (void) hideBackGround {
    self.backGroundTransparant.hidden = YES;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.viewPicker.frame = CGRectMake(0, screenRect.size.height + self.viewPicker.frame.size.height, self.viewPicker.frame.size.width, self.viewPicker.frame.size.height);
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[GGGlobalVariable sharedInstance].itemAreaList[@"data"] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [GGGlobalVariable sharedInstance].itemAreaList[@"data"][row][@"area_name"];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

@end
