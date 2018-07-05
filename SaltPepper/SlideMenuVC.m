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
#import "ProductDetailVC.h"
#import "OptionView.h"

@interface SlideMenuVC ()<EHHorizontalSelectionViewProtocol>
{
    NSMutableArray *cartArr;
}
@end

@implementation SlideMenuVC
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (KmyappDelegate.MainCartArr.count == 0)
    {
        _lblCartCount.hidden = YES;
    }
    else
    {
        _lblCartCount.hidden = NO;
    }
    _lblCartCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)KmyappDelegate.MainCartArr.count];
    _lblCartCount.layer.cornerRadius = 10;
    _lblCartCount.layer.masksToBounds = YES;
    _lblCartCount.layer.borderColor = [UIColor whiteColor].CGColor;
    _lblCartCount.layer.borderWidth = 1;
      [self CalculationTotal];
    
}
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
    [_HSSelView selectIndex:_index];
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
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,PRODUCTCATEGORY];
    
    [Utility postRequest:json url:makeURL success:^(id responseObject)
    {
        
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
                arrProductsItems = [[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"products"]objectForKey:@"result"]objectForKey:@"products"] mutableCopy];
               
                for (int i=0; i<arrProductsItems.count; i++)
                {
                    NSLog(@"==%@",KmyappDelegate.MainFavArr);
                    
                    NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
                    intdic=[[arrProductsItems objectAtIndex:i] mutableCopy];
                    if (KmyappDelegate.MainFavArr!=nil)
                    {
                        if ([[KmyappDelegate.MainFavArr valueForKey:@"id"] containsObject:[[arrProductsItems valueForKey:@"id"]objectAtIndex:i]])
                        {
                            [intdic setObject:@"YES" forKey:@"Favorite"];
                        }
                        else
                        {
                            [intdic setObject:@"NO" forKey:@"Favorite"];
                        }
                    }
                    
                    
                    [intdic setObject:[NSNumber numberWithInt:1] forKey:@"Quantity"];
                    
                    [arrProductsItems replaceObjectAtIndex:i withObject:intdic];
                    
                }

                
                NSLog(@"%@",[[arrProductsItems valueForKey:@"allergy_image_path"] objectAtIndex:0]);
                if([[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"products"] objectForKey:@"result"] objectForKey:@"containImg"] == [NSNull null] || [[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"products"] objectForKey:@"result"] objectForKey:@"containImg"]isEqualToString:@""])
                {
                    _tblItem.hidden = NO;
                    _collectionViewItem.hidden = YES;
                    [_tblItem reloadData];
                }
                else
                {
                    BOOL ImageFag=[[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"products"] objectForKey:@"result"] objectForKey:@"containImg"] boolValue];
                    
                    if(ImageFag)
                    {
                        _tblItem.hidden = YES;
                        _collectionViewItem.hidden = NO;
                        [_collectionViewItem reloadData];
                    }
                    else
                    {
                        _tblItem.hidden = NO;
                        _collectionViewItem.hidden = YES;
                        [_tblItem reloadData];
                    }
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
    cell.btnFav.tag = indexPath.row;
    cell.btnModify.tag = indexPath.row;
    
    [cell.btnAdd addTarget:self action:@selector(addToCartClickedCollectionView:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnFav addTarget:self action:@selector(addToFavClickedCollectionView:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnPlus addTarget:self action:@selector(plusClickedCollectionView:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnMinus addTarget:self action:@selector(minusClickedCollectionView:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnModify addTarget:self action:@selector(ModifyClickedCollectionView:) forControlEvents:UIControlEventTouchUpInside];
    
    //Favorite
    if ([[[arrProductsItems objectAtIndex:indexPath.row] valueForKey:@"Favorite"] isEqualToString:@"YES"])
    {
        [cell.btnFav setImage:[UIImage imageNamed:@"RedHeart"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.btnFav setImage:[UIImage imageNamed:@"BlackHeart"] forState:UIControlStateNormal];
    }
    
    cell.lblQty.text=[NSString stringWithFormat:@"%@",[[arrProductsItems objectAtIndex:indexPath.row] valueForKey:@"Quantity"]];

//    NSString *urlToDownload = [NSString stringWithFormat:@"%@temp/uploads/images/allergyImages/chicken.png" ,BASE_PROFILE_IMAGE_URL];
//    if ([urlToDownload isEqualToString:@""])
//    {
//        cell.imgCategoryItem.image = [UIImage imageNamed:@""];
//    }
//    else
//    {
//        dispatch_async(dispatch_get_main_queue(),
//                       ^{
//                           dispatch_async(dispatch_get_main_queue(), ^{
//                               [cell.imgCategoryItem sd_setImageWithURL:[NSURL URLWithString:urlToDownload] placeholderImage:[UIImage imageNamed:@""]];
//                               //[cell.imgVegNonVeg setShowActivityIndicatorView:YES];
//                           });
//
//                       });
//    }
    
    if(isFiltered)
    {
        NSString *urlToDownload = [NSString stringWithFormat:@"%@%@" ,BASE_PROFILE_IMAGE_URL,[[filteredProducts objectAtIndex:indexPath.row] valueForKey:@"allergy_image_path"]];
        if([[[filteredProducts valueForKey:@"ingredients"] objectAtIndex:indexPath.row] count] == 0)
        {
            cell.btnModify.hidden = YES;
        }
        else
        {
            cell.btnModify.hidden = NO;
        }
        
        if ([urlToDownload isEqualToString:@""])
        {
            cell.imgVegNonVeg.image = [UIImage imageNamed:@""];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [cell.imgVegNonVeg sd_setImageWithURL:[NSURL URLWithString:urlToDownload] placeholderImage:[UIImage imageNamed:@""]];
                                   //[cell.imgVegNonVeg setShowActivityIndicatorView:YES];
                               });
                               
                           });
        }
        cell.lblCatItemName.text = [[filteredProducts valueForKey:@"productName"] objectAtIndex:indexPath.row];
        cell.lblPrice.text = [NSString stringWithFormat:@"£%@",[[filteredProducts valueForKey:@"price"] objectAtIndex:indexPath.row]];
    }
    else
    {
        NSString *urlToDownload = [NSString stringWithFormat:@"%@%@" ,BASE_PROFILE_IMAGE_URL,[[arrProductsItems objectAtIndex:indexPath.row] valueForKey:@"allergy_image_path"]];
        
        if([[[arrProductsItems valueForKey:@"ingredients"] objectAtIndex:indexPath.row] count] == 0)
        {
            cell.btnModify.hidden = YES;
        }
        else
        {
            cell.btnModify.hidden = NO;
        }
        
        if ([urlToDownload isEqualToString:@""])
        {
            cell.imgVegNonVeg.image = [UIImage imageNamed:@""];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [cell.imgVegNonVeg sd_setImageWithURL:[NSURL URLWithString:urlToDownload] placeholderImage:[UIImage imageNamed:@""]];
                                   //[cell.imgVegNonVeg setShowActivityIndicatorView:YES];
                               });
                               
                           });
        }
        cell.lblCatItemName.text = [[arrProductsItems valueForKey:@"productName"] objectAtIndex:indexPath.row];
        cell.lblPrice.text = [NSString stringWithFormat:@"£%@",[[arrProductsItems valueForKey:@"price"] objectAtIndex:indexPath.row]];
        
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ProductDetailVC *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductDetailVC"];
    mainVC.productDetail = [[NSMutableDictionary alloc]init];
    if(isFiltered)
    {
        mainVC.productDetail = [filteredProducts objectAtIndex:indexPath.row];
    }
    else
    {
        mainVC.productDetail = [arrProductsItems objectAtIndex:indexPath.row];
    }
        
    [self.navigationController pushViewController:mainVC animated:YES];
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
    if([[SharedClass sharedSingleton].storyBaordName isEqualToString:@"Main"])
    {
        return CGSizeMake((width/2) - 8,250);
    }
    else
    {
        return CGSizeMake(collectionView.frame.size.width / 3 - 20,250);
    }
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
    if([[SharedClass sharedSingleton].storyBaordName isEqualToString:@"Main"])
    {
        return 90;
    }
    else
    {
        return 110;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"ItemCell";
    ItemCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    //ItemCell *cell = (ItemCell*)[tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
    cell.btnPlus.tag = indexPath.row;
    cell.btnMinus.tag = indexPath.row;
    cell.btnAdd.tag = indexPath.row;
    cell.btnModify.tag = indexPath.row;
    cell.btnFav.tag = indexPath.row;

    if ([[[arrProductsItems objectAtIndex:indexPath.row] valueForKey:@"Favorite"] isEqualToString:@"YES"])
    {
        [cell.btnFav setImage:[UIImage imageNamed:@"RedHeart"] forState:UIControlStateNormal];
    }
    else
    {
        [cell.btnFav setImage:[UIImage imageNamed:@"BlackHeart"] forState:UIControlStateNormal];
    }
    [cell.btnFav addTarget:self action:@selector(addToFavClickedTableView:) forControlEvents:UIControlEventTouchUpInside];

    [cell.btnAdd addTarget:self action:@selector(addToCartClickedTableView:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnPlus addTarget:self action:@selector(plusClickedTableView:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnMinus addTarget:self action:@selector(minusClickedTableView:) forControlEvents:UIControlEventTouchUpInside];
    [cell.btnModify addTarget:self action:@selector(ModifyClickedTableView:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell.viewBack.layer setShadowColor:[UIColor grayColor].CGColor];
    [cell.viewBack.layer setShadowOpacity:0.8];
    [cell.viewBack.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    cell.lblQty.text=[NSString stringWithFormat:@"%@",[[arrProductsItems objectAtIndex:indexPath.row] valueForKey:@"Quantity"]];
    
 
    if(isFiltered)
    {
        NSString *urlToDownload = [NSString stringWithFormat:@"%@%@" ,BASE_PROFILE_IMAGE_URL,[[filteredProducts objectAtIndex:indexPath.row] valueForKey:@"allergy_image_path"]];
        
        if([[[filteredProducts valueForKey:@"ingredients"] objectAtIndex:indexPath.row] count] == 0)
        {
            cell.btnModify.hidden = YES;
        }
        else
        {
            cell.btnModify.hidden = NO;
        }
        
        if ([urlToDownload isEqualToString:@""])
        {
            cell.imgIcon.image = [UIImage imageNamed:@""];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [cell.imgIcon sd_setImageWithURL:[NSURL URLWithString:urlToDownload] placeholderImage:[UIImage imageNamed:@""]];
                                   //[cell.imgVegNonVeg setShowActivityIndicatorView:YES];
                               });
                               
                           });
        }
        cell.lblItemName.text = [[filteredProducts valueForKey:@"productName"] objectAtIndex:indexPath.row];
        cell.lblPrice.text = [NSString stringWithFormat:@"£%@",[[filteredProducts valueForKey:@"price"] objectAtIndex:indexPath.row]];
    }
    else
    {
        NSString *urlToDownload = [NSString stringWithFormat:@"%@%@" ,BASE_PROFILE_IMAGE_URL,[[arrProductsItems objectAtIndex:indexPath.row] valueForKey:@"allergy_image_path"]];
        NSLog(@"%@",[[arrProductsItems valueForKey:@"ingredients"] objectAtIndex:indexPath.row]);
        
        if([[[arrProductsItems valueForKey:@"ingredients"] objectAtIndex:indexPath.row] count] == 0)
        {
            cell.btnModify.hidden = YES;
        }
        else
        {
            cell.btnModify.hidden = NO;
        }
        
        if ([urlToDownload isEqualToString:@""])
        {
            cell.imgIcon.image = [UIImage imageNamed:@""];
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               dispatch_async(dispatch_get_main_queue(), ^{
                                   [cell.imgIcon sd_setImageWithURL:[NSURL URLWithString:urlToDownload] placeholderImage:[UIImage imageNamed:@""]];
                                   //[cell.imgVegNonVeg setShowActivityIndicatorView:YES];
                               });
                               
                           });
        }
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

