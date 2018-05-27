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
{
    NSMutableArray *cartArr;
}
@end

@implementation SlideMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    cartArr = [[NSMutableArray alloc]init];
    _viewBottom.hidden = YES;
    _viewSearch.layer.cornerRadius = 20;
    _viewSearch.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewSearch.layer.borderWidth = 1.0;
//    arrCategories = @[@"STARTERS & MAIN", @"HOUSE SPECIAL DISHES", @"SEAFOOD SPECIAL DISHES", @"MILD DISHES", @"TRADITIONAL DISHES", @"BIRYANI DISHES", @"ENGLISH DISHES", @"BREADS", @"RICE", @"SOFT DRINKS"];
//    arrItems = @[@"Vegetarian", @"Chicken", @"Lamb", @"Speciality", @"Seafood"];
    
    arrProductsItems = [[NSMutableArray alloc]init];
    filteredProducts = [[NSMutableArray alloc]init];
    
    [_collectionViewItem registerClass:[CategoryItemCell class] forCellWithReuseIdentifier:@"CategoryItemCell"];
    
    _HSSelView.delegate = self;
    //_collectionViewItem.hidden = YES;
    [self CallCategoryProduct];
    
    for (UIView *subview in [[self.searchBar.subviews lastObject] subviews]) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
            break;
        }
    }
    
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    
    // To change background color
    [searchField setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0]];
    //[searchField setBackground: [UIImage imageNamed:@"searchBG"]]; //set your gray background image here
    [searchField setBorderStyle:UITextBorderStyleNone];
    // To change text color
    searchField.textColor = [UIColor blackColor];
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.leftViewMode = UITextFieldViewModeNever;
    // To change placeholder text color
    UILabel *placeholderLabel = [searchField valueForKey:@"placeholderLabel"];
    placeholderLabel.textColor = [UIColor grayColor];
    placeholderLabel.text = @"Enter Your Dish Here";
    
    _collectionViewItem.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _tblItem.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
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
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 1;
//}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(isFiltered)
    {
        return filteredProducts.count;
    }
    else
    {
        return arrProductsItems.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CategoryItemCell";
    
    CategoryItemCell *cell = (CategoryItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.btnPlus.tag = indexPath.row;
    cell.btnMinus.tag = indexPath.row;
    cell.btnAdd.tag = indexPath.row;
    cell.btnModify.tag = indexPath.row;
    
    [cell.btnAdd addTarget:self action:@selector(addToCartClickedCollectionView:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnPlus addTarget:self action:@selector(plusClickedCollectionView:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnMinus addTarget:self action:@selector(minusClickedCollectionView:) forControlEvents:UIControlEventTouchUpInside];
    
    if(isFiltered)
    {
        cell.lblCatItemName.text = [[filteredProducts valueForKey:@"productName"] objectAtIndex:indexPath.row];
        cell.lblPrice.text = [NSString stringWithFormat:@"£%@",[[filteredProducts valueForKey:@"price"] objectAtIndex:indexPath.row]];
    }
    else
    {
        cell.lblCatItemName.text = [[arrProductsItems valueForKey:@"productName"] objectAtIndex:indexPath.row];
        cell.lblPrice.text = [NSString stringWithFormat:@"£%@",[[arrProductsItems valueForKey:@"price"] objectAtIndex:indexPath.row]];
        
    }
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (lastContentOffset > scrollView.contentOffset.y)
    {
        _viewBottom.hidden = YES;
        NSLog(@"Scrolling Up");
    }
    else if (lastContentOffset < scrollView.contentOffset.y)
    {
        NSLog(@"%f",lastContentOffset - scrollView.contentOffset.y);
        if(scrollView.contentOffset.y <= 20)
        {
            _viewBottom.hidden = YES;
        }
        else
        {
            _viewBottom.hidden = NO;
        }
        NSLog(@"Scrolling Down");
    }
    
    lastContentOffset = scrollView.contentOffset.y;
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isFiltered)
    {
        return filteredProducts.count;
    }
    else
    {
        return arrProductsItems.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ItemCell *cell = (ItemCell*)[tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.btnPlus.tag = indexPath.row;
    cell.btnMinus.tag = indexPath.row;
    cell.btnAdd.tag = indexPath.row;
    cell.btnModify.tag = indexPath.row;

    [cell.btnAdd addTarget:self action:@selector(addToCartClickedTableView:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnPlus addTarget:self action:@selector(plusClickedTableView:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnMinus addTarget:self action:@selector(minusClickedTableView:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.viewBack.layer setShadowColor:[UIColor grayColor].CGColor];
    [cell.viewBack.layer setShadowOpacity:0.8];
    [cell.viewBack.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    if(isFiltered)
    {
        cell.lblItemName.text = [[filteredProducts valueForKey:@"productName"] objectAtIndex:indexPath.row];
        cell.lblPrice.text = [NSString stringWithFormat:@"£%@",[[filteredProducts valueForKey:@"price"] objectAtIndex:indexPath.row]];
    }
    else
    {
        cell.lblItemName.text = [[arrProductsItems valueForKey:@"productName"] objectAtIndex:indexPath.row];
        cell.lblPrice.text = [NSString stringWithFormat:@"£%@",[[arrProductsItems valueForKey:@"price"] objectAtIndex:indexPath.row]];
        
    }
    return cell;
}

#pragma mark - SearchBar Delegate Methods

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [filteredProducts removeAllObjects];
    
    if(searchText.length > 0)
    {
        isFiltered = YES;
        //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [search] %@", self.searchBar.text];
        
        for(int i = 0; i < arrProductsItems.count; i++)
        {
            NSString *name = [[arrProductsItems valueForKey:@"productName"]objectAtIndex:i];
            
            if([name containsString:self.searchBar.text])
            {
                [filteredProducts addObject:arrProductsItems[i]];
            }
        }
        
    }
    else
    {
        isFiltered = NO;
        [filteredProducts removeAllObjects];
        [self.searchBar resignFirstResponder];
    }
    
    if(_tblItem.hidden)
    {
        [_collectionViewItem reloadData];
    }
    else
    {
        [_tblItem reloadData];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)SearchBar
{
    //SearchBar.showsCancelButton=YES;
    [SearchBar layoutIfNeeded];
    
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)theSearchBar
{
    [theSearchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)SearchBar
{
    @try
    {
        SearchBar.showsCancelButton=NO;
        [SearchBar resignFirstResponder];
        isFiltered = NO;
        if(_tblItem.hidden)
        {
            [_collectionViewItem reloadData];
        }
        else
        {
            [_tblItem reloadData];
        }
    }
    @catch (NSException *exception) {
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)SearchBar
{
    [SearchBar resignFirstResponder];
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

- (IBAction)plusClickedCollectionView:(UIButton *)sender
{
    NSIndexPath *changedRow = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    CategoryItemCell *cell = (CategoryItemCell *)[_collectionViewItem cellForItemAtIndexPath:changedRow];
    
    NSInteger val = [cell.lblQty.text integerValue];
    NSInteger newValue = val + 1;
    cell.lblQty.text = [NSString stringWithFormat:@"%ld",(long)newValue];
}

- (IBAction)plusClickedTableView:(UIButton *)sender
{
    NSIndexPath *changedRow = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    ItemCell *cell = (ItemCell *)[_tblItem cellForRowAtIndexPath:changedRow];
    
    NSInteger val = [cell.lblQty.text integerValue];
    NSInteger newValue = val + 1;
    cell.lblQty.text = [NSString stringWithFormat:@"%ld",(long)newValue];
    
}

- (IBAction)minusClickedCollectionView:(UIButton *)sender
{
    NSIndexPath *changedRow = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    CategoryItemCell *cell = (CategoryItemCell *)[_collectionViewItem cellForItemAtIndexPath:changedRow];
    
    NSInteger val = [cell.lblQty.text integerValue];
    if(val > 1)
    {
        NSInteger newValue = val - 1;
        cell.lblQty.text = [NSString stringWithFormat:@"%ld",(long)newValue];
    }
}

- (IBAction)minusClickedTableView:(UIButton *)sender
{
    NSIndexPath *changedRow = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    ItemCell *cell = (ItemCell *)[_tblItem cellForRowAtIndexPath:changedRow];
    
    NSInteger val = [cell.lblQty.text integerValue];
    if(val > 1)
    {
        NSInteger newValue = val - 1;
        cell.lblQty.text = [NSString stringWithFormat:@"%ld",(long)newValue];
    }
}

- (IBAction)addToCartClickedCollectionView:(UIButton *)sender
{
    NSIndexPath *changedRow = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    CategoryItemCell *cell = (CategoryItemCell *)[_collectionViewItem cellForItemAtIndexPath:changedRow];
    NSInteger qty = [cell.lblQty.text integerValue];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    if(isFiltered)
    {
        [dict setObject:[filteredProducts objectAtIndex:sender.tag] forKey:@"product"];
        [dict setObject:[NSNumber numberWithInteger:qty] forKey:@"Qty"];
        [cartArr addObject:dict];
    }
    else
    {
        [dict setObject:[arrProductsItems objectAtIndex:sender.tag] forKey:@"product"];
        [dict setObject:[NSNumber numberWithInteger:qty] forKey:@"Qty"];
        [cartArr addObject:dict];
    }
}

- (IBAction)addToCartClickedTableView:(UIButton *)sender
{
    NSIndexPath *changedRow = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    ItemCell *cell = (ItemCell *)[_tblItem cellForRowAtIndexPath:changedRow];
    NSInteger qty = [cell.lblQty.text integerValue];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    if(isFiltered)
    {
        [dict setObject:[filteredProducts objectAtIndex:sender.tag] forKey:@"product"];
        [dict setObject:[NSNumber numberWithInteger:qty] forKey:@"Qty"];
        [cartArr addObject:dict];
    }
    else
    {
        [dict setObject:[arrProductsItems objectAtIndex:sender.tag] forKey:@"product"];
        [dict setObject:[NSNumber numberWithInteger:qty] forKey:@"Qty"];
        [cartArr addObject:dict];
    }
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
