//
//  CartVW.m
//  SaltPepper
//
//  Created by jignesh solanki on 28/05/2018.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "CartVW.h"

@interface CartVW ()

@end

@implementation CartVW
@synthesize Quantity_LBL,ProceedToPayBTN;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;

    Quantity_LBL.layer.cornerRadius = 12;
    Quantity_LBL.clipsToBounds = YES;
    ProceedToPayBTN.layer.cornerRadius = 22;
    ProceedToPayBTN.clipsToBounds = YES;
    // Do any additional setup after loading the view.
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
