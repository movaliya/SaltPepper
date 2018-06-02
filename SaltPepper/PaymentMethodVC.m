//
//  PaymentMethodVC.m
//  SaltPepper
//
//  Created by Dharmraj Vora on 02/06/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "PaymentMethodVC.h"

@interface PaymentMethodVC ()

@end

@implementation PaymentMethodVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [_viewDetail.layer setShadowColor:[UIColor grayColor].CGColor];
    [_viewDetail.layer setShadowOpacity:0.8];
    [_viewDetail.layer setShadowRadius:3.0];
    [_viewDetail.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    _viewName.layer.cornerRadius = 20;
    _viewName.layer.borderWidth = 1.0;
    _viewName.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewNumber.layer.cornerRadius = 20;
    _viewNumber.layer.borderWidth = 1.0;
    _viewNumber.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewExpireDate.layer.cornerRadius = 20;
    _viewExpireDate.layer.borderWidth = 1.0;
    _viewExpireDate.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _viewCVV.layer.cornerRadius = 20;
    _viewCVV.layer.borderWidth = 1.0;
    _viewCVV.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _btnConfirmPayment.layer.cornerRadius = 20;
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
- (IBAction)btnCreditClicked:(id)sender
{
    [_btnPayOnCollection setBackgroundColor:[UIColor colorWithRed:123.0/255.0 green:11.0/255.0 blue:12.0/255.0 alpha:1.0]];
    [_btnCredit setBackgroundColor:[UIColor lightGrayColor]];
    _viewPayOn.hidden = YES;
    _viewCredit.hidden = NO;
}
- (IBAction)btnPayClicked:(id)sender
{
    [_btnCredit setBackgroundColor:[UIColor colorWithRed:123.0/255.0 green:11.0/255.0 blue:12.0/255.0 alpha:1.0]];
    [_btnPayOnCollection setBackgroundColor:[UIColor lightGrayColor]];
    _viewCredit.hidden = YES;
    _viewPayOn.hidden = NO;
}
- (IBAction)btnConfirmClicked:(id)sender {
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
