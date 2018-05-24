//
//  LoginVW.m
//  SaltPepper
//
//  Created by jignesh solanki on 12/03/2018.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "LoginVW.h"
#import "saltPepper.pch"
#import "ForgotPasswordVC.h"
#import "RegisterVW.h"
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
    
    NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,LOGINKEY];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
    // NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:makeURL] cachePolicy:NSURLRequestUseProtocolCachePolicy   timeoutInterval:60.0];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPMethod:@"POST"];
    NSDictionary *mapData = [[NSDictionary alloc] initWithDictionary:json];
    NSData *postData = [NSJSONSerialization dataWithJSONObject:mapData options:0 error:&error];
    [request setHTTPBody:postData];
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
      {
          if (!error)
          {
              
              NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
              NSData *data1 = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
              id json = [NSJSONSerialization JSONObjectWithData:data1 options:0 error:nil];
              NSMutableDictionary *dicjson = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
              NSLog(@"%@",json);
          }
          else
          {
              NSLog(@"%@",error.description);
          }
      }];
  
    
    [postDataTask resume];

}

- (IBAction)ForgetPasswordBtn_Click:(id)sender
{
    ForgotPasswordVC *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordVC"];
    [self.navigationController pushViewController:mainVC animated:YES];
}
- (IBAction)RegisterBtn_Click:(id)sender
{
    RegisterVW *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterVW"];
    [self.navigationController pushViewController:mainVC animated:YES];
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

- (IBAction)btnLoginFB:(id)sender {
}

- (IBAction)btnLoginGoogle:(id)sender {
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
