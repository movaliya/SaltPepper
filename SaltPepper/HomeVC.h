//
//  HomeVC.h
//  SaltPepper
//
//  Created by jignesh solanki on 12/03/2018.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@interface HomeVC : UIViewController
{
    NSMutableArray *BannerImageDataArr;
    NSMutableArray *OfferTextArr;
}
@property (weak, nonatomic) IBOutlet UILabel *lblCartCount;
@property (weak, nonatomic) IBOutlet UICollectionView *MenuCollectionVW;
@property (weak, nonatomic) IBOutlet UIPageControl *pagesControl;
@property (weak, nonatomic) IBOutlet UIScrollView *bannerscroll;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImgVW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;

@end
