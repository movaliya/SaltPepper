//
//  RegisterVW.m
//  SaltPepper
//
//  Created by jignesh solanki on 12/03/2018.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "RegisterVW.h"
#import "LoginVW.h"
#import "DEMORootViewController.h"

@interface RegisterVW ()

@end

@implementation RegisterVW
@synthesize Email_TXT,Password_TXT,LastName_TXT,ConfirmPasswd_TXT,Name_TXT,RegisterBtn;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RegisterBtn.layer.cornerRadius = 22;
    RegisterBtn.clipsToBounds = YES;
}
- (IBAction)RegisterBtnClick:(id)sender
{
    
    if ([Name_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter First name" delegate:nil];
    }
    else if ([LastName_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Last name" delegate:nil];
    }
    else if ([Email_TXT.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Email" delegate:nil];
    }
    else if ([Password_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter password" delegate:nil];
    }
    else if ([ConfirmPasswd_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter confrim password" delegate:nil];
    }
    else
    {
        if (![AppDelegate IsValidEmail:Email_TXT.text])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter valid email" delegate:nil];
        }
        else if (![ConfirmPasswd_TXT.text isEqualToString:Password_TXT.text])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Confrim password do not match." delegate:nil];
        }
        else
        {
            BOOL internet=[AppDelegate connectedToNetwork];
            if (internet)
            {
                [self Callforregister:Email_TXT.text Pass:Password_TXT.text Fname:Name_TXT.text Lname:LastName_TXT.text];
            }
            else
                [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        }
    }
}
-(void)Callforregister :(NSString *)EmailStr Pass:(NSString *)PasswordStr Fname:(NSString *)FnameStr Lname:(NSString *)LNameStr
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    
    NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
    [dictInner setObject:EmailStr forKey:@"EMAIL"];
    [dictInner setObject:PasswordStr forKey:@"PASSWORD"];
    [dictInner setObject:FnameStr forKey:@"FIRSTNAME"];
    [dictInner setObject:LNameStr forKey:@"LASTNAME"];
    [dictInner setObject:@"firebase" forKey:@"REGID"];
    
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    [dictSub setObject:@"postitem" forKey:@"MODULE"];
    [dictSub setObject:@"registration" forKey:@"METHOD"];
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
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
    NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,REGISTERKEY];
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
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    [postDataTask resume];
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
