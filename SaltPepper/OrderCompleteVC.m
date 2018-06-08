//
//  OrderCompleteVC.m
//  SaltPepper
//
//  Created by Dharmraj Vora on 02/06/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "OrderCompleteVC.h"
#import "DEMORootViewController.h"
#import "OrderHistoryVC.h"
@interface OrderCompleteVC ()

@end

@implementation OrderCompleteVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;

    if([[SharedClass sharedSingleton].storyBaordName isEqualToString:@"Main"])
    {
        self.btnOrderHistory.layer.cornerRadius = 22;
        self.btnOrderHistory.clipsToBounds = YES;
        
        self.btnContinue.layer.cornerRadius = 22;
        self.btnContinue.clipsToBounds = YES;
    }
    else
    {
        self.btnOrderHistory.layer.cornerRadius = 30;
        self.btnOrderHistory.clipsToBounds = YES;
        
        self.btnContinue.layer.cornerRadius = 30;
        self.btnContinue.clipsToBounds = YES;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Click Action

- (IBAction)btnOrderHistory:(id)sender
{
    OrderHistoryVC *vcr = [[UIStoryboard storyboardWithName:[SharedClass sharedSingleton].storyBaordName  bundle:nil] instantiateViewControllerWithIdentifier:@"OrderHistoryVC"];
    [self.navigationController pushViewController:vcr animated:YES];
}
- (IBAction)btnContinue:(id)sender
{
    DEMORootViewController *vcr = [[UIStoryboard storyboardWithName:[SharedClass sharedSingleton].storyBaordName  bundle:nil] instantiateViewControllerWithIdentifier:@"rootController"];
    [self.navigationController pushViewController:vcr animated:YES];
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
