//
//  GGBerandaVC.m
//  GoGolf
//
//  Created by Eddyson Tan on 8/13/16.
//  Copyright © 2016 Eddyson Tan. All rights reserved.
//

#import "GGBerandaVC.h"
#import "GGHomeVC.h"
#import "GGHomePageVC.h"

@interface GGBerandaVC ()

@end

@implementation GGBerandaVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([[GGCommonFunc sharedInstance] connected]) {
        [[GGCommonFunc sharedInstance] showLoadingImage:((GGHomePageVC*)((GGHomeVC*)self.berandaVCDelegate).homeDelegate).homePageView];
        [[GGAPIManager sharedInstance] getHomeListWithcompletion:^(NSDictionary *responseDict, NSError *error) {
            [[GGCommonFunc sharedInstance] hideLoadingImage:((GGHomePageVC*)((GGHomeVC*)self.berandaVCDelegate).homeDelegate).homePageView];
            if (error == nil) {
                //            NSLog(@"RESPONSE : %@", responseDict);
                if ([[responseDict objectForKey:@"code"] intValue] == 400) {
                    [[GGCommonFunc sharedInstance] setAlert:@"Notification" message:@"Token is not available."];
                    [[GGAPIManager sharedInstance] clearAllData];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    [self.collTopView reloadData];
                    [self.collBottomView reloadData];
                }
            }
        }];
    }else{
        [self showCommonAlert:@"Alert" message:@"No internet connection."];
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

- (void) showCommonAlert:(NSString *) title message:(NSString *)msg {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:msg
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* okButton = [UIAlertAction
                               actionWithTitle:@"OK"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action)
                               {
                                   //Handel no, thanks button
                                   
                               }];
    
    [alert addAction:okButton];
    
    [self presentViewController:alert  animated:YES completion:nil];
}

#pragma mark - UICOLLECTIONVIEW DELEGATE & DATASOURCE

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView.tag == 1)
        return [[[[GGGlobalVariable sharedInstance].itemHomeList objectForKey:@"data"] objectForKey:@"toparr"] count];
    else if (collectionView.tag == 3)
        return [[[[GGGlobalVariable sharedInstance].itemHomeList objectForKey:@"data"] objectForKey:@"bottomarr"] count];
    
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *reCell;
    
    if (collectionView.tag == 1) {
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"headCell" forIndexPath:indexPath];
        
        UIImageView *imgRow = (UIImageView *)[cell viewWithTag:1];
        UILabel *lblTitle = (UILabel *)[cell viewWithTag:3];
        NSLog(@"toparr description %@", [[[[GGGlobalVariable sharedInstance].itemHomeList objectForKey:@"data"] objectForKey:@"toparr"] description]);
        if([[[[[GGGlobalVariable sharedInstance].itemHomeList objectForKey:@"data"] objectForKey:@"toparr"] objectAtIndex:indexPath.row] objectForKey:@"image"] != (id)[NSNull null]) {
            [[GGCommonFunc sharedInstance] setLazyLoadImage:imgRow urlString:[[[[[GGGlobalVariable sharedInstance].itemHomeList objectForKey:@"data"] objectForKey:@"toparr"] objectAtIndex:indexPath.row] objectForKey:@"image"]];
        }
        if ([[[[[GGGlobalVariable sharedInstance].itemHomeList objectForKey:@"data"] objectForKey:@"toparr"] objectAtIndex:indexPath.row] objectForKey:@"title"] != (id)[NSNull null]) {
            lblTitle.text = [NSString stringWithFormat:@"%@", [[[[[GGGlobalVariable sharedInstance].itemHomeList objectForKey:@"data"] objectForKey:@"toparr"] objectAtIndex:indexPath.row] objectForKey:@"title"]];
            lblTitle.hidden = NO;
        }
