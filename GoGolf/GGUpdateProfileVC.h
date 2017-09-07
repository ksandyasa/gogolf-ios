//
//  GGUpdateProfileVC.h
//  GoGolf
//
//  Created by Eddyson Tan on 9/2/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GGGlobalVariable.h"
#import "GGAPIUserManager.h"

@interface GGUpdateProfileVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate> {

}

@property (weak, nonatomic) IBOutlet UITableView *tblUpdateProfile;

@property NSInteger clickSection;

@property NSInteger clickIndex;

@property (strong, nonatomic) UIAlertController *pickerViewPopup;

@property (strong, nonatomic) UIView *viewPickerLang;

@property (strong, nonatomic) UIPickerView *pickerLanguage;

- (void) showCommonAlert:(NSString *) title message:(NSString *)msg indeks:(int)indeks;

@end
