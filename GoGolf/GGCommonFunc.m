//
//  GGCommonFunc.m
//  GoGolf
//
//  Created by Eddyson Tan on 6/12/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGCommonFunc.h"

@implementation GGCommonFunc {
    UIView *viewLoading;
}

+ (GGCommonFunc *)sharedInstance
{
    // the instance of this class is stored here
    static GGCommonFunc *myInstance = nil;
    
    // check to see if an instance already exists
    if (nil == myInstance) {
        myInstance  = [[[self class] alloc] init];
    }
    // return the instance of this class
    return myInstance;
}

- (NSString *)setLocaleDateFormat:(NSDate *)date {
    // create dateFormatter with UTC time format
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
//    NSDate *date = [dateFormatter dateFromString:@"2015-04-01T11:42:00"]; // create date from string
    
    // change to a readable time format and change to local time zone
//    [dateFormatter setDateFormat:@"EEE, MMM d, yyyy - h:mm a"];
//    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *timestamp = [dateFormatter stringFromDate:date];
    
    return timestamp;
}

- (NSString *) changeDateFormat:(NSString *) date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    
    NSDate *myDate = [dateFormatter dateFromString:date];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *stringFromDate = [dateFormatter stringFromDate:myDate];
    return stringFromDate;
    
}

- (NSString *)changeDateFormatForAPI:(NSString *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy MM dd"];
    
    NSDate *myDate = [dateFormatter dateFromString:date];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *stringFromDate = [dateFormatter stringFromDate:myDate];
    
    return stringFromDate;
}

- (NSString *) changeDateFormatForSearch:(NSDate *) date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *stringFromDate = [dateFormatter stringFromDate:date];
    return stringFromDate;
}

- (NSString *) changeCurrencyFormat:(float)value {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    
    return [numberFormatter stringFromNumber:[NSNumber numberWithFloat:value]];
}

- (NSString *) changeDateFormatForCourseDetail:(NSString *) date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat: @"yyyy MM dd"];
    
    NSDate *myDate = [dateFormatter dateFromString:date];
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    NSString *stringFromDate = [dateFormatter stringFromDate:myDate];
    NSLog(@"stringFromDate %@", stringFromDate);
    
    NSArray *stringDateArray = [stringFromDate componentsSeparatedByString:@"-"];
    NSString *formatFromArray = [NSString stringWithFormat:@"%@ %@th %@", stringDateArray[1], stringDateArray[2], stringDateArray[0]];
    
    return formatFromArray;
}

- (NSString *) changeFormatTimeForCourseDetail:(NSString *) time {
    NSArray *stringTimeArray = [time componentsSeparatedByString:@":"];
    NSString *stringTime = [NSString stringWithFormat:@"%@:%@", stringTimeArray[0], stringTimeArray[1]];
    
    return stringTime;
}

