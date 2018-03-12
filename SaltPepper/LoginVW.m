//
//  LoginVW.m
//  SaltPepper
//
//  Created by jignesh solanki on 12/03/2018.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "LoginVW.h"

@interface LoginVW ()

@end

@implementation LoginVW
@synthesize LoginBtn,Email_TXT,Password_TXT;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    LoginBtn.layer.cornerRadius = 22;
    LoginBtn.clipsToBounds = YES;
    
    
    // Do any additional setup after loading the view.
}


- (IBAction)LoginBtn_Click:(id)sender
{
    
}
- (IBAction)ForgetPasswordBtn_Click:(id)sender
{
    
}
- (IBAction)RegisterBtn_Click:(id)sender
{
    
}
- (IBAction)ShowPasswordBtn_Click:(id)sender
{
    if (Password_TXT.secureTextEntry==YES)
    {
        Password_TXT.secureTextEntry=NO;
    }
    else
    {
        Password_TXT.secureTextEntry=YES;
    }
}
- (IBAction)BackBtnClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

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
