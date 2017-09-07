//
//  GGPaymentConfirmationVC.m
//  GoGolf
//
//  Created by Eddyson Tan on 9/13/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGPaymentConfirmationVC.h"

@interface GGPaymentConfirmationVC ()

@end

@implementation GGPaymentConfirmationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
    [self setNeedsStatusBarAppearanceUpdate];
    
    [self.tblConfirmInfo reloadData];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated {
}

- (IBAction) goBack:(id)sender {
    NSArray *array = [self.navigationController viewControllers];
    NSLog(@"JLH ARRAY : %lu", (unsigned long)[array count]);
    
    [self.navigationController popToViewController:[array objectAtIndex:1] animated:YES];
}

#pragma mark - UItableView Delegate & datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseIdentifier = @"confirmCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    UILabel *lblTitle = (UILabel *)[cell viewWithTag:1];
    UILabel *lblContent = (UILabel *)[cell viewWithTag:2];
    
    if (indexPath.row == 0) {
        lblTitle.text = @"Total Amount";
        lblContent.text = [NSString stringWithFormat:@"Rp. %@", [[GGCommonFunc sharedInstance] setSeparatedCurrency:(float)self.grossAmount]];
    } else if (indexPath.row == 1) {
        
        lblTitle.text = @"Booking Code";
        lblContent.text = [NSString stringWithFormat:@"%@", self.bookingCode];
    } else if (indexPath.row == 2) {
        
        lblTitle.text = @"Transaction Time";
        lblContent.text = [[GGCommonFunc sharedInstance] getDateFromSystem];
    } else if (indexPath.row == 3) {
        
        lblTitle.text = @"Payment Type";
        lblContent.text = @"Credit Card";
    }
    
    return cell;
}

@end
