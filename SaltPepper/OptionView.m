//
//  OptionView.m
//  SaltPepper
//
//  Created by kaushik on 24/05/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "OptionView.h"
#import "OptionWithCell.h"
#import "saltPepper.pch"

@interface OptionView ()

@end

@implementation OptionView
@synthesize WithCollection,WithoutCollection;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UINib *nib2 = [UINib nibWithNibName:@"OptionWithCell" bundle:nil];
    [WithCollection registerNib:nib2 forCellWithReuseIdentifier:@"OptionWithCell"];
    
    UINib *nib = [UINib nibWithNibName:@"OptionWithCell" bundle:nil];
    [WithoutCollection registerNib:nib forCellWithReuseIdentifier:@"OptionWithCell"];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(120, 150)];
    flowLayout.minimumInteritemSpacing = 0;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [WithCollection setCollectionViewLayout:flowLayout];
    [WithoutCollection setCollectionViewLayout:flowLayout];
    
    [WithCollection reloadData];
    [WithoutCollection reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - COLLECTIONVIEW
#pragma mark Collection View CODE

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==WithCollection)
    {
        static NSString *cellIdentifier = @"OptionWithCell";
        OptionWithCell *cell = (OptionWithCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        
        // cell.MainIMG.image=[UIImage imageNamed:[Array objectAtIndex:indexPath.row]];
        return cell;
    }
    else{
        static NSString *cellIdentifier = @"OptionWithCell";
        OptionWithCell *cell = (OptionWithCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        
        // cell.MainIMG.image=[UIImage imageNamed:[Array objectAtIndex:indexPath.row]];
        return cell;
    }
    return nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark Collection view layout things
// Layout: Set cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize mElementSize;
    mElementSize=CGSizeMake(SCREEN_WIDTH/3.4, 150);
    return mElementSize;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5.0;
}




//// Layout: Set Edges
//- (UIEdgeInsets)collectionView: (UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    if (isIphone5 || isiPhone4)
//    {
//        return UIEdgeInsetsMake(15,15,5,15);  // top, left, bottom, right
//    }
//    else if (isIphone6)
//    {
//        return UIEdgeInsetsMake(15,15,5,15);  // top, left, bottom, right
//    }
//    else if (isIphone6P)
//    {
//        return UIEdgeInsetsMake(15,15,5,15);  // top, left, bottom, right
//    }
//    
//    return UIEdgeInsetsMake(15,15,5,15);  // top, left, bottom, right
//}
@end
