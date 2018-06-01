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
{
    NSMutableArray *withoutIntegrate,*WithIntegrate;
    
}
@end

@implementation OptionView
@synthesize WithCollection,WithoutCollection;
@synthesize ModifyDic;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden=YES;
    
    UINib *nib2 = [UINib nibWithNibName:@"OptionWithCell" bundle:nil];
    [WithCollection registerNib:nib2 forCellWithReuseIdentifier:@"OptionWithCell"];
    
    UINib *nib = [UINib nibWithNibName:@"OptionWithCell" bundle:nil];
    [WithoutCollection registerNib:nib forCellWithReuseIdentifier:@"OptionWithCell"];
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 150)];
    flowLayout.minimumInteritemSpacing = 0;
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [WithCollection setCollectionViewLayout:flowLayout];
    [WithoutCollection setCollectionViewLayout:flowLayout];
    
    [WithCollection reloadData];
    [WithoutCollection reloadData];
    
    self.WithTagView.tagColorTheme = TagColorThemeStrawberry;
    self.WithoutTagsView.tagColorTheme = TagColorThemeStrawberry;
    [self handleWithTagBlocks];
    [self handleWithoutTagBlocks];
    
    NSLog(@"Dic==%@",ModifyDic);
    
    int count=0;
    withoutIntegrate=[[NSMutableArray alloc] init];
    WithIntegrate=[[NSMutableArray alloc] init];
    
    for (NSMutableArray *dic1 in [ModifyDic valueForKey:@"ingredients"])
    {
        if ([[dic1 valueForKey:@"is_with"] boolValue]==0)
        {
            [withoutIntegrate addObject:dic1];
        }
        else
        {
            [WithIntegrate addObject:dic1];
        }
        count++;
    }
    NSLog(@"withoutIntegrate=%@",withoutIntegrate);
    

}

#pragma mark - Tag blocks

- (void)handleWithTagBlocks
{
    __weak typeof(self) weakSelf = self;
    [self.WithTagView setTapBlock:^(NSString *tagText, NSInteger idx)
     {
         NSString *message = [NSString stringWithFormat:@"You tapped: %@", tagText];
         NSLog(@"Click==%@",message);
     }];
    
    [self.WithTagView setDeleteBlock:^(NSString *tagText, NSInteger idx)
     {
         NSString *message = [NSString stringWithFormat:@"You deleted: %@", tagText];
         NSLog(@"Click==%@",message);
         [weakSelf.WithTagView deleteTagAtIndex:idx];
     }];
}

- (void)handleWithoutTagBlocks
{
    __weak typeof(self) weakSelf = self;
    [self.WithoutTagsView setTapBlock:^(NSString *tagText, NSInteger idx)
     {
         NSString *message = [NSString stringWithFormat:@"You tapped: %@", tagText];
         NSLog(@"Click==%@",message);
     }];
    
    [self.WithoutTagsView setDeleteBlock:^(NSString *tagText, NSInteger idx)
     {
         NSString *message = [NSString stringWithFormat:@"You deleted: %@", tagText];
         NSLog(@"Click==%@",message);
         [weakSelf.WithoutTagsView deleteTagAtIndex:idx];
     }];
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
    if (collectionView==WithCollection)
    {
        return WithIntegrate.count;
    }
    else
    {
        return withoutIntegrate.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==WithCollection)
    {
        static NSString *cellIdentifier = @"OptionWithCell";
        OptionWithCell *cell = (OptionWithCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        
        cell.Title_LBL.text=[NSString stringWithFormat:@"%@",[[WithIntegrate objectAtIndex:indexPath.row] valueForKey:@"ingredient_name"]];
        
        cell.Price_LBL.text=[NSString stringWithFormat:@"%@",[[WithIntegrate objectAtIndex:indexPath.row] valueForKey:@"price"]];
        
        NSString *ImgURL = [NSString stringWithFormat:@"%@%@" ,BASE_PROFILE_IMAGE_URL,[[WithIntegrate objectAtIndex:indexPath.row] valueForKey:@"image_path"]];
        [cell.IMG sd_setShowActivityIndicatorView:YES];
        [cell.IMG sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        [cell.IMG sd_setImageWithURL:[NSURL URLWithString:ImgURL]
                        placeholderImage:[UIImage imageNamed:@"bannerImage.jpg"]
                               completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                                   
                                   [cell.IMG sd_setShowActivityIndicatorView:NO];
                               }];
        
        return cell;
    }
    else{
        static NSString *cellIdentifier = @"OptionWithCell";
        OptionWithCell *cell = (OptionWithCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
        
        cell.Title_LBL.text=[NSString stringWithFormat:@"%@",[[withoutIntegrate objectAtIndex:indexPath.row] valueForKey:@"ingredient_name"]];
        
        cell.Price_LBL.text=[NSString stringWithFormat:@"%@",[[withoutIntegrate objectAtIndex:indexPath.row] valueForKey:@"price"]];
        
        NSString *ImgURL = [NSString stringWithFormat:@"%@%@" ,BASE_PROFILE_IMAGE_URL,[[withoutIntegrate objectAtIndex:indexPath.row] valueForKey:@"image_path"]];
        [cell.IMG sd_setShowActivityIndicatorView:YES];
        [cell.IMG sd_setIndicatorStyle:UIActivityIndicatorViewStyleGray];
        
        [cell.IMG sd_setImageWithURL:[NSURL URLWithString:ImgURL]
                    placeholderImage:[UIImage imageNamed:@"bannerImage.jpg"]
                           completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                               
                               [cell.IMG sd_setShowActivityIndicatorView:NO];
                           }];
        
        return cell;
    }
    return nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==self.WithCollection)
    {
        [self.WithTagView addTag:@"Kaushik"];
    }
    else if (collectionView==self.WithoutCollection)
    {
        [self.WithoutTagsView addTag:@"Kaushik"];
    }
}

#pragma mark Collection view layout things
// Layout: Set cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize mElementSize;
    mElementSize=CGSizeMake(100, 150);
    return mElementSize;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.0;
}

- (IBAction)Back_Click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
