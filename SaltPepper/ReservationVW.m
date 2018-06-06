//
//  ReservationVW.m
//  MirchMasala
//
//  Created by Mango SW on 09/09/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "ReservationVW.h"
#import "DEMORootViewController.h"
@interface ReservationVW ()
{
    NSMutableArray *UserSaveData;
}
@end

@implementation ReservationVW

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.BackView.layer.masksToBounds = NO;
    self.BackView.layer.shadowOffset = CGSizeMake(0, 1);
    self.BackView.layer.shadowRadius = 1.0;
    self.BackView.layer.shadowColor = [UIColor colorWithRed:115.0f/255.0f green:115.0f/255.0f blue:115.0f/255.0f alpha:1.0f].CGColor;
    self.BackView.layer.shadowOpacity = 0.5;
    
    // Do any additional setup after loading the view.
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        [self GetUserProfileData];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
}

-(void)GetUserProfileData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UserSaveData = [AppDelegate GetData:@"LoginUserDic"];
    //NSMutableDictionary *UserSaveData = [[[NSUserDefaults standardUserDefaults] objectForKey:@"LoginUserDic"] mutableCopy];
    if (UserSaveData)
    {
        NSString *CoustmerID=[[[[[[UserSaveData valueForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
        
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
        
        [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
        
        
        NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
        
        [dictInner setObject:CoustmerID forKey:@"CUSTOMERID"];
        
        
        
        NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
        
        [dictSub setObject:@"getitem" forKey:@"MODULE"];
        
        [dictSub setObject:@"myProfile" forKey:@"METHOD"];
        
        [dictSub setObject:dictInner forKey:@"PARAMS"];
        
        
        NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
        NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
        
        [dictREQUESTPARAM setObject:arr forKey:@"REQUESTPARAM"];
        [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
        
        NSError* error = nil;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&error];
        NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,GETPROFILE];
        
        [Utility postRequest:json url:makeURL success:^(id result)
         {
             if (![result isKindOfClass:[NSString class]])
             {
                 [MBProgressHUD hideHUDForView:self.view animated:YES];
                 NSString *SUCCESS=[[[[result objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"myProfile"] objectForKey:@"SUCCESS"];
                 if ([SUCCESS boolValue] ==YES)
                 {
                     NSMutableDictionary *myProfileDic=[[[[[result objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"myProfile"] objectForKey:@"result"] objectForKey:@"myProfile"];
                     self.NameTXT.text=[myProfileDic valueForKey:@"customerName"];
                     self.EmailTXT.text=[myProfileDic valueForKey:@"email"];
                     
                     if ([myProfileDic valueForKey:@"mobile"] != (id)[NSNull null])
                     {
                         self.PhoneNumberTXT.text=[myProfileDic valueForKey:@"mobile"];
                     }
                 }
             }
         }
        failure:^(NSError *error)
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             if (![Utility connected])
             {
                 //[sharedAppDel ShowAlertWithOneBtn:kReachability andStrTitle:nil andbtnTitle:@"OK"];
             }
             else
             {
                 //[sharedAppDel ShowAlertWithOneBtn:[result valueForKey:@"message"] andStrTitle:nil andbtnTitle:@"OK"];
             }
         }];
    }
    else
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [AppDelegate showErrorMessageWithTitle:@"" message:@"You are not Login." delegate:nil];
    }
    
}

- (IBAction)SubmitBtn_Action:(id)sender
{
   
    if ([self.NameTXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter name." delegate:nil];
    }
    else if ([_EmailTXT.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter email." delegate:nil];
    }
    else if ([_PhoneNumberTXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter phone number." delegate:nil];
    }
    
    else
    {
        if (![AppDelegate IsValidEmail:_EmailTXT.text])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter valid email" delegate:nil];
        }
        else
        {
            BOOL internet=[AppDelegate connectedToNetwork];
            if (internet)
            {
                [self SubmitReservationData];
            }
            else
                [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        }
    }
}

-(void)SubmitReservationData
{
    
    if (_ro(@"LoginUserDic") != nil)
    {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *CoustmerID=[[[[[[UserSaveData valueForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
        

        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
        
        [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
        
        
        NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
        
        [dictInner setObject:CoustmerID forKey:@"REGID"];
        [dictInner setObject:_EmailTXT.text forKey:@"CUSTOMER_EMAIL"];
        [dictInner setObject:_NameTXT.text forKey:@"CUSTOMER_NAME"];
        [dictInner setObject:_PhoneNumberTXT.text forKey:@"CUSTOMER_TELEPHONE"];
        [dictInner setObject:self.Res_date forKey:@"RESERVATION_DATE"];
        [dictInner setObject:self.Res_Time forKey:@"RESERVATION_TIME"];
        [dictInner setObject:self.Stay_Hour forKey:@"RESERVATION_DURATION_HOUR"];
        [dictInner setObject:self.Stay_Mint forKey:@"RESERVATION_DURATION_MINUTE"];
        [dictInner setObject:self.aultNo forKey:@"ADULT"];
        [dictInner setObject:_MessageTXT.text forKey:@"MESSAGE"];
        
        NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
        
        [dictSub setObject:@"postitem" forKey:@"MODULE"];
        
        [dictSub setObject:@"reservation" forKey:@"METHOD"];
        
        [dictSub setObject:dictInner forKey:@"PARAMS"];
        
        
        NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
        NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
        
        [dictREQUESTPARAM setObject:arr forKey:@"REQUESTPARAM"];
        [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
        
        
        NSError* error = nil;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                             options:NSJSONReadingMutableContainers
                                                               error:&error];
        
        NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,RESERVATION];
        
        [Utility postRequest:json url:makeURL success:^(id responseObject) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSLog(@"responseObject==%@",responseObject);
            NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"postitem"] objectForKey:@"reservation"] objectForKey:@"SUCCESS"];
            if ([SUCCESS boolValue] ==YES)
            {
                 NSString *MESSAGE=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"postitem"] objectForKey:@"reservation"] objectForKey:@"RESULT"]objectForKey:@"reservation"];
                DEMORootViewController *vcr = [[UIStoryboard storyboardWithName:[SharedClass sharedSingleton].storyBaordName  bundle:nil] instantiateViewControllerWithIdentifier:@"rootController"];
                [self.navigationController pushViewController:vcr animated:YES];
                [AppDelegate showErrorMessageWithTitle:@"" message:MESSAGE delegate:nil];
            }
            else
            {
                NSString *DESCRIPTION=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"postitem"] objectForKey:@"reservation"] objectForKey:@"ERROR"] objectForKey:@"DESCRIPTION"];
                [AppDelegate showErrorMessageWithTitle:@"" message:DESCRIPTION delegate:nil];
            }
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSLog(@"Fail");
        }];
        
    }
    else
    {
        
        [AppDelegate showErrorMessageWithTitle:@"" message:@"You are not Login." delegate:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backBtn_Action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];

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
