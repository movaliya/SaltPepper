//
//  OrderHistoryVC.m
//  SaltPepper
//
//  Created by Dharmraj Vora on 02/06/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "OrderHistoryVC.h"
#import "OrderHistoryCell.h"

@interface OrderHistoryVC ()
{
    NSMutableDictionary *UserSaveData;
    NSMutableArray *arrOrderHistory;
}
@end

@implementation OrderHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    arrOrderHistory = [[NSMutableArray alloc]init];
    filteredResHistory = [[NSMutableArray alloc]init];
    _searchBar.hidden = YES;
    UserSaveData = [AppDelegate GetData:@"LoginUserDic"];
    [self CallOrderHistory];
    
    for (UIView *subview in [[self.searchBar.subviews lastObject] subviews]) {
        if ([subview isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [subview removeFromSuperview];
            break;
        }
    }
    
    UITextField *searchField = [self.searchBar valueForKey:@"searchField"];
    
    // To change background color
    [searchField setBackgroundColor:[UIColor clearColor]];
    //[searchField setBackground: [UIImage imageNamed:@"searchBG"]]; //set your gray background image here
    [searchField setBorderStyle:UITextBorderStyleNone];
    // To change text color
    searchField.textColor = [UIColor whiteColor];
    searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
    searchField.leftViewMode = UITextFieldViewModeNever;
    // To change placeholder text color
    UILabel *placeholderLabel = [searchField valueForKey:@"placeholderLabel"];
    placeholderLabel.textColor = [UIColor grayColor];
    placeholderLabel.text = @"Search by order id";
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)CallOrderHistory
{
    if (_ro(@"LoginUserDic") != nil)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *CoustmerID=[[[[[[UserSaveData objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
        
        
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
        
        [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
        
        
        NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
        
        [dictInner setObject:CoustmerID forKey:@"CUSTOMERID"];
        
        NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
        
        [dictSub setObject:@"getitem" forKey:@"MODULE"];
        
        [dictSub setObject:@"orderHistory" forKey:@"METHOD"];
        
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
        
        NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,ORDERHISTORY];
        
        [Utility postRequest:json url:makeURL success:^(id responseObject) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSLog(@"responseObject==%@",responseObject);
            NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"orderHistory"] objectForKey:@"SUCCESS"];
            if ([SUCCESS boolValue] ==YES)
            {
                arrOrderHistory = [[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"orderHistory"] objectForKey:@"result"]objectForKey:@"orderHistory"];
                [_tblHistory reloadData];
            }
            else
            {
                NSString *DESCRIPTION=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"postitem"] objectForKey:@"reservation"] objectForKey:@"ERROR"] objectForKey:@"DESCRIPTION"];
                [AppDelegate showErrorMessageWithTitle:@"" message:DESCRIPTION delegate:nil];
            }
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSLog(@"Fail");
        }];
        
    }
    else
    {
        
        [AppDelegate showErrorMessageWithTitle:@"" message:@"You are not Login." delegate:nil];
    }
}


#pragma mark - SearchBar Delegate Methods

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [filteredResHistory removeAllObjects];
    
    if(searchText.length > 0)
    {
        isFiltered = YES;
        //NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains [search] %@", self.searchBar.text];
        
        for(int i = 0; i < arrOrderHistory.count; i++)
        {
            NSString *id = [[arrOrderHistory valueForKey:@"order_id"]objectAtIndex:i];
            
            if([id containsString:self.searchBar.text])
            {
                [filteredResHistory addObject:arrOrderHistory[i]];
            }
        }
    }
    else
    {
        isFiltered = NO;
        [filteredResHistory removeAllObjects];
        [self.searchBar resignFirstResponder];
    }
    [_tblHistory reloadData];
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
        _lblHeader.hidden = NO;
        _btnCart.hidden = NO;
        _btnSearch.hidden = NO;
        _searchBar.hidden = YES;
        [_tblHistory reloadData];
    }
    @catch (NSException *exception) {
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)SearchBar
{
    [SearchBar resignFirstResponder];
}

#pragma mark - Tableview Delegate Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(isFiltered)
    {
        return filteredResHistory.count;
    }
    else
    {
        return arrOrderHistory.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 230;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderHistoryCell *cell = (OrderHistoryCell*)[tableView dequeueReusableCellWithIdentifier:@"OrderHistoryCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.viewBack.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.viewBack.layer.borderWidth = 0.5;
    [cell.viewBack.layer setShadowColor:[UIColor grayColor].CGColor];
    [cell.viewBack.layer setShadowOpacity:0.8];
    [cell.viewBack.layer setShadowRadius:3.0];
    [cell.viewBack.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    cell.btnTrack.layer.borderColor = [UIColor blackColor].CGColor;
    cell.btnTrack.layer.borderWidth = 1.0;
    cell.btnOnTheWay.layer.borderColor = [UIColor blackColor].CGColor;
    cell.btnOnTheWay.layer.borderWidth = 1.0;
    cell.btnTrack.layer.cornerRadius = 2.0;
    cell.btnOnTheWay.layer.cornerRadius = 2.0;
    if(isFiltered)
    {
        cell.lblOrderNo.text = [[filteredResHistory valueForKey:@"order_id"] objectAtIndex:indexPath.row];
        cell.lblOrderStatus.text = [[filteredResHistory valueForKey:@"status"] objectAtIndex:indexPath.row];
        cell.lblOrderAmount.text = [[filteredResHistory valueForKey:@"total"] objectAtIndex:indexPath.row];
        cell.lblOrderDate.text = [[filteredResHistory valueForKey:@"order_date"] objectAtIndex:indexPath.row];
        cell.lblComments.text = [[filteredResHistory valueForKey:@"comments"] objectAtIndex:indexPath.row];
    }
    else
    {
        cell.lblOrderNo.text = [[arrOrderHistory valueForKey:@"order_id"] objectAtIndex:indexPath.row];
        cell.lblOrderStatus.text = [[arrOrderHistory valueForKey:@"status"] objectAtIndex:indexPath.row];
        cell.lblOrderAmount.text = [[arrOrderHistory valueForKey:@"total"] objectAtIndex:indexPath.row];
        cell.lblOrderDate.text = [[arrOrderHistory valueForKey:@"order_date"] objectAtIndex:indexPath.row];
        cell.lblComments.text = [[arrOrderHistory valueForKey:@"comments"] objectAtIndex:indexPath.row];
    }
    return cell;
    
}

#pragma mark - Button Click Action

- (IBAction)btnBack:(id)sender
{
    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"]]
                                                 animated:YES];
    [self.sideMenuViewController hideMenuViewController];
}

- (IBAction)btnFavClicked:(id)sender
{
    _lblHeader.hidden = YES;
    _btnCart.hidden = YES;
    _btnSearch.hidden = YES;
    _searchBar.hidden = NO;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
