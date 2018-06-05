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

    BannerImageDataArr=[[NSMutableArray alloc]init];
    OfferTextArr=[[NSMutableArray alloc]init];

    [self CallOfferText];
    [self CallCategoryList];
    [self CallBannerImage];
    
}

-(void)SetheaderScroll
{
    NSArray* subviews = [[NSArray alloc] initWithArray: bannerscroll.subviews];
    for (UIView* view in subviews)
    {
        if ([view isKindOfClass:[UIView class]])
        {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UIImageView class]])
        {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UIButton class]])
        {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:[UILabel class]])
        {
            [view removeFromSuperview];
        }
    }
    
    int x=0;
    
    
    for (int i=0; i<BannerImageDataArr.count; i++)
    {
       UIImageView *Headerimg=[[UIImageView alloc]initWithFrame:CGRectMake(x, 0, SCREEN_WIDTH, 260)];
        //Headerimg.image = [UIImage imageNamed:@"bannerImage.jpg"];
        NSString *Urlstr = [[BannerImageDataArr valueForKey:@"image_path"] objectAtIndex:i];
        [Headerimg sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"bannerImage.jpg"]];
        [Headerimg sd_setShowActivityIndicatorView:YES];
        
        //Headerimg.image=[UIImage imageNamed:@"HomeLogo"];
        [bannerscroll addSubview:Headerimg];
        [bannerscroll bringSubviewToFront:Headerimg];
        
        if (OfferTextArr.count>i)
        {
            if (i==0)
            {
                for (int i =0 ; i<OfferTextArr.count; i++)
                {
                    if (i==0)
                    {
                        UILabel *First_LBL=[[UILabel alloc]initWithFrame:CGRectMake(x, 260-190, SCREEN_WIDTH, 40)];
                        First_LBL.text=[OfferTextArr objectAtIndex:i];
                        First_LBL.font=[UIFont boldSystemFontOfSize:30];
                        First_LBL.textAlignment=NSTextAlignmentCenter;
                        First_LBL.textColor=[UIColor whiteColor];
                        [bannerscroll addSubview:First_LBL];
                    }
                    else if (i==1)
                    {
                        UILabel *Second_LBL=[[UILabel alloc]initWithFrame:CGRectMake(x, 260-145, SCREEN_WIDTH, 30)];
                        Second_LBL.text=[OfferTextArr objectAtIndex:i];
                        Second_LBL.font=[UIFont boldSystemFontOfSize:20];
                        Second_LBL.textAlignment=NSTextAlignmentCenter;
                        Second_LBL.textColor=[UIColor whiteColor];
                        [bannerscroll addSubview:Second_LBL];
                    }
                    else if (i==2)
                    {
                        UILabel *thert_LBL=[[UILabel alloc]initWithFrame:CGRectMake(x, 260-115, SCREEN_WIDTH, 30)];
                        thert_LBL.text=[OfferTextArr objectAtIndex:i];
                        thert_LBL.font=[UIFont boldSystemFontOfSize:12];
                        thert_LBL.textAlignment=NSTextAlignmentCenter;
                        thert_LBL.textColor=[UIColor whiteColor];
                        [bannerscroll addSubview:thert_LBL];
                    }
                }
            }
            else if (i==1)
            {
                for (int i =0 ; i<OfferTextArr.count; i++)
                {
                    if (i==0)
                    {
                        UILabel *First_LBL=[[UILabel alloc]initWithFrame:CGRectMake(x, 260-190, SCREEN_WIDTH, 40)];
                        First_LBL.text=[OfferTextArr  objectAtIndex:i];
                        First_LBL.font=[UIFont boldSystemFontOfSize:30];
                        First_LBL.textAlignment=NSTextAlignmentCenter;
                        First_LBL.textColor=[UIColor whiteColor];
                        [bannerscroll addSubview:First_LBL];
                    }
                    else if (i==1)
                    {
                        UILabel *Second_LBL=[[UILabel alloc]initWithFrame:CGRectMake(x, 260-145, SCREEN_WIDTH, 30)];
                        Second_LBL.text=[OfferTextArr objectAtIndex:i];
                        Second_LBL.font=[UIFont boldSystemFontOfSize:20];
                        Second_LBL.textAlignment=NSTextAlignmentCenter;
                        Second_LBL.textColor=[UIColor whiteColor];
                        [bannerscroll addSubview:Second_LBL];
                    }
                    else if (i==2)
                    {
                        UILabel *thert_LBL=[[UILabel alloc]initWithFrame:CGRectMake(x, 260-115, SCREEN_WIDTH, 30)];
                        thert_LBL.text=[OfferTextArr objectAtIndex:i];
                        thert_LBL.font=[UIFont boldSystemFontOfSize:12];
                        thert_LBL.textAlignment=NSTextAlignmentCenter;
                        thert_LBL.textColor=[UIColor whiteColor];
                        [bannerscroll addSubview:thert_LBL];
                    }
                }
            }
            else if (i==2)
            {
                for (int i =0 ; i<OfferTextArr.count; i++)
                {
                    if (i==0)
                    {
                        UILabel *First_LBL=[[UILabel alloc]initWithFrame:CGRectMake(x, 260-190, SCREEN_WIDTH, 40)];
                        First_LBL.text=[OfferTextArr  objectAtIndex:i];
                        First_LBL.font=[UIFont boldSystemFontOfSize:30];
                        First_LBL.textAlignment=NSTextAlignmentCenter;
                        First_LBL.textColor=[UIColor whiteColor];
                        [bannerscroll addSubview:First_LBL];
                    }
                    else if (i==1)
                    {
                        UILabel *Second_LBL=[[UILabel alloc]initWithFrame:CGRectMake(x, 260-145, SCREEN_WIDTH, 30)];
                        Second_LBL.text=[OfferTextArr objectAtIndex:i];
                        Second_LBL.font=[UIFont boldSystemFontOfSize:20];
                        Second_LBL.textAlignment=NSTextAlignmentCenter;
                        Second_LBL.textColor=[UIColor whiteColor];
                        [bannerscroll addSubview:Second_LBL];
                    }
                    else if (i==2)
                    {
                        UILabel *thert_LBL=[[UILabel alloc]initWithFrame:CGRectMake(x, 260-115, SCREEN_WIDTH, 30)];
                        thert_LBL.text=[OfferTextArr objectAtIndex:i];
                        thert_LBL.font=[UIFont boldSystemFontOfSize:12];
                        thert_LBL.textAlignment=NSTextAlignmentCenter;
                        thert_LBL.textColor=[UIColor whiteColor];
                        [bannerscroll addSubview:thert_LBL];
                    }
                }
            }
        }
        
        x=x+SCREEN_WIDTH;
    }
    [bannerscroll setContentSize:CGSizeMake(x, 130)];
    pagesControl.numberOfPages = 3;
    pagesControl.currentPage = 0;
    [bannerscroll setPagingEnabled:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if([sender isKindOfClass:[UITableView class]])
    {
        return;
    }
    
    if (sender==bannerscroll)
    {
        CGFloat pageWidth = bannerscroll.frame.size.width;
        float fractionalPage = bannerscroll.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        pagesControl.currentPage = page;
    }
}

