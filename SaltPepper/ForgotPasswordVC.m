//
//  ForgotPasswordVC.m
//  SaltPepper
//
//  Created by Dharmraj Vora on 24/05/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "ForgotPasswordVC.h"
#import "DEMORootViewController.h"

@interface ForgotPasswordVC ()

@end

@implementation ForgotPasswordVC
@synthesize txtEmail;

- (void)viewDidLoad {
    [super viewDidLoad];
    _btnSubmit.layer.cornerRadius = 22;
    _btnSubmit.clipsToBounds = YES;
    
    _viewEmail.layer.cornerRadius = 27;
    _viewEmail.layer.borderWidth = 1.0;
    _viewEmail.layer.borderColor = [UIColor colorWithRed:207.0/255.0 green:197.0/255.0 blue:144.0/255.0 alpha:1.0].CGColor;
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

- (IBAction)btnSubmitClicked:(id)sender
{
    if ([txtEmail.text isEqualToString:@""])
    {
        //[self ShowPOPUP];
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter email" delegate:nil];
    }
    else
    {
        if (![AppDelegate IsValidEmail:txtEmail.text])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter valid email" delegate:nil];
        }
        else
        {
            
                BOOL internet=[AppDelegate connectedToNetwork];
                if (internet)
                    [self callForgetpassService];
                else
                    [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        }
    }
}

-(void)callForgetpassService
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
    
    [dictInner setObject:txtEmail.text forKey:@"EMAIL"];
    
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    
    [dictSub setObject:@"action" forKey:@"MODULE"];
    
    [dictSub setObject:@"forgotPassword" forKey:@"METHOD"];
    
    [dictSub setObject:dictInner forKey:@"PARAMS"];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
    NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
    
    [dictREQUESTPARAM setObject:arr forKey:@"REQUESTPARAM"];
    [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
    
    NSError* error = nil;
    
    NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,FORGOTPASS];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
    // NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", nil];
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:makeURL parameters:json success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         NSLog(@"responseObject==%@",responseObject);
         NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"forgotPassword"] objectForKey:@"SUCCESS"];
         if ([SUCCESS boolValue] ==YES)
         {
             txtEmail.text=@"";
             DEMORootViewController *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"rootController"];
             [self.navigationController pushViewController:vcr animated:YES];
              NSString *DESCRIPTION=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"forgotPassword"] objectForKey:@"result"] objectForKey:@"forgotPassword"];
             [AppDelegate showErrorMessageWithTitle:@"" message:DESCRIPTION delegate:nil];
         }
         else
         {
              NSString *DESCRIPTION=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"forgotPassword"] objectForKey:@"ERROR"] objectForKey:@"DESCRIPTION"];
             [AppDelegate showErrorMessageWithTitle:@"" message:DESCRIPTION delegate:nil];
         }
     }
     
          failure:^(NSURLSessionDataTask *operation, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         NSLog(@"Fail");
     }];
}

@end
