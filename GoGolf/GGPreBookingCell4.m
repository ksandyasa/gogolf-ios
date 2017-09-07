//
//  GGPreBookingCell4.m
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/2/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGPreBookingCell4.h"

@implementation GGPreBookingCell4

int posFlight = 0;

static NSString *cellIdentifier = @"preBookingColCell";

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.btnNextFlight.imageView.transform = CGAffineTransformMakeScale(-1, 1); //Flipped
    
    [self.colFlightDetail registerNib:[UINib nibWithNibName:@"GGPreBookingDetailFlight" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
    
    [self.colFlightDetail setDelegate:self];
    [self.colFlightDetail setDataSource:self];
    
    self.colFlightDetail.contentSize = self.contentView.bounds.size;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)showDetailFlight {
    [self.colFlightDetail reloadData];
    posFlight = 0;
    [self.colFlightDetail scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:posFlight inSection:0]
                                 atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                         animated:YES];
    if ([[self.preBookDict objectForKey:@"flight"] intValue] == 1) {
        self.btnPrevFlight.hidden = true;
        self.btnNextFlight.hidden = true;
    }else{
        self.btnPrevFlight.hidden = false;
        self.btnNextFlight.hidden = false;
        [self setupPrevAndNextTitles];
    }
}

- (void)showTeeTimeFromCell:(int)index {
    if ([self.preBookingDelegate isKindOfClass:[GGPreBookingVC class]]) {
        [self.preBookingDelegate showPreBookingTeeTimePicker:[[[self.preBookDict objectForKey:@"flights"][index] objectForKey:@"ttimePos"] intValue] fromFlightIndex:index];
    }
}

- (void)showPlayerNumberFromCell:(int)index {
    NSLog(@"show player number picker from cell");
    NSLog(@"cartOpt %d", [[NSUserDefaults standardUserDefaults] boolForKey:@"cartOpt"]);
    if ([self.preBookingDelegate isKindOfClass:[GGPreBookingVC class]]) {
        [self.preBookingDelegate showPreBookingPlayerNumberPicker:[[[self.preBookDict objectForKey:@"flights"][index] objectForKey:@"ttimePos"] intValue] fromFlightIndex:index withSelectedPlayerNumber:[[[self.preBookDict objectForKey:@"flights"][index] objectForKey:@"player"] intValue]];
    }
}

- (void)showPlayerTypeFromCell:(BOOL)optCart fromIndex:(int)index atFlightIndex:(int)flightIndex {
    NSLog(@"optCart %d", optCart);
    if ([self.preBookingDelegate isKindOfClass:[GGPreBookingVC class]]) {
        [self.preBookingDelegate showPreBookingPlayerTypePicker:optCart fromIndex:index atFlightIndex:flightIndex];
    }
}

- (void)updateFlightDataBasedOnCartOptFromCell:(int)flightIndex {
    NSLog(@"flightIndex %ld", (long)flightIndex);
    if ([self.preBookingDelegate isKindOfClass:[GGPreBookingVC class]]) {
        [self.preBookingDelegate updateFlightDetailBasedOnCartOpt:flightIndex];
    }
}

- (void)setupPrevAndNextTitles {
    if ([[self.preBookDict objectForKey:@"flights"] count] == 2) {
        if (posFlight == 1) {
            [self.btnPrevFlight setTitle:@"< Flight 1" forState:UIControlStateNormal];
            [self.btnNextFlight setTitle:@"" forState:UIControlStateNormal];
        }else if (posFlight == 0) {
            [self.btnPrevFlight setTitle:@"" forState:UIControlStateNormal];
            [self.btnNextFlight setTitle:@"Flight 2 >" forState:UIControlStateNormal];
        }
    }else if ([[self.preBookDict objectForKey:@"flights"] count] == 3) {
        if (posFlight == 0) {
            [self.btnPrevFlight setTitle:@"" forState:UIControlStateNormal];
            [self.btnNextFlight setTitle:@"Flight 2 >" forState:UIControlStateNormal];
        }else if (posFlight == 1) {
            [self.btnPrevFlight setTitle:@"< Flight 1" forState:UIControlStateNormal];
            [self.btnNextFlight setTitle:@"Flight 3 >" forState:UIControlStateNormal];
        }else if (posFlight == 2) {
            [self.btnPrevFlight setTitle:@"< Flight 2" forState:UIControlStateNormal];
            [self.btnNextFlight setTitle:@"" forState:UIControlStateNormal];
        }
    }else if ([[self.preBookDict objectForKey:@"flights"] count] == 4) {
        if (posFlight == 0) {
            [self.btnPrevFlight setTitle:@"" forState:UIControlStateNormal];
            [self.btnNextFlight setTitle:@"Flight 2 >" forState:UIControlStateNormal];
        }else if (posFlight == 1) {
            [self.btnPrevFlight setTitle:@"< Flight 1" forState:UIControlStateNormal];
            [self.btnNextFlight setTitle:@"Flight 3 >" forState:UIControlStateNormal];
        }else if (posFlight == 2) {
            [self.btnPrevFlight setTitle:@"< Flight 2" forState:UIControlStateNormal];
            [self.btnNextFlight setTitle:@"Flight 4 >" forState:UIControlStateNormal];
        }else if (posFlight == 3) {
            [self.btnPrevFlight setTitle:@"< Flight 3" forState:UIControlStateNormal];
            [self.btnNextFlight setTitle:@"" forState:UIControlStateNormal];
        }
    }else if ([[self.preBookDict objectForKey:@"flights"] count] == 5) {
        if (posFlight == 0) {
            [self.btnPrevFlight setTitle:@"" forState:UIControlStateNormal];
            [self.btnNextFlight setTitle:@"Flight 2 >" forState:UIControlStateNormal];
        }else if (posFlight == 1) {
            [self.btnPrevFlight setTitle:@"< Flight 1" forState:UIControlStateNormal];
            [self.btnNextFlight setTitle:@"Flight 3 >" forState:UIControlStateNormal];
        }else if (posFlight == 2) {
            [self.btnPrevFlight setTitle:@"< Flight 2" forState:UIControlStateNormal];
            [self.btnNextFlight setTitle:@"Flight 4 >" forState:UIControlStateNormal];
        }else if (posFlight == 3) {
            [self.btnPrevFlight setTitle:@"< Flight 3" forState:UIControlStateNormal];
            [self.btnNextFlight setTitle:@"Flight 5 >" forState:UIControlStateNormal];
        }else if (posFlight == 4) {
            [self.btnPrevFlight setTitle:@"< Flight 4" forState:UIControlStateNormal];
            [self.btnNextFlight setTitle:@"" forState:UIControlStateNormal];
        }
    }
}

