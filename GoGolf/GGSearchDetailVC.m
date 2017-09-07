//
//  GGSearchDetailVC.m
//  GoGolf
//
//  Created by Aprido Sandyasa on 10/31/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGSearchDetailVC.h"

@interface GGSearchDetailVC () {
    GGCourseHeader *headerView;
    GGSearchDetailCell1 *cell1;
    GGSearchDetailCell2 *cell2;
    GGSearchDetailCell3 *cell3;
    GGSearchDetailCell4 *cell4;
    GGSearchDetailCell5 *cell5;
    GGSearchDetailCell6 *cell6;
    GGSearchDetailCell7 *cell7;
    NSMutableArray *amenities;
}

@end

CGFloat kAmenitiesHeight = 550.0;
static NSString *cellIdentifier1 = @"searchDetailCell1";
static NSString *cellIdentifier2 = @"searchDetailCell2";
static NSString *cellIdentifier3 = @"searchDetailCell3";
static NSString *cellIdentifier4 = @"searchDetailCell4";
static NSString *cellIdentifier5 = @"searchDetailCell5";
static NSString *cellIdentifier6 = @"searchDetailCell6";
static NSString *cellIdentifier7 = @"searchDetailCell7";

@implementation GGSearchDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.isMapLoaded = false;
    
    [self.tblDetailGourse registerNib:[UINib nibWithNibName:@"GGSearchDetailCell1" bundle:nil] forCellReuseIdentifier:cellIdentifier1];
    [self.tblDetailGourse registerNib:[UINib nibWithNibName:@"GGSearchDetailCell2" bundle:nil] forCellReuseIdentifier:cellIdentifier2];
    [self.tblDetailGourse registerNib:[UINib nibWithNibName:@"GGSearchDetailCell3" bundle:nil] forCellReuseIdentifier:cellIdentifier3];
    [self.tblDetailGourse registerNib:[UINib nibWithNibName:@"GGSearchDetailCell4" bundle:nil] forCellReuseIdentifier:cellIdentifier4];
    [self.tblDetailGourse registerNib:[UINib nibWithNibName:@"GGSearchDetailCell5" bundle:nil] forCellReuseIdentifier:cellIdentifier5];
    
    [self.tblDetailGourse setDelegate:self];
    [self.tblDetailGourse setDataSource:self];
    
    NSLog(@"courseDetailArr %@", [[self.courseDetailArr objectForKey:@"data"] description]);
    self.slideArray = [[self.courseDetailArr objectForKey:@"data"] objectForKey:@"imagearr"];
    [self setupAmenitiesList];
    [self setupHeaderView];
    [self setupCourseSlideView];
}

- (void)backToSearchView {
    [self.navigationController popViewControllerAnimated:true];
}

- (void)setupHeaderView {
    NSArray *nibViews = [[NSBundle mainBundle] loadNibNamed:@"GGCourseHeader"
                                                                owner:self
                                                              options:nil];
    headerView = [nibViews objectAtIndex:0];
    headerView.detailCourseDelegate = self;
    headerView.maximumContentHeight = 266.0;
    [self.tblDetailGourse addSubview:headerView];
}

- (void)setupCourseSlideView {
    self.slideVC = [[UIPageViewControllerWithOverlayIndicator alloc]
                    initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                    options:nil];
    
    [self.slideVC setDelegate:self];
    [self.slideVC setDataSource:self];
    
    [self.slideVC setViewControllers:@[[self viewControllerAtIndex:0]]
                           direction:UIPageViewControllerNavigationDirectionForward
                            animated:true
                          completion:nil];
    
    [self addChildViewController:self.slideVC];
    self.slideVC.view.frame = headerView.viewSlide.frame;
    [headerView.viewSlide addSubview:self.slideVC.view];
    [self.slideVC didMoveToParentViewController:self];
    if ([self.searchListDelegate isKindOfClass:[GGGoogleMapsVC class] ]) {
        [self.searchListDelegate setIsClicked:true];
    }
    
    [self.tblDetailGourse reloadData];
}

