//
//  GGPreBookingVC.m
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/2/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGPreBookingVC.h"

@interface GGPreBookingVC () {
    UIAlertController *datePickerPopup;
    UIAlertController *flightPickerPopup;
    UIAlertController *teeTimePickerPopup;
    UIAlertController *playerNumberPickerPopup;
    UIAlertController *playerTypePickerPopup;
    MDDatePickerDialog *calendarView;
    UIDatePicker *datePicker;
    UIPickerView *flightPicker;
    UIPickerView *teeTimePicker;
    UIPickerView *playerNumberPicker;
    UIPickerView *playerTypePicker;
    UIButton *btnPreBooking;
    GGPreBookingHeader *headerView;
    GGPreBookingCell1 *cell1;
    GGPreBookingCell2 *cell2;
    GGPreBookingCell3 *cell3;
    GGPreBookingCell4 *cell4;
    GGPreBookingCell5 *cell5;
    GGPreBookingCell6 *cell6;
    NSString *courseDate;
    int flightNumber;
    NSMutableArray *teeTimeArr;
    NSMutableArray *playerNumber;
    NSMutableArray *playerType;
}

@end

int selectedFlight = 0;
int selectedTeeTime = 0;
int selectedTeeTimePos = 0;
int selectedFlightDetail = 0;
int selectedPlayerNumber = 0;
int selectedPlayerType = 0;
int selectedPlayerTypeIndex = 0;
CGFloat kPromotionHeight = 66.0;
BOOL isCartSelected = true;
static NSString *cellIdentifier1 = @"preBookingCell1";
static NSString *cellIdentifier2 = @"preBookingCell2";
static NSString *cellIdentifier3 = @"preBookingCell3";
static NSString *cellIdentifier4 = @"preBookingCell4";
static NSString *cellIdentifier5 = @"preBookingCell5";
static NSString *cellIdentifier6 = @"preBookingCell6";

@implementation GGPreBookingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tblPreBooking registerNib:[UINib nibWithNibName:@"GGPreBookingCell1" bundle:nil] forCellReuseIdentifier:cellIdentifier1];
    [self.tblPreBooking registerNib:[UINib nibWithNibName:@"GGPreBookingCell2" bundle:nil] forCellReuseIdentifier:cellIdentifier2];
    [self.tblPreBooking registerNib:[UINib nibWithNibName:@"GGPreBookingCell3" bundle:nil] forCellReuseIdentifier:cellIdentifier3];
    [self.tblPreBooking registerNib:[UINib nibWithNibName:@"GGPreBookingCell4" bundle:nil] forCellReuseIdentifier:cellIdentifier4];
    [self.tblPreBooking registerNib:[UINib nibWithNibName:@"GGPreBookingCell5" bundle:nil] forCellReuseIdentifier:cellIdentifier5];
    [self.tblPreBooking registerNib:[UINib nibWithNibName:@"GGPreBookingCell6" bundle:nil] forCellReuseIdentifier:cellIdentifier6];
    
    [self.tblPreBooking setDelegate:self];
    [self.tblPreBooking setDataSource:self];
    
    self.automaticallyAdjustsScrollViewInsets = false;
    self.edgesForExtendedLayout = false;
    
    headerView = [[GGPreBookingHeader alloc] initWithNibName:@"GGPreBookingHeader" bundle:nil];
    [self addChildViewController:headerView];
    [headerView didMoveToParentViewController:self];
    
    [self setupPreBookingCalendarView];
    [self setupPreBookDatePicker];
    [self setupPreBookFlightPicker];
    [self setupPreBookingData];
    
    NSLog(@"%@",self.preBookDataFromServer);
}

- (void)setupPreBookingData {
    flightNumber = 1;
    
    if ([self.detailArr objectForKey:@"date"] != nil) {
        
        kPromotionHeight = 66.0;
        headerView.lblPreCourseDisc.hidden = false;
        headerView.lblPreCoursePrice.hidden = false;
        headerView.lblPreCoursePPrice.hidden = false;
        courseDate = [self.detailArr objectForKey:@"date"];
        [self loadDetailView:[self.detailArr objectForKey:@"gid"] courseDate:[self.detailArr objectForKey:@"date"] flightCount:flightNumber];
        
    } else {
        kPromotionHeight = 0.0;
        courseDate = [[GGCommonFunc sharedInstance] getDateFromSystem];
        [self loadDetailView:[self.detailArr objectForKey:@"gid"] courseDate:courseDate flightCount:flightNumber];
    }

}

