//
//  GGPreBookingDetailFlight.m
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/2/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGPreBookingDetailFlight.h"
#import "GGPreBookingCell4.h"

@implementation GGPreBookingDetailFlight

static NSString *cellIdentifier1 = @"teeTimeCell";
static NSString *cellIdentifier2 = @"playerTypeCell";

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.playerArr = [[NSMutableArray alloc] init];
    
    self.vwContent.layer.cornerRadius = 5;
    self.vwContent.layer.masksToBounds = true;
    self.vwContent.layer.borderWidth = 1.5;
    self.vwContent.layer.borderColor = [[GGCommonFunc sharedInstance] colorWithHexString:@"7ED321"].CGColor;
    
    self.txtTeeTime.delegate = self;
    self.txtPlayerNumber.delegate = self;
    
    [self.tblPlayerType registerNib:[UINib nibWithNibName:@"GGPlayerTypeCell" bundle:nil] forCellReuseIdentifier:cellIdentifier2];
    
    [self.tblPlayerType setDelegate:self];
    [self.tblPlayerType setDataSource:self];
    [self.tblPlayerType setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];    
}

- (IBAction)actionSelectTeeTime:(id)sender {
    NSLog(@"clicked show teetime picker");
    if ([self.preBookingCell4Delegate isKindOfClass:[GGPreBookingCell4 class]]) {
        [self.preBookingCell4Delegate showTeeTimeFromCell:self.flightIndex];
    }
}

- (IBAction)actionSelectPlayerNumber:(id)sender {
    NSLog(@"clicked show player number picker");
    if ([self.preBookingCell4Delegate isKindOfClass:[GGPreBookingCell4 class]]) {
        [self.preBookingCell4Delegate showPlayerNumberFromCell:self.flightIndex];
    }
}

- (IBAction)actionOptYes:(id)sender {
    self.isCartOpt = true;
    self.btnCartYes.selected = true;
    self.btnCartNo.selected = false;
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"cartOpt"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if ([self.preBookingCell4Delegate isKindOfClass:[GGPreBookingCell4 class]]) {
        [self.preBookingCell4Delegate updateFlightDataBasedOnCartOptFromCell:self.flightIndex];
    }
}

- (IBAction)actionOptNo:(id)sender {
    self.isCartOpt = false;
    self.btnCartYes.selected = false;
    self.btnCartNo.selected = true;
    [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"cartOpt"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if ([self.preBookingCell4Delegate isKindOfClass:[GGPreBookingCell4 class]]) {
        [self.preBookingCell4Delegate updateFlightDataBasedOnCartOptFromCell:self.flightIndex];
    }    
}

- (IBAction)actionShowTeeTime:(id)sender {
    if ([self.preBookingCell4Delegate isKindOfClass:[GGPreBookingCell4 class]]) {
        [self.preBookingCell4Delegate showTeeTimeFromCell:self.flightIndex];
    }
}

- (IBAction)actionShowPlayerNumber:(id)sender {
    if ([self.preBookingCell4Delegate isKindOfClass:[GGPreBookingCell4 class]]) {
        [self.preBookingCell4Delegate showPlayerNumberFromCell:self.flightIndex];
    }
}

#pragma mark - UITABLEVIEW

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return (self.playerArr != nil) ? [self.playerArr count] : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    cellPlayerType = (GGPlayerTypeCell *) [self.tblPlayerType dequeueReusableCellWithIdentifier:cellIdentifier2];
    if (cellPlayerType == nil) {
        NSArray *cellArray = [[NSBundle mainBundle] loadNibNamed:@"GGPlayerTypeCell" owner:self options:nil];
        cellPlayerType = [cellArray objectAtIndex:0];
    }
    
    if (self.playerArr != nil) {
        playerNumber = indexPath.row + 1;
        playerType = [[self.playerArr objectAtIndex:indexPath.row] objectForKey:@"type"];
        float playerPrice = [[[self.playerArr objectAtIndex:indexPath.row] objectForKey:@"price"] floatValue];
        cellPlayerType.lblPlayerType.text = [NSString stringWithFormat:@"Player %ld - %@ - Rp. %@", (long)playerNumber, playerType, [[GGCommonFunc sharedInstance] setSeparatedCurrency:playerPrice]];
    }
    
    return cellPlayerType;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 33.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 33;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([((GGPreBookingCell4*)self.preBookingCell4Delegate).preBookingDelegate isKindOfClass:[GGPreBookingVC class]]) {
        [((GGPreBookingCell4*)self.preBookingCell4Delegate).preBookingDelegate showPreBookingPlayerTypePicker:self.isCartOpt fromIndex:(int)indexPath.row atFlightIndex:self.flightIndex];
    }
}

#pragma end

#pragma mark - UITEXTFIELD DELEGATE

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == self.txtTeeTime) {
        [self actionSelectTeeTime:nil];
        
        return NO;
    }else if (textField == self.txtPlayerNumber) {
        [self actionSelectPlayerNumber:nil];
        
        return NO;
    }
    
    return YES;
}

#pragma end

@end
