//
//  GalleryVW.m
//  MirchMasala
//
//  Created by Mango SW on 09/09/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "GalleryVW.h"
#import "CVCell.h"
#import "GalleryFullView.h"
@interface GalleryVW ()
{
    NSMutableArray *ImageNameSection;
}
@end

@implementation GalleryVW
@synthesize IMGCollection;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;

    GalleryDataArr=[[NSMutableArray alloc]init];
    ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"cart.png",@"gallery.png",@"cart.png",@"gallery.png",@"cart.png",@"gallery.png", nil];
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
         [self CallGalleryService];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
   
    [IMGCollection registerClass:[CVCell class] forCellWithReuseIdentifier:@"cvCell"];
    // Configure layout collectionView
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(100, 150)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [IMGCollection setCollectionViewLayout:flowLayout];
    

}
-(void)CallGalleryService
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    [dictSub setObject:@"galleryImages" forKey:@"METHOD"];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
    NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
    
    [dictREQUESTPARAM setObject:arr forKey:@"REQUESTPARAM"];
    [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
    
    NSError* error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,GALLERYIMAGE];
    
    [Utility postRequest:json url:makeURL success:^(id result)
     {
         if (![result isKindOfClass:[NSString class]])
         {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *SUCCESS=[[[[result objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"galleryImages"] objectForKey:@"SUCCESS"];
             if ([SUCCESS boolValue] ==YES)
             {
                 GalleryDataArr=[[[[[[result objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"galleryImages"] objectForKey:@"result"] objectForKey:@"galleryImages"] mutableCopy];
                 [IMGCollection reloadData];
             }
         }
     }failure:^(NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         if (![Utility connected])
         {
             //[sharedAppDel ShowAlertWithOneBtn:kReachability andStrTitle:nil andbtnTitle:@"OK"];
         }
         else
         {
             //[sharedAppDel ShowAlertWithOneBtn:[result valueForKey:@"message"] andStrTitle:nil andbtnTitle:@"OK"];
         }
     }];
}

- (IBAction)backBtn_action:(id)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return GalleryDataArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Setup cell identifier
    static NSString *cellIdentifier = @"cvCell";
    
    CVCell *cell = (CVCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.layer.masksToBounds = NO;
    cell.layer.shadowOffset = CGSizeMake(0, 1);
    cell.layer.shadowRadius = 1.0;
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOpacity = 0.5;
    
    cell.Title_Hight.constant=0;
    
    NSString *Urlstr=[[GalleryDataArr valueForKey:@"image_path"] objectAtIndex:indexPath.row];
    [cell.IconImageview sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
    [cell.IconImageview sd_setShowActivityIndicatorView:YES];
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GalleryFullView *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"GalleryFullView"];
    vcr.ImagArr=GalleryDataArr;
    vcr.SelectedImage=[NSString stringWithFormat:@"%d",indexPath.row];
    [self.navigationController pushViewController:vcr animated:YES];
    
}

#pragma mark Collection view layout things
// Layout: Set cell size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize mElementSize;
    if (IS_IPHONE_5 || IS_IPHONE_4)
    {
        mElementSize = CGSizeMake(139, 139);
    }
    else if (IS_IPHONE_6)
    {
        mElementSize = CGSizeMake(166, 166);
    }
    else
    {
        mElementSize = CGSizeMake(185, 185);
    }
    return mElementSize;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
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
    
    return UIEdgeInsetsMake(15,15,15,15);  // top, left, bottom, right
}

@end
