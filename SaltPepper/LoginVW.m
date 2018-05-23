//
//  LoginVW.m
//  SaltPepper
//
//  Created by jignesh solanki on 12/03/2018.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "LoginVW.h"
#import "saltPepper.pch"
#import "DEMORootViewController.h"
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

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    [super viewWillAppear:YES];
}

- (IBAction)LoginBtn_Click:(id)sender
{
    if ([Email_TXT.text isEqualToString:@""])
    {
        //[self ShowPOPUP];
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter email" delegate:nil];
    }
    else
    {
        if (![AppDelegate IsValidEmail:Email_TXT.text])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter valid email" delegate:nil];
        }
        else
        {
            if ([Password_TXT.text isEqualToString:@""])
            {
                [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter password" delegate:nil];
            }
            else
            {
                BOOL internet=[AppDelegate connectedToNetwork];
                if (internet)
                    [self CallForloging:Email_TXT.text Password:Password_TXT.text];
                else
                    [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
            }
        }
    }
}

-(void)CallForloging :(NSString *)EmailStr Password:(NSString *)PasswordStr
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    
    NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
    
    [dictInner setObject:EmailStr forKey:@"EMAIL"];
    [dictInner setObject:PasswordStr forKey:@"PASSWORD"];
    [dictInner setObject:@"" forKey:@"REGID"];
    
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    
    [dictSub setObject:@"action" forKey:@"MODULE"];
    
    [dictSub setObject:@"authenticate" forKey:@"METHOD"];
    
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
    //AFHTTPSessionManager
    
    NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,LOGINKEY];
    
    [Utility postRequest:json url:makeURL success:^(id result)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"responseObject==%@",result);
        NSString *SUCCESS=[[[[result objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"SUCCESS"];
        if ([SUCCESS boolValue] ==YES)
        {
            //_wo(@"LoginUserDic", result);
            
            //[[NSUserDefaults standardUserDefaults]setObject:result forKey:@"LoginUserDic"];
            
            DEMORootViewController *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"rootController"];
            [self.navigationController pushViewController:vcr animated:YES];
            Email_TXT.text=@"";
            Password_TXT.text=@"";
            [AppDelegate showErrorMessageWithTitle:@"" message:@"Login successful" delegate:nil];
        }
        else
        {
            NSString *DESCRIPTION=[[[[[result objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"ERROR"] objectForKey:@"DESCRIPTION"];
            
            [AppDelegate showErrorMessageWithTitle:@"" message:DESCRIPTION delegate:nil];
            //[AppDelegate showErrorMessageWithTitle:@"" message:@"Email and/or Password did not matched." delegate:nil];
        }
        
    } failure:^(NSError *error)
    {
        NSLog(@"Fail");
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", nil];
//    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
//    [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//    [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    manager.requestSerializer = serializer;
//    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//
//    [manager POST:makeURL parameters:json success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject)
//     {
//
//     }
//
//          failure:^(NSURLSessionDataTask *operation, NSError *error)
//     {
//
//     }];
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
    if(_rb(@"isSkip"))
    {
        DEMORootViewController *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"rootController"];
        [self.navigationController pushViewController:vcr animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }

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
