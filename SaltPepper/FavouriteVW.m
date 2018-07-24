//
//  FavouriteVW.m
//  SaltPepper
//
//  Created by jignesh solanki on 28/05/2018.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "FavouriteVW.h"
#import "FavoriteCell.h"
@interface FavouriteVW ()

@end

@implementation FavouriteVW
@synthesize TableVW;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(IS_IPHONE_X)
    {
        _headerHeight.constant = 90;
    }
    else
    {
        _headerHeight.constant = 70;
    }
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    static NSString *CellIdentifier = @"FavoriteCell";
    UINib *nib = [UINib nibWithNibName:@"FavoriteCell" bundle:nil];
    [TableVW registerNib:nib forCellReuseIdentifier:CellIdentifier];
    // News_TBL.estimatedRowHeight = 220;
    TableVW.rowHeight = UITableViewAutomaticDimension;
    // Do any additional setup after loading the view.
    
      //NSDictionary *FavrtDic = _ro(@"FavDIC");
     // NSLog(@"MainFavArr==%@",FavrtDic);
    KmyappDelegate.MainCartArr = [AppDelegate GetData:@"CartDIC"];
    KmyappDelegate.MainFavArr=[AppDelegate GetData:@"FavDIC"];
   // NSData *data = _ro(@"FavDIC");
    //NSArray *savedArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
  // KmyappDelegate.MainFavArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
   // NSLog(@"MainFavArr==%@",KmyappDelegate.MainFavArr);

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return KmyappDelegate.MainFavArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"FavoriteCell";
    FavoriteCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    if ([[KmyappDelegate.MainCartArr valueForKey:@"id"] containsObject:[[KmyappDelegate.MainFavArr valueForKey:@"id"]objectAtIndex:indexPath.row]])
    {
        cell.AddToCartBTN.hidden = YES;
    }
    else
    {
        
    }
    
    cell.AddToCartBTN.tag=indexPath.section;
    cell.Delete_BTN.tag=indexPath.section;
    
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    cell.layer.shadowOffset = CGSizeMake(1, 0);
    cell.layer.shadowColor = [[UIColor blackColor] CGColor];
    cell.layer.shadowRadius = 5;
    cell.layer.shadowOpacity = .25;
    
    
    [cell.AddToCartBTN addTarget:self action:@selector(AddToCartBTN_Clcik:) forControlEvents:UIControlEventTouchUpInside];
    [cell.Delete_BTN addTarget:self action:@selector(Delete_Clcik:) forControlEvents:UIControlEventTouchUpInside];
    cell.Title_LBL.text=[NSString stringWithFormat:@"%@",[[KmyappDelegate.MainFavArr valueForKey:@"productName"] objectAtIndex:indexPath.section]];
    cell.Price_BTN.text=[NSString stringWithFormat:@"£%@",[[KmyappDelegate.MainFavArr valueForKey:@"price"] objectAtIndex:indexPath.section]];
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 115.0f;
}

- (IBAction)Menu_action:(id)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ADD TO CART Click Action

- (void)AddToCartBTN_Clcik:(UIButton *)sender
{
    if (KmyappDelegate.MainCartArr==nil)
    {
        KmyappDelegate.MainCartArr=[[NSMutableArray alloc]init];
    }
    else
    {
        
    }
    
    if([[KmyappDelegate.MainFavArr objectAtIndex:[sender tag]] valueForKey:@"ingredients"] != nil)
    {
        NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
        intdic=[[KmyappDelegate.MainFavArr objectAtIndex:[sender tag]] mutableCopy];
        [intdic removeObjectForKey:@"ingredients"];
        
        [KmyappDelegate.MainCartArr addObject:intdic];
    }
    else
    {
        [KmyappDelegate.MainCartArr addObject:[KmyappDelegate.MainFavArr objectAtIndex:[sender tag]]];
    }
    [AppDelegate WriteData:@"CartDIC" RootObject:KmyappDelegate.MainCartArr];
    [TableVW reloadData];
    FCAlertView *alert = [KmyappDelegate ShowAlertWithBtnAction:@"Item added to cart successfully" andStrTile:nil andbtnTitle:@"OK" andButtonArray:@[]];
    //[KmyappDelegate.MainCartArr addObject:[KmyappDelegate.MainFavArr objectAtIndex:[sender tag]];
}

- (void)Delete_Clcik:(UIButton *)sender
{
    FCAlertView *alert = [KmyappDelegate ShowAlertWithBtnAction:@"Are you sure want to remove from favourite?" andStrTile:nil andbtnTitle:@"NO" andButtonArray:@[]];
    
    [alert addButton:@"YES" withActionBlock:^{
        
        [KmyappDelegate.MainFavArr removeObjectAtIndex:[sender tag]];
        [TableVW reloadData];
        [AppDelegate WriteData:@"FavDIC" RootObject:KmyappDelegate.MainFavArr];
    }];
    
    
}


@end