- (void) loadDetailView:(NSString *) GID courseDate:(NSString *)date flightCount:(int)flightCount {
    
    if ([[GGCommonFunc sharedInstance] connected]) {
        [[GGCommonFunc sharedInstance] showLoadingImage:self.view];
        [[GGAPICourseManager sharedInstance] getPreBookingListWithGID:GID courseDate:date completion:^(NSDictionary *responseDict, NSError *error) {
            
            [[GGCommonFunc sharedInstance] hideLoadingImage];
            
            NSLog(@"HASIL PREBOOK : %@", [responseDict description]);
            
            self.preBookDataFromServer = [[NSDictionary alloc] init];
            self.preBookDataFromServer = responseDict;
            NSLog(@"%@",self.preBookDataFromServer);
            if ([[self.preBookDataFromServer objectForKey:@"code"] intValue] != 200) {
                
                [self showCommonAlert:@"Notification" message:[self.preBookDataFromServer objectForKey:@"message"]];
                
            } else{
                
                headerView.lblPreCourseName.text = self.preBookDataFromServer[@"data"][@"gname"];
                [[GGCommonFunc sharedInstance] setLazyLoadImage:headerView.ivPreCourse urlString:self.preBookDataFromServer[@"data"][@"image"]];
                
                if ([[[self.preBookDataFromServer objectForKey:@"data"] objectForKey:@"promotion"] count] > 0) {
                    kPromotionHeight = 66.0;
                    headerView.lblPreCoursePrice.hidden = false;
                    headerView.lblPreCourseDisc.hidden = false;
                    headerView.lblPreCoursePPrice.hidden = false;
                    
                    headerView.lblPreCoursePrice.text = [NSString stringWithFormat:@"Rp. %@", [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[[[self.preBookDataFromServer objectForKey:@"data"] objectForKey:@"promotion"][0] objectForKey:@"pprice"] floatValue]]];
                    
                    NSString *priceOrigin = [NSString stringWithFormat:@"Rp. %@", [[GGCommonFunc sharedInstance] setSeparatedCurrency:[[[[self.preBookDataFromServer objectForKey:@"data"] objectForKey:@"promotion"][0] objectForKey:@"prate"] floatValue]]];
                    
                    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:priceOrigin];
                    [attributeString addAttribute:NSStrikethroughStyleAttributeName
                                            value:@2
                                            range:NSMakeRange(0, [attributeString length])];
                    
                    headerView.lblPreCoursePPrice.attributedText = attributeString;
                    
                    headerView.lblPreCourseDisc.text = [NSString stringWithFormat:@"Disc. %@%%", [[[self.preBookDataFromServer objectForKey:@"data"] objectForKey:@"promotion"][0] objectForKey:@"discount"]];
                    
                } else {
                    kPromotionHeight = 0.0;
                    headerView.lblPreCourseDisc.hidden = true;
                    headerView.lblPreCoursePrice.hidden = true;
                }
                                
                if ([responseDict[@"data"][@"conditionarr"] count] > 1) {
                    self.preBookDict = [[NSMutableDictionary alloc] init];
                    self.preBookDict = [[GGCommonFunc sharedInstance] setupBookingParams:responseDict initWithFlight:flightCount];
                    
                    teeTimeArr = [[NSMutableArray alloc] init];
                    teeTimeArr = [[self.preBookDataFromServer objectForKey:@"data"] objectForKey:@"timearr"];
                    [self setupPreBookTeeTimePicker];
                    
                    playerNumber = [[NSMutableArray alloc] init];
                    playerNumber = [[GGCommonFunc sharedInstance] setupPlayerNumber:[[[self.preBookDict objectForKey:@"flights"][0] objectForKey:@"max_number"] intValue] fromIndex:[[[self.preBookDict objectForKey:@"flights"][0] objectForKey:@"min_number"] intValue]];
                    [self setupPreBookPlayerNumberPicker];
                    
                    playerType = [[NSMutableArray alloc] init];
                    playerType = [[GGCommonFunc sharedInstance] setupPlayerType:self.preBookDataFromServer withRowConditionarr:[[teeTimeArr[selectedTeeTime] objectForKey:@"condition"] intValue]];
                    [self setupPreBookPlayerTypePicker];
                    
                    [self.tblPreBooking reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                }else{
                    [self showCommonAlert:@"Alert" message:@"No flight data for this course."];
                }
            }
        }];
    }else{
        [self showCommonAlert:@"Alert" message:@"No internet connection."];
    }
}

- (void)showPreBookingCalendarView {
    [calendarView show];
}

