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
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button ClickAction

- (IBAction)btnBackClicked:(id)sender {
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
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter M" delegate:nil];
    }
    else
    {
        [self CallSendFeedback];
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
        NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"postitem"] objectForKey:@"registration"] objectForKey:@"SUCCESS"];
        if ([SUCCESS boolValue] ==YES)
        {
            _wo(@"LoginUserDic", responseObject);
            [AppDelegate showErrorMessageWithTitle:@"" message:@"Registration successful" delegate:nil];
        }
        else
        {
            NSString *DESCRIPTION=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"postitem"] objectForKey:@"registration"] objectForKey:@"ERROR"] objectForKey:@"DESCRIPTION"];
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