- (NSString *)getCurrencyFromString:(NSString *)value {
    NSString *pureString = [value stringByReplacingOccurrencesOfString:@" " withString:@""];
    pureString = [pureString stringByReplacingOccurrencesOfString:@"Rp." withString:@""];
    pureString = [pureString stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    return pureString;
}

- (NSString *)getDateFromSystem {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [[NSDate alloc] init];
    NSString *theDate = [dateFormat stringFromDate:now];
    
    return theDate;
}

- (NSString *)getNextYearDate {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [[NSDate alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:1];
    NSDate *nextYear = [gregorian dateByAddingComponents:offsetComponents toDate:now options:0];
    NSString *theDate = [dateFormat stringFromDate:nextYear];
    
    return theDate;
}

- (NSString *)getLastYearDate {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSDate *now = [[NSDate alloc] init];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *offsetComponents = [[NSDateComponents alloc] init];
    [offsetComponents setYear:-1];
    NSDate *nextYear = [gregorian dateByAddingComponents:offsetComponents toDate:now options:0];
    NSString *theDate = [dateFormat stringFromDate:nextYear];
    
    return theDate;
}

- (NSString *)getDateFromDatePicker:(NSDate *)dateValue {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *theDate = [dateFormat stringFromDate:dateValue];
    
    return theDate;
}

- (NSString *)setSeparatedCurrency:(float)value {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setGroupingSeparator:@"."];
    [numberFormatter setGroupingSize:3];
    [numberFormatter setUsesGroupingSeparator:YES];
    [numberFormatter setDecimalSeparator:@","];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [numberFormatter setMaximumFractionDigits:2];
    NSString *theString = [numberFormatter stringFromNumber:[NSNumber numberWithDouble:value]];
    
    return theString;
}

- (void) hideMenuView : (UIView *) sender {
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    if ([sender tag] == 5) {
        
        [UIView animateWithDuration:0.3 animations:^{
            sender.frame = CGRectMake(0, screenRect.size.height + sender.frame.size.height + 100, sender.frame.size.width, sender.frame.size.height);
        }];
    } else {
    
        [UIView animateWithDuration:0.3 animations:^{
            sender.frame = CGRectMake(0, screenRect.size.height + sender.frame.size.height, sender.frame.size.width, sender.frame.size.height);
        }];
    }
}

- (void) showMenuView : (UIView *) sender {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    if ([sender tag] == 5) {
        [UIView animateWithDuration:0.3 animations:^{
            sender.frame = CGRectMake(0, screenRect.size.height - sender.frame.size.height - 100, sender.frame.size.width, sender.frame.size.height);
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            sender.frame = CGRectMake(0, screenRect.size.height - sender.frame.size.height, sender.frame.size.width, sender.frame.size.height);
        }];
    }
}

- (void)showLoadingImage:(UIView *)view {
    viewLoading = [[UIView alloc] initWithFrame:CGRectMake(view.bounds.size.width / 2 - 38, view.bounds.size.height / 2 - 38, 76, 76)];
    viewLoading.tag = 200;
    viewLoading.backgroundColor = [UIColor darkGrayColor];
    viewLoading.layer.cornerRadius = 5.0;
    viewLoading.layer.masksToBounds = true;
    viewLoading.alpha = 0.9;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(viewLoading.bounds.size.width / 2 - 38, viewLoading.bounds.size.height / 2 - 38, 76, 76)];
    imageView.image = [UIImage animatedImageNamed:@"loader-" duration:0.75f];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [viewLoading addSubview:imageView];
    [view addSubview:viewLoading];
    [view bringSubviewToFront:viewLoading];
}

- (void)hideLoadingImage {
    [viewLoading removeFromSuperview];
}

- (void)hideLoadingImage:(UIView *)view {
    for (UIView *subview in view.subviews) {
        if (subview.tag == 200) {
            [subview removeFromSuperview];
        }
    }
}

- (void) setLazyLoadImage:(__weak UIImageView *)imageCell urlString:(NSString *) urlImage {
    NSURL *url = [NSURL URLWithString:urlImage];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"def_big_img"];
    
    [imageCell setImageWithURLRequest:request
                     placeholderImage:placeholderImage
                              success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                  
                                  [UIView transitionWithView:imageCell
                                                    duration:0.3
                                                     options:UIViewAnimationOptionAllowAnimatedContent
                                                  animations:^{
                                                      imageCell.image = image;
                                                  }
                                                  completion:NULL];
                                  
                                  
                              } failure:nil];
}

-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

-(void)setAlert:(NSString *)title message:(NSString *)message{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    
    [alert show];
}

- (CGFloat)obtainScreenWidth {
    
    return [[UIScreen mainScreen] bounds].size.width;
}

- (BOOL)isValidEmail:(NSString *)checkEmailString
{
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-‌​Za-z0-9-]+)*(\\.[A-Z‌​a-z]{2,4})$";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:checkEmailString];
}

- (BOOL)isValidPhoneNumber:(NSString *)checkPhoneString {
    NSString *stricterFilterString = @"^((\\+)|(00))[0-9]{6,14}$";
    NSString *phoneRegex = stricterFilterString ;
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    
    return [phoneTest evaluateWithObject:checkPhoneString];
}

