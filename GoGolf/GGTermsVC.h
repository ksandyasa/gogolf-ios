//
//  GGTermsVC.h
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/9/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGGlobal.h"
#import "GGSignUpVC.h"

@interface GGTermsVC : UIViewController

@property (weak, nonatomic) IBOutlet UIWebView *wvTerms;

@property (weak, nonatomic) id signUpDelegate;

- (IBAction)actionDismiss:(id)sender;

@end
