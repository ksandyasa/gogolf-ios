//
//  GGGolfDetailVC.h
//  GoGolf
//
//  Created by Eddyson Tan on 6/14/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GGCommonFunc.h"
#import "GGBookPromotionVC.h"

@import GoogleMaps;

@interface GGGolfDetailVC : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource> {
    GMSMapView *mapCourseView_;
}

@property (nonatomic, retain) NSDictionary *courseDetailArr;

@property (weak, nonatomic) IBOutlet UILabel *lblTitleCourse;

@property (weak, nonatomic) IBOutlet UIView *promoView;

@property (weak, nonatomic) IBOutlet UILabel *lblCourseAddress;

@property (weak, nonatomic) IBOutlet UIImageView *imgGolf;

@property (weak, nonatomic) IBOutlet UITextView *txtCourseAbout;

@property (weak, nonatomic) IBOutlet UIView *viewMapsDetail;
@property (weak, nonatomic) IBOutlet UIView *viewMaps;

@property (weak, nonatomic) IBOutlet UICollectionView *detailPromoColl;
@end