- (NSMutableDictionary *)setupBookingParams:(NSDictionary *)responseDict initWithFlight:(NSInteger)flightNumber {
    NSMutableDictionary *bookParams = [[NSMutableDictionary alloc] init];
    NSMutableArray *flightDetail = [[NSMutableArray alloc] init];
    
    int rowConditionarr = [[[[responseDict objectForKey:@"data"] objectForKey:@"timearr"][flightNumber - 1] objectForKey:@"condition"] intValue];
    int totPrice = 0;
    int totPriceFlightDetail = 0;
    
    for (int i=0; i < flightNumber; i++) {
        [flightDetail addObject:[self setupFlightDetail:responseDict index:i rowConditionarr:rowConditionarr]];
        totPriceFlightDetail = [[[flightDetail objectAtIndex:i] objectForKey:@"price"] intValue];
        totPrice = totPrice + totPriceFlightDetail;
    }

    NSLog(@"flightDetail %@", [flightDetail description]);
    
    [bookParams setObject:[[responseDict objectForKey:@"data"] objectForKey:@"gid"] forKey:@"gid"];
    [bookParams setObject:[[responseDict objectForKey:@"data"] objectForKey:@"gname"] forKey:@"gname"];
    [bookParams setObject:[[responseDict objectForKey:@"data"] objectForKey:@"date"] forKey:@"date"];
    [bookParams setObject:[[responseDict objectForKey:@"data"] objectForKey:@"image"] forKey:@"image"];
    [bookParams setObject:[NSString stringWithFormat:@"%ld", (long)flightNumber] forKey:@"flight"];
    [bookParams setObject:[NSString stringWithFormat:@"%ld", (long)totPrice] forKey:@"tprice"];
    [bookParams setObject:flightDetail forKey:@"flights"];
    NSLog(@"bookParams %@", [bookParams description]);
    
    return bookParams;
}

- (NSMutableDictionary *)setupFlightDetail:(NSDictionary *)responseDict index:(NSInteger)index rowConditionarr:(NSInteger)rowConditionarr {
    int flightId = (int)index + 1;
    NSMutableDictionary *flightDetailDesc = [[NSMutableDictionary alloc] init];
    NSMutableArray *playerarr = [[NSMutableArray alloc] init];
    NSMutableArray *pricelist = [[NSMutableArray alloc] init];
    pricelist = [[[responseDict objectForKey:@"data"] objectForKey:@"conditionarr"][rowConditionarr] objectForKey:@"price_list"];
    playerarr = [self setupPlayerArr:responseDict withCount:[[[[responseDict objectForKey:@"data"] objectForKey:@"conditionarr"][rowConditionarr] objectForKey:@"min_number"] intValue] fromConditionarr:rowConditionarr fromPlayerIndex:0 withTypePrice:@"price_cart" andPlayerType:@"type"];
    int totPriceFlightDetail = [self setupFlightDetailTotPrice:playerarr];
    NSString *teeTime = [NSString stringWithFormat:@"%@", [[[[responseDict objectForKey:@"data"] objectForKey:@"timearr"][index] objectForKey:@"ttime"] description]];
    NSString *cartMandatory = [[[[responseDict objectForKey:@"data"] objectForKey:@"conditionarr"][rowConditionarr] objectForKey:@"cart_mandatory"] description];
    [flightDetailDesc setObject:cartMandatory forKey:@"cart"];
    if ([[pricelist[0] objectForKey:@"cart_mandatory"] isEqualToString:@"1"])
        [flightDetailDesc setObject:@"1" forKey:@"cart"];
    if ([cartMandatory isEqualToString:@"1"])
        [flightDetailDesc setObject:cartMandatory forKey:@"cartOpt"];
    else
        [flightDetailDesc setObject:@"1" forKey:@"cartOpt"];
    [flightDetailDesc setObject:[NSString stringWithFormat:@"%ld",(long)flightId] forKey:@"id"];
    [flightDetailDesc setObject:[[[responseDict objectForKey:@"data"] objectForKey:@"conditionarr"][rowConditionarr] objectForKey:@"min_number"] forKey:@"player"];
    [flightDetailDesc setObject:[NSString stringWithFormat:@"%ld", (long)totPriceFlightDetail] forKey:@"price"];
    [flightDetailDesc setObject:teeTime forKey:@"ttime"];
    [flightDetailDesc setObject:[NSString stringWithFormat:@"%ld", (long)index] forKey:@"ttimePos"];
    [flightDetailDesc setObject:playerarr forKey:@"playerarr"];
    [flightDetailDesc setObject:[[[responseDict objectForKey:@"data"] objectForKey:@"conditionarr"][rowConditionarr] objectForKey:@"cancel_limit_hours"] forKey:@"cancel_limit_hours"];
    [flightDetailDesc setObject:[[[responseDict objectForKey:@"data"] objectForKey:@"conditionarr"][rowConditionarr] objectForKey:@"deposit_rate"] forKey:@"deposit_rate"];
    [flightDetailDesc setObject:[[[responseDict objectForKey:@"data"] objectForKey:@"conditionarr"][rowConditionarr] objectForKey:@"max_number"] forKey:@"max_number"];
    [flightDetailDesc setObject:[[[responseDict objectForKey:@"data"] objectForKey:@"conditionarr"][rowConditionarr] objectForKey:@"min_number"] forKey:@"min_number"];

    return flightDetailDesc;
}

