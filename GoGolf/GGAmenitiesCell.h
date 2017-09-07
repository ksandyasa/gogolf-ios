//
//  GGAmenitiesCell.h
//  GoGolf
//
//  Created by Aprido Sandyasa on 11/14/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface GGAmenitiesCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ivIcon;

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;

@property (weak, nonatomic) IBOutlet UITextView *tvTitle;

@property (weak, nonatomic) IBOutlet UIImageView *ivCheck;
@end
