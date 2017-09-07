//
//  GGSearchDetailCell4.m
//  GoGolf
//
//  Created by Aprido Sandyasa on 10/31/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGSearchDetailCell4.h"

@implementation GGSearchDetailCell4

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.colCoursePromo registerNib:[UINib nibWithNibName:@"GGSearchDetailPromoCell" bundle:nil] forCellWithReuseIdentifier:@"detailPromoCell"];
    
    [self.colCoursePromo setDelegate:self];
    [self.colCoursePromo setDataSource:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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

#pragma end

@end