- (int)setupFlightDetailTotPrice:(NSMutableArray *)playerarr {
    int totPrice = 0;
    
    for (int i = 0; i < [playerarr count]; i++) {
        totPrice = totPrice + [[playerarr[i] objectForKey:@"price"] intValue];
    }
    
    return totPrice;
}

- (NSMutableArray *)setupPlayerArr:(NSDictionary *)responseDict withCount:(NSInteger)count fromConditionarr:(NSInteger)rowConditionarr fromPlayerIndex:(NSInteger)playerIndex withTypePrice:(NSString *)priceType andPlayerType:(NSString *)playerType {
    NSMutableArray *playerArr = [[NSMutableArray alloc] init];
    
    for (int i = (int)playerIndex; i < count; i++) {
        NSMutableDictionary *playerDetail = [[NSMutableDictionary alloc] init];
        [playerDetail setObject:[[[[responseDict objectForKey:@"data"] objectForKey:@"conditionarr"][rowConditionarr] objectForKey:@"price_list"][0] objectForKey:priceType] forKey:@"price"];
        [playerDetail setObject:[[[[responseDict objectForKey:@"data"] objectForKey:@"conditionarr"][rowConditionarr] objectForKey:@"price_list"][0] objectForKey:playerType] forKey:@"type"];
        [playerArr addObject:playerDetail];
    }
    
    return playerArr;
}


- (NSMutableArray *)setupPlayerNumber:(int)max fromIndex:(int)min {
    NSMutableArray *playerNumber = [[NSMutableArray alloc] init];
    for (int i = min; i < max + 1; i++) {
        [playerNumber addObject:[NSString stringWithFormat:@"%ld", (long)i]];
    }
    
    return playerNumber;
}

- (NSMutableArray *)setupPlayerType:(NSDictionary *)responseDict withRowConditionarr:(NSInteger)rowConditionarr {
    NSMutableArray *playerType = [[NSMutableArray alloc] init];
    
    playerType = [[[responseDict objectForKey:@"data"] objectForKey:@"conditionarr"][rowConditionarr] objectForKey:@"price_list"];
    
    return playerType;
}

- (NSMutableDictionary *)getFlightDetailFromTeeTime:(NSString *)teeTime responseDict:(NSDictionary *)responseDict rowConditionarr:(NSInteger)rowConditionarr teeTimePos:(NSInteger)pos {
    NSLog(@"teetime %@", teeTime);
    NSLog(@"rowConditionarr %ld", (long)rowConditionarr);
    NSLog(@"teetime pos %ld", (long)pos);
    
    NSMutableDictionary *flightDetail = [[NSMutableDictionary alloc] init];
    [flightDetail setObject:[[[responseDict objectForKey:@"data"] objectForKey:@"conditionarr"][rowConditionarr] objectForKey:@"cancel_limit_hours"] forKey:@"cancel_limit_hours"];
    [flightDetail setObject:[[[responseDict objectForKey:@"data"] objectForKey:@"conditionarr"][rowConditionarr] objectForKey:@"cart_mandatory"] forKey:@"cart"];
    [flightDetail setObject:[[[responseDict objectForKey:@"data"] objectForKey:@"conditionarr"][rowConditionarr] objectForKey:@"deposit_rate"] forKey:@"deposit_rate"];
    [flightDetail setObject:[[[responseDict objectForKey:@"data"] objectForKey:@"conditionarr"][rowConditionarr] objectForKey:@"max_number"] forKey:@"max_number"];
    [flightDetail setObject:[[[responseDict objectForKey:@"data"] objectForKey:@"conditionarr"][rowConditionarr] objectForKey:@"min_number"] forKey:@"min_number"];
    [flightDetail setObject:teeTime forKey:@"ttime"];
    [flightDetail setObject:[NSString stringWithFormat:@"%ld", (long)pos] forKey:@"ttimePos"];
    
    return flightDetail;
}

- (void)updateFlightDetail:(NSMutableDictionary *)flightDetail withDetail:(NSMutableDictionary *)data {
    [flightDetail setObject:[data objectForKey:@"cancel_limit_hours"] forKey:@"cancel_limit_hours"];
    [flightDetail setObject:[data objectForKey:@"cart"] forKey:@"cart"];
    [flightDetail setObject:[data objectForKey:@"deposit_rate"] forKey:@"deposit_rate"];
    [flightDetail setObject:[data objectForKey:@"max_number"] forKey:@"max_number"];
    [flightDetail setObject:[data objectForKey:@"min_number"] forKey:@"min_number"];
    [flightDetail setObject:[data objectForKey:@"ttime"] forKey:@"ttime"];
    [flightDetail setObject:[data objectForKey:@"ttimePos"] forKey:@"ttimePos"];
}