- (void)showPreBookingDatePicker {
    [self presentViewController:datePickerPopup animated:true completion:nil];
}

- (void)showPreBookingFlightPicker {
    [self presentViewController:flightPickerPopup animated:true completion:nil];
    [flightPicker selectRow:selectedFlight inComponent:0 animated:true];
}

- (void)showPreBookingTeeTimePicker:(int)ttimePos fromFlightIndex:(int)index {
    selectedTeeTimePos = ttimePos;
    selectedFlightDetail = index;
    [self presentViewController:teeTimePickerPopup animated:true completion:nil];
    [teeTimePicker selectRow:0 inComponent:0 animated:true];
}

- (void)showPreBookingPlayerNumberPicker:(int)ttimePos fromFlightIndex:(int)index withSelectedPlayerNumber:(int)playerIndex {
    isCartSelected = [[NSUserDefaults standardUserDefaults] boolForKey:@"cartOpt"];
    selectedTeeTimePos = ttimePos;
    selectedFlightDetail = index;
    [self presentViewController:playerNumberPickerPopup animated:true completion:nil];
    [playerNumberPicker selectRow:selectedPlayerNumber inComponent:0 animated:true];
}

- (void)showPreBookingPlayerTypePicker:(BOOL)optCart fromIndex:(int)index atFlightIndex:(int)flightIndex {
    isCartSelected = optCart;
    selectedPlayerTypeIndex = index;
    selectedFlightDetail = flightIndex;
    NSLog(@"selectedPlayerTypeIndex %ld", (long)selectedPlayerTypeIndex);
    [playerTypePicker reloadAllComponents];
    [self presentViewController:playerTypePickerPopup animated:true completion:nil];
    [playerTypePicker selectRow:selectedPlayerType inComponent:0 animated:true];
}

- (void)setupPreBookingCalendarView {
    calendarView = [[MDDatePickerDialog alloc] init];
    calendarView.minimumDate = [NSDate date];
    calendarView.selectedDate = [NSDate date];
    calendarView.delegate = self;
}

- (void)setupPreBookDatePicker {
    datePickerPopup = [UIAlertController alertControllerWithTitle:@"Choose Date" message:@"\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Done"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    courseDate = [[GGCommonFunc sharedInstance] getDateFromDatePicker:datePicker.date];
                                    
                                    [self loadDetailView:[self.detailArr objectForKey:@"gid"] courseDate:courseDate flightCount:flightNumber];
                                }];
    
    [datePickerPopup addAction:yesButton];
    
    datePicker = [[UIDatePicker alloc] init];
    [datePicker setDatePickerMode:UIDatePickerModeDate];
    [datePicker setMinimumDate:[NSDate date]];
    datePicker.tag = 90;
    [datePicker setBounds:CGRectMake(20,
                                       datePicker.bounds.origin.y,
                                       datePicker.bounds.size.width,
                                       datePicker.bounds.size.height)];
    
    [datePickerPopup.view addSubview:datePicker];
}

- (void)setupPreBookFlightPicker {
    flightPickerPopup = [UIAlertController alertControllerWithTitle:@"Choose Flight" message:@"\n\n\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
    
    //    [self.pickerViewPopup.view setBounds:CGRectMake(7, 180, [[GGCommonFunc sharedInstance] obtainScreenWidth], 114)];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Done"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    flightNumber = [[GGGlobalVariable sharedInstance].itemFlightList[selectedFlight] intValue];
                                    
                                    self.preBookDict = [[GGCommonFunc sharedInstance] setupBookingParams:self.preBookDataFromServer initWithFlight:flightNumber];
                                    
                                    teeTimeArr = [[self.preBookDataFromServer objectForKey:@"data"] objectForKey:@"timearr"];
                                    [self setupPreBookTeeTimePicker];
                                    
                                    playerNumber = [[NSMutableArray alloc] init];
                                    playerNumber = [[GGCommonFunc sharedInstance] setupPlayerNumber:[[[self.preBookDict objectForKey:@"flights"][0] objectForKey:@"max_number"] intValue] fromIndex:[[[self.preBookDict objectForKey:@"flights"][0] objectForKey:@"min_number"] intValue]];
                                    [self setupPreBookPlayerNumberPicker];
                                    
                                    playerType = [[NSMutableArray alloc] init];
                                    playerType = [[GGCommonFunc sharedInstance] setupPlayerType:self.preBookDataFromServer withRowConditionarr:[[teeTimeArr[selectedTeeTime] objectForKey:@"condition"] intValue]];
                                    [self setupPreBookPlayerTypePicker];
                                    
                                    [self.tblPreBooking reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                                }];
    
    [flightPickerPopup addAction:yesButton];
    
    flightPicker = [[UIPickerView alloc] init];
    [flightPicker setDelegate:self];
    [flightPicker setDataSource:self];
    flightPicker.showsSelectionIndicator = true;
    flightPicker.tag = 91;
    [flightPicker reloadAllComponents];
    
    [flightPicker setBounds:CGRectMake(-20,
                                        flightPicker.bounds.origin.y,
                                        flightPicker.bounds.size.width,
                                        flightPicker.bounds.size.height)];
    [flightPickerPopup.view addSubview:flightPicker];
}

