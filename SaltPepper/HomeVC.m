//
//  HomeVC.m
//  SaltPepper
//
//  Created by jignesh solanki on 12/03/2018.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "HomeVC.h"
#import "MenuListCollectCELL.h"
#import "saltPepper.pch"
#import "SlideMenuVC.h"

@interface HomeVC ()

@end

@implementation HomeVC
@synthesize MenuCollectionVW,bannerscroll,pagesControl;


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    [MenuCollectionVW registerClass:[MenuListCollectCELL class] forCellWithReuseIdentifier:@"MenuListCollectCELL"];
    // Configure layout collectionView
    
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(50, 50)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [MenuCollectionVW setCollectionViewLayout:flowLayout];

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Setup cell identifier
    static NSString *cellIdentifier = @"MenuListCollectCELL";
    
    MenuListCollectCELL *cell = (MenuListCollectCELL *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
   
    
    //NSString *Urlstr=[[CatDATA valueForKey:@"img"] objectAtIndex:indexPath.row];
    
    // [cell.IconImageview sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
    // [cell.IconImageview setShowActivityIndicatorView:YES];
    
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SlideMenuVC *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SlideMenuVC"];
    [self.navigationController pushViewController:mainVC animated:YES];
}

#pragma mark Collection view layout things
// Layout: Set cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize mElementSize;
    if (IS_IPHONE_5 || IS_IPHONE_4)
    {
        mElementSize = CGSizeMake(90, 120);
    }
    else if (IS_IPHONE_6)
    {
        mElementSize = CGSizeMake(150, 150);
    }
    else
    {
        mElementSize = CGSizeMake(120, 150);
    }
    return mElementSize;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 2.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (IS_IPHONE_5 || IS_IPHONE_4)
    {
        return 12.0;
    }
    else if (IS_IPHONE_6)
    {
        return 10.0;
    }
    else if (IS_IPHONE_6P)
    {
        return 15.0;
    }
    return 15.0;
}

// Layout: Set Edges
- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (IS_IPHONE_5 || IS_IPHONE_4)
    {
        return UIEdgeInsetsMake(15,15,15,15);  // top, left, bottom, right
    }
    else if (IS_IPHONE_6)
    {
        return UIEdgeInsetsMake(15,15,15,15);  // top, left, bottom, right
    }
    else if (IS_IPHONE_6P)
    {
        return UIEdgeInsetsMake(15,15,15,15);  // top, left, bottom, right
    }
    
    return UIEdgeInsetsMake(10,15,10,15);  // top, left, bottom, right
}

- (IBAction)MenuButtonClick:(id)sender
{
     [self.sideMenuViewController presentLeftMenuViewController];
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

@end
