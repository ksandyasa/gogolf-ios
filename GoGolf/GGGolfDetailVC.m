//
//  GGGolfDetailVC.m
//  GoGolf
//
//  Created by Eddyson Tan on 6/14/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGGolfDetailVC.h"

@interface GGGolfDetailVC ()

@end

@implementation GGGolfDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillAppear:(BOOL)animated {
    [self loadDetailValue];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) loadDetailValue {
    if ([[self.courseDetailArr objectForKey:@"data"] objectForKey:@"gname"] == nil || [[self.courseDetailArr objectForKey:@"data"] objectForKey:@"gname"] == (id) [NSNull null]) {
        self.lblTitleCourse.text = @"<not available>";
    } else {
        self.lblTitleCourse.text = [[self.courseDetailArr objectForKey:@"data"] objectForKey:@"gname"];
    }
    
    if ([[self.courseDetailArr objectForKey:@"data"] objectForKey:@"address"] == nil || [[self.courseDetailArr objectForKey:@"data"] objectForKey:@"address"] == (id) [NSNull null]) {
        self.lblCourseAddress.text = @"<not available>";
    } else {
        self.lblCourseAddress.text = [[self.courseDetailArr objectForKey:@"data"] objectForKey:@"address"];
    }
    
    if ([[[self.courseDetailArr objectForKey:@"data"] objectForKey:@"imagearr"] count] > 0) {
        
        [[GGCommonFunc sharedInstance] setLazyLoadImage:self.imgGolf urlString:[[self.courseDetailArr objectForKey:@"data"] objectForKey:@"imagearr"][0]];
    } else {
        self.imgGolf.image = [UIImage imageNamed:@"def_big_img"];
    }
    
    if ([[self.courseDetailArr objectForKey:@"data"] objectForKey:@"info"] == nil || [[self.courseDetailArr objectForKey:@"data"] objectForKey:@"info"] == (id) [NSNull null]) {
        self.txtCourseAbout.text = @"<not available>";
    } else {
        
        self.txtCourseAbout.text = [[self.courseDetailArr objectForKey:@"data"] objectForKey:@"info"];
    }
    
    self.txtCourseAbout.textAlignment = NSTextAlignmentCenter;
    self.txtCourseAbout.textColor = [UIColor darkGrayColor];
    
    if ([[[self.courseDetailArr objectForKey:@"data"] objectForKey:@"promotion"] count] > 0) {
        self.promoView.hidden = NO;
        [self.detailPromoColl reloadData];
    } else
        self.promoView.hidden = YES;
        
    [self generateMaps];
    
}

- (IBAction)bookCourse:(id)sender {
    
    GGBookPromotionVC *bookPromoView  = [self.storyboard instantiateViewControllerWithIdentifier:@"bookPromoVC"];
    bookPromoView.isHomeList = NO;
    [bookPromoView setDetailArr:[self.courseDetailArr objectForKey:@"data"]];
    [self.navigationController pushViewController:bookPromoView animated:YES];
    
}

#pragma mark - Google Maps
- (void) generateMaps {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    GMSCameraPosition *camera = nil;
    
    camera = [GMSCameraPosition cameraWithLatitude:[[self.courseDetailArr objectForKey:@"data"][@"lat"] doubleValue]
                                         longitude:[[self.courseDetailArr objectForKey:@"data"][@"ing"] doubleValue]
                                              zoom:12];
    
    mapCourseView_ = [GMSMapView mapWithFrame:CGRectMake(0, 0, screenRect.size.width, self.viewMapsDetail.frame.size.height) camera:camera];
    mapCourseView_.myLocationEnabled = YES;

    
    CLLocationCoordinate2D position = { [[self.courseDetailArr objectForKey:@"data"][@"lat"] doubleValue], [[self.courseDetailArr objectForKey:@"data"][@"ing"] doubleValue] };
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.title = [self.courseDetailArr objectForKey:@"data"][@"gname"];
    marker.appearAnimation = YES;
    marker.flat = YES;
    
    UIImage *markerIcon = [UIImage imageNamed:@"marker_icon"];
    markerIcon = [markerIcon imageWithAlignmentRectInsets:UIEdgeInsetsMake(0, 0, (markerIcon.size.height/4), 0)];
    
    
    marker.icon = markerIcon;
    marker.snippet = @"";
    marker.map = mapCourseView_;
    
    [self.viewMapsDetail addSubview:mapCourseView_];
}

