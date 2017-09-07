//
//  GGWebViewVC.h
//  GoGolf
//
//  Created by Eddyson Tan on 9/23/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGCommonFunc.h"

@interface GGWebViewVC : UIViewController <UIWebViewDelegate> {

}

@property NSString *urlString;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@end