- (IBAction)showPrevFlight:(id)sender {
    if (posFlight == 0) {
        
        return;
    }
    
    if (posFlight == [[self.preBookDict objectForKey:@"flights"] count] - 1) {
        self.btnNextFlight.hidden = false;
    }
    
    posFlight--;
    
    [self setupPrevAndNextTitles];
    
    [self.colFlightDetail scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:posFlight inSection:0]
                                 atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                         animated:YES];
    
}

- (IBAction)showNextFlight:(id)sender {
    posFlight++;
    
    [self setupPrevAndNextTitles];
    
    if (posFlight == [[self.preBookDict objectForKey:@"flights"] count]) {
        
        return;
    }
    
    if (posFlight > 0)
        self.btnPrevFlight.hidden = false;
    
    [self.colFlightDetail scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:posFlight inSection:0]
                                atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                         animated:YES];
}

#pragma mark - UICOLLECTIONVIEW

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [[self.preBookDict objectForKey:@"flights"] count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    cell = (GGPreBookingDetailFlight *) [self.colFlightDetail dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (self.preBookDict != nil) {
        cell.preBookingCell4Delegate = self;
        cell.preBookDataFromServer = self.preBookDataFromServer;
        cell.preBookDict = self.preBookDict;
        cell.playerArr = [[NSMutableArray alloc] init];
        cell.playerArr = [[self.preBookDict objectForKey:@"flights"][indexPath.row] objectForKey:@"playerarr"];
        cell.flightIndex = (int)indexPath.row;
        cell.lblFlight.text = [NSString stringWithFormat:@"Flight %ld", (long)(indexPath.row + 1)];
        cell.txtTeeTime.text = [NSString stringWithFormat:@"%@", [[self.preBookDict objectForKey:@"flights"][indexPath.row] objectForKey:@"ttime"]];
        float totPrice = [[[self.preBookDict objectForKey:@"flights"][indexPath.row] objectForKey:@"price"] floatValue];
        cell.lblTotPrice.text = [NSString stringWithFormat:@"Rp. %@", [[GGCommonFunc sharedInstance] setSeparatedCurrency:totPrice]];
        cell.txtPlayerNumber.text = [NSString stringWithFormat:@"%@", [[self.preBookDict objectForKey:@"flights"][indexPath.row] objectForKey:@"player"]];
        if ([[[[self.preBookDict objectForKey:@"flights"][indexPath.row] objectForKey:@"cart"] description] isEqualToString:@"1"]) {
            cell.viewOptCart.hidden = true;
            cell.lblCartMandatory.hidden = false;
        }else{
            cell.lblCartMandatory.hidden = true;
            cell.viewOptCart.hidden = false;
        }
        if ([[[self.preBookDict objectForKey:@"flights"][cell.flightIndex] objectForKey:@"cartOpt"]  isEqualToString:@"1"]) {
            cell.isCartOpt = true;
            cell.btnCartYes.selected = true;
            cell.btnCartNo.selected = false;
            [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"cartOpt"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }else if ([[[self.preBookDict objectForKey:@"flights"][cell.flightIndex] objectForKey:@"cartOpt"]  isEqualToString:@"0"]) {
            cell.isCartOpt = false;
            cell.btnCartYes.selected = false;
            cell.btnCartNo.selected = true;
            [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"cartOpt"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }

        
        [cell.tblPlayerType reloadData];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    for (GGPreBookingDetailFlight *visibleCells in [self.colFlightDetail visibleCells]) {
        NSIndexPath *indexPath = [self.colFlightDetail indexPathForCell:visibleCells];
        posFlight = (int)indexPath.row;
        [self setupPrevAndNextTitles];
        NSLog(@"%@",indexPath);
    }
}

#pragma end

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize size = self.contentView.frame.size;
//    CGFloat width = size.width - 20;
    return CGSizeMake(size.width, 512);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
@end
