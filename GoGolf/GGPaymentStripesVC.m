//
//  GGPaymentStripesVC.m
//  GoGolf
//
//  Created by Aprido Sandyasa on 12/14/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGPaymentStripesVC.h"

@interface GGPaymentStripesVC () {
    NSString *urlStripes;
}

@end

@implementation GGPaymentStripesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.wvStripes.delegate = self;
    
    urlStripes = [NSString stringWithFormat:@"%@?id=%@&access_token=%@", [GGGlobal apiStripeCharge], self.bcode, [[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"]];
    NSLog(@"urlStripes %@", urlStripes);
    
    [self.wvStripes loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[urlStripes stringByReplacingOccurrencesOfString:@"/v1" withString:@""]]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIWEBVIEW DELEGATE

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *html = [webView stringByEvaluatingJavaScriptFromString:
                      @"document.body.innerHTML"];
    NSLog(@"html %@", html);
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSLog(@"url %@", [[request URL] absoluteString]);
    
    if ([[[request URL] absoluteString] isEqualToString:[[[GGGlobal apiStripeCharge] stringByReplacingOccurrencesOfString:@"/view" withString:@""] stringByReplacingOccurrencesOfString:@"/v1" withString:@""]]) {
        if ([self.paymentStripesDelegate isKindOfClass:[GGBookingConfirmationVC class]]) {
            [self.paymentStripesDelegate goToPaymentConfirmation];
        }else if ([self.paymentStripesDelegate isKindOfClass:[GGBookingDetailVC class]]) {
            [self.paymentStripesDelegate goToPaymentConfirmationView];
        }
    }
    
    return YES;
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

@end
