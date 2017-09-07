//
//  GGTermsVC.m
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/9/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGTermsVC.h"

@interface GGTermsVC ()

@end

@implementation GGTermsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self.wvTerms loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[GGGlobal apiTermsOfUse]]]];
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

- (IBAction)actionDismiss:(id)sender {
    if ([self.signUpDelegate isKindOfClass:[GGSignUpVC class]]) {
        [self.signUpDelegate dismissViewControllerAnimated:true completion:nil];
    }
    
}
@end