- (void)plusClickedCollectionView:(UIButton *)sender
{
    NSIndexPath *changedRow = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    CategoryItemCell *cell = (CategoryItemCell *)[_collectionViewItem cellForItemAtIndexPath:changedRow];
    
    int val = [cell.lblQty.text intValue];
    int newValue = val + 1;
    cell.lblQty.text = [NSString stringWithFormat:@"%ld",(long)newValue];
    
    if(isFiltered)
    {
        NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
        intdic=[[filteredProducts objectAtIndex:changedRow.row] mutableCopy];
        [intdic setObject:[NSNumber numberWithInt:newValue] forKey:@"Quantity"];
        
        [filteredProducts replaceObjectAtIndex:changedRow.row withObject:intdic];
    }
    else
    {
        NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
        intdic=[[arrProductsItems objectAtIndex:changedRow.row] mutableCopy];
        [intdic setObject:[NSNumber numberWithInt:newValue] forKey:@"Quantity"];
        
        [arrProductsItems replaceObjectAtIndex:changedRow.row withObject:intdic];
    }
    
}

- (void)plusClickedTableView:(UIButton *)sender
{
    NSIndexPath *changedRow = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    ItemCell *cell = (ItemCell *)[_tblItem cellForRowAtIndexPath:changedRow];
    
    int val = [cell.lblQty.text intValue];
    int newValue = val + 1;
    cell.lblQty.text = [NSString stringWithFormat:@"%ld",(long)newValue];
    
    if(isFiltered)
    {
        NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
        intdic=[[filteredProducts objectAtIndex:changedRow.row] mutableCopy];
        [intdic setObject:[NSNumber numberWithInt:newValue] forKey:@"Quantity"];
        
        [filteredProducts replaceObjectAtIndex:changedRow.row withObject:intdic];
    }
    else
    {
        NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
        intdic=[[arrProductsItems objectAtIndex:changedRow.row] mutableCopy];
        [intdic setObject:[NSNumber numberWithInt:newValue] forKey:@"Quantity"];
        
        [arrProductsItems replaceObjectAtIndex:changedRow.row withObject:intdic];
    }
    
    
}