- (void)setupPreBookTeeTimePicker {
    teeTimePickerPopup = [UIAlertController alertControllerWithTitle:@"Choose Tee Time" message:@"\n\n\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleActionSheet];
    
    //    [self.pickerViewPopup.view setBounds:CGRectMake(7, 180, [[GGCommonFunc sharedInstance] obtainScreenWidth], 114)];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Done"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    NSLog(@"selectedFlightDetail %ld", (long)selectedFlightDetail);
                                    
                                    BOOL checkTeeTime = [self checkTeeTimeIfDuplicated:selectedTeeTime];
                                    if (checkTeeTime == true) {
                                        [self showCommonAlert:@"Notification" message:@"You have already chosen same tee time in different flight. Please choose other tee time."];
                                    }else{
                                        NSMutableDictionary *flightDetail = [[NSMutableDictionary alloc] init];
                                        flightDetail = [[GGCommonFunc sharedInstance] getFlightDetailFromTeeTime:[teeTimeArr[selectedTeeTime] objectForKey:@"ttime"] responseDict:self.preBookDataFromServer rowConditionarr:[[teeTimeArr[selectedTeeTime] objectForKey:@"condition"] intValue] teeTimePos:selectedTeeTime];
                                        [[GGCommonFunc sharedInstance] updateFlightDetail:[self.preBookDict objectForKey:@"flights"][selectedFlightDetail] withDetail:flightDetail];
                                        
                                        NSLog(@"preBookDict after Select teetime %@", [self.preBookDict description]);
                                        
                                        playerType = [[NSMutableArray alloc] init];
                                        playerType = [[[self.preBookDataFromServer objectForKey:@"data"] objectForKey:@"conditionarr"][[[teeTimeArr[selectedTeeTime] objectForKey:@"condition"] intValue]] objectForKey:@"price_list"];
                                        NSLog(@"playerType %@", [playerType description]);
                                        [playerTypePicker reloadAllComponents];
                                        [[GGCommonFunc sharedInstance] updateAllPlayerArrFromTeeTime:[self.preBookDict objectForKey:@"flights"][selectedFlightDetail] fromPlayerType:playerType withCartOpt:([[[self.preBookDict objectForKey:@"flights"][selectedFlightDetail] objectForKey:@"cartOpt"] isEqualToString:@"1"] ? true : false )];
                                                                                
                                        [[GGCommonFunc sharedInstance] updatePreBookTotPrice:self.preBookDict];
                                        
                                        [self.tblPreBooking reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                                        
                                        selectedPlayerType = 0;
                                        selectedTeeTime = 0;
                                    }
                                }];
    
    [teeTimePickerPopup addAction:yesButton];
    
    teeTimePicker = [[UIPickerView alloc] init];
    [teeTimePicker setDelegate:self];
    [teeTimePicker setDataSource:self];
    teeTimePicker.showsSelectionIndicator = true;
    teeTimePicker.tag = 92;
    [teeTimePicker reloadAllComponents];
    
    [teeTimePicker setBounds:CGRectMake(-20,
                                       teeTimePicker.bounds.origin.y,
                                       teeTimePicker.bounds.size.width,
                                       teeTimePicker.bounds.size.height)];
    [teeTimePickerPopup.view addSubview:teeTimePicker];
    
}

