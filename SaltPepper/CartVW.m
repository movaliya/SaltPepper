//
//  CartVW.m
//  SaltPepper
//
//  Created by jignesh solanki on 28/05/2018.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "CartVW.h"
#import "CartCell.h"
@interface CartVW ()

@end

@implementation CartVW
@synthesize Quantity_LBL,ProceedToPayBTN;
@synthesize TableVW;
- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;

    Quantity_LBL.layer.cornerRadius = 12;
    Quantity_LBL.clipsToBounds = YES;
    ProceedToPayBTN.layer.cornerRadius = 22;
    ProceedToPayBTN.clipsToBounds = YES;
    
    static NSString *CellIdentifier = @"CartCell";
    UINib *nib = [UINib nibWithNibName:@"CartCell" bundle:nil];
    [TableVW registerNib:nib forCellReuseIdentifier:CellIdentifier];
    // News_TBL.estimatedRowHeight = 220;
    TableVW.rowHeight = UITableViewAutomaticDimension;
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"CartDIC"];
    KmyappDelegate.MainCartArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"MainCartArr=%@", KmyappDelegate.MainCartArr);
    // Do any additional setup after loading the view.
     [self CalculateTotal];
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
    return  KmyappDelegate.MainCartArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CartCell";
    CartCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    //cell.layer.shadowOffset = CGSizeMake(1, 0);
    //cell.layer.shadowColor = [[UIColor blackColor] CGColor];
   // cell.layer.shadowRadius = 5;
   // cell.layer.shadowOpacity = .25;
    
    //cell.NewsIMG.image=[UIImage imageNamed:@"testImage.jpg"];
    
    
    
    cell.DeleteBtn.tag=indexPath.section;
    [cell.DeleteBtn addTarget:self action:@selector(Delete_Clcik:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.ProductTitle_LBL.text=[NSString stringWithFormat:@"%@",[[KmyappDelegate.MainCartArr valueForKey:@"productName"] objectAtIndex:indexPath.row]];
    cell.ProductPrice_LBL.text=[NSString stringWithFormat:@"£%@*",[[KmyappDelegate.MainCartArr valueForKey:@"price"] objectAtIndex:indexPath.row]];
    
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
    return 85.0f;
}
- (void)Delete_Clcik:(UIButton *)sender
{
    FCAlertView *alert = [KmyappDelegate ShowAlertWithBtnAction:@"Are you sure want to remove from Cart?" andStrTile:nil andbtnTitle:@"NO" andButtonArray:@[]];
    
    [alert addButton:@"YES" withActionBlock:^{
        
        [KmyappDelegate.MainCartArr removeObjectAtIndex:[sender tag]];
        [TableVW reloadData];
        [self CalculateTotal];
        NSData *dataSave = [NSKeyedArchiver archivedDataWithRootObject:KmyappDelegate.MainCartArr];
        [[NSUserDefaults standardUserDefaults] setObject:dataSave forKey:@"CartDIC"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    
    
}
-(void)CalculateTotal
{
    subTotalINT=0;
    QTYINT=0;
    for (int rr=0; rr<KmyappDelegate.MainCartArr.count; rr++)
    {
        subTotalINT=subTotalINT+[[[KmyappDelegate.MainCartArr valueForKey:@"price"] objectAtIndex:rr] floatValue];
        QTYINT=QTYINT+[[[KmyappDelegate.MainCartArr valueForKey:@"Quantity"] objectAtIndex:rr] integerValue];
        self.Quantity_LBL.text=[NSString stringWithFormat:@"%ld",(long)QTYINT];
        self.SubTotal.text=[NSString stringWithFormat:@"£%.2f",subTotalINT];
        self.SubTotalUpperLBL.text=[NSString stringWithFormat:@"£%.2f",subTotalINT];
        self.GrandTotal_LBL.text=[NSString stringWithFormat:@"£%.2f",subTotalINT];
    }
}
- (IBAction)MenuBtn_click:(id)sender
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