//        else
//            imgRow.image = [UIImage imageNamed:@"def_big_img"];
        
        reCell = cell;
        
    } else if (collectionView.tag == 2) {
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"sliderMenuCell" forIndexPath:indexPath];
        
        UILabel *lblMenu = (UILabel *)[cell viewWithTag:1];
        
        switch (indexPath.row) {
            case 0:
                lblMenu.text = @"HOME";
                break;
            case 1:
                lblMenu.text = @"PROMOTION";
                break;
            case 2:
                lblMenu.text = @"SEARCH";
                break;
            case 3:
                lblMenu.text = @"MAP";
                break;
            case 4:
                lblMenu.text = @"POINT";
                break;
            default:
                break;
        }
        
        if (cell.selected) {
            cell.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1];
            lblMenu.textColor = [UIColor colorWithRed:82/255.0 green:154/255.0 blue:4/255.0 alpha:1];
        }
        else
        {
            cell.backgroundColor = [UIColor colorWithRed:82/255.0 green:154/255.0 blue:4/255.0 alpha:1];
            lblMenu.textColor = [UIColor whiteColor];
        }
        
        reCell = cell;
        
    } else if (collectionView.tag == 3) {
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"homeMenuCell" forIndexPath:indexPath];
        
        UIImageView *imgLogo = (UIImageView *)[cell viewWithTag:1];
        
        if([[[[[GGGlobalVariable sharedInstance].itemHomeList objectForKey:@"data"] objectForKey:@"bottomarr"] objectAtIndex:indexPath.row] objectForKey:@"image"] != (id)[NSNull null])
            [[GGCommonFunc sharedInstance] setLazyLoadImage:imgLogo urlString:[[[[[GGGlobalVariable sharedInstance].itemHomeList objectForKey:@"data"] objectForKey:@"bottomarr"] objectAtIndex:indexPath.row] objectForKey:@"image"]];
        else
            imgLogo.image = [UIImage imageNamed:@"def_big_img"];
        
        
        UILabel *lblTitle = (UILabel *)[cell viewWithTag:2];
        lblTitle.text = [[[[[GGGlobalVariable sharedInstance].itemHomeList objectForKey:@"data"] objectForKey:@"bottomarr"] objectAtIndex:indexPath.row] objectForKey:@"title"];
        lblTitle.textColor = [UIColor whiteColor];
        
        UIView *bgView = (UIView *)[cell viewWithTag:3];
        bgView.backgroundColor = [[GGCommonFunc sharedInstance] colorWithHexString:[[[[[[GGGlobalVariable sharedInstance].itemHomeList objectForKey:@"data"] objectForKey:@"bottomarr"] objectAtIndex:indexPath.row] objectForKey:@"bgcolor"] substringFromIndex:1]];
        
        reCell = cell;
    }
    
    
    return reCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView.tag == 1) {
        if ([[[[[[GGGlobalVariable sharedInstance].itemHomeList objectForKey:@"data"] objectForKey:@"toparr"] objectAtIndex:indexPath.row] objectForKey:@"event"] isEqualToString:@"webview"]) {
            
            GGWebViewVC *webView = [self.storyboard instantiateViewControllerWithIdentifier:@"webViewVC"];
            webView.urlString = [[[[[GGGlobalVariable sharedInstance].itemHomeList objectForKey:@"data"] objectForKey:@"toparr"] objectAtIndex:indexPath.row] objectForKey:@"destination"];
            [self.navigationController pushViewController:webView animated:YES];
        } else if ([[[[[[GGGlobalVariable sharedInstance].itemHomeList objectForKey:@"data"] objectForKey:@"toparr"] objectAtIndex:indexPath.row] objectForKey:@"destination"] isEqualToString:@"booking"]) {
            
            NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObject:@"3" forKey:@"tab"];
            [dict setValue:@"booking" forKey:@"type"];
            [dict setValue:[NSString stringWithFormat:@"%ld",(long)indexPath.row] forKey:@"row"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTabNotification" object:self userInfo:dict];
            
        } else {
            
            [self showCommonAlert:@"Under Development" message:[NSString stringWithFormat:@"Golf Course %ld", (long)indexPath.row]];
        }
        
    } else if (collectionView.tag == 3) {
        
        if ([[[[[[GGGlobalVariable sharedInstance].itemHomeList objectForKey:@"data"] objectForKey:@"bottomarr"] objectAtIndex:indexPath.row] objectForKey:@"event"] isEqualToString:@"tab"]) {
            
            NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObject:[[[[[GGGlobalVariable sharedInstance].itemHomeList objectForKey:@"data"] objectForKey:@"bottomarr"] objectAtIndex:indexPath.row] objectForKey:@"destination"] forKey:@"tab"];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTabNotification" object:self userInfo:dict];
        } else if ([[[[[[GGGlobalVariable sharedInstance].itemHomeList objectForKey:@"data"] objectForKey:@"bottomarr"] objectAtIndex:indexPath.row] objectForKey:@"event"] isEqualToString:@"page"]) {
            
            
            if ([[[[[[GGGlobalVariable sharedInstance].itemHomeList objectForKey:@"data"] objectForKey:@"bottomarr"] objectAtIndex:indexPath.row] objectForKey:@"destination"] isEqualToString:@"weekend"]) {
                
                
                NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObject:@"3" forKey:@"tab"];
                [dict setValue:@"weekend" forKey:@"type"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTabNotification" object:self userInfo:dict];
                
            } else if ([[[[[[GGGlobalVariable sharedInstance].itemHomeList objectForKey:@"data"] objectForKey:@"bottomarr"] objectAtIndex:indexPath.row] objectForKey:@"destination"] isEqualToString:@"search golf course"]) {
                
                NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithObject:@"1" forKey:@"tab"];
                [dict setValue:@"search" forKey:@"type"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeTabNotification" object:self userInfo:dict];
            }
            
        } else {
            [self showCommonAlert:@"Under Development" message:[NSString stringWithFormat:@"Menu %ld", (long)indexPath.row]];
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag == 2) {
        UICollectionViewCell* cell = [collectionView  cellForItemAtIndexPath:indexPath];
        cell.backgroundColor = [UIColor colorWithRed:82/255.0 green:154/255.0 blue:4/255.0 alpha:1];
        
        UILabel *lblMenu = (UILabel *)[cell viewWithTag:1];
        lblMenu.textColor = [UIColor whiteColor];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGRect screenRect = [[UIScreen mainScreen] bounds];

    if (collectionView.tag == 3)
        return CGSizeMake((screenRect.size.width - 30)/2, (collectionView.frame.size.height - 30)/2);
    
    return CGSizeMake(screenRect.size.width, collectionView.frame.size.height);
}

@end