- (void)setupAmenitiesList {
    amenities = [[NSMutableArray alloc] init];
    NSLog(@"%@", [self.courseDetailArr[@"data"] objectForKey:@"caddy"]);
    if ([[self.courseDetailArr[@"data"] objectForKey:@"carts"] isEqualToString:@"1"])
        [amenities addObject:@"Golf Carts"];
    if ([[self.courseDetailArr[@"data"] objectForKey:@"shoe_rental"] isEqualToString:@"1"])
        [amenities addObject:@"Shoe Rental"];
    if ([[self.courseDetailArr[@"data"] objectForKey:@"caddy"] isEqualToString:@"1"])
        [amenities addObject:@"Caddy"];
    if ([[self.courseDetailArr[@"data"] objectForKey:@"locker_room"] isEqualToString:@"1"])
        [amenities addObject:@"Locker Room"];
    if ([[self.courseDetailArr[@"data"] objectForKey:@"practice_facility"] isEqualToString:@"1"])
        [amenities addObject:@"Practice Facility"];
    if ([[self.courseDetailArr[@"data"] objectForKey:@"night_golf"] isEqualToString:@"1"])
        [amenities addObject:@"Night Golf"];
    if ([[self.courseDetailArr[@"data"] objectForKey:@"lesson"] isEqualToString:@"1"])
        [amenities addObject:@"Lesson"];
    if ([[self.courseDetailArr[@"data"] objectForKey:@"golf_shop"] isEqualToString:@"1"])
        [amenities addObject:@"Golf Shop"];
    if ([[self.courseDetailArr[@"data"] objectForKey:@"restaurant"] isEqualToString:@"1"])
        [amenities addObject:@"Restaurant"];
    if ([[self.courseDetailArr[@"data"] objectForKey:@"accomodation"] isEqualToString:@"1"])
        [amenities addObject:@"Accomodation"];
    if ([[self.courseDetailArr[@"data"] objectForKey:@"spa"] isEqualToString:@"1"])
        [amenities addObject:@"Spa"];
    if ([[self.courseDetailArr[@"data"] objectForKey:@"health_club"] isEqualToString:@"1"])
        [amenities addObject:@"Health Club"];
    if ([[self.courseDetailArr[@"data"] objectForKey:@"club_rental"] isEqualToString:@"1"])
        [amenities addObject:@"Club Rental"];
    if ([[self.courseDetailArr[@"data"] objectForKey:@"club_valet"] isEqualToString:@"1"])
        [amenities addObject:@"Club Valet"];
    if ([amenities count] == 0) {
        kAmenitiesHeight = 0.0;
    }else{
        kAmenitiesHeight = 550.0;
    }
}

- (void)bookGolfCourse {
    NSLog(@"clicked");
    
//    GGBookPromotionVC *bookPromoView  = [self.storyboard instantiateViewControllerWithIdentifier:@"bookPromoVC"];
//    bookPromoView.isHomeList = NO;
//    [bookPromoView setDetailArr:[self.courseDetailArr objectForKey:@"data"]];
    
    GGPreBookingVC *preBookingView  = [self.storyboard instantiateViewControllerWithIdentifier:@"preBookingView"];
    preBookingView.isHomeList = NO;
    preBookingView.detailArr = [self.courseDetailArr objectForKey:@"data"];
    
    [self.navigationController pushViewController:preBookingView animated:YES];

}

