//
//  GGGoogleMapsVC.m
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/6/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGGoogleMapsVC.h"
#import "GGHomeVC.h"
#import "GGHomePageVC.h"

@interface GGGoogleMapsVC () {
    GMSMapView *mapView_;
    GGAreaCell *cellArea;
    NSString *areaID;
    NSMutableArray *markerArr;
    NSIndexPath *selectedIndexpath;
}

@end

static NSString *cellIdentifier = @"areaCell";
BOOL isMapLoaded = false;
BOOL isClicked = true;

@implementation GGGoogleMapsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setupFirstLoadMaps) name:@"mapsActionNotification" object:nil];
    
    [self.colAreaList registerNib:[UINib nibWithNibName:@"GGAreaCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    
    [self.colAreaList setDelegate:self];
    [self.colAreaList setDataSource:self];
    [self.colAreaList setContentInset:UIEdgeInsetsMake(1.25, 1.25, 1.25, 1.25)];
    
    markerArr = [[NSMutableArray alloc] init];
    
    //[self setupAreaList];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    NSLog(@"description %@",[[GGGlobalVariable sharedInstance].itemAreaList[@"data"] description]);
//    if ([[GGGlobalVariable sharedInstance].itemAreaList[@"data"] count] > 0) {
//        selectedIndexpath = [NSIndexPath indexPathForRow:8 inSection:0];
//        areaID = [GGGlobalVariable sharedInstance].itemAreaList[@"data"][8][@"area_id"];
//        [self reloadMapBasedOnAreaID];
//    }
//}

- (void)setupFirstLoadMaps {
    NSLog(@"description %@",[[GGGlobalVariable sharedInstance].itemAreaList[@"data"] description]);
    if ([[GGGlobalVariable sharedInstance].itemAreaList[@"data"] count] > 0) {
        for (int i = 0; i < [[GGGlobalVariable sharedInstance].itemAreaList[@"data"] count]; i++) {
            if ([[[GGGlobalVariable sharedInstance].itemAreaList[@"data"][i] objectForKey:@"area_id"] isEqualToString:@"1"]) {
                selectedIndexpath = [NSIndexPath indexPathForRow:i inSection:0];
            }
        }
        areaID = [GGGlobalVariable sharedInstance].itemAreaList[@"data"][selectedIndexpath.row][@"area_id"];
        [self reloadMapBasedOnAreaID];
    }
}

- (void)setupAreaList {
    if ([[[GGGlobalVariable sharedInstance].itemAreaList objectForKey:@"data"] count] > 0) {
        
        if ([[GGCommonFunc sharedInstance] connected]) {
            [[GGCommonFunc sharedInstance] showLoadingImage:((GGHomePageVC*)((GGHomeVC*)self.googleMapVCDelegate).homeDelegate).homePageView];

            [[GGAPIHomeManager sharedInstance] getMapListWithID:[NSString stringWithFormat:@"%@", [[[[GGGlobalVariable sharedInstance].itemAreaList objectForKey:@"data"] objectAtIndex:0] objectForKey:@"area_id"]] Completion:^(NSDictionary *responseDict, NSError *error) {
                
                NSLog(@"areaList %@", [responseDict description]);
                [[GGCommonFunc sharedInstance] hideLoadingImage:((GGHomePageVC*)((GGHomeVC*)self.googleMapVCDelegate).homeDelegate).homePageView];
                
                if (error == nil) {
                    if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                        [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                        [[GGAPIManager sharedInstance] clearAllData];
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    } else {
                        if([[responseDict objectForKey:@"data"] count] > 0)
                            [self generateMaps];
                        else
                            [self showCommonAlert:@"Notification" message:@"No Spot Available for this Area."];
                        [self.colAreaList performBatchUpdates:^{
                            [self.colAreaList reloadData];
                        } completion:^(BOOL finished) {}];
                    }
                } else {
                    NSLog(@"ERROR : %@", error.localizedDescription);
                }
            }];
        }else{
            [self showCommonAlert:@"Alert" message:@"No internet connection."];
        }
    }
}

- (void)reloadMapBasedOnAreaID {
    if ([[GGCommonFunc sharedInstance] connected]) {
        [[GGCommonFunc sharedInstance] showLoadingImage:((GGHomePageVC*)((GGHomeVC*)self.googleMapVCDelegate).homeDelegate).homePageView];
        [[GGAPIHomeManager sharedInstance] getMapListWithID:areaID Completion:^(NSDictionary *responseDict, NSError *error) {
            
            [[GGCommonFunc sharedInstance] hideLoadingImage:((GGHomePageVC*)((GGHomeVC*)self.googleMapVCDelegate).homeDelegate).homePageView];
            
            if (error == nil) {
                if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                    [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                    [[GGAPIManager sharedInstance] clearAllData];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    NSLog(@"responseDict Maps %@", [responseDict description]);
                    [self generateMaps];

//                    if ([[responseDict objectForKey:@"data"] count] > 0) {
//                        
//                    } else {
//                        [self showCommonAlert:@"Notification" message:@"No Spot Available for this Area."];
//                    }
                }
            } else {
                NSLog(@"ERROR : %@", error.localizedDescription);
                isClicked = true;
            }
        }];
    }else{
        [self showCommonAlert:@"Alert" message:@"No internet connection."];
    }
}

- (void) generateMaps {
    
    NSLog(@"itemMapList %@", [[GGGlobalVariable sharedInstance].itemMapList description]);
    
    NSArray *mapsDict = [[NSArray alloc] init];
    
    mapsDict = [[GGGlobalVariable sharedInstance].itemMapList objectForKey:@"data"];
    NSLog(@"mapDict %@", [mapsDict description]);
    GMSCameraPosition *camera = nil;
    
    camera = [GMSCameraPosition cameraWithLatitude:[[GGGlobalVariable sharedInstance].itemAreaList[@"data"][selectedIndexpath.row][@"lat"] doubleValue]
                                         longitude:[[GGGlobalVariable sharedInstance].itemAreaList[@"data"][selectedIndexpath.row][@"lang"] doubleValue]
                                              zoom:11];
    
//    if (isMapLoaded == false) {
//        mapView_ = [GMSMapView mapWithFrame:self.mapVIew.bounds camera:camera];
//        mapView_.myLocationEnabled = YES;
//        mapView_.delegate = self;
//        [self.mapVIew addSubview:mapView_];
//        isMapLoaded = true;
//        [self.colAreaList selectItemAtIndexPath:selectedIndexpath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
//    }else{
//        [mapView_ setCamera:camera];
//    }
    
    mapView_ = [GMSMapView mapWithFrame:self.mapVIew.bounds camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.delegate = self;
    [self.mapVIew addSubview:mapView_];
    [self.colAreaList selectItemAtIndexPath:selectedIndexpath animated:NO scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
    
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
        
        [markerArr addObject:mapsDict[i]];
    }
    
    isClicked = true;
}

- (void)setIsClicked:(BOOL)value {
    isClicked = value;
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
                                   isClicked = true;
                               }];
    
    [alert addAction:okButton];
    
    [self presentViewController:alert  animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICOLLECTIONVIEW

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [[GGGlobalVariable sharedInstance].itemAreaList[@"data"] count];
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    GGAreaCell *selectedCell = (GGAreaCell *) cell;
    
    if (selectedCell == nil) {
        return;
    }
    
    if (selectedCell.selected == true) {
        selectedCell.lblArea.textColor = [[GGCommonFunc sharedInstance] colorWithHexString:@"7ED321"];
    }else{
        selectedCell.lblArea.textColor = [[GGCommonFunc sharedInstance] colorWithHexString:@"FFFFFF"];
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    cellArea = (GGAreaCell *)[self.colAreaList dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if ([[GGGlobalVariable sharedInstance].itemAreaList[@"data"] count] > 0) {
        cellArea.lblArea.text = [GGGlobalVariable sharedInstance].itemAreaList[@"data"][indexPath.row][@"area_name"];
    }
    
    return cellArea;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    selectedIndexpath = indexPath;
    GGAreaCell *selectedCell = (GGAreaCell *)[self.colAreaList cellForItemAtIndexPath:indexPath];
    
    if (selectedCell == nil) {
        return;
    }
    
    selectedCell.selected = true;
    selectedCell.lblArea.textColor = [[GGCommonFunc sharedInstance] colorWithHexString:@"7ED321"];
    
    if (isClicked == true) {
        isClicked = false;
        areaID = [GGGlobalVariable sharedInstance].itemAreaList[@"data"][indexPath.row][@"area_id"];
        [self reloadMapBasedOnAreaID];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    GGAreaCell *selectedCell = (GGAreaCell *)[self.colAreaList cellForItemAtIndexPath:indexPath];
    
    if (selectedCell == nil) {
        return;
    }
    
    selectedCell.selected = false;
    selectedCell.lblArea.textColor = [[GGCommonFunc sharedInstance] colorWithHexString:@"FFFFFF"];
}

#pragma end

#pragma mark - UIMAPVIEW
- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(nonnull GMSMarker *)marker {
    
    if (isClicked == true) {
        isClicked = false;
        NSLog(@"JUDUL : %@", marker.title);
        
        NSLog(@"markerArr %@", [markerArr description]);
        
        for (int i=0; i < [markerArr count]; i++) {
            if ([marker.title isEqual:markerArr[i][@"gname"]]) {
                
                if ([[GGCommonFunc sharedInstance] connected]) {
                    [[GGAPICourseManager sharedInstance] getCourseDetailWithID:markerArr[i][@"gid"] completion:^(NSDictionary *responseDict, NSError *error) {
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
                                searchDetailView.searchListDelegate = self;
                                [self.navigationController pushViewController:searchDetailView animated:YES];
                                //isClicked = true;
                            }
                        } else {
                            NSLog(@"Error : %@", error.localizedDescription);
                        }
                    }];
                }else{
                    [self showCommonAlert:@"Alert" message:@"No internet connection."];
                }
                
                break;
            }
        }
    }
    
}

#pragma end

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
