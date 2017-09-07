//
//  GGGoogleMapsVC.h
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/6/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GGAreaCell.h"
#import "GGGolfDetailVC.h"
#import "GGSearchDetailVC.h"
#import "GGAPIHomeManager.h"
#import "GGAPICourseManager.h"
#import "GGGlobalVariable.h"
#import "GGCommonFunc.h"

@import GoogleMaps;

@interface GGGoogleMapsVC : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource, GMSMapViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *mapVIew;

@property (weak, nonatomic) IBOutlet UICollectionView *colAreaList;

@property (weak, nonatomic) id googleMapVCDelegate;

- (void)setIsClicked:(BOOL)value;

@end
