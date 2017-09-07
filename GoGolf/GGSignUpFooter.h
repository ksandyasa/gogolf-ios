//
//  GGSignUpFooter.h
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/9/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GGSignUpVC.h"

@interface GGSignUpFooter : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *lblTerms;

@property (weak, nonatomic) IBOutlet UIButton *btnSignUp;

@property (weak, nonatomic) id signUpDelegate;

- (IBAction)actonSignUp:(id)sender;

@end