#pragma mark - UICOLLECTIONVIEW DATASOURCE & DELEGATE
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [[[self.courseDetailArr objectForKey:@"data"] objectForKey:@"promotion"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"detailPromoCell" forIndexPath:indexPath];
    
    UIImageView *imgRow = (UIImageView *)[cell viewWithTag:1];
    if ([[self.courseDetailArr objectForKey:@"data"] objectForKey:@"promotion"][indexPath.row][@"image"] == nil || [[self.courseDetailArr objectForKey:@"data"] objectForKey:@"promotion"][indexPath.row][@"image"] == (id) [NSNull null]) {
        imgRow.image = [UIImage imageNamed:@"def_big_img"];
    } else {
        [[GGCommonFunc sharedInstance] setLazyLoadImage:imgRow urlString:[[self.courseDetailArr objectForKey:@"data"] objectForKey:@"promotion"][indexPath.row][@"image"]];
    }
    
    UILabel *lblPromoDate = (UILabel *)[cell viewWithTag:2];
    if ([[self.courseDetailArr objectForKey:@"data"] objectForKey:@"promotion"][indexPath.row][@"date"] == nil || [[self.courseDetailArr objectForKey:@"data"] objectForKey:@"promotion"][indexPath.row][@"date"] == (id) [NSNull null]) {
        lblPromoDate.text = @"<not available>";
    } else {
        lblPromoDate.text = [[GGCommonFunc sharedInstance] changeDateFormat:[[self.courseDetailArr objectForKey:@"data"] objectForKey:@"promotion"][indexPath.row][@"date"]];
    }
    
    UILabel *lblPromoprice = (UILabel *)[cell viewWithTag:3];
    if ([[self.courseDetailArr objectForKey:@"data"] objectForKey:@"promotion"][indexPath.row][@"pprice"] == nil || [[self.courseDetailArr objectForKey:@"data"] objectForKey:@"pprice"][indexPath.row][@"date"] == (id) [NSNull null]) {
        lblPromoprice.text = @"<not available>";
    } else {
        lblPromoprice.text = [NSString stringWithFormat:@"Rp. %@", [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[[self.courseDetailArr objectForKey:@"data"] objectForKey:@"promotion"][indexPath.row][@"pprice"] floatValue]]];
    }
    
    UILabel *lblRealprice = (UILabel *)[cell viewWithTag:4];
    if ([[self.courseDetailArr objectForKey:@"data"] objectForKey:@"promotion"][indexPath.row][@"prate"] == nil || [[self.courseDetailArr objectForKey:@"data"] objectForKey:@"prate"][indexPath.row][@"date"] == (id) [NSNull null]) {
        lblRealprice.text = @"<not available>";
    } else {
        
        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Rp. %@", [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[[self.courseDetailArr objectForKey:@"data"] objectForKey:@"promotion"][indexPath.row][@"prate"] floatValue]]]];
        [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                value:@2
                                range:NSMakeRange(0, [attributeString length])];
        
        lblRealprice.attributedText = attributeString;
    }
    
    UILabel *lblPromoLimit = (UILabel *)[cell viewWithTag:5];
    if ([[self.courseDetailArr objectForKey:@"data"] objectForKey:@"promotion"][indexPath.row][@"limit_num"] == nil || [[self.courseDetailArr objectForKey:@"data"] objectForKey:@"prate"][indexPath.row][@"limit_num"] == (id) [NSNull null]) {
        lblPromoLimit.text = @"<not available>";
    } else {
        lblPromoLimit.text = [NSString stringWithFormat:@"Rest of limit : %@ Flights", [[self.courseDetailArr objectForKey:@"data"] objectForKey:@"promotion"][indexPath.row][@"limit_num"]];
    }
    
    return cell;
}

@end
