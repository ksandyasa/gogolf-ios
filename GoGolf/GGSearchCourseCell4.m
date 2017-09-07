//
//  GGSearchCourseCell4.m
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/9/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGSearchCourseCell4.h"

@implementation GGSearchCourseCell4 {
    GGCourseCell *colCell;
}

static NSString *colCellIdentifier = @"courseCell";

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.colCourseList registerNib:[UINib nibWithNibName:@"GGCourseCell" bundle:nil] forCellWithReuseIdentifier:colCellIdentifier];
    
    [self.colCourseList setDelegate:self];
    [self.colCourseList setDataSource:self];
    [self.colCourseList setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
}

- (void)reloadCourseList:(NSInteger)selectedIndex {
    if (self.courseDict != nil) {
        [self.colCourseList reloadData];
        [self.colCourseList selectItemAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] animated:true scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        [self fillCourseInputFromCell:self.courseDict[selectedIndex][@"gname"] fromIndeks:selectedIndex];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)fillCourseInputFromCell:(NSString *)courseName fromIndeks:(NSInteger)index {
    if ([self.searchDelegate isKindOfClass:[GGSearchGolfCourseVC class]]) {
        [self.searchDelegate fillCourseNameInput:courseName fromIndeks:index];
    }else if ([self.searchDelegate isKindOfClass:[GGSearchGolfCoursePromotionVC class]]) {
        [self.searchDelegate fillCourseNameInput:courseName fromIndeks:index];
    }
}

#pragma mark - UICOLLECTIONVIEW

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return (self.courseDict != nil) ? [self.courseDict count] : 0;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    GGCourseCell *selectedCell = (GGCourseCell *)cell;
    
    if (selectedCell == nil) {
        return;
    }
    
    if (selectedCell.selected == true) {
        selectedCell.lblCourseName.textColor = [[GGCommonFunc sharedInstance] colorWithHexString:@"7ED321"];
    }else{
        selectedCell.lblCourseName.textColor = [[GGCommonFunc sharedInstance] colorWithHexString:@"FFFFFF"];
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    colCell = (GGCourseCell *)[self.colCourseList dequeueReusableCellWithReuseIdentifier:colCellIdentifier forIndexPath:indexPath];
    
    if (self.courseDict != nil) {
        colCell.lblCourseName.text = self.courseDict[indexPath.row][@"gname"];
    }
    
    return colCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"clicked");
    GGCourseCell *selectedCell = (GGCourseCell *)[self.colCourseList cellForItemAtIndexPath:indexPath];
    
    if (selectedCell == nil) {
        return;
    }
    
    selectedCell.selected = true;
    selectedCell.lblCourseName.textColor = [[GGCommonFunc sharedInstance] colorWithHexString:@"7ED321"];
    
    [self fillCourseInputFromCell:self.courseDict[indexPath.row][@"gname"] fromIndeks:indexPath.row];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    GGCourseCell *selectedCell = (GGCourseCell *)[self.colCourseList cellForItemAtIndexPath:indexPath];
    
    if (selectedCell == nil) {
        return;
    }
    
    selectedCell.selected = false;
    selectedCell.lblCourseName.textColor = [[GGCommonFunc sharedInstance] colorWithHexString:@"FFFFFF"];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(133, 36);
}

#pragma end

@end
