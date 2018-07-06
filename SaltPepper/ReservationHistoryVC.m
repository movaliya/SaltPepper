//
//  ReservationHistoryVC.m
//  SaltPepper
//
//  Created by Dharmraj Vora on 30/05/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "ReservationHistoryVC.h"
#import "ResHistoryCell.h"

@interface ReservationHistoryVC ()
{
    NSMutableDictionary *UserSaveData;
    NSMutableArray *arrResHistory;
}
@end

@implementation ReservationHistoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;
    arrResHistory = [[NSMutableArray alloc]init];
    filteredResHistory = [[NSMutableArray alloc]init];
    _searchBar.hidden = YES;
    UserSaveData = [AppDelegate GetData:@"LoginUserDic"];
    [self CallReservationHistory];
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)CallReservationHistory
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
        
        [dictSub setObject:@"reservationHistory" forKey:@"METHOD"];
        
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
        
        NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,RESERVATIONHISTORY];
        
        [Utility postRequest:json url:makeURL success:^(id responseObject) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSLog(@"responseObject==%@",responseObject);
            NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"reservationHistory"] objectForKey:@"SUCCESS"];
            if ([SUCCESS boolValue] ==YES)
            {
                arrResHistory = [[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"reservationHistory"] objectForKey:@"result"]objectForKey:@"reservationHistory"];
                [_tblResHistory reloadData];
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
        
        for(int i = 0; i < arrResHistory.count; i++)
        {
            NSString *id = [[arrResHistory valueForKey:@"order_id"]objectAtIndex:i];
            
            if([id containsString:self.searchBar.text])
            {
                [filteredResHistory addObject:arrResHistory[i]];
            }
        }
    }
    else
    {
        isFiltered = NO;
        [filteredResHistory removeAllObjects];
        [self.searchBar resignFirstResponder];
    }
    [_tblResHistory reloadData];
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
        _lblCartCount.hidden = NO;
        _searchBar.hidden = YES;
        [_tblResHistory reloadData];
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
        return arrResHistory.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[SharedClass sharedSingleton].storyBaordName isEqualToString:@"Main"])
    {
        return 240;
    }
    else
    {
        return 260;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ResHistoryCell *cell = (ResHistoryCell*)[tableView dequeueReusableCellWithIdentifier:@"ResHistoryCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.viewBack.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.viewBack.layer.borderWidth = 0.5;
    [cell.viewBack.layer setShadowColor:[UIColor grayColor].CGColor];
    [cell.viewBack.layer setShadowOpacity:0.8];
    [cell.viewBack.layer setShadowRadius:3.0];
    [cell.viewBack.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    if(isFiltered)
    {
        cell.lblCusName.text = [[filteredResHistory valueForKey:@"customer_name"] objectAtIndex:indexPath.row];
        cell.lblResNo.text = [[filteredResHistory valueForKey:@"order_id"] objectAtIndex:indexPath.row];
        cell.lblStatus.text = [[filteredResHistory valueForKey:@"reservationStatus"] objectAtIndex:indexPath.row];
        cell.lblNoOfGuest.text = [[filteredResHistory valueForKey:@"no_of_guests"] objectAtIndex:indexPath.row];
        cell.lblResDate.text = [[filteredResHistory valueForKey:@"reservation_date"] objectAtIndex:indexPath.row];
        cell.lblSpecialInstruction.text = [[filteredResHistory valueForKey:@"special_instruction"] objectAtIndex:indexPath.row];
    }
    else
    {
        cell.lblCusName.text = [[arrResHistory valueForKey:@"customer_name"] objectAtIndex:indexPath.row];
        cell.lblResNo.text = [[arrResHistory valueForKey:@"order_id"] objectAtIndex:indexPath.row];
        cell.lblStatus.text = [[arrResHistory valueForKey:@"reservationStatus"] objectAtIndex:indexPath.row];
        cell.lblNoOfGuest.text = [[arrResHistory valueForKey:@"no_of_guests"] objectAtIndex:indexPath.row];
        cell.lblResDate.text = [[arrResHistory valueForKey:@"reservation_date"] objectAtIndex:indexPath.row];
        cell.lblSpecialInstruction.text = [[arrResHistory valueForKey:@"special_instruction"] objectAtIndex:indexPath.row];
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
    _lblCartCount.hidden = YES;
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
