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
@synthesize TableVW,POPView;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    POPView = [[[NSBundle mainBundle] loadNibNamed:@"AlertViewPromoCode" owner:nil options:nil] firstObject];
    POPView.frame = self.view.frame;
    
    POPView.hidden=YES;
    POPView.alpha = 0;
    
    [POPView.Applay_BTN addTarget:self action:@selector(ApplayPromo_Click:) forControlEvents:UIControlEventTouchUpInside];
    [POPView.Cancel_BTN addTarget:self action:@selector(CancelPromo_Click:) forControlEvents:UIControlEventTouchUpInside];

    
    self.navigationController.navigationBar.hidden=YES;

    Quantity_LBL.layer.cornerRadius = 12;
    Quantity_LBL.clipsToBounds = YES;
    ProceedToPayBTN.layer.cornerRadius = 22;
    ProceedToPayBTN.clipsToBounds = YES;
    
    static NSString *CellIdentifier = @"CartCell";
    UINib *nib = [UINib nibWithNibName:@"CartCell" bundle:nil];
    [TableVW registerNib:nib forCellReuseIdentifier:CellIdentifier];
    TableVW.backgroundColor=[UIColor clearColor];
    // News_TBL.estimatedRowHeight = 220;
    TableVW.rowHeight = UITableViewAutomaticDimension;
    
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"CartDIC"];
    KmyappDelegate.MainCartArr = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    NSLog(@"MainCartArr=%@", KmyappDelegate.MainCartArr);
     [self CalculateTotal];
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 4.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return KmyappDelegate.MainCartArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  1;
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
    
    
    cell.PlusBtn.tag=indexPath.section;
    cell.MinusBtn.tag=indexPath.section;
    cell.DeleteBtn.tag=indexPath.section;
    
    [cell.DeleteBtn addTarget:self action:@selector(Delete_Clcik:) forControlEvents:UIControlEventTouchUpInside];
    [cell.PlusBtn addTarget:self action:@selector(Plush_Clcik:) forControlEvents:UIControlEventTouchUpInside];
    [cell.MinusBtn addTarget:self action:@selector(Minush_Clcik:) forControlEvents:UIControlEventTouchUpInside];

    cell.QTY_LBL.text=[NSString stringWithFormat:@"%@",[[KmyappDelegate.MainCartArr valueForKey:@"Quantity"] objectAtIndex:indexPath.section]];
    cell.ProductTitle_LBL.text=[NSString stringWithFormat:@"%@",[[KmyappDelegate.MainCartArr valueForKey:@"productName"] objectAtIndex:indexPath.section]];
    cell.ProductPrice_LBL.text=[NSString stringWithFormat:@"£%@*",[[KmyappDelegate.MainCartArr valueForKey:@"price"] objectAtIndex:indexPath.section]];
    
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

- (void)Plush_Clcik:(UIButton *)sender
{
    NSIndexPath *changedRow = [NSIndexPath indexPathForRow:0 inSection:sender.tag];
    CartCell *cell = (CartCell *)[TableVW cellForRowAtIndexPath:changedRow];
    
    int val = [cell.QTY_LBL.text intValue];
    int newValue = val + 1;
    cell.QTY_LBL.text = [NSString stringWithFormat:@"%ld",(long)newValue];
    
    NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
    intdic=[[KmyappDelegate.MainCartArr objectAtIndex:changedRow.section] mutableCopy];
    [intdic setObject:[NSNumber numberWithInt:newValue] forKey:@"Quantity"];
    [KmyappDelegate.MainCartArr replaceObjectAtIndex:changedRow.section withObject:intdic];
    
    NSData *dataSave = [NSKeyedArchiver archivedDataWithRootObject:KmyappDelegate.MainCartArr];
    [[NSUserDefaults standardUserDefaults] setObject:dataSave forKey:@"CartDIC"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self CalculateTotal];
    
}

- (void)Minush_Clcik:(UIButton *)sender
{
    NSIndexPath *changedRow = [NSIndexPath indexPathForRow:0 inSection:sender.tag];
    CartCell *cell = (CartCell *)[TableVW cellForRowAtIndexPath:changedRow];
    
    int val = [cell.QTY_LBL.text intValue];
    if(val > 1)
    {
        int newValue = val - 1;
        cell.QTY_LBL.text = [NSString stringWithFormat:@"%ld",(long)newValue];
        
        NSMutableDictionary *intdic=[[NSMutableDictionary alloc]init];
        intdic=[[KmyappDelegate.MainCartArr objectAtIndex:changedRow.section] mutableCopy];
        [intdic setObject:[NSNumber numberWithInt:newValue] forKey:@"Quantity"];
        [KmyappDelegate.MainCartArr replaceObjectAtIndex:changedRow.section withObject:intdic];
        
        NSData *dataSave = [NSKeyedArchiver archivedDataWithRootObject:KmyappDelegate.MainCartArr];
        [[NSUserDefaults standardUserDefaults] setObject:dataSave forKey:@"CartDIC"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self CalculateTotal];
    }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)ClearCart_Click:(id)sender
{
    FCAlertView *alert = [KmyappDelegate ShowAlertWithBtnAction:@"Are you sure want to Clear cart?" andStrTile:nil andbtnTitle:@"NO" andButtonArray:@[]];
    
    [alert addButton:@"YES" withActionBlock:^{
        
        [KmyappDelegate.MainCartArr removeAllObjects];
        KmyappDelegate.MainCartArr=[[NSMutableArray alloc]init];
        
        NSData *dataSave = [NSKeyedArchiver archivedDataWithRootObject:KmyappDelegate.MainCartArr];
        [[NSUserDefaults standardUserDefaults] setObject:dataSave forKey:@"CartDIC"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    
}

- (IBAction)Promocode_Click:(id)sender
{
  [self ShowPopUpAnimation];
}

-(void)ApplayPromo_Click:(id)sender
{
    NSLog(@"PROMOCODE==%@",POPView.Promo_TXT.text);
}

-(void)CancelPromo_Click:(id)sender
{
    [self HidePopUpAnimation];
}

#pragma mark - POPUP CODE

-(void)ShowPopUpAnimation
{
    [self.view endEditing:YES];
    POPView.alpha = 0;
    [KmyappDelegate.window addSubview:POPView];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        POPView.hidden=NO;
        POPView.alpha = 1;
        
        POPView.BackView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        POPView.BackView.frame = CGRectMake(SCREEN_WIDTH/2 - 150, SCREEN_HEIGHT/2 - 90,300, 200);
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)HidePopUpAnimation
{
    [UIView animateWithDuration:0.175 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        POPView.alpha = 0;
        POPView.BackView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        
    } completion:^(BOOL finished) {
        
        POPView.hidden=YES;
        [POPView removeFromSuperview];
        
    }];
}

@end