- (void)minusClickedCollectionView:(UIButton *)sender
{
    NSIndexPath *changedRow = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    CategoryItemCell *cell = (CategoryItemCell *)[_collectionViewItem cellForItemAtIndexPath:changedRow];
    
    int val = [cell.lblQty.text intValue];
    if(val > 1)
    {
        int newValue = val - 1;
        cell.lblQty.text = [NSString stringWithFormat:@"%ld",(long)newValue];
        
        if(isFiltered)
        {
            NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
            intdic=[[filteredProducts objectAtIndex:changedRow.row] mutableCopy];
            [intdic setObject:[NSNumber numberWithInt:newValue] forKey:@"Quantity"];
            
            [filteredProducts replaceObjectAtIndex:changedRow.row withObject:intdic];
        }
        else
        {
            NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
            intdic=[[arrProductsItems objectAtIndex:changedRow.row] mutableCopy];
            [intdic setObject:[NSNumber numberWithInt:newValue] forKey:@"Quantity"];
            
            [arrProductsItems replaceObjectAtIndex:changedRow.row withObject:intdic];
        }
        
        
    }
}

- (void)minusClickedTableView:(UIButton *)sender
{
    NSIndexPath *changedRow = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    ItemCell *cell = (ItemCell *)[_tblItem cellForRowAtIndexPath:changedRow];
    
    int val = [cell.lblQty.text intValue];
    if(val > 1)
    {
        int newValue = val - 1;
        cell.lblQty.text = [NSString stringWithFormat:@"%ld",(long)newValue];
        
        if(isFiltered)
        {
            NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
            intdic=[[filteredProducts objectAtIndex:changedRow.row] mutableCopy];
            [intdic setObject:[NSNumber numberWithInt:newValue] forKey:@"Quantity"];
            
            [filteredProducts replaceObjectAtIndex:changedRow.row withObject:intdic];
        }
        else
        {
            NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
            intdic=[[arrProductsItems objectAtIndex:changedRow.row] mutableCopy];
            [intdic setObject:[NSNumber numberWithInt:newValue] forKey:@"Quantity"];
            
            [arrProductsItems replaceObjectAtIndex:changedRow.row withObject:intdic];
        }
    }
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

#pragma mark - Modify Click Action

-(void)ModifyClickedCollectionView:(UIButton *)sender
{
    NSIndexPath *changedRow = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSDictionary *PassDic=[[NSDictionary alloc]init];
    if(isFiltered)
    {
        PassDic=[[filteredProducts objectAtIndex:changedRow.row]mutableCopy];
    }
    else
    {
        PassDic=[[arrProductsItems objectAtIndex:changedRow.row]mutableCopy];
    }
    OptionView *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OptionView"];
    mainVC.ModifyDic=[[NSMutableDictionary alloc]initWithDictionary:PassDic];
    [self.navigationController pushViewController:mainVC animated:YES];

}
-(void)ModifyClickedTableView:(UIButton *)sender
{
    NSIndexPath *changedRow = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    NSDictionary *PassDic=[[NSDictionary alloc]init];
    if(isFiltered)
    {
        PassDic=[[filteredProducts objectAtIndex:changedRow.row]mutableCopy];
    }
    else
    {
        PassDic=[[arrProductsItems objectAtIndex:changedRow.row]mutableCopy];
    }
    OptionView *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OptionView"];
    mainVC.ModifyDic=[[NSMutableDictionary alloc]initWithDictionary:PassDic];
    [self.navigationController pushViewController:mainVC animated:YES];
}


#pragma mark - ADD TO CART Click Action

- (void)addToCartClickedTableView:(UIButton *)sender
{
    if (_ro(@"LoginUserDic") != nil)
    {
        NSIndexPath *changedRow = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        if(isFiltered)
        {
            if (KmyappDelegate.MainCartArr==nil)
            {
                KmyappDelegate.MainCartArr=[[NSMutableArray alloc]init];
                
                if([[filteredProducts objectAtIndex:changedRow.row] valueForKey:@"ingredients"] != nil)
                {
                    NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
                    intdic=[[filteredProducts objectAtIndex:changedRow.row] mutableCopy];
                    [intdic removeObjectForKey:@"ingredients"];
                    
                    [KmyappDelegate.MainCartArr addObject:intdic];
                }
                else
                {
                    [KmyappDelegate.MainCartArr addObject:[filteredProducts objectAtIndex:changedRow.row]];
                }
            }
            else
            {
                if ([[KmyappDelegate.MainCartArr valueForKey:@"id"] containsObject:[[filteredProducts valueForKey:@"id"]objectAtIndex:changedRow.row]])
                {
                    NSLog(@"Already Added");
                    NSMutableArray *IdArr=[KmyappDelegate.MainCartArr valueForKey:@"id"];
                    NSInteger idx=[IdArr indexOfObject:[[filteredProducts valueForKey:@"id"]objectAtIndex:changedRow.row]];
                    
                    NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
                    intdic=[[KmyappDelegate.MainCartArr objectAtIndex:idx] mutableCopy];
                    int qnt=[[intdic valueForKey:@"Quantity"] intValue];
                    qnt=qnt + 1;
                    [intdic setObject:[NSNumber numberWithInt:qnt] forKey:@"Quantity"];
                    
                    if([intdic valueForKey:@"ingredients"] != nil)
                    {
                        [intdic removeObjectForKey:@"ingredients"];
                        [KmyappDelegate.MainCartArr replaceObjectAtIndex:idx withObject:intdic];
                    }
                    else
                    {
                        [KmyappDelegate.MainCartArr replaceObjectAtIndex:idx withObject:intdic];
                    }
                }
                else
                {
                    if([[filteredProducts objectAtIndex:changedRow.row] valueForKey:@"ingredients"] != nil)
                    {
                        NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
                        intdic=[[filteredProducts objectAtIndex:changedRow.row] mutableCopy];
                        [intdic removeObjectForKey:@"ingredients"];
                        
                        [KmyappDelegate.MainCartArr addObject:intdic];
                    }
                    else
                    {
                        [KmyappDelegate.MainCartArr addObject:[filteredProducts objectAtIndex:changedRow.row]];
                    }
                    
                    //[KmyappDelegate.MainCartArr addObject:[filteredProducts objectAtIndex:changedRow.row]];
                }
            }
            NSLog(@"==%@",KmyappDelegate.MainCartArr);
        }
        else
        {
            if (KmyappDelegate.MainCartArr==nil)
            {
                KmyappDelegate.MainCartArr=[[NSMutableArray alloc]init];
                if([[arrProductsItems objectAtIndex:changedRow.row] valueForKey:@"ingredients"] != nil)
                {
                    NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
                    intdic=[[arrProductsItems objectAtIndex:changedRow.row] mutableCopy];
                    [intdic removeObjectForKey:@"ingredients"];
                    
                    [KmyappDelegate.MainCartArr addObject:intdic];
                }
                else
                {
                    [KmyappDelegate.MainCartArr addObject:[arrProductsItems objectAtIndex:changedRow.row]];
                }
                //[KmyappDelegate.MainCartArr addObject:[arrProductsItems objectAtIndex:changedRow.row]];
            }
            else
            {
                if ([[KmyappDelegate.MainCartArr valueForKey:@"id"] containsObject:[[arrProductsItems valueForKey:@"id"]objectAtIndex:changedRow.row]])
                {
                    NSLog(@"Already Added");
                    NSMutableArray *IdArr=[KmyappDelegate.MainCartArr valueForKey:@"id"];
                    NSInteger idx=[IdArr indexOfObject:[[arrProductsItems valueForKey:@"id"]objectAtIndex:changedRow.row]];
                    
                    NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
                    intdic=[[KmyappDelegate.MainCartArr objectAtIndex:idx] mutableCopy];
                    int qnt=[[intdic valueForKey:@"Quantity"] intValue];
                    qnt=qnt + 1;
                    [intdic setObject:[NSNumber numberWithInt:qnt] forKey:@"Quantity"];
                    
                    if([intdic valueForKey:@"ingredients"] != nil)
                    {
                        [intdic removeObjectForKey:@"ingredients"];
                        [KmyappDelegate.MainCartArr replaceObjectAtIndex:idx withObject:intdic];
                    }
                    else
                    {
                        [KmyappDelegate.MainCartArr replaceObjectAtIndex:idx withObject:intdic];
                    }
                    
                    //[KmyappDelegate.MainCartArr replaceObjectAtIndex:idx withObject:intdic];
                }
                else
                {
                    if([[arrProductsItems objectAtIndex:changedRow.row] valueForKey:@"ingredients"] != nil)
                    {
                        NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
                        intdic=[[arrProductsItems objectAtIndex:changedRow.row] mutableCopy];
                        [intdic removeObjectForKey:@"ingredients"];
                        
                        [KmyappDelegate.MainCartArr addObject:intdic];
                    }
                    else
                    {
                        [KmyappDelegate.MainCartArr addObject:[arrProductsItems objectAtIndex:changedRow.row]];
                    }
                    
                    //[KmyappDelegate.MainCartArr addObject:[arrProductsItems objectAtIndex:changedRow.row]];
                }
            }
            NSLog(@"==%@",KmyappDelegate.MainCartArr);
        }
        [AppDelegate WriteData:@"CartDIC" RootObject:KmyappDelegate.MainCartArr];
        [self CalculationTotal];
        
        FCAlertView *alert = [KmyappDelegate ShowAlertWithBtnAction:@"Item added to cart successfully" andStrTile:nil andbtnTitle:@"OK" andButtonArray:@[]];
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
    if (KmyappDelegate.MainCartArr.count == 0)
    {
        _lblCartCount.hidden = YES;
    }
    else
    {
        _lblCartCount.hidden = NO;
    }
    _lblCartCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)KmyappDelegate.MainCartArr.count];
}

