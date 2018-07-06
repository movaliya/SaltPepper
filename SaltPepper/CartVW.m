//
//  CartVW.m
//  SaltPepper
//
//  Created by jignesh solanki on 28/05/2018.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "CartVW.h"
#import "CartCell.h"
#import "CheckOutAddressVW.h"
@interface CartVW ()

@end

@implementation CartVW
@synthesize Quantity_LBL,ProceedToPayBTN;
@synthesize TableVW,POPView;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    NSDate *now = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE"];
    dayName=[dateFormatter stringFromDate:now];
    
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
   // TableVW.rowHeight = UITableViewAutomaticDimension;
    
    KmyappDelegate.MainCartArr = [AppDelegate GetData:@"CartDIC"];
    
    if ( KmyappDelegate.MainCartArr.count!=0)
    {
        NSLog(@"MainCartArr=%@", KmyappDelegate.MainCartArr);
        self.NotItem_LBL.hidden=YES;
        [self CalculateTotal];
    }
    else
    {
         self.NotItem_LBL.hidden=NO;
        self.UpperView.hidden=YES;
         self.TableVW.hidden=YES;
         self.TotalView.hidden=YES;
         self.ClearBtn.hidden=YES;
         self.PromoBtn.hidden=YES;
         self.ProceedToPayBTN.hidden=YES;
    }
    
    
   
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
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
    
    
    NSMutableArray *Array=[[[KmyappDelegate.MainCartArr objectAtIndex:indexPath.section] valueForKey:@"ingredients"] mutableCopy];
    NSMutableArray *withINTG=[[NSMutableArray alloc]init];
    NSMutableArray *withoutINTG=[[NSMutableArray alloc]init];
    for (int i=0; i<Array.count; i++)
    {
        if ([[[Array objectAtIndex:i] valueForKey:@"is_with"] boolValue]==0)
        {
            [withoutINTG addObject:[[Array objectAtIndex:i] valueForKey:@"ingredient_name"]];
            
        }
        else
        {
            [withINTG addObject:[[Array objectAtIndex:i] valueForKey:@"ingredient_name"]];
        }
    }
    NSString *WithjoinedComponents = [withINTG componentsJoinedByString:@","];
    NSString *WithoutjoinedComponents = [withoutINTG componentsJoinedByString:@","];
    if (WithjoinedComponents == nil || [WithjoinedComponents isKindOfClass:[NSNull class]]) {
        //do something
    }
    if (withINTG.count>0)
    {
        cell.With_LBL.text=[NSString stringWithFormat:@"With: %@",WithjoinedComponents];
    }
    else
    {
        cell.With_LBL.text=@" ";

    }
    
    if (withoutINTG.count>0)
    {
        cell.Without_LBL.text=[NSString stringWithFormat:@"Without: %@",WithoutjoinedComponents];
    }
    else
    {
        cell.Without_LBL.text=@" ";
        
    }


    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
/*
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return 85.0f;
}*/

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
    
    [AppDelegate WriteData:@"CartDIC" RootObject:KmyappDelegate.MainCartArr];
   
    
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
        
        [AppDelegate WriteData:@"CartDIC" RootObject:KmyappDelegate.MainCartArr];

        
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
        
        [AppDelegate WriteData:@"CartDIC" RootObject:KmyappDelegate.MainCartArr];
        if ( KmyappDelegate.MainCartArr.count==0)
        {
            self.NotItem_LBL.hidden=NO;
            self.UpperView.hidden=YES;
            self.TableVW.hidden=YES;
            self.TotalView.hidden=YES;
            self.ClearBtn.hidden=YES;
            self.PromoBtn.hidden=YES;
            self.ProceedToPayBTN.hidden=YES;
        }
       
    }];
}

