//
//  ContactUSVW.m
//  SaltPepper
//
//  Created by jignesh solanki on 01/04/2018.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "ContactUSVW.h"
#import "SendFeedbackVC.h"
#import "OurLocationVC.h"

@interface ContactUSVW ()
{
    NSMutableDictionary *locationInfo;
    NSMutableDictionary *ContactInfo;
}
@end

@implementation ContactUSVW

- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollView.contentSize = CGSizeMake(0, 620);
    if(IS_IPHONE_X)
    {
        _headerHeight.constant = 90;
    }
    else
    {
        _headerHeight.constant = 70;
    }
    
    locationInfo = [[NSMutableDictionary alloc]init];
    ContactInfo = [[NSMutableDictionary alloc]init];
    [self CallReservationHistory];
    [self CallLocationService];
    [self CallTelephoneService];
    self.navigationController.navigationBar.hidden=YES;
    
}

- (void)CallReservationHistory
{
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    
    NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    
    [dictSub setObject:@"appButtons" forKey:@"METHOD"];
    
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
    
    NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,APPBUTTON];
    
    [Utility postRequest:json url:makeURL success:^(id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"responseObject==%@",responseObject);
        NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"appButtons"] objectForKey:@"SUCCESS"];
        if ([SUCCESS boolValue] ==YES)
        {
            
        }
        else
        {
//            NSString *DESCRIPTION=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"postitem"] objectForKey:@"reservation"] objectForKey:@"ERROR"] objectForKey:@"DESCRIPTION"];
//            [AppDelegate showErrorMessageWithTitle:@"" message:DESCRIPTION delegate:nil];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"Fail");
    }];
}


-(void)CallLocationService
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    [dictSub setObject:@"mapAddress" forKey:@"METHOD"];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
    NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
    
    [dictREQUESTPARAM setObject:arr forKey:@"REQUESTPARAM"];
    [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
    
    NSError* error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,MAPADDRESS];
    
    [Utility postRequest:json url:makeURL success:^(id result)
     {
         if (![result isKindOfClass:[NSString class]])
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             NSString *SUCCESS=[[[[result objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"mapAddress"] objectForKey:@"SUCCESS"];
             if ([SUCCESS boolValue] ==YES)
             {
                 locationInfo = [[[[result objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"mapAddress"] objectForKey:@"result"];
                 _lblAddress.text = [locationInfo valueForKey:@"mapAddress"];
             }
         }
     }failure:^(NSError *error)
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

-(void)CallTelephoneService
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    [dictSub setObject:@"restaurantTelephone" forKey:@"METHOD"];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
    NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
    
    [dictREQUESTPARAM setObject:arr forKey:@"REQUESTPARAM"];
    [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
    
    NSError* error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,TELEPHONE];
    
    [Utility postRequest:json url:makeURL success:^(id result)
     {
         if (![result isKindOfClass:[NSString class]])
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             NSString *SUCCESS=[[[[result objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"restaurantTelephone"] objectForKey:@"SUCCESS"];
             if ([SUCCESS boolValue] ==YES)
             {
                ContactInfo = [[[[[result objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"restaurantTelephone"] objectForKey:@"result"] objectForKey:@"restaurantTelephone"];
                 
             }
         }
     }failure:^(NSError *error)
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

- (IBAction)MenuBtn_click:(id)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];

}
- (IBAction)btnCall:(id)sender
{
    FCAlertView *alert = [KmyappDelegate ShowAlertWithBtnAction:@"Are you want to Call?" andStrTile:nil andbtnTitle:@"NO" andButtonArray:@[]];
    
    [alert addButton:@"YES" withActionBlock:^{
        NSString *contact = [ContactInfo valueForKey:@"value"];
        NSString *telephone = [NSString stringWithFormat:@"telprompt://%@",contact];
        NSURL *url = [NSURL URLWithString:telephone];
        UIApplication *application = [UIApplication sharedApplication];
        [application openURL:url options:@{} completionHandler:^(BOOL success) {
            if (success) {
                NSLog(@"Opened url");
            }
        }];
    }];
    
    //[[UIApplication  sharedApplication] openURL:url];
}
- (IBAction)btnFeedback:(id)sender
{
    SendFeedbackVC *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SendFeedbackVC"];
    [self.navigationController pushViewController:mainVC animated:YES];
}
- (IBAction)btnGetLocation:(id)sender
{
    OurLocationVC *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"OurLocationVC"];
    mainVC.locationDetail = [[NSMutableDictionary alloc]init];
    mainVC.locationDetail = [locationInfo mutableCopy];
    [self.navigationController pushViewController:mainVC animated:YES];
}
- (IBAction)btnFB:(id)sender
{
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"https://www.facebook.com/apple/"];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened url");
        }
    }];
}
- (IBAction)btnLinked:(id)sender
{
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"https://www.linkedin.com/company/apple"];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened url");
        }
    }];
}
- (IBAction)btnTwitter:(id)sender
{
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"https://twitter.com/apple?lang=en"];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened url");
        }
    }];
}
- (IBAction)btnYoutube:(id)sender
{
    UIApplication *application = [UIApplication sharedApplication];
    NSURL *URL = [NSURL URLWithString:@"https://www.youtube.com/user/Apple"];
    [application openURL:URL options:@{} completionHandler:^(BOOL success) {
        if (success) {
            NSLog(@"Opened url");
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
