//
//  GGSearchDetailCell7.h
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/14/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGAmenitiesCell.h"

@interface GGSearchDetailCell7 : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UILabel *lblTitleAmenities;

@property (weak, nonatomic) IBOutlet UICollectionView *colAmenitiesList;

@property (nonatomic) NSMutableArray *amenitiesList;

- (void)refreshColAmenitiesList;

@end
