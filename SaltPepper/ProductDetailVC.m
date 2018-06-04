//
//  ProductDetailVC.m
//  SaltPepper
//
//  Created by Dharmraj Vora on 28/05/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "ProductDetailVC.h"
#import "OptionView.h"

@interface ProductDetailVC ()

@end

@implementation ProductDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _btnModify.layer.cornerRadius = 5.0;
    _btnAddToCart.layer.cornerRadius = 25;
    _btnCheckOut.layer.cornerRadius = 25;
    _btnPlus.layer.cornerRadius = _btnPlus.frame.size.height / 2.0;
    _btnMinus.layer.cornerRadius = _btnMinus.frame.size.height / 2.0;
    
    [_viewDetail.layer setShadowColor:[UIColor grayColor].CGColor];
    [_viewDetail.layer setShadowOpacity:0.8];
    [_viewDetail.layer setShadowOffset:CGSizeMake(0.0, 0.0)];
    
    _lblProductName.text = [_productDetail valueForKey:@"productName"];
    _lblPrice.text = [NSString stringWithFormat:@"£%@",[_productDetail valueForKey:@"price"]];
    _txtDetail.text = [_productDetail valueForKey:@"description"];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Click Action

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnCheckoutClicked:(id)sender
{
    
}
- (IBAction)btnAddToCartClicked:(id)sender
{
    NSLog(@"%@",KmyappDelegate.MainCartArr);
    if (KmyappDelegate.MainCartArr==nil)
    {
        KmyappDelegate.MainCartArr=[[NSMutableArray alloc]init];
        [KmyappDelegate.MainCartArr addObject:_productDetail];
    }
    else
    {
        if ([[KmyappDelegate.MainCartArr valueForKey:@"id"] containsObject:[_productDetail valueForKey:@"id"]])
        {
            NSLog(@"Already Added");
        }
        else
        {
            [KmyappDelegate.MainCartArr addObject:_productDetail];
            NSLog(@"%@",KmyappDelegate.MainCartArr);
        }
    }
    NSData *dataSave = [NSKeyedArchiver archivedDataWithRootObject:KmyappDelegate.MainCartArr];
    [[NSUserDefaults standardUserDefaults] setObject:dataSave forKey:@"CartDIC"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (IBAction)btnModifyClicked:(id)sender
{
    OptionView *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OptionView"];
    mainVC.ModifyDic=[[NSMutableDictionary alloc]initWithDictionary:_productDetail];
    [self.navigationController pushViewController:mainVC animated:YES];
}
- (IBAction)btnPlusClicked:(id)sender
{
    int val = [_lblQty.text intValue];
    int newValue = val + 1;
    _lblQty.text = [NSString stringWithFormat:@"%ld",(long)newValue];
}
- (IBAction)btnMinusClicked:(id)sender
{
    int val = [_lblQty.text intValue];
    if(val > 1)
    {
        int newValue = val - 1;
        _lblQty.text = [NSString stringWithFormat:@"%ld",(long)newValue];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
