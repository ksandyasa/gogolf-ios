//
//  GGSearchDetailCell7.m
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/14/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGSearchDetailCell7.h"

@implementation GGSearchDetailCell7 {
    GGAmenitiesCell *colCell;
    UIImage *imageCell;
}

static NSString *colCellIdentifier = @"amenitiesCell";

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self.colAmenitiesList registerNib:[UINib nibWithNibName:@"GGAmenitiesCell" bundle:nil] forCellWithReuseIdentifier:colCellIdentifier];
    
    [self.colAmenitiesList setDelegate:self];
    [self.colAmenitiesList setDataSource:self];
    
}

- (void)refreshColAmenitiesList {
    [self.colAmenitiesList reloadData];
    NSLog(@"amenitiesList %@", [self.amenitiesList description]);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - UICOLLECTIONVIEW

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.amenitiesList count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    colCell = (GGAmenitiesCell *)[self.colAmenitiesList dequeueReusableCellWithReuseIdentifier:colCellIdentifier forIndexPath:indexPath];
    
    if ([self.amenitiesList count] > 0) {
        if ([self.amenitiesList[indexPath.row] isEqualToString:@"Golf Carts"]) {
            colCell.ivIcon.image = [UIImage imageNamed:@"Golf Cart.png"];
            colCell.tvTitle.text = [NSString stringWithFormat:@"%@",self.amenitiesList[indexPath.row]];
            colCell.ivCheck.image = [UIImage imageNamed:@"Checklist.png"];
        }else if ([self.amenitiesList[indexPath.row] isEqualToString:@"Shoe Rental"]) {
            colCell.ivIcon.image = [UIImage imageNamed:@"Shoe Rental.png"];
            colCell.tvTitle.text = [NSString stringWithFormat:@"%@",self.amenitiesList[indexPath.row]];
            colCell.ivCheck.image = [UIImage imageNamed:@"Checklist.png"];
        }else if ([self.amenitiesList[indexPath.row] isEqualToString:@"Locker Room"]) {
            colCell.ivIcon.image = [UIImage imageNamed:@"Locker Room.png"];
            colCell.tvTitle.text = [NSString stringWithFormat:@"%@",self.amenitiesList[indexPath.row]];
            colCell.ivCheck.image = [UIImage imageNamed:@"Checklist.png"];
        }else if ([self.amenitiesList[indexPath.row] isEqualToString:@"Practice Facility"]) {
            colCell.ivIcon.image = [UIImage imageNamed:@"Practice Facility.png"];
            colCell.tvTitle.text = [NSString stringWithFormat:@"%@",self.amenitiesList[indexPath.row]];
            colCell.ivCheck.image = [UIImage imageNamed:@"Checklist.png"];
        }else if ([self.amenitiesList[indexPath.row] isEqualToString:@"Night Golf"]) {
            colCell.ivIcon.image = [UIImage imageNamed:@"Night Golf.png"];
            colCell.tvTitle.text = [NSString stringWithFormat:@"%@",self.amenitiesList[indexPath.row]];
            colCell.ivCheck.image = [UIImage imageNamed:@"Checklist.png"];
        }else if ([self.amenitiesList[indexPath.row] isEqualToString:@"Lesson"]) {
            colCell.ivIcon.image = [UIImage imageNamed:@"Lesson.png"];
            colCell.tvTitle.text = [NSString stringWithFormat:@"%@",self.amenitiesList[indexPath.row]];
            colCell.ivCheck.image = [UIImage imageNamed:@"Checklist.png"];
        }else if ([self.amenitiesList[indexPath.row] isEqualToString:@"Golf Shop"]) {
            colCell.ivIcon.image = [UIImage imageNamed:@"Golf Shop.png"];
            colCell.tvTitle.text = [NSString stringWithFormat:@"%@",self.amenitiesList[indexPath.row]];
            colCell.ivCheck.image = [UIImage imageNamed:@"Checklist.png"];
        }else if ([self.amenitiesList[indexPath.row] isEqualToString:@"Restaurant"]) {
            colCell.ivIcon.image = [UIImage imageNamed:@"Restaurant.png"];
            colCell.tvTitle.text = [NSString stringWithFormat:@"%@",self.amenitiesList[indexPath.row]];
            colCell.ivCheck.image = [UIImage imageNamed:@"Checklist.png"];
        }else if ([self.amenitiesList[indexPath.row] isEqualToString:@"Accomodation"]) {
            colCell.ivIcon.image = [UIImage imageNamed:@"Accomodation.png"];
            colCell.tvTitle.text = [NSString stringWithFormat:@"%@",self.amenitiesList[indexPath.row]];
            colCell.ivCheck.image = [UIImage imageNamed:@"Checklist.png"];
        }else if ([self.amenitiesList[indexPath.row] isEqualToString:@"Health Club"]) {
            colCell.ivIcon.image = [UIImage imageNamed:@"Health Club.png"];
            colCell.tvTitle.text = [NSString stringWithFormat:@"%@",self.amenitiesList[indexPath.row]];
            colCell.ivCheck.image = [UIImage imageNamed:@"Checklist.png"];
        }else if ([self.amenitiesList[indexPath.row] isEqualToString:@"Club Rental"]) {
            colCell.ivIcon.image = [UIImage imageNamed:@"Club Rental.png"];
            colCell.tvTitle.text = [NSString stringWithFormat:@"%@",self.amenitiesList[indexPath.row]];
            colCell.ivCheck.image = [UIImage imageNamed:@"Checklist.png"];
        }else if ([self.amenitiesList[indexPath.row] isEqualToString:@"Spa"]) {
            colCell.ivIcon.image = [UIImage imageNamed:@"Spa.png"];
            colCell.tvTitle.text = [NSString stringWithFormat:@"%@",self.amenitiesList[indexPath.row]];
            colCell.ivCheck.image = [UIImage imageNamed:@"Checklist.png"];
        }else if ([self.amenitiesList[indexPath.row] isEqualToString:@"Club Valet"]) {
            colCell.ivIcon.image = [UIImage imageNamed:@"Club Rental.png"];
            colCell.tvTitle.text = [NSString stringWithFormat:@"%@",self.amenitiesList[indexPath.row]];
            colCell.ivCheck.image = [UIImage imageNamed:@"Checklist.png"];
        }
            
    }
    
//    if (indexPath.row == 0) {
//        
//        colCell.ivIcon.image = [UIImage imageNamed:@"Golf Cart.png"];
//        colCell.lblTitle.text = @"Golf Cart";
//        
//    }else if (indexPath.row == 1) {
//        
//        colCell.ivIcon.image = [UIImage imageNamed:@"Shoe Rental.png"];
//        colCell.lblTitle.text = @"Shoe Rental";
//        
//    }else if (indexPath.row == 2) {
//        
//        colCell.ivIcon.image = [UIImage imageNamed:@"Caddy.png"];
//        colCell.lblTitle.text = @"Caddy";
//        
//    }else if (indexPath.row == 3) {
//        
//        colCell.ivIcon.image = [UIImage imageNamed:@"Locker Room.png"];
//        colCell.lblTitle.text = @"Locker Room";
//        
//    }else if (indexPath.row == 4) {
//        
//        colCell.ivIcon.image = [UIImage imageNamed:@"Practice Facility.png"];
//        colCell.lblTitle.text = @"Practice Facility";
//        
//    }else if (indexPath.row == 5) {
//        
//        colCell.ivIcon.image = [UIImage imageNamed:@"Night Golf.png"];
//        colCell.lblTitle.text = @"Night Golf";
//        
//    }else if (indexPath.row == 6) {
//        
//        colCell.ivIcon.image = [UIImage imageNamed:@"Lesson.png"];
//        colCell.lblTitle.text = @"Lesson";
//        
//    }else if (indexPath.row == 7) {
//        
//        colCell.ivIcon.image = [UIImage imageNamed:@"Golf Shop.png"];
//        colCell.lblTitle.text = @"Golf Shop";
//        
//    }else if (indexPath.row == 8) {
//        
//        colCell.ivIcon.image = [UIImage imageNamed:@"Restaurant.png"];
//        colCell.lblTitle.text = @"Restaurant";
//        
//    }else if (indexPath.row == 9) {
//        
//        colCell.ivIcon.image = [UIImage imageNamed:@"Accomodation.png"];
//        colCell.lblTitle.text = @"Accomodation";
//        
//    }else if (indexPath.row == 10) {
//        
//        colCell.ivIcon.image = [UIImage imageNamed:@"Spa.png"];
//        colCell.lblTitle.text = @"Spa";
//        
//    }else if (indexPath.row == 11) {
//        
//        colCell.ivIcon.image = [UIImage imageNamed:@"Health Club.png"];
//        colCell.lblTitle.text = @"Health Club";
//        
//    }else if (indexPath.row == 12) {
//        
//        colCell.ivIcon.image = [UIImage imageNamed:@"Club Rental.png"];
//        colCell.lblTitle.text = @"Club Rental";
//        
//    }
    
    return colCell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(145, 56);
}

#pragma end

@end
