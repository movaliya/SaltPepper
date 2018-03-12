//
//  StartUpVW.m
//  SaltPepper
//
//  Created by jignesh solanki on 12/03/2018.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "StartUpVW.h"
#import "LoginVW.h"
#import "RegisterVW.h"
#import "DEMORootViewController.h"

@interface StartUpVW ()

@end

@implementation StartUpVW
@synthesize RegisterBtn,LoginBtn;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden=YES;

    RegisterBtn.layer.cornerRadius = 22;
    RegisterBtn.clipsToBounds = YES;
   
    
    LoginBtn.layer.cornerRadius = 22;
    LoginBtn.clipsToBounds = YES;
    LoginBtn.layer.borderColor=[UIColor whiteColor].CGColor;
    LoginBtn.layer.borderWidth=1.0f;
    
    
    // Do any additional setup after loading the view.
}
- (IBAction)RegiterBtn_Click:(id)sender
{
    RegisterVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"RegisterVW"];
    [self.navigationController pushViewController:vcr animated:YES];
    
}
- (IBAction)LoginBtn_Click:(id)sender
{
    LoginVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginVW"];
    [self.navigationController pushViewController:vcr animated:YES];
}
- (IBAction)SkipBtn_click:(id)sender
{
    DEMORootViewController *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"rootController"];
    [self.navigationController pushViewController:vcr animated:YES];
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
