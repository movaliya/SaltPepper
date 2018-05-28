//
//  ProductDetailVC.m
//  SaltPepper
//
//  Created by Dharmraj Vora on 28/05/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "ProductDetailVC.h"

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
- (IBAction)btnCheckoutClicked:(id)sender {
}
- (IBAction)btnAddToCartClicked:(id)sender
{
    if (KmyappDelegate.MainCartArr==nil)
    {
        KmyappDelegate.MainCartArr=[[NSMutableArray alloc]init];
        [KmyappDelegate.MainCartArr addObject:_productDetail];
    }
    else
    {
        if ([[KmyappDelegate.MainCartArr valueForKey:@"id"] containsObject:_productDetail])
        {
            NSLog(@"Already Added");
        }
        else
        {
            [KmyappDelegate.MainCartArr addObject:_productDetail];
        }
    }
}
- (IBAction)btnModifyClicked:(id)sender {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