-(void)CalculateTotal
{
    subTotalINT=0;
    QTYINT=0;
    withoutIntegrate=[[NSMutableArray alloc] init];
    WithIntegrate=[[NSMutableArray alloc] init];
    
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
                [withoutIntegrate addObject:[[Array objectAtIndex:i] valueForKey:@"ingredient_name"]];
            
            }
            else
            {
                integratPRICE=integratPRICE+[[[Array objectAtIndex:i] valueForKey:@"price"] floatValue];
                [WithIntegrate addObject:[[Array objectAtIndex:i] valueForKey:@"ingredient_name"]];
            }
        }
       
    }
    
    NSLog(@"with=%@",WithIntegrate);
    NSLog(@"withOut=%@",withoutIntegrate);

    subTotalINT=subTotalINT+integratPRICE;
    self.Quantity_LBL.text=[NSString stringWithFormat:@"%ld",(long)QTYINT];
    self.SubTotal.text=[NSString stringWithFormat:@"£%.2f",subTotalINT];
    self.SubTotalUpperLBL.text=[NSString stringWithFormat:@"£%.2f",subTotalINT];
    self.GrandTotal_LBL.text=[NSString stringWithFormat:@"£%.2f",subTotalINT];
    
     NSString *GToal = [ self.GrandTotal_LBL.text stringByReplacingOccurrencesOfString:@"£"  withString:@""];
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
         [self Discount:dayName GrandTotal:GToal];
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
   
}

-(void)Discount:(NSString *)day GrandTotal:(NSString *)GT
{
    
   
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    
    NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
    [dictInner setObject:GT forKey:@"TOTALSUM"];
    [dictInner setObject:day forKey:@"DAY"];
    [dictInner setObject:@"Collection" forKey:@"ORDERTYPE"];
    
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    [dictSub setObject:@"orderDiscount" forKey:@"METHOD"];
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
    NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,DISCOUNT];
    [Utility postRequest:json url:makeURL success:^(id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"orderDiscount"] objectForKey:@"SUCCESS"];
        if ([SUCCESS boolValue] ==YES)
        {
           NSDictionary *orderDiscount=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"orderDiscount"] objectForKey:@"RESULT"] objectForKey:@"orderDiscount"];
            
            self.GrandTotal_LBL.text=[NSString stringWithFormat:@"£%@",[orderDiscount objectForKey:@"totalprice"]];
            self.Discount_LBL.text=[NSString stringWithFormat:@"£%@",[orderDiscount objectForKey:@"discount"]];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"Fail");
    }];
    
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
        
        [AppDelegate WriteData:@"CartDIC" RootObject:KmyappDelegate.MainCartArr];

        [TableVW reloadData];
        [self CalculateTotal];
        self.NotItem_LBL.hidden=NO;
        self.UpperView.hidden=YES;
        self.TableVW.hidden=YES;
        self.TotalView.hidden=YES;
        self.ClearBtn.hidden=YES;
        self.PromoBtn.hidden=YES;
        self.ProceedToPayBTN.hidden=YES;
    }];
    
}

- (IBAction)Promocode_Click:(id)sender
{
  [self ShowPopUpAnimation];
}

