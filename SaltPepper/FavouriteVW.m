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
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    static NSString *CellIdentifier = @"FavoriteCell";
    UINib *nib = [UINib nibWithNibName:@"FavoriteCell" bundle:nil];
    [TableVW registerNib:nib forCellReuseIdentifier:CellIdentifier];
    // News_TBL.estimatedRowHeight = 220;
    TableVW.rowHeight = UITableViewAutomaticDimension;
    // Do any additional setup after loading the view.
    
      //NSDictionary *FavrtDic = _ro(@"FavDIC");
     // NSLog(@"MainFavArr==%@",FavrtDic);
    NSLog(@"MainFavArr==%@",KmyappDelegate.MainFavArr);

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return KmyappDelegate.MainFavArr.count;
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
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    cell.layer.shadowOffset = CGSizeMake(1, 0);
    cell.layer.shadowColor = [[UIColor blackColor] CGColor];
    cell.layer.shadowRadius = 5;
    cell.layer.shadowOpacity = .25;
    
    
    cell.Title_LBL.text=[NSString stringWithFormat:@"%@",[[KmyappDelegate.MainFavArr valueForKey:@"productName"] objectAtIndex:indexPath.row]];
    cell.Price_BTN.text=[NSString stringWithFormat:@"£%@",[[KmyappDelegate.MainFavArr valueForKey:@"price"] objectAtIndex:indexPath.row]];
    
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
    return 120.0f;
}

- (IBAction)Menu_action:(id)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];
    
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
