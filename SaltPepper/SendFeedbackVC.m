//
//  SendFeedbackVC.m
//  SaltPepper
//
//  Created by Dharmraj Vora on 29/05/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "SendFeedbackVC.h"

@interface SendFeedbackVC ()

@end

@implementation SendFeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];

    if([[SharedClass sharedSingleton].storyBaordName isEqualToString:@"Main"])
    {
        _viewEmail.layer.cornerRadius = 25.0;
        _viewEmail.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _viewEmail.layer.borderWidth = 1.0;
        _viewFName.layer.cornerRadius = 25.0;
        _viewFName.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _viewFName.layer.borderWidth = 1.0;
        _viewMessage.layer.cornerRadius = 25.0;
        _viewMessage.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _viewMessage.layer.borderWidth = 1.0;
        _viewContact.layer.cornerRadius = 25.0;
        _viewContact.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _viewContact.layer.borderWidth = 1.0;
        
        _btnSubmit.layer.cornerRadius = 20;
    }
    else
    {
        _viewEmail.layer.cornerRadius = 30.0;
        _viewEmail.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _viewEmail.layer.borderWidth = 1.0;
        _viewFName.layer.cornerRadius = 30.0;
        _viewFName.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _viewFName.layer.borderWidth = 1.0;
        _viewMessage.layer.cornerRadius = 30.0;
        _viewMessage.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _viewMessage.layer.borderWidth = 1.0;
        _viewContact.layer.cornerRadius = 30.0;
        _viewContact.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _viewContact.layer.borderWidth = 1.0;
        
        _btnSubmit.layer.cornerRadius = 30.0;
    }
    
    
    
    NSMutableArray *Userdata=[AppDelegate GetData:@"LoginUserDic"];
    if (Userdata)
    {
        NSString *customer_name = [[[[[[[Userdata valueForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"myProfile"] objectForKey:@"customer_name"];
        NSString *customer_email = [[[[[[[Userdata valueForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"myProfile"] objectForKey:@"email"];
        NSString *mobile = [[[[[[[Userdata valueForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"myProfile"] objectForKey:@"mobile"];
        _txtFName.text=customer_name;
        _txtEmail.text=customer_email;
         _txtContact.text=mobile;
    }
   
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button ClickAction

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnSubmitClicked:(id)sender
{
    if ([_txtFName.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter First name" delegate:nil];
    }
    else if ([_txtEmail.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Email" delegate:nil];
    }
    if (![AppDelegate IsValidEmail:_txtEmail.text])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter valid email" delegate:nil];
    }
    else if ([_txtMsg.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Message" delegate:nil];
    }
    else if ([_txtContact.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Contact Number" delegate:nil];
    }
    else
    {
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
            [self CallSendFeedback];
        else
            [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    }
}

-(void)CallSendFeedback
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    
    NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
    [dictInner setObject:_txtFName.text forKey:@"FULLNAME"];
    [dictInner setObject:_txtEmail.text forKey:@"EMAIL"];
    [dictInner setObject:_txtMsg.text forKey:@"MESSAGE"];
    [dictInner setObject:_txtContact.text forKey:@"PHONE"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    [dictSub setObject:@"action" forKey:@"MODULE"];
    [dictSub setObject:@"contactUs" forKey:@"METHOD"];
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
    NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,CONTACTUS];
    
    [Utility postRequest:json url:makeURL success:^(id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"responseObject==%@",responseObject);
        NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"contactUs"] objectForKey:@"SUCCESS"];
        if ([SUCCESS boolValue] ==YES)
        {
            [self.navigationController popViewControllerAnimated:YES];
            NSString *DESCRIPTION=[[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"contactUs"] objectForKey:@"result"] objectForKey:@"contactUs"] objectForKey:@"msg"];
            [AppDelegate showErrorMessageWithTitle:@"" message:DESCRIPTION delegate:nil];
        }
        else
        {
            [self.navigationController popViewControllerAnimated:YES];
            NSString *DESCRIPTION=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"contactUs"] objectForKey:@"ERROR"] objectForKey:@"DESCRIPTION"];
            [AppDelegate showErrorMessageWithTitle:@"" message:DESCRIPTION delegate:nil];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"Fail");
        
    }];
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
