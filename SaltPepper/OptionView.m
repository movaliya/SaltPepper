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
#import "ASJTagsView.h"

@interface OptionView ()
{
    NSMutableArray *withoutIntegrate,*WithIntegrate;
    NSMutableArray *WithSelected,*WithoutSelected;
    
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
    WithSelected=[[NSMutableArray alloc] init];
    WithoutSelected=[[NSMutableArray alloc] init];
    
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
    
    self.HeaderTitle.text=[ModifyDic valueForKey:@"productName"];
    self.Title_LBL.text=[ModifyDic valueForKey:@"productName"];
    
    self.Plush_BTN.layer.cornerRadius=12.5f;
    self.Minush_BTN.layer.cornerRadius=12.5f;
    self.Applay_BTN.layer.cornerRadius=22.0f;
    self.Clear_BTN.layer.cornerRadius=22.0f;    

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
         
         ASJTagsView *conController = (ASJTagsView *)weakSelf.WithTagView;
         weakSelf.WithHight.constant=conController.contentSize.height;
         [weakSelf.view updateConstraints];
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
        cell.Bedge_LBL.hidden=YES;
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
        
        cell.Bedge_LBL.hidden=YES;
        
        return cell;
    }
    return nil;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (collectionView==self.WithCollection)
    {
        if ([self.WithTagView isKindOfClass:[ASJTagsView class]])
        {
            ASJTagsView *conController = (ASJTagsView *)self.WithTagView;
            
            
            
            [self.WithTagView addTag:[[WithIntegrate objectAtIndex:indexPath.row]valueForKey:@"ingredient_name"]];
            self.WithHight.constant=conController.contentSize.height;
            [self.view updateConstraints];
            NSLog(@"==%@",[WithIntegrate objectAtIndex:indexPath.row]);
          
            if (WithSelected.count==0)
            {
                NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
                intdic=[[withoutIntegrate objectAtIndex:indexPath.row] mutableCopy];
                [intdic setObject:[NSNumber numberWithInt:1] forKey:@"Quantity"];
                
                [WithSelected addObject:intdic];
            }
            else
            {
                if ([[WithSelected valueForKey:@"ingredient_id"] containsObject:[[WithIntegrate objectAtIndex:indexPath.row]valueForKey:@"ingredient_id"]])
                {
                    NSArray *Idarr=[WithSelected valueForKey:@"ingredient_id"];
                    NSInteger idx=[Idarr indexOfObject:[[WithIntegrate objectAtIndex:indexPath.row]valueForKey:@"ingredient_id"]];

                    NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
                    intdic=[[WithSelected objectAtIndex:idx] mutableCopy];
                   
                    if([intdic valueForKey:@"Quantity"] != nil)
                    {
                        int qnt=[[intdic valueForKey:@"Quantity"] intValue];
                        qnt=qnt + 1;
                        [intdic setObject:[NSNumber numberWithInt:qnt] forKey:@"Quantity"];
                    }
                    else
                    {
                        [intdic setObject:[NSNumber numberWithInt:1] forKey:@"Quantity"];
                    }
                    
                    [WithSelected replaceObjectAtIndex:idx withObject:intdic];
                }
                else
                {
                    NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
                    intdic=[[withoutIntegrate objectAtIndex:indexPath.row] mutableCopy];
                    [intdic setObject:[NSNumber numberWithInt:1] forKey:@"Quantity"];
                    
                    [WithSelected addObject:intdic];
                }
            }
            
        }
    }
    else if (collectionView==self.WithoutCollection)
    {        
        ASJTagsView *conController = (ASJTagsView *)self.WithoutTagsView;
        
        
        [self.WithoutTagsView addTag:[[withoutIntegrate objectAtIndex:indexPath.row]valueForKey:@"ingredient_name"]];
        self.WithoutHight.constant=conController.contentSize.height;
        [self.view updateConstraints];
        NSLog(@"==%@",[withoutIntegrate objectAtIndex:indexPath.row]);
        
        if (WithoutSelected.count==0)
        {
            NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
            intdic=[[withoutIntegrate objectAtIndex:indexPath.row] mutableCopy];
            [intdic setObject:[NSNumber numberWithInt:1] forKey:@"Quantity"];
            
            [WithoutSelected addObject:intdic];
        }
        else
        {
            if ([[WithoutSelected valueForKey:@"ingredient_id"] containsObject:[[withoutIntegrate objectAtIndex:indexPath.row]valueForKey:@"ingredient_id"]])
            {
                NSArray *Idarr=[WithoutSelected valueForKey:@"ingredient_id"];
                NSInteger idx=[Idarr indexOfObject:[[withoutIntegrate objectAtIndex:indexPath.row]valueForKey:@"ingredient_id"]];
                
                NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
                intdic=[[WithoutSelected objectAtIndex:idx] mutableCopy];
                
                if([intdic valueForKey:@"Quantity"] != nil)
                {
                    int qnt=[[intdic valueForKey:@"Quantity"] intValue];
                    qnt=qnt + 1;
                    [intdic setObject:[NSNumber numberWithInt:qnt] forKey:@"Quantity"];
                }
                else
                {
                    [intdic setObject:[NSNumber numberWithInt:1] forKey:@"Quantity"];
                }
                
                [WithoutSelected replaceObjectAtIndex:idx withObject:intdic];
            }
            else
            {
                NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
                intdic=[[withoutIntegrate objectAtIndex:indexPath.row] mutableCopy];
                [intdic setObject:[NSNumber numberWithInt:1] forKey:@"Quantity"];
                
                [WithoutSelected addObject:intdic];
            }
        }
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

- (IBAction)Plush_Click:(id)sender
{
    
}

- (IBAction)Minush_Click:(id)sender
{
    
}

- (IBAction)Clear_Click:(id)sender
{
    WithSelected=[[NSMutableArray alloc]init];
    WithoutSelected=[[NSMutableArray alloc]init];
}

- (IBAction)Applay_Click:(id)sender
{
    
}
@end