-(void)CallOfferText
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    [dictSub setObject:@"offerText" forKey:@"METHOD"];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
    NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
    
    [dictREQUESTPARAM setObject:arr forKey:@"REQUESTPARAM"];
    [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
    
    NSError* error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,OFFERTEXT];
    
    [Utility postRequest:json url:makeURL success:^(id result)
     {
         if (![result isKindOfClass:[NSString class]])
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             NSString *SUCCESS=[[[[result objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"offerText"] objectForKey:@"SUCCESS"];
             if ([SUCCESS boolValue] ==YES)
             {
                 OfferTextArr=[[[[[[result objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"offerText"] objectForKey:@"result"] objectForKey:@"offerText"] mutableCopy];
                 [self SetheaderScroll];
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

-(void)CallBannerImage
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    [dictSub setObject:@"bannerImages" forKey:@"METHOD"];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
    NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
    
    [dictREQUESTPARAM setObject:arr forKey:@"REQUESTPARAM"];
    [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
    
    NSError* error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,BANNERIMAGE];
    
    [Utility postRequest:json url:makeURL success:^(id result)
     {
         if (![result isKindOfClass:[NSString class]])
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             NSString *SUCCESS=[[[[result objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"bannerImages"] objectForKey:@"SUCCESS"];
             if ([SUCCESS boolValue] ==YES)
             {
                 BannerImageDataArr=[[[[[[result objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"bannerImages"] objectForKey:@"result"] objectForKey:@"bannerImages"] mutableCopy];
                 [self SetheaderScroll];
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

- (void)CallCategoryList
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    
    [dictSub setObject:@"topCategories" forKey:@"METHOD"];
    
    [dictSub setObject:dictInner forKey:@"PARAMS"];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
    NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
    
    [dictREQUESTPARAM setObject:arr forKey:@"REQUESTPARAM"];
    [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
    
    NSError* error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
    // NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,CATEGORY];
    
    [Utility postRequest:json url:makeURL success:^(id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"responseObject==%@",responseObject);
        NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"topCategories"] objectForKey:@"SUCCESS"];
        if ([SUCCESS boolValue] ==YES)
        {
        
            NSMutableArray *arrCategory = [[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"topCategories"]objectForKey:@"result"]objectForKey:@"topCategories"];
            [SharedClass sharedSingleton].arrCategories = [arrCategory mutableCopy];
            [self.MenuCollectionVW reloadData];
            
            //            DEMORootViewController *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"rootController"];
            //            [self.navigationController pushViewController:vcr animated:YES];
            
        }
        else
        {
            //            NSString *DESCRIPTION=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"postitem"] objectForKey:@"registration"] objectForKey:@"ERROR"] objectForKey:@"DESCRIPTION"];
            //            [AppDelegate showErrorMessageWithTitle:@"" message:DESCRIPTION delegate:nil];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"Fail");
        
    }];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [SharedClass sharedSingleton].arrCategories.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // Setup cell identifier
    static NSString *cellIdentifier = @"MenuListCollectCELL";
    
    MenuListCollectCELL *cell = (MenuListCollectCELL *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.MenuTitleLBL.text = [[[SharedClass sharedSingleton].arrCategories valueForKey:@"categoryName"] objectAtIndex:indexPath.row];
    //NSString *Urlstr=[[CatDATA valueForKey:@"img"] objectAtIndex:indexPath.row];
    
    // [cell.IconImageview sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
    // [cell.IconImageview setShowActivityIndicatorView:YES];
    
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SlideMenuVC *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SlideMenuVC"];
    mainVC.index = indexPath.row;
    [SharedClass sharedSingleton].index = mainVC.index;
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

- (IBAction)btnFavClicked:(id)sender
{
    if (_ro(@"LoginUserDic") != nil)
    {
        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"FavouriteVW"]]
                                                     animated:YES];
        [self.sideMenuViewController hideMenuViewController];
    }
    else
    {
        FCAlertView *alert = [KmyappDelegate ShowAlertWithBtnAction:@"Please First Login" andStrTile:nil andbtnTitle:@"Cancel" andButtonArray:@[]];
        
        [alert addButton:@"Login" withActionBlock:^{
            
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginVW"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            
        }];
    }
}

- (IBAction)btnCartClicked:(id)sender
{
    if (_ro(@"LoginUserDic") != nil)
    {
        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"CartVW"]]
                                                     animated:YES];
        [self.sideMenuViewController hideMenuViewController];
    }
    else
    {
        FCAlertView *alert = [KmyappDelegate ShowAlertWithBtnAction:@"Please First Login" andStrTile:nil andbtnTitle:@"Cancel" andButtonArray:@[]];
        
        [alert addButton:@"Login" withActionBlock:^{
            
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginVW"]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            
        }];
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

@end
