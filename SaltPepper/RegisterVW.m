//
//  RegisterVW.m
//  SaltPepper
//
//  Created by jignesh solanki on 12/03/2018.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "RegisterVW.h"
#import "LoginVW.h"
@interface RegisterVW ()

@end

@implementation RegisterVW
@synthesize Email_TXT,Password_TXT,Mobile_TXT,ConfirmPasswd_TXT,Name_TXT,RegisterBtn;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RegisterBtn.layer.cornerRadius = 22;
    RegisterBtn.clipsToBounds = YES;
}
- (IBAction)RegisterBtnClick:(id)sender
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
- (IBAction)AlreadyLoginBtn_Click:(id)sender
{
    LoginVW *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"LoginVW"];
    [self.navigationController pushViewController:vcr animated:YES];
}
- (IBAction)ShowConfirmPawwsor_Click:(id)sender
{
    if (ConfirmPasswd_TXT.secureTextEntry==YES)
    {
        ConfirmPasswd_TXT.secureTextEntry=NO;
    }
    else
    {
        ConfirmPasswd_TXT.secureTextEntry=YES;
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
