//
//  GGBerandaVC.h
//  GoGolf
//
//  Created by Eddyson Tan on 8/13/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GGWebViewVC.h"

#import "GGAPIManager.h"

#import "GGGlobalVariable.h"
#import "GGCommonFunc.h"

@interface GGBerandaVC : UIViewController <UICollectionViewDelegate, UICollectionViewDataSource> {

}

@property (weak, nonatomic) IBOutlet UICollectionView *collTopView;

@property (weak, nonatomic) IBOutlet UICollectionView *collBottomView;

@property (weak, nonatomic) id berandaVCDelegate;

@end
