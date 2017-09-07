//
//  GGTutorialVC.m
//  GoGolf
//
//  Created by Eddyson Tan on 6/14/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGTutorialVC.h"

@interface GGTutorialVC ()

@end

int pageTutorial = 0;

@implementation GGTutorialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.navigationController.interactivePopGestureRecognizer setDelegate:nil];
    [self contentSetup];
    [self setNeedsStatusBarAppearanceUpdate];
    
    self.btnNextTut.imageView.transform = CGAffineTransformMakeScale(-1, 1); //Flipped
    
    // Create page view controller
    self.pageViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"pageViewController"];
    self.pageViewController.dataSource = self;
    
    pageContentViewController *startingViewController = [self viewControllerAtIndex:0];
    NSArray *viewControllers = @[startingViewController];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // Change the size of page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.bodyView.frame.size.width, self.bodyView.frame.size.height + 40);
    
    [self.bodyView addSubview:_pageViewController.view];
    
    UIPageControl *pageControl = [UIPageControl appearance];
    pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    pageControl.currentPageIndicatorTintColor = [UIColor darkGrayColor];
    pageControl.backgroundColor = [UIColor clearColor];
    
}

- (void)contentSetup {
    // Override point for customization after application launch.
    currentPage = 0;
    self.titles = @[@"Book Golf Course",
                    @"Find Promotion",
                    @"Search Golf Course",
                    @"Reward Points"];
    self.texts = @[@"Pick Golf course you like and make a book easily by GoGolf.",
                   @"GoGolf publish good Promotion info from Golf course",
                   @"Find Golf Course you like with search condition.",
                   @"Save your point by booking Golf course and get discount rate."];
    self.wireframes = @[@"wireframe1",
                        @"wireframe2",
                        @"wireframe3",
                        @"wireframe4"];
    self.colors = @[@"7ED321",
                    @"F5A623",
                    @"FF5252",
                    @"06BEBD"];
    self.shadows = @[@"shadow0",
                     @"shadow1",
                     @"shadow2",
                     @"shadow3"];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (IBAction)goBack:(id)sender {
    pageTutorial = 0;
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)skipOrDoneTutorial:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)showNextTutorial:(id)sender {
    pageTutorial++;
    NSLog(@"pageTutorial %ld", (long)pageTutorial);

    if (pageTutorial == [self.titles count]) {
        pageTutorial--;
        
        return;
    }
    
    if (pageTutorial == [self.titles count] - 1) {
        [self.btnDoneTut setTitle:@"Done" forState:UIControlStateNormal];
        self.btnNextTut.hidden = true;
    }
    [self.pageViewController setViewControllers:@[[self viewControllerAtIndex:pageTutorial]] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];

}

- (pageContentViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.titles count] == 0) || (index >= [self.titles count])) {
        return nil;
    }
    
    // Create a new view controller and pass suitable data.
    pageContentViewController *pageContentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"pageContentViewController"];
    pageContentViewController.imageFile = [UIImage imageNamed:self.wireframes[index]];
    pageContentViewController.titleText = self.titles[index];
    pageContentViewController.DescText= self.texts[index];
    pageContentViewController.pageIndex = index;
    pageContentViewController.imagePage = [UIImage imageNamed:[NSString stringWithFormat:@"icons%lu", (unsigned long)index]];
    pageContentViewController.titleColor = [UIColor whiteColor];
    //pageContentViewController.backColor = self.colors[index];
    pageContentViewController.imageShadow = [UIImage imageNamed:self.shadows[index]];
    pageContentViewController.view.backgroundColor = [[GGCommonFunc sharedInstance] colorWithHexString:self.colors[index]];
    return pageContentViewController;
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((pageContentViewController*) viewController).pageIndex;
    
    NSLog(@"TEST 1: %lu", (unsigned long)index);
    if ((index == 0) || (index == NSNotFound)) {
        pageTutorial = (int)index;
        
        return nil;
    }

    pageTutorial = (int)index;
    index = index - 1;

    if (index < [self.titles count]) {
        self.btnNextTut.hidden = false;
        [self.btnDoneTut setTitle:@"Skip" forState:UIControlStateNormal];
    }
//    [self.pageControl setCurrentPage:index];
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((pageContentViewController*) viewController).pageIndex;
    
    if (index == NSNotFound) {
        return nil;
    }
    
    NSLog(@"TEST 2: %lu", (unsigned long)index);
    
//    if (currentPage == (int)index)
    
//    [self.pageControl setCurrentPage:index];
    if (index == [self.titles count] - 1) {
        self.btnNextTut.hidden = true;
        [self.btnDoneTut setTitle:@"Done" forState:UIControlStateNormal];
    }
    
    pageTutorial = (int)index;
    index = index + 1;
    if (index == [self.titles count]) {
        
        return nil;
    }
    
    return [self viewControllerAtIndex:index];
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController
{
    return [self.titles count];
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController
{
    return 0;
}

@end