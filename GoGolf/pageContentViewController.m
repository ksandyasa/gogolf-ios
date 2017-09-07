//
//  pageContentViewController.m
//  NomadAlpha
//
//  Created by Eddyson Tan on 12/2/15.
//  Copyright © 2015 Allega Nomad Indonesia. All rights reserved.
//

#import "pageContentViewController.h"


@interface pageContentViewController ()

@end


@implementation pageContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.titleLabel.text = self.titleText;
    self.titleLabel.textColor = _titleColor;
    
    self.txtDetail.text = self.DescText;
    self.txtDetail.textAlignment = NSTextAlignmentCenter;
    self.txtDetail.textColor = [UIColor whiteColor];
    self.txtDetail.font = [UIFont fontWithName:@"Charlevoix Pro" size:18];
    
    self.backgroundImageView.image = self.imageFile;
    self.imgIcon.image = self.imagePage;
    
    self.imgShadow.image = self.imageShadow;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