- (void)setupPreBookPlayerNumberPicker {
    playerNumberPickerPopup = [UIAlertController alertControllerWithTitle:@"Choose Player Number" message:@"\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
    
    //    [self.pickerViewPopup.view setBounds:CGRectMake(7, 180, [[GGCommonFunc sharedInstance] obtainScreenWidth], 114)];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Done"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    NSLog(@"selectedPlayerNumber %ld", (long)selectedPlayerNumber);
                                    NSString *pricePlayer = (isCartSelected == true || [[playerType[selectedPlayerType] objectForKey:@"cart_mandatory"] isEqualToString:@"1"]) ? [NSString stringWithFormat:@"%@", [playerType[0] objectForKey:@"price_cart"]] : [NSString stringWithFormat:@"%@", [playerType[0] objectForKey:@"price"]];
                                    NSString *typePlayer = [NSString stringWithFormat:@"%@", [playerType[0] objectForKey:@"type"]];
                                    NSString *cartMandatory = [NSString stringWithFormat:@"%@", [playerType[0] objectForKey:@"cart_mandatory"]];
                                    NSLog(@"cart_mandatory %@", cartMandatory);
                                    [[GGCommonFunc sharedInstance] addPlayerArr:[self.preBookDict objectForKey:@"flights"][selectedFlightDetail] withPrice:pricePlayer andType:typePlayer withCount:[playerNumber[selectedPlayerNumber] intValue] andCartMandatory:cartMandatory];
                                    [[GGCommonFunc sharedInstance] updatePreBookTotPrice:self.preBookDict];
                                    
                                    selectedPlayerNumber = 0;
                                    
                                    [self.tblPreBooking reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                                }];
    
    [playerNumberPickerPopup addAction:yesButton];
    
    playerNumberPicker = [[UIPickerView alloc] init];
    [playerNumberPicker setDelegate:self];
    [playerNumberPicker setDataSource:self];
    playerNumberPicker.showsSelectionIndicator = true;
    playerNumberPicker.tag = 93;
    [playerNumberPicker reloadAllComponents];
    
    [playerNumberPicker setBounds:CGRectMake(-20,
                                        playerNumberPicker.bounds.origin.y,
                                        playerNumberPicker.bounds.size.width,
                                        playerNumberPicker.bounds.size.height)];
    [playerNumberPickerPopup.view addSubview:playerNumberPicker];
}

- (void)setupPreBookPlayerTypePicker {
    playerTypePickerPopup = [UIAlertController alertControllerWithTitle:@"Choose Player Type" message:@"\n\n\n\n\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
    
    //    [self.pickerViewPopup.view setBounds:CGRectMake(7, 180, [[GGCommonFunc sharedInstance] obtainScreenWidth], 114)];
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Done"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    NSString *pricePlayer = (isCartSelected == true) ? [NSString stringWithFormat:@"%@", [playerType[selectedPlayerType] objectForKey:@"price_cart"]] : [NSString stringWithFormat:@"%@", [playerType[selectedPlayerType] objectForKey:@"price"]];
                                    NSString *typePlayer = [NSString stringWithFormat:@"%@", [playerType[selectedPlayerType] objectForKey:@"type"]];
                                    NSString *cartMandatory = [NSString stringWithFormat:@"%@", [playerType[selectedPlayerType] objectForKey:@"cart_mandatory"]];
                                    [[GGCommonFunc sharedInstance] updatePlayerArr:[self.preBookDict objectForKey:@"flights"][selectedFlightDetail] withPrice:pricePlayer andType:typePlayer atIndex:selectedPlayerTypeIndex withCartOpt:isCartSelected andCartMandatory:cartMandatory andPlayerType:playerType];
                                    [[GGCommonFunc sharedInstance] updatePreBookTotPrice:self.preBookDict];
                                    
                                    selectedPlayerType = 0;
                                    
                                    [self.tblPreBooking reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
                                }];
    
    [playerTypePickerPopup addAction:yesButton];
    
    playerTypePicker = [[UIPickerView alloc] init];
    [playerTypePicker setDelegate:self];
    [playerTypePicker setDataSource:self];
    playerTypePicker.showsSelectionIndicator = true;
    playerTypePicker.tag = 94;
    [playerTypePicker reloadAllComponents];
    
    [playerTypePicker setBounds:CGRectMake(-20,
                                             playerTypePicker.bounds.origin.y,
                                             playerTypePicker.bounds.size.width,
                                             playerTypePicker.bounds.size.height)];
    [playerTypePickerPopup.view addSubview:playerTypePicker];
}