- (GGCourseHeaderDetail *)viewControllerAtIndex:(NSUInteger)index {
    if (([self.slideArray count] == 0) || (index == [self.slideArray count])) {
        return nil;
    }
    
    self.slideContentVC = [[GGCourseHeaderDetail alloc] initWithNibName:@"GGCourseHeaderDetail" bundle:nil];
    self.slideContentVC.courseImage = [self.slideArray objectAtIndex:index];
    self.slideContentVC.imageIndex = index;
    
    return self.slideContentVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITABLEVIEW

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        
        cell1 = (GGSearchDetailCell1 *) [self.tblDetailGourse dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (cell1 == nil) {
            NSArray *cellArray1 = [[NSBundle mainBundle] loadNibNamed:@"GGSearchDetailCell1" owner:self options:nil];
            cell1 = [cellArray1 objectAtIndex:0];
        }
        
        if ([[self.courseDetailArr objectForKey:@"data"] objectForKey:@"gname"] == nil || [[self.courseDetailArr objectForKey:@"data"] objectForKey:@"gname"] == (id) [NSNull null]) {
            cell1.lblCourseName.text = @"<not available>";
        } else {
            cell1.lblCourseName.text = [[self.courseDetailArr objectForKey:@"data"] objectForKey:@"gname"];
        }
        
        if ([[self.courseDetailArr objectForKey:@"data"] objectForKey:@"address"] == nil || [[self.courseDetailArr objectForKey:@"data"] objectForKey:@"address"] == (id) [NSNull null]) {
            cell1.lblCourseAddress.text = @"<not available>";
        } else {
            cell1.lblCourseAddress.text = [[self.courseDetailArr objectForKey:@"data"] objectForKey:@"address"];
        }
        
        
        return cell1;
        
    } else if (indexPath.row == 1) {
        
        cell2 = (GGSearchDetailCell2 *) [self.tblDetailGourse dequeueReusableCellWithIdentifier:cellIdentifier2];
        if (cell2 == nil) {
            NSArray *cellArray2 = [[NSBundle mainBundle] loadNibNamed:@"GGSearchDetailCell2" owner:self options:nil];
            cell2 = [cellArray2 objectAtIndex:0];
        }
        
        if ([[self.courseDetailArr objectForKey:@"data"] objectForKey:@"info"] == nil || [[self.courseDetailArr objectForKey:@"data"] objectForKey:@"info"] == (id) [NSNull null]) {
            cell2.lblDesc.text = @"<not available>";
        } else {
            
            cell2.lblDesc.text = [[self.courseDetailArr objectForKey:@"data"] objectForKey:@"info"];
        }
        
        return cell2;
        
    } else if (indexPath.row == 2) {
        
        cell6 = (GGSearchDetailCell6 *) [self.tblDetailGourse dequeueReusableCellWithIdentifier:cellIdentifier6];
        if (cell6 == nil) {
            NSArray *cellArray6 = [[NSBundle mainBundle] loadNibNamed:@"GGSearchDetailCell6" owner:self options:nil];
            cell6 = [cellArray6 objectAtIndex:0];
        }
        
        if (self.courseDetailArr[@"data"][@"open"] != [NSNull null]) {
            cell6.lblSTime.text = [[GGCommonFunc sharedInstance] changeFormatTimeForCourseDetail:self.courseDetailArr[@"data"][@"open"]];
            cell6.lblETime.text = [[GGCommonFunc sharedInstance] changeFormatTimeForCourseDetail:self.courseDetailArr[@"data"][@"close"]];
            cell6.lblDay.text = self.courseDetailArr[@"data"][@"closedate"];
            cell6.lblHoles.text = [NSString stringWithFormat:@"%@ Holes", self.courseDetailArr[@"data"][@"holes"]];
            cell6.lblPar.text = [NSString stringWithFormat:@"%@ Yards", self.courseDetailArr[@"data"][@"par"]];
            cell6.lblLength.text = [NSString stringWithFormat:@"%@ Yards", self.courseDetailArr[@"data"][@"length"]];
            //        cell6.lblEstDate.text = [[GGCommonFunc sharedInstance] changeDateFormatForCourseDetail:self.courseDetailArr[@"data"][@"establish"]];
            cell6.lblDesign.text = self.courseDetailArr[@"data"][@"designer"];
        }
        
        return cell6;
        
    } else if (indexPath.row == 3) {
        
        cell7 = (GGSearchDetailCell7 *) [self.tblDetailGourse dequeueReusableCellWithIdentifier:cellIdentifier7];
        if (cell7 == nil) {
            NSArray *cellArray7 = [[NSBundle mainBundle] loadNibNamed:@"GGSearchDetailCell7" owner:self options:nil];
            cell7 = [cellArray7 objectAtIndex:0];
        }
        
        cell7.amenitiesList = amenities;
        [cell7 refreshColAmenitiesList];
        if (kAmenitiesHeight == 0.0) {
            cell7.lblTitleAmenities.hidden = true;
            cell7.colAmenitiesList.hidden = true;
        }else{
            cell7.lblTitleAmenities.hidden = false;
            cell7.colAmenitiesList.hidden = false;
        }
        
        return cell7;
        
    } else if (indexPath.row == 4) {
        
        cell3 = (GGSearchDetailCell3 *) [self.tblDetailGourse dequeueReusableCellWithIdentifier:cellIdentifier3];
        if (cell3 == nil) {
            NSArray *cellArray3 = [[NSBundle mainBundle] loadNibNamed:@"GGSearchDetailCell3" owner:self options:nil];
            cell3 = [cellArray3 objectAtIndex:0];
        }
        
        if (self.isMapLoaded == false)
            [self generateMaps:cell3.contentView];
        
        return cell3;
        
    }
//    else if (indexPath.row == 5) {
//        
//        cell4 = (GGSearchDetailCell4 *) [self.tblDetailGourse dequeueReusableCellWithIdentifier:cellIdentifier4];
//        if (cell4 == nil) {
//            NSArray *cellArray4 = [[NSBundle mainBundle] loadNibNamed:@"GGSearchDetailCell4" owner:self options:nil];
//            cell4 = [cellArray4 objectAtIndex:0];
//        }
//        
//        cell4.courseDetailArr = self.courseDetailArr;
//        [cell4.colCoursePromo reloadData];
//        if ([[[self.courseDetailArr objectForKey:@"data"] objectForKey:@"promotion"] count] == 0) {
//            cell4.colCoursePromo.hidden = true;
//        }
//        
//        return cell4;
//        
//    }
    else if (indexPath.row == 5) {
        
        cell5 = (GGSearchDetailCell5 *) [self.tblDetailGourse dequeueReusableCellWithIdentifier:cellIdentifier5];
        if (cell5 == nil) {
            NSArray *cellArray5 = [[NSBundle mainBundle] loadNibNamed:@"GGSearchDetailCell5" owner:self options:nil];
            cell5 = [cellArray5 objectAtIndex:0];
        }
        
        cell5.searchDetailDelegate = self;
        
        return cell5;
        
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0)
        return 110.0;
    else if (indexPath.row == 1)
        return 95.0;
    else if (indexPath.row == 2)
        return 110;
    else if (indexPath.row == 3)
        return 550.0;
    else if (indexPath.row == 4)
        return 220.0;
//    else if (indexPath.row == 5)
//        return 250.0;
    else if (indexPath.row == 5)
        return 55.0;
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0)
        return UITableViewAutomaticDimension;
    else if (indexPath.row == 1)
        return UITableViewAutomaticDimension;
    else if (indexPath.row == 2)
        return 110;
    else if (indexPath.row == 3)
        return kAmenitiesHeight;
    else if (indexPath.row == 4)
        return 220.0;