- (void)addPlayerArr:(NSMutableDictionary *)flightDetail withPrice:(NSString *)price andType:(NSString *)type withCount:(int)count andCartMandatory:(NSString *)cartMandatory {
    
    int countFromFlight = (int)[[flightDetail objectForKey:@"playerarr"] count];
    if (count != countFromFlight || [cartMandatory isEqualToString:@"1"]) {
        NSMutableArray *playerarr = [[NSMutableArray alloc] init];
        int totPrice = 0;
        
        for (int i = 0; i < count; i++) {
            NSMutableDictionary *playerDetail = [[NSMutableDictionary alloc] init];
            [playerDetail setObject:price forKey:@"price"];
            [playerDetail setObject:type forKey:@"type"];
            totPrice = totPrice + [price intValue];
            [playerarr addObject:playerDetail];
        }
        
        [flightDetail setObject:playerarr forKey:@"playerarr"];
        [flightDetail setObject:[NSString stringWithFormat:@"%ld", (long)totPrice] forKey:@"price"];
        [flightDetail setObject:[NSString stringWithFormat:@"%ld", (long)count] forKey:@"player"];
        if ([cartMandatory isEqualToString:@"1"])
            [flightDetail setObject:@"1" forKey:@"cart"];
        else
            [flightDetail setObject:@"0" forKey:@"cart"];
        NSLog(@"flightDetail %@", [flightDetail description]);
    }
}

- (void)updateAllPlayerArr:(NSMutableDictionary *)flightDetail fromPlayerType:(NSMutableArray *)playerType withCartOpt:(BOOL)cartOpt {
    NSMutableArray *playerarr = [[NSMutableArray alloc] init];
    playerarr = [flightDetail objectForKey:@"playerarr"];
    int totPrice = 0;
    int countCart = 0;
    
    for (int i = 0; i < [playerarr count]; i++) {
        for (int j = 0; j < [playerType count]; j++) {
            if ([[playerarr[i] objectForKey:@"type"] isEqualToString:[playerType[j] objectForKey:@"type"]]) {
                if ([[playerType[j] objectForKey:@"cart_mandatory"] isEqualToString:@"1"]) {
                    countCart += 1;
                }
                if (cartOpt == true || [[playerType[j] objectForKey:@"cart_mandatory"] isEqualToString:@"1"]) {
                    [playerarr[i] setObject:[playerType[j] objectForKey:@"price_cart"] forKey:@"price"];
                }else{
                    [playerarr[i] setObject:[playerType[j] objectForKey:@"price"] forKey:@"price"];
                }
            }
        }
        totPrice = totPrice + [[playerarr[i] objectForKey:@"price"] intValue];
    }
    
    NSLog(@"flight detail before update %@", [flightDetail description]);
    [flightDetail setObject:playerarr forKey:@"playerarr"];
    [flightDetail setObject:[NSString stringWithFormat:@"%ld", (long)totPrice] forKey:@"price"];
    [flightDetail setObject:[NSString stringWithFormat:@"%d", cartOpt] forKey:@"cartOpt"];
    if (countCart > 0)
        [flightDetail setObject:@"1" forKey:@"cart"];
    else
        [flightDetail setObject:@"0" forKey:@"cart"];
    NSLog(@"flight detail after update %@", [flightDetail description]);
}