- (void)addToCartClickedCollectionView:(UIButton *)sender
{
    if (_ro(@"LoginUserDic") != nil)
    {
        NSIndexPath *changedRow = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        
        if(isFiltered)
        {
            if (KmyappDelegate.MainCartArr==nil)
            {
                KmyappDelegate.MainCartArr=[[NSMutableArray alloc]init];
                
                if([[filteredProducts objectAtIndex:changedRow.row] valueForKey:@"ingredients"] != nil)
                {
                    NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
                    intdic=[[filteredProducts objectAtIndex:changedRow.row] mutableCopy];
                    [intdic removeObjectForKey:@"ingredients"];
                    
                    [KmyappDelegate.MainCartArr addObject:intdic];
                }
                else
                {
                    [KmyappDelegate.MainCartArr addObject:[filteredProducts objectAtIndex:changedRow.row]];
                }
                
                //[KmyappDelegate.MainCartArr addObject:[filteredProducts objectAtIndex:changedRow.row]];
            }
            else
            {
                if ([[KmyappDelegate.MainCartArr valueForKey:@"id"] containsObject:[[filteredProducts valueForKey:@"id"]objectAtIndex:changedRow.row]])
                {
                    NSLog(@"Already Added");
                    NSMutableArray *IdArr=[KmyappDelegate.MainCartArr valueForKey:@"id"];
                    NSInteger idx=[IdArr indexOfObject:[[filteredProducts valueForKey:@"id"]objectAtIndex:changedRow.row]];
                    
                    NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
                    intdic=[[KmyappDelegate.MainCartArr objectAtIndex:idx] mutableCopy];
                    int qnt=[[intdic valueForKey:@"Quantity"] intValue];
                    qnt=qnt + 1;
                    [intdic setObject:[NSNumber numberWithInt:qnt] forKey:@"Quantity"];
                    
                    if([intdic valueForKey:@"ingredients"] != nil)
                    {
                        [intdic removeObjectForKey:@"ingredients"];
                        [KmyappDelegate.MainCartArr replaceObjectAtIndex:idx withObject:intdic];
                    }
                    else
                    {
                        [KmyappDelegate.MainCartArr replaceObjectAtIndex:idx withObject:intdic];
                    }
                    //                [KmyappDelegate.MainCartArr replaceObjectAtIndex:idx withObject:intdic];
                }
                else
                {
                    if([[filteredProducts objectAtIndex:changedRow.row] valueForKey:@"ingredients"] != nil)
                    {
                        NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
                        intdic=[[filteredProducts objectAtIndex:changedRow.row] mutableCopy];
                        [intdic removeObjectForKey:@"ingredients"];
                        
                        [KmyappDelegate.MainCartArr addObject:intdic];
                    }
                    else
                    {
                        [KmyappDelegate.MainCartArr addObject:[filteredProducts objectAtIndex:changedRow.row]];
                    }
                    //[KmyappDelegate.MainCartArr addObject:[filteredProducts objectAtIndex:changedRow.row]];
                }
            }
            NSLog(@"==%@",KmyappDelegate.MainCartArr);
        }
        else
        {
            if (KmyappDelegate.MainCartArr==nil)
            {
                KmyappDelegate.MainCartArr=[[NSMutableArray alloc]init];
                if([[arrProductsItems objectAtIndex:changedRow.row] valueForKey:@"ingredients"] != nil)
                {
                    NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
                    intdic=[[arrProductsItems objectAtIndex:changedRow.row] mutableCopy];
                    [intdic removeObjectForKey:@"ingredients"];
                    
                    [KmyappDelegate.MainCartArr addObject:intdic];
                }
                else
                {
                    [KmyappDelegate.MainCartArr addObject:[arrProductsItems objectAtIndex:changedRow.row]];
                }
                //[KmyappDelegate.MainCartArr addObject:[arrProductsItems objectAtIndex:changedRow.row]];
            }
            else
            {
                if ([[KmyappDelegate.MainCartArr valueForKey:@"id"] containsObject:[[arrProductsItems valueForKey:@"id"]objectAtIndex:changedRow.row]])
                {
                    NSLog(@"Already Added");
                    NSMutableArray *IdArr=[KmyappDelegate.MainCartArr valueForKey:@"id"];
                    NSInteger idx=[IdArr indexOfObject:[[arrProductsItems valueForKey:@"id"]objectAtIndex:changedRow.row]];
                    
                    NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
                    intdic=[[KmyappDelegate.MainCartArr objectAtIndex:idx] mutableCopy];
                    int qnt=[[intdic valueForKey:@"Quantity"] intValue];
                    qnt=qnt + 1;
                    [intdic setObject:[NSNumber numberWithInt:qnt] forKey:@"Quantity"];
                    
                    if([intdic valueForKey:@"ingredients"] != nil)
                    {
                        [intdic removeObjectForKey:@"ingredients"];
                        [KmyappDelegate.MainCartArr replaceObjectAtIndex:idx withObject:intdic];
                    }
                    else
                    {
                        [KmyappDelegate.MainCartArr replaceObjectAtIndex:idx withObject:intdic];
                    }
                    
                    //[KmyappDelegate.MainCartArr replaceObjectAtIndex:idx withObject:intdic];
                }
                else
                {
                    if([[arrProductsItems objectAtIndex:changedRow.row] valueForKey:@"ingredients"] != nil)
                    {
                        NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
                        intdic=[[arrProductsItems objectAtIndex:changedRow.row] mutableCopy];
                        [intdic removeObjectForKey:@"ingredients"];
                        
                        [KmyappDelegate.MainCartArr addObject:intdic];
                    }
                    else
                    {
                        [KmyappDelegate.MainCartArr addObject:[arrProductsItems objectAtIndex:changedRow.row]];
                    }
                    //[KmyappDelegate.MainCartArr addObject:[arrProductsItems objectAtIndex:changedRow.row]];
                }
            }
            NSLog(@"==%@",KmyappDelegate.MainCartArr);
        }
        [AppDelegate WriteData:@"CartDIC" RootObject:KmyappDelegate.MainCartArr];
        [self CalculationTotal];
        
        FCAlertView *alert = [KmyappDelegate ShowAlertWithBtnAction:@"Item added to cart successfully" andStrTile:nil andbtnTitle:@"OK" andButtonArray:@[]];
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
    if (KmyappDelegate.MainCartArr.count == 0)
    {
        _lblCartCount.hidden = YES;
    }
    else
    {
        _lblCartCount.hidden = NO;
    }
    _lblCartCount.text = [NSString stringWithFormat:@"%lu",(unsigned long)KmyappDelegate.MainCartArr.count];
    
}

#pragma mark - ADD TO FAVORITE Click Action

- (void)addToFavClickedTableView:(UIButton *)sender
{
    if (_ro(@"LoginUserDic") != nil)
    {
        NSIndexPath *changedRow = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        ItemCell *cell = (ItemCell *)[_tblItem cellForRowAtIndexPath:changedRow];
        [cell.btnFav setImage:[UIImage imageNamed:@"RedHeart"] forState:UIControlStateNormal];
        
        if(isFiltered)
        {
            if (KmyappDelegate.MainFavArr==nil)
            {
                KmyappDelegate.MainFavArr=[[NSMutableArray alloc]init];
                [KmyappDelegate.MainFavArr addObject:[filteredProducts objectAtIndex:changedRow.row]];
            }
            else
            {
                if ([[KmyappDelegate.MainFavArr valueForKey:@"id"] containsObject:[[filteredProducts valueForKey:@"id"]objectAtIndex:changedRow.row]])
                {
                    NSLog(@"Already Added");
                }
                else
                {
                    [KmyappDelegate.MainFavArr addObject:[filteredProducts objectAtIndex:changedRow.row]];
                }
            }
            NSLog(@"==%@",KmyappDelegate.MainFavArr);
            //_wo(@"FavDIC", KmyappDelegate.MainFavArr);
        }
        else
        {
            if (KmyappDelegate.MainFavArr==nil)
            {
                KmyappDelegate.MainFavArr=[[NSMutableArray alloc]init];
                [KmyappDelegate.MainFavArr addObject:[arrProductsItems objectAtIndex:changedRow.row]];
            }
            else
            {
                if ([[KmyappDelegate.MainFavArr valueForKey:@"id"] containsObject:[[arrProductsItems valueForKey:@"id"]objectAtIndex:changedRow.row]])
                {
                    NSLog(@"Already Added");
                }
                else
                {
                    [KmyappDelegate.MainFavArr addObject:[arrProductsItems objectAtIndex:changedRow.row]];
                }
            }
            NSLog(@"==%@",KmyappDelegate.MainFavArr);
            //_wo(@"FavDIC", KmyappDelegate.MainFavArr);
        }
        NSLog(@"==%@",KmyappDelegate.MainFavArr);
        [AppDelegate WriteData:@"FavDIC" RootObject:KmyappDelegate.MainFavArr];
        // _wo(@"FavDIC", dataSave);
        
        NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
        intdic=[[arrProductsItems objectAtIndex:changedRow.row] mutableCopy];
        if (KmyappDelegate.MainFavArr!=nil)
        {
            NSLog(@"%@",[[KmyappDelegate.MainFavArr objectAtIndex:KmyappDelegate.MainFavArr.count-1] valueForKey:@"id"]);
            if ([[[KmyappDelegate.MainFavArr objectAtIndex:KmyappDelegate.MainFavArr.count-1] valueForKey:@"id"] integerValue]==[[intdic valueForKey:@"id"]integerValue])
            {
                [intdic setObject:@"YES" forKey:@"Favorite"];
                [arrProductsItems replaceObjectAtIndex:changedRow.row withObject:intdic];
            }
            
        }
        [_tblItem reloadData];
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

- (void)addToFavClickedCollectionView:(UIButton *)sender
{
    if (_ro(@"LoginUserDic") != nil)
    {
        NSIndexPath *changedRow = [NSIndexPath indexPathForRow:sender.tag inSection:0];
        CategoryItemCell *cell = (CategoryItemCell *)[_collectionViewItem cellForItemAtIndexPath:changedRow];
        [cell.btnFav setImage:[UIImage imageNamed:@"RedHeart"] forState:UIControlStateNormal];
        
        if(isFiltered)
        {
            if (KmyappDelegate.MainFavArr==nil)
            {
                KmyappDelegate.MainFavArr=[[NSMutableArray alloc]init];
                [KmyappDelegate.MainFavArr addObject:[filteredProducts objectAtIndex:changedRow.row]];
            }
            else
            {
                if ([[KmyappDelegate.MainFavArr valueForKey:@"id"] containsObject:[[filteredProducts valueForKey:@"id"]objectAtIndex:changedRow.row]])
                {
                    NSLog(@"Already Added");
                }
                else
                {
                    [KmyappDelegate.MainFavArr addObject:[filteredProducts objectAtIndex:changedRow.row]];
                }
            }
            NSLog(@"MainFavArr==%@",KmyappDelegate.MainFavArr);
        }
        else
        {
            if (KmyappDelegate.MainFavArr==nil)
            {
                KmyappDelegate.MainFavArr=[[NSMutableArray alloc]init];
                [KmyappDelegate.MainFavArr addObject:[arrProductsItems objectAtIndex:changedRow.row]];
            }
            else
            {
                if ([[KmyappDelegate.MainFavArr valueForKey:@"id"] containsObject:[[arrProductsItems valueForKey:@"id"]objectAtIndex:changedRow.row]])
                {
                    NSLog(@"Already Added");
                }
                else
                {
                    [KmyappDelegate.MainFavArr addObject:[arrProductsItems objectAtIndex:changedRow.row]];
                }
            }
            NSLog(@"MainFavArr==%@",KmyappDelegate.MainFavArr);
        }
        [AppDelegate WriteData:@"FavDIC" RootObject:KmyappDelegate.MainFavArr];
        
        NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
        intdic=[[arrProductsItems objectAtIndex:changedRow.row] mutableCopy];
        if (KmyappDelegate.MainFavArr!=nil)
        {
            NSLog(@"%@",[[KmyappDelegate.MainFavArr objectAtIndex:KmyappDelegate.MainFavArr.count-1] valueForKey:@"id"]);
            if ([[[KmyappDelegate.MainFavArr objectAtIndex:KmyappDelegate.MainFavArr.count-1] valueForKey:@"id"] integerValue]==[[intdic valueForKey:@"id"]integerValue])
            {
                [intdic setObject:@"YES" forKey:@"Favorite"];
                [arrProductsItems replaceObjectAtIndex:changedRow.row withObject:intdic];
            }
            
        }
        [_collectionViewItem reloadData];
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
    
    //[[NSUserDefaults standardUserDefaults] setObject:tempArry forKey:@"FavDIC"];
    //_wo(@"FavDIC",KmyappDelegate.MainFavArr);
}
-(void)CalculationTotal
{
    KmyappDelegate.MainCartArr = [AppDelegate GetData:@"CartDIC"];

    float subTotalINT=0;
   NSInteger QTYINT=0;
    float integratPRICE=0.00;
    for (int rr=0; rr<KmyappDelegate.MainCartArr.count; rr++)
    {
        subTotalINT=subTotalINT+[[[KmyappDelegate.MainCartArr valueForKey:@"price"] objectAtIndex:rr] floatValue]*[[[KmyappDelegate.MainCartArr valueForKey:@"Quantity"] objectAtIndex:rr] integerValue];
        QTYINT=QTYINT+[[[KmyappDelegate.MainCartArr valueForKey:@"Quantity"] objectAtIndex:rr] integerValue];
      
        NSMutableArray *Array=[[[KmyappDelegate.MainCartArr objectAtIndex:rr] valueForKey:@"ingredients"] mutableCopy];
        for (int i=0; i<Array.count; i++)
        {
            if ([[[Array objectAtIndex:i] valueForKey:@"is_with"] boolValue]==0)
            {
                integratPRICE=integratPRICE+[[[Array objectAtIndex:i] valueForKey:@"price_without"] floatValue];
            }
            else
            {
                integratPRICE=integratPRICE+[[[Array objectAtIndex:i] valueForKey:@"price"] floatValue];
            }
        }
    }
    subTotalINT=subTotalINT+integratPRICE;
    if (subTotalINT>0)
    {
          _lblTotal.text=[NSString stringWithFormat:@"TOTAL :£%.2f",subTotalINT];
    }
    else
    {
          _lblTotal.text=@"TOTAL :£0.00";
    }
  
   
}

- (IBAction)btnViewCartClicked:(id)sender
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

- (IBAction)btnCheckoutClicked:(id)sender
{
    
}

@end
