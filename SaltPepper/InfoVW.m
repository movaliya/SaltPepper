//
//  InfoVW.m
//  SaltPepper
//
//  Created by Dharmraj Vora on 13/07/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "InfoVW.h"
#import "InfoFullView.h"
#import "NewsCell.h"

@interface InfoVW ()

@end

@implementation InfoVW

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(IS_IPHONE_X)
    {
        _headerHeight.constant = 90;
    }
    else
    {
        _headerHeight.constant = 70;
    }
    
    self.navigationController.navigationBar.hidden=YES;
    
    static NSString *CellIdentifier = @"NewsCell";
    UINib *nib = [UINib nibWithNibName:@"NewsCell" bundle:nil];
    [_Info_TBL registerNib:nib forCellReuseIdentifier:CellIdentifier];
    // News_TBL.estimatedRowHeight = 220;
    _Info_TBL.rowHeight = UITableViewAutomaticDimension;
    
   
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        [self CallInfoService];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)CallInfoService
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    [dictSub setObject:@"appButtons" forKey:@"METHOD"];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
    NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
    
    [dictREQUESTPARAM setObject:arr forKey:@"REQUESTPARAM"];
    [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
    
    NSError* error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,APPBUTTON];
    
    [Utility postRequest:json url:makeURL success:^(id responseObject)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"appButtons"] objectForKey:@"SUCCESS"];
         if ([SUCCESS boolValue] ==YES)
         {
             NSMutableArray *TempSocialDataArr=[[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"appButtons"] objectForKey:@"result"] objectForKey:@"appButtons"] mutableCopy];
             
             for (int ii=0; ii<TempSocialDataArr.count; ii++)
             {
                 NSString *CheckButtontype=[[TempSocialDataArr valueForKey:@"button_type"] objectAtIndex:ii];
                 if ([CheckButtontype isEqualToString:@"Link"]||[CheckButtontype isEqualToString:@"Text"])
                 {
                     [InfoDataArr addObject:[TempSocialDataArr objectAtIndex:ii]];
                 }
             }
             [_Info_TBL reloadData];
         }
     } failure:^(NSError *error) {
         
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         NSLog(@"Fail");
         
     }];

}

- (IBAction)backBtn_action:(id)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 5.0f;
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
    return InfoDataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"NewsCell";
    NewsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
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
    
    //cell.NewsIMG.image=[UIImage imageNamed:@"testImage.jpg"];
    
    
    NSString *Urlstr=[[InfoDataArr valueForKey:@"image_path"] objectAtIndex:indexPath.row];
    [cell.NewsIMG sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
    // [cell.NewsIMG setShowActivityIndicatorView:YES];
    
    cell.NewsTitle_LBL.text=[[InfoDataArr valueForKey:@"title"] objectAtIndex:indexPath.row];
    //cell.Date_LBL.text=[[InfoDataArr valueForKey:@"news_date"] objectAtIndex:indexPath.row];
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    InfoFullView *vcr = [[UIStoryboard storyboardWithName:[SharedClass sharedSingleton].storyBaordName  bundle:nil] instantiateViewControllerWithIdentifier:@"InfoFullView"];
    vcr.infoSelectArr=[InfoDataArr objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:vcr animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 85.0f;
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