//    else if (indexPath.row == 5)
//        return 250.0;
    else if (indexPath.row == 5)
        return 55.0;
    
    return 0;
}

#pragma end

#pragma mark - UIPAGEVIEWCONTROLLER

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger index = ((GGCourseHeaderDetail*)viewController).imageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger index = ((GGCourseHeaderDetail*)viewController).imageIndex;
    
    if (index == NSNotFound || index == [self.slideArray count] - 1) {
        return nil;
    }
    NSLog(@"index Slide %ld", (long)index);
    index++;
    
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return [self.slideArray count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

#pragma end

#pragma mark - Google Maps

- (void) generateMaps:(UIView *)contentView {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    GMSCameraPosition *camera = nil;
    
    camera = [GMSCameraPosition cameraWithLatitude:[[self.courseDetailArr objectForKey:@"data"][@"lat"] doubleValue]
                                         longitude:[[self.courseDetailArr objectForKey:@"data"][@"ing"] doubleValue]
                                              zoom:12];
    
    self.mapCourseView = [GMSMapView mapWithFrame:CGRectMake(0, 0, screenRect.size.width, contentView.frame.size.height) camera:camera];
    self.mapCourseView.myLocationEnabled = YES;
    self.mapCourseView.userInteractionEnabled = NO;
    
    CLLocationCoordinate2D position = { [[self.courseDetailArr objectForKey:@"data"][@"lat"] doubleValue], [[self.courseDetailArr objectForKey:@"data"][@"ing"] doubleValue] };
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.title = [self.courseDetailArr objectForKey:@"data"][@"gname"];
    marker.appearAnimation = YES;
    marker.flat = YES;
    
    UIImage *markerIcon = [UIImage imageNamed:@"marker_icon"];
    markerIcon = [markerIcon imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, (markerIcon.size.height/4), 0)];
    
    
    marker.icon = markerIcon;
    marker.snippet = @"";
    marker.map = self.mapCourseView;
    
    [contentView addSubview:self.mapCourseView];

    self.isMapLoaded = true;
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