- (void)updateFlightDetailBasedOnCartOpt:(int)indeks {
    NSLog(@"flightIndex %ld", (long)indeks);
    isCartSelected = [[NSUserDefaults standardUserDefaults] boolForKey:@"cartOpt"];
    selectedFlightDetail = indeks;
    [[GGCommonFunc sharedInstance] updateAllPlayerArr:[self.preBookDict objectForKey:@"flights"][selectedFlightDetail] fromPlayerType:playerType withCartOpt:isCartSelected];
    [[GGCommonFunc sharedInstance] updatePreBookTotPrice:self.preBookDict];
    NSLog(@"preBookDict after update %@", [self.preBookDict description]);
    
    [self.tblPreBooking reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

- (BOOL)checkTeeTimeIfDuplicated:(NSInteger)selectedTeeTime {
    NSInteger count = [[self.preBookDict objectForKey:@"flights"] count];
    if (count > 1) {
        for (int i = 0; i < count; i++) {
            if (selectedTeeTime == [[[self.preBookDict objectForKey:@"flights"][i] objectForKey:@"ttimePos"] intValue]) {
                return true;
            }
        }
    }
    
    return false;
}

- (void) showCommonAlert:(NSString *) title message:(NSString *)msg {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                               }];
    
    [alert addAction:okButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)goToBookingConfirmationView {
    if (self.preBookDict == nil) {
        [self showCommonAlert:@"Alert" message:@"Cannot book because there is no flight data that has been set"];
        [cell6.btnPreBookNow setEnabled:true];
    }else{
        [GGGlobalVariable sharedInstance].bookInfoDict = self.preBookDict;
        
        GGBookingConfirmationVC *bookConfirmView = [self.storyboard instantiateViewControllerWithIdentifier:@"bookConfirmVC"];
        
        bookConfirmView.deposit_rate = [[[self.preBookDict objectForKey:@"flights"][0] objectForKey:@"deposit_rate"] intValue];
        
        [self.navigationController pushViewController:bookConfirmView animated:YES];
        [cell6.btnPreBookNow setEnabled:true];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITABLEVIEW

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 6;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    return headerView.view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        cell1 = (GGPreBookingCell1 *) [self.tblPreBooking dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (cell1 == nil) {
            NSArray *cellArray1 = [[NSBundle mainBundle] loadNibNamed:@"GGPreBookingCell1" owner:self options:nil];
            cell1 = [cellArray1 objectAtIndex:0];
        }
        
        cell1.lblPreBookCalendar.text = [[GGCommonFunc sharedInstance] changeDateFormat:courseDate];
        
        if (kPromotionHeight == 0) {
            cell1.ivCalendarPreBook.hidden = true;
            cell1.ivPreBookTime.hidden = true;
            cell1.lblPreBookCalendar.hidden = true;
            cell1.lblPreBookTime.hidden = true;
            cell1.lblPreBookLimit.hidden = true;
        }else{
            cell1.ivCalendarPreBook.hidden = false;
            cell1.ivPreBookTime.hidden = false;
            cell1.lblPreBookCalendar.hidden = false;
            cell1.lblPreBookTime.hidden = false;
            cell1.lblPreBookLimit.hidden = false;
            
            cell1.lblPreBookTime.text = [NSString stringWithFormat:@"%@ - %@", [[[self.preBookDataFromServer objectForKey:@"data"] objectForKey:@"promotion"][0] objectForKey:@"stime"], [[[self.preBookDataFromServer objectForKey:@"data"] objectForKey:@"promotion"][0] objectForKey:@"etime"]];
            cell1.lblPreBookLimit.text = [NSString stringWithFormat:@"Rest of limit : %@ flight", [[[self.preBookDataFromServer objectForKey:@"data"] objectForKey:@"promotion"][0] objectForKey:@"limit_num"]];
            
        }
        
        return cell1;
        
    } else if (indexPath.row == 1) {
        
        cell2 = (GGPreBookingCell2 *) [self.tblPreBooking dequeueReusableCellWithIdentifier:cellIdentifier2];
        if (cell2 == nil) {
            NSArray *cellArray2 = [[NSBundle mainBundle] loadNibNamed:@"GGPreBookingCell2" owner:self options:nil];
            cell2 = [cellArray2 objectAtIndex:0];
        }
        
        cell2.preBookingDelegate = self;
        cell2.txtPreBookDate.text = [[GGCommonFunc sharedInstance] changeDateFormat:courseDate];
        
        return cell2;
        
    } else if (indexPath.row == 2) {
        
        cell3 = (GGPreBookingCell3 *) [self.tblPreBooking dequeueReusableCellWithIdentifier:cellIdentifier3];
        if (cell3 == nil) {
            NSArray *cellArray3 = [[NSBundle mainBundle] loadNibNamed:@"GGPreBookingCell3" owner:self options:nil];
            cell3 = [cellArray3 objectAtIndex:0];
        }
        
        cell3.preBookingDelegate = self;
        cell3.txtPreBookingFlightNumber.text = [NSString stringWithFormat:@"%ld", (long)flightNumber];
        
        return cell3;
        
    } else if (indexPath.row == 3) {
        
        cell4 = (GGPreBookingCell4 *) [self.tblPreBooking dequeueReusableCellWithIdentifier:cellIdentifier4];
        if (cell4 == nil) {
            NSArray *cellArray4 = [[NSBundle mainBundle] loadNibNamed:@"GGPreBookingCell4" owner:self options:nil];
            cell4 = [cellArray4 objectAtIndex:0];
        }
        
        if (self.preBookDict != nil) {
            cell4.preBookingDelegate = self;
            cell4.preBookDataFromServer = self.preBookDataFromServer;
            cell4.preBookDict = self.preBookDict;
            [cell4 showDetailFlight];
        }                
        
        return cell4;
        
    } else if (indexPath.row == 4) {
        
        cell5 = (GGPreBookingCell5 *) [self.tblPreBooking dequeueReusableCellWithIdentifier:cellIdentifier5];
        if (cell5 == nil) {
            NSArray *cellArray5 = [[NSBundle mainBundle] loadNibNamed:@"GGPreBookingCell5" owner:self options:nil];
            cell5 = [cellArray5 objectAtIndex:0];
        }
        
        if (self.preBookDict != nil) {
            float totPrice = [[NSString stringWithFormat:@"%@", [[self.preBookDict objectForKey:@"tprice"] description]] floatValue];
            cell5.lblPreBookingTotPrice.text = [NSString stringWithFormat:@"Rp. %@", [[GGCommonFunc sharedInstance] setSeparatedCurrency:totPrice]];
        }
        
        return cell5;
        
    } else if (indexPath.row == 5) {
        
        cell6 = (GGPreBookingCell6 *) [self.tblPreBooking dequeueReusableCellWithIdentifier:cellIdentifier6];
        if (cell6 == nil) {
            NSArray *cellArray6 = [[NSBundle mainBundle] loadNibNamed:@"GGPreBookingCell6" owner:self options:nil];
            cell6 = [cellArray6 objectAtIndex:0];
        }
        
        cell6.preBookingDelegate = self;
        btnPreBooking = cell6.btnPreBookNow;
        
        return cell6;
        
    }
    
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {
    
    return 220;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0)
        return 66.0;
    else if (indexPath.row == 1)
        return 77.0;
    else if (indexPath.row == 2)
        return 77.0;
    else if (indexPath.row == 3)
        return 532.0;
    else if (indexPath.row == 4)
        return 77.0;
    else if (indexPath.row == 5)
        return 55.0;
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    
    return 1.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 220;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0)
        return kPromotionHeight;
    else if (indexPath.row == 1)
        return 77.0;
    else if (indexPath.row == 2)
        return 77.0;
    else if (indexPath.row == 3)
        return 532.0;
    else if (indexPath.row == 4)
        return 77.0;
    else if (indexPath.row == 5)
        return 55.0;
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        [self showPreBookingDatePicker];
    }else if (indexPath.row == 2) {
        [self showPreBookingFlightPicker];
    }
}

