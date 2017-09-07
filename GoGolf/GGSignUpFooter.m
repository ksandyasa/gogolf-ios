//
//  GGSignUpFooter.m
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/9/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGSignUpFooter.h"

@interface GGSignUpFooter ()

@end

@implementation GGSignUpFooter

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UITapGestureRecognizer *tapTerms = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTermsOfUseFromFooter:)];
    [self.lblTerms addGestureRecognizer:tapTerms];
    
    self.btnSignUp.layer.cornerRadius = 5.0;
    self.btnSignUp.layer.masksToBounds = true;
}

- (void)showTermsOfUseFromFooter:(UITapGestureRecognizer *)sender {
    if ([self.signUpDelegate isKindOfClass:[GGSignUpVC class]]) {
        [self.signUpDelegate showTermOfUse];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actonSignUp:(id)sender {
    if ([self.signUpDelegate isKindOfClass:[GGSignUpVC class]]) {
        [self.signUpDelegate registerWithNewAccount];
    }
}

@end
