//
//  SlideMenuVC.m
//  SaltPepper
//
//  Created by Dharmraj Vora on 24/05/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "SlideMenuVC.h"
#import "ItemCell.h"

@interface SlideMenuVC ()<EHHorizontalSelectionViewProtocol>

@end

@implementation SlideMenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    arrCategories = @[@"STARTERS & MAIN", @"HOUSE SPECIAL DISHES", @"SEAFOOD SPECIAL DISHES", @"MILD DISHES", @"TRADITIONAL DISHES", @"BIRYANI DISHES", @"ENGLISH DISHES", @"BREADS", @"RICE", @"SOFT DRINKS"];
    arrItems = @[@"Vegetarian", @"Chicken", @"Lamb", @"Speciality", @"Seafood"];
    _HSSelView.delegate = self;
    [SharedClass sharedSingleton].index = _index;
    [_tblItem reloadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[[SharedClass sharedSingleton].arrCategories objectAtIndex:_index]valueForKey:@"child"] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ItemCell *cell = (ItemCell*)[tableView dequeueReusableCellWithIdentifier:@"ItemCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
    
    [cell.viewBack.layer setShadowColor:[UIColor grayColor].CGColor];
    [cell.viewBack.layer setShadowOpacity:0.8];
    [cell.viewBack.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    
    cell.lblItemName.text = [[[[[SharedClass sharedSingleton].arrCategories objectAtIndex:_index]valueForKey:@"child"]valueForKey:@"categoryName"]objectAtIndex:indexPath.row];

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
    [_tblItem reloadData];
    NSLog(@"%lu",(unsigned long)index);
}

#pragma mark - Button Click Action

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
