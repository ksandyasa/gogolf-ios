//
//  pageContentViewController.h
//  NomadAlpha
//
//  Created by Eddyson Tan on 12/2/15.
//  Copyright © 2015 Allega Nomad Indonesia. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GGCommonFunc.h"

@interface pageContentViewController : UIViewController

@property NSUInteger pageIndex;
@property NSString *titleText;
@property NSString *DescText;
@property UIImage *imageFile;
@property UIImage *imagePage;
@property UIImage *imageShadow;
    
@property UIColor *titleColor;

@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextView *txtDetail;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imgShadow;

@end