- (void)updateAllPlayerArrFromTeeTime:(NSMutableDictionary *)flightDetail fromPlayerType:(NSMutableArray *)playerType withCartOpt:(BOOL)cartOpt {
    NSMutableArray *playerarr = [[NSMutableArray alloc] init];
    int totPrice = 0;
    int countCart = 0;
    int min = 0;
    int max = [[flightDetail objectForKey:@"min_number"] intValue];
    
    for (int i = min; i < max; i++) {
        NSMutableDictionary *playerDetail = [[NSMutableDictionary alloc] init];
        if ([[playerType[0] objectForKey:@"cart_mandatory"] isEqualToString:@"1"]) {
            countCart += 1;
            [playerDetail setObject:[playerType[0] objectForKey:@"price_cart"] forKey:@"price"];
        }else{
            if ([[flightDetail objectForKey:@"cartOpt"] isEqualToString:@"1"])
                [playerDetail setObject:[playerType[0] objectForKey:@"price_cart"] forKey:@"price"];
            else
                [playerDetail setObject:[playerType[0] objectForKey:@"price"] forKey:@"price"];
        }
        [playerDetail setObject:[playerType[0] objectForKey:@"type"] forKey:@"type"];
        totPrice = totPrice + [[playerDetail objectForKey:@"price"] intValue];
        [playerarr addObject:playerDetail];
    }
    
    NSLog(@"flight detail before update %@", [flightDetail description]);
    [flightDetail setObject:playerarr forKey:@"playerarr"];
    [flightDetail setObject:[NSString stringWithFormat:@"%ld", (long)totPrice] forKey:@"price"];
    [flightDetail setObject:[NSString stringWithFormat:@"%d", cartOpt] forKey:@"cartOpt"];
    if (countCart > 0)
        [flightDetail setObject:@"1" forKey:@"cart"];
    else
        [flightDetail setObject:@"0" forKey:@"cart"];
    NSLog(@"flight detail after update %@", [flightDetail description]);
}

- (void)updatePlayerArr:(NSMutableDictionary *)flightDetail withPrice:(NSString *)price andType:(NSString *)type atIndex:(int)index withCartOpt:(BOOL)cartOpt andCartMandatory:(NSString *)cartMandatory andPlayerType:(NSMutableArray *)playerType {
    NSLog(@"indePlayer %ld", (long)index);
    NSMutableArray *playerarr = [[NSMutableArray alloc] init];
    playerarr = [flightDetail objectForKey:@"playerarr"];
    [playerarr[index] setObject:price forKey:@"price"];
    [playerarr[index] setObject:type forKey:@"type"];
    int totPrice = 0;
    int cartCount = 0;
        
    for (int i = 0; i < [playerarr count]; i++) {
        totPrice = totPrice + [[playerarr[i] objectForKey:@"price"] intValue];
        for (int j = 0; j < [playerType count]; j++) {
            if ([[playerarr[i] objectForKey:@"type"] isEqualToString:@"Prestige"] || [[playerarr[i] objectForKey:@"type"] isEqualToString:@"Qgolf"] || [cartMandatory isEqualToString:@"1"] || ([[playerType[j] objectForKey:@"type"] isEqualToString:[playerarr[i] objectForKey:@"type"]] && [[playerType[j] objectForKey:@"cart_mandatory"] isEqualToString:@"1"])) {
                cartCount += 1;
            }
        }
    }
    
    NSLog(@"cartCount %ld", (long)cartCount);
    NSLog(@"playerarr coung %ld", [playerarr count]);
    
    [flightDetail setObject:playerarr forKey:@"playerarr"];
    [flightDetail setObject:[NSString stringWithFormat:@"%ld", (long)totPrice] forKey:@"price"];
    [flightDetail setObject:[NSString stringWithFormat:@"%d", cartOpt] forKey:@"cartOpt"];
    if (cartCount > 0) {
        [flightDetail setObject:@"1" forKey:@"cart"];
    }else{
        [flightDetail setObject:@"0" forKey:@"cart"];
    }
    NSLog(@"flightDetail %@", [flightDetail description]);
}

- (void)updatePreBookTotPrice:(NSMutableDictionary *)preBookDict {
    int totPrice = 0;
    NSInteger countFlight = [[preBookDict objectForKey:@"flights"] count];
    for (int i = 0; i < countFlight; i++) {
        totPrice = totPrice + [[[preBookDict objectForKey:@"flights"][i] objectForKey:@"price"] intValue];
    }
    
    [preBookDict setObject:[NSString stringWithFormat:@"%ld", (long)totPrice] forKey:@"tprice"];    
}

- (BOOL)connected {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    
    if (networkStatus == NotReachable)
    {
        NSLog(@"Internet not reachable.");
        return false;
    }
    else
    {
        NSLog(@"Internet is reachable.");
        return true;
    }
}

-(void)setViewMovedUp:(BOOL)movedUp fromView:(UIView *)view fromPos:(int)pos
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect         = view.frame;
    
    if (movedUp)
    {
        
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= (50 * pos);
        rect.size.height += (50 * pos);
    }
    else
    {
        
        // revert back to the normal state.
        rect.origin.y += (50 * pos);
        rect.size.height -= (50 * pos);
    }
    
    view.frame = rect;
    
    [UIView commitAnimations];
}

@end