-(void)ApplayPromo_Click:(id)sender
{
    //NSLog(@"PROMOCODE==%@",POPView.Promo_TXT.text);
    
    if ([POPView.Promo_TXT.text isEqualToString:@""])
    {
        //[self ShowPOPUP];
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Promocode." delegate:nil];
    }
    else
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        KmyappDelegate.MainCartArr = [AppDelegate GetData:@"CartDIC"];
        NSMutableArray *ProdArr=[[NSMutableArray alloc]init];
        NSLog(@"===%@",KmyappDelegate.MainCartArr);
        NSMutableArray *Userdata=[AppDelegate GetData:@"LoginUserDic"];
        NSString *CutomerID = [[[[[[Userdata valueForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
        
        for (int k=0; k<KmyappDelegate.MainCartArr.count; k++)
        {
            NSMutableArray *Array=[[[KmyappDelegate.MainCartArr objectAtIndex:k] valueForKey:@"ingredients"] mutableCopy];
            NSMutableArray *Withindgarr=[[NSMutableArray alloc]init];
            NSMutableArray *Withoutindgarr=[[NSMutableArray alloc]init];
            NSMutableDictionary *inddic=[[NSMutableDictionary alloc]init];
            
            
            // ProdArr=[[NSMutableArray alloc]init];
            NSString *ProdidSr=[[NSString alloc]init];
            if ([Array isKindOfClass:[NSArray class]])
            {
                //NSLog(@"Array===%@",Array);
                for (int i=0; i<Array.count; i++)
                {
                    if ([[[Array objectAtIndex:i] valueForKey:@"is_with"] isEqualToString:@"1"])
                    {
                        [Withindgarr addObject:[[Array objectAtIndex:i] valueForKey:@"ingredient_id"]];
                    }
                    else
                    {
                        [Withoutindgarr addObject:[[Array objectAtIndex:i] valueForKey:@"ingredient_id"]];
                    }
                    ProdidSr=[[Array objectAtIndex:i] valueForKey:@"product_id"];
                }
                if (Withindgarr.count>0)
                {
                    [inddic setObject:Withindgarr forKey:@"WITHINGREDIENTID"];
                }
                if (Withoutindgarr.count>0)
                {
                    [inddic setObject:Withoutindgarr forKey:@"WITHOUTINGREDIENTID"];
                }
            }
            
            [inddic setObject:[[KmyappDelegate.MainCartArr objectAtIndex:k] valueForKey:@"id"] forKey:@"ID"];
            [inddic setObject:[[KmyappDelegate.MainCartArr objectAtIndex:k] valueForKey:@"Quantity"] forKey:@"QUANTITY"];
            [ProdArr addObject:inddic];
        }
        
        
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
        [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
        NSString *Total=[NSString stringWithFormat:@"%.2f",subTotalINT];
        NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
        [dictInner setObject:CutomerID forKey:@"CUSTOMERID"];
        [dictInner setObject:POPView.Promo_TXT.text forKey:@"PROMOCODE"];
        [dictInner setObject:Total forKey:@"TOTALSUM"];
        [dictInner setObject:ProdArr forKey:@"PRODUCTID"];
        
        NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
        [dictSub setObject:@"getitem" forKey:@"MODULE"];
        [dictSub setObject:@"promoDiscount" forKey:@"METHOD"];
        [dictSub setObject:dictInner forKey:@"PARAMS"];
        
        
        NSMutableArray *arrs = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
        NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
        [dictREQUESTPARAM setObject:arrs forKey:@"REQUESTPARAM"];
        [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
        
        NSLog(@"dictREQUESTPARAM===%@",dictREQUESTPARAM);
        
        
        NSError* error = nil;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers  error:&error];
        
        NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,PROMOCODE];
        [Utility postRequest:json url:makeURL success:^(id responseObject)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"promoDiscount"] objectForKey:@"SUCCESS"];
             if ([SUCCESS boolValue] ==YES)
             {
                [self HidePopUpAnimation];
                 NSString *result=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"promoDiscount"] objectForKey:@"result"] objectForKey:@"promoDiscount"];
                 NSLog(@"place order result=%@",result);
                 
             }
             else
             {
                [self HidePopUpAnimation];
                 NSString *ERRORMSG=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"promoDiscount"] objectForKey:@"ERROR"] objectForKey:@"DESCRIPTION"];
                 [AppDelegate showErrorMessageWithTitle:@"Error!" message:ERRORMSG delegate:nil];
             }
         }
        failure:^(NSError *error) {
                         
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"Fail");
        }];
    }
    
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
- (IBAction)ProceedToPay_Click:(id)sender
{
    CheckOutAddressVW *vcr = [[UIStoryboard storyboardWithName:[SharedClass sharedSingleton].storyBaordName  bundle:nil] instantiateViewControllerWithIdentifier:@"CheckOutAddressVW"];
    vcr.GrandTotal=self.GrandTotal_LBL.text;
    vcr.Discount=self.Discount_LBL.text;
    [self.navigationController pushViewController:vcr animated:YES];
}

@end