#pragma end

#pragma mark - UIPICKER
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView.tag == 91) {
        return [[GGGlobalVariable sharedInstance].itemFlightList count];
    }else if (pickerView.tag == 92)
        return [teeTimeArr count];
    else if (pickerView.tag == 93)
        return [playerNumber count];
    else if (pickerView.tag == 94)
        return [playerType count];
    
    return 0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView.tag == 91) {
        selectedFlight = (int)row;
    }else if (pickerView.tag == 92) {
        selectedTeeTime = (int)row;
    }else if (pickerView.tag == 93) {
        selectedPlayerNumber = (int)row;
    }else if (pickerView.tag == 94) {
        selectedPlayerType = (int)row;
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    if (pickerView.tag == 92) {
        UIView *viewRow;
        if (view) {
            viewRow = view;
        } else {
            viewRow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[GGCommonFunc sharedInstance] obtainScreenWidth], 25)];

            UILabel *lblTeeTime = [[UILabel alloc] initWithFrame:CGRectMake(([[GGCommonFunc sharedInstance] obtainScreenWidth] / 2) - 35.5, 0, 55, 25)];
            [lblTeeTime setFont:[UIFont fontWithName:@"CharlevoixPro-Regular.otf" size:22]];
            lblTeeTime.tag = 100;
            [viewRow addSubview:lblTeeTime];
            
            UILabel *lblPromo = [[UILabel alloc] initWithFrame:CGRectMake(([[GGCommonFunc sharedInstance] obtainScreenWidth] / 2) + 35.5, 0, 55, 25)];
            lblPromo.textColor = [[GGCommonFunc sharedInstance] colorWithHexString:@"F5A623"];
            [lblPromo setFont:[UIFont fontWithName:@"CharlevoixPro-Medium.otf" size:22]];
            lblPromo.tag = 101;
            lblPromo.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
            [viewRow addSubview:lblPromo];
        }
        
        UILabel *lblTTime = (UILabel *)[viewRow viewWithTag:100];
        UILabel *lblPrmo = (UILabel *)[viewRow viewWithTag:101];
        
        lblTTime.text = [NSString stringWithFormat:@"%@", [teeTimeArr[row] objectForKey:@"ttime"]];
        lblPrmo.text = ([[teeTimeArr[row] objectForKey:@"promo"] intValue] == 1) ? @"Promo" : @"" ;
        
        [lblTTime sizeToFit];
        [lblPrmo sizeToFit];
        
        [viewRow sizeToFit];
        
        return viewRow;
    }else if (pickerView.tag == 91) {
        UIView *viewRow;
        if (view) {
            viewRow = view;
        } else {
            viewRow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[GGCommonFunc sharedInstance] obtainScreenWidth], 25)];
            
            UILabel *lblFlight = [[UILabel alloc] initWithFrame:CGRectMake([[GGCommonFunc sharedInstance] obtainScreenWidth] /2, 0, 55, 25)];
            [lblFlight setFont:[UIFont fontWithName:@"CharlevoixPro-Regular.otf" size:22]];
            lblFlight.tag = 102;
            [viewRow addSubview:lblFlight];
        }
        
        UILabel *lblFlght = (UILabel *)[viewRow viewWithTag:102];
        
        lblFlght.text = [NSString stringWithFormat:@"%@", [GGGlobalVariable sharedInstance].itemFlightList[row]];
        
        [lblFlght sizeToFit];
        
        [viewRow sizeToFit];
        
        return viewRow;
    }else if (pickerView.tag == 93) {
        UIView *viewRow;
        if (view) {
            viewRow = view;
        } else {
            viewRow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[GGCommonFunc sharedInstance] obtainScreenWidth], 25)];
            
            UILabel *lblNumber = [[UILabel alloc] initWithFrame:CGRectMake([[GGCommonFunc sharedInstance] obtainScreenWidth] / 2, 0, 55, 25)];
            [lblNumber setFont:[UIFont fontWithName:@"CharlevoixPro-Regular.otf" size:22]];
            lblNumber.tag = 103;
            [viewRow addSubview:lblNumber];
        }
        
        UILabel *lblNmbr = (UILabel *)[viewRow viewWithTag:103];
        
        lblNmbr.text = [NSString stringWithFormat:@"%@", playerNumber[row]];
        
        [lblNmbr sizeToFit];
        
        [viewRow sizeToFit];
        
        return viewRow;
    }else if (pickerView.tag == 94) {
        UIView *viewRow;
        if (view) {
            viewRow = view;
        } else {
            viewRow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[GGCommonFunc sharedInstance] obtainScreenWidth], 25)];
            
            UILabel *lblType = [[UILabel alloc] initWithFrame:CGRectMake([[GGCommonFunc sharedInstance] obtainScreenWidth] * 0.125, 0, 55, 25)];
            [lblType setFont:[UIFont fontWithName:@"CharlevoixPro-Regular.otf" size:22]];
            lblType.tag = 104;
            [viewRow addSubview:lblType];
        }
        
        UILabel *lblTyp = (UILabel *)[viewRow viewWithTag:104];
        
        lblTyp.text = (isCartSelected == true) ? [NSString stringWithFormat:@"%@ - Rp. %@", [playerType[row] objectForKey:@"type"], [playerType[row] objectForKey:@"price_cart"]] : [NSString stringWithFormat:@"%@ - Rp. %@", [playerType[row] objectForKey:@"type"], [playerType[row] objectForKey:@"price"]];
        
        [lblTyp sizeToFit];
        
        [viewRow sizeToFit];
        
        return viewRow;
    }
    
    return view;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

#pragma mark - MDDATEPICKERDIALOGDELEGATE

- (void)datePickerDialogDidSelectDate:(NSDate *)date {
    courseDate = [[GGCommonFunc sharedInstance] getDateFromDatePicker:date];
    
    [self loadDetailView:[self.detailArr objectForKey:@"gid"] courseDate:courseDate flightCount:flightNumber];    
}

#pragma end

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:true];
}

@end
