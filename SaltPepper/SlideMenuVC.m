//
//  SlideMenuVC.m
//  SaltPepper
//
//  Created by Dharmraj Vora on 24/05/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "SlideMenuVC.h"
#import "ItemCell.h"
#import "CategoryItemCell.h"

@interface SlideMenuVC ()<EHHorizontalSelectionViewProtocol>

@end

@implementation SlideMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _viewSearch.layer.cornerRadius = 20;
    _viewSearch.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewSearch.layer.borderWidth = 1.0;
//    arrCategories = @[@"STARTERS & MAIN", @"HOUSE SPECIAL DISHES", @"SEAFOOD SPECIAL DISHES", @"MILD DISHES", @"TRADITIONAL DISHES", @"BIRYANI DISHES", @"ENGLISH DISHES", @"BREADS", @"RICE", @"SOFT DRINKS"];
//    arrItems = @[@"Vegetarian", @"Chicken", @"Lamb", @"Speciality", @"Seafood"];
    
    arrProductsItems = [[NSMutableArray alloc]init];
    
    [_collectionViewItem registerClass:[CategoryItemCell class] forCellWithReuseIdentifier:@"CategoryItemCell"];
    
    _HSSelView.delegate = self;
    //_collectionViewItem.hidden = YES;
    [self CallCategoryProduct];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)CallCategoryProduct
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
    [dictInner setObject:[[[SharedClass sharedSingleton].arrCategories valueForKey:@"id"] objectAtIndex:_index] forKey:@"CATEGORYID"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    
    [dictSub setObject:@"products" forKey:@"METHOD"];
    
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
    NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,PRODUCTCATEGORY];
    
    [Utility postRequest:json url:makeURL success:^(id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        arrProductsItems = [[NSMutableArray alloc]init];
        NSLog(@"responseObject==%@",responseObject);
        if([responseObject count] == 0)
        {
            _tblItem.hidden = YES;
            _collectionViewItem.hidden = YES;
        }
        else
        {
            NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"products"] objectForKey:@"SUCCESS"];
            if ([SUCCESS boolValue] ==YES)
            {
                arrProductsItems = [[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"products"]objectForKey:@"result"]objectForKey:@"products"];
                NSLog(@"%@",[[arrProductsItems valueForKey:@"allergy_image_path"] objectAtIndex:0]);
                if([[arrProductsItems valueForKey:@"allergy_image_path"] objectAtIndex:0] == [NSNull null] || [[[arrProductsItems valueForKey:@"allergy_image_path"] objectAtIndex:0]isEqualToString:@""])
                {
                    _tblItem.hidden = NO;
                    _collectionViewItem.hidden = YES;
                    [_tblItem reloadData];
                }
                else
                {
                    _tblItem.hidden = YES;
                    _collectionViewItem.hidden = NO;
                    [_collectionViewItem reloadData];
                }
            }
            else
            {
                //            NSString *DESCRIPTION=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"postitem"] objectForKey:@"registration"] objectForKey:@"ERROR"] objectForKey:@"DESCRIPTION"];
                //            [AppDelegate showErrorMessageWithTitle:@"" message:DESCRIPTION delegate:nil];
            }
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"Fail");
        
    }];
}

#pragma mark - Collectionview delegate methods
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrProductsItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CategoryItemCell";
    
    CategoryItemCell *cell = (CategoryItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.lblCatItemName.text = [[arrProductsItems valueForKey:@"productName"] objectAtIndex:indexPath.row];
    cell.lblPrice.text = [NSString stringWithFormat:@"£%@",[[arrProductsItems valueForKey:@"price"] objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 15.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width  = self.collectionViewItem.frame.size.width;
    // in case you you want the cell to be 40% of your controllers view
    return CGSizeMake((width/2) - 8,250);
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrProductsItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ItemCell *cell = (ItemCell*)[tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell.viewBack.layer setShadowColor:[UIColor grayColor].CGColor];
    [cell.viewBack.layer setShadowOpacity:0.8];
    [cell.viewBack.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    
    cell.lblItemName.text = [[arrProductsItems valueForKey:@"productName"] objectAtIndex:indexPath.row];
    cell.lblPrice.text = [NSString stringWithFormat:@"£%@",[[arrProductsItems valueForKey:@"price"] objectAtIndex:indexPath.row]];
    return cell;
    
}

#pragma mark - EHHorizontalSelectionViewProtocol

- (NSUInteger)numberOfItemsInHorizontalSelection:(EHHorizontalSelectionView*)hSelView
{
    if (hSelView == _HSSelView)
    {
        return [SharedClass sharedSingleton].arrCategories.count;
    }
    
    return 0;
}

- (NSString *)titleForItemAtIndex:(NSUInteger)index forHorisontalSelection:(EHHorizontalSelectionView*)hSelView
{
    if (hSelView == _HSSelView )
    {
        return [[[[SharedClass sharedSingleton].arrCategories valueForKey:@"categoryName"] objectAtIndex:index] uppercaseString];
    }
    
    return @"";
}

- (EHHorizontalViewCell *)selectionView:(EHHorizontalSelectionView *)selectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (void)horizontalSelection:(EHHorizontalSelectionView *)selectionView didSelectObjectAtIndex:(NSUInteger)index;
{
//    if([CommonWS checkNetworkReachability])
//    {
//        catID = [[[CommonWS sharedInstance].arrCategories valueForKey:@"id"]objectAtIndex:index];
//        [self callAPIGetProduct];
//    }
//    else
//    {
//        [self displayAlertWithTitle:@"Please check your internet connection..."];
//    }
//    [_collectionviewCategory setContentOffset:CGPointZero animated:YES];
    _index = index;
    [self CallCategoryProduct];
    NSLog(@"%lu",(unsigned long)index);
}

#pragma mark - Button Click Action

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnViewCartClicked:(id)sender {
}
- (IBAction)btnCheckoutClicked:(id)sender {
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
