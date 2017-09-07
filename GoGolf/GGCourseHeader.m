//
//  GGCourseHeader.m
//  GoGolf
//
//  Created by Aprido Sandyasa on 10/31/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGCourseHeader.h"

static const BOOL kNavBar = YES;

@implementation GGCourseHeader

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.expansionMode = GSKStretchyHeaderViewExpansionModeTopOnly;
    if (kNavBar) {
        self.minimumContentHeight = 60;
    } else {
        self.viewBelt.hidden = YES;
    }    
}

- (void)didChangeStretchFactor:(CGFloat)stretchFactor {
    CGFloat alpha = CGFloatTranslateRange(stretchFactor, 0.2, 0.8, 0, 1);
    alpha = MAX(0, MIN(1, alpha));
    
    self.viewSlide.alpha = alpha;
    
    if (kNavBar) {
        
        CGFloat navTitleFactor = 0.4;
        CGFloat navTitleAlpha = 0;
        if (stretchFactor < navTitleFactor) {
            navTitleAlpha = CGFloatTranslateRange(stretchFactor, 0, navTitleFactor, 1, 0);
        }
        self.viewBelt.alpha = navTitleAlpha;
    }
}

- (IBAction)actionBack:(id)sender {
    if ([self.detailCourseDelegate isKindOfClass:[GGSearchDetailVC class]]) {
        [self.detailCourseDelegate backToSearchView];
    }
}

@end
