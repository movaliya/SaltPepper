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
    locationInfo = [[NSMutableDictionary alloc]init];
    ContactInfo = [[NSMutableDictionary alloc]init];
    [self CallLocationService];
    [self CallTelephoneService];
    self.navigationController.navigationBar.hidden=YES;
    
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
                ContactInfo = [[[[result objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"restaurantTelephone"] objectForKey:@"result"];
                 
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
    NSString *contact = [ContactInfo valueForKey:@"restaurantTelephone"];
    NSString *telephone = [NSString stringWithFormat:@"telprompt://%@",contact];
    NSURL *url = [NSURL URLWithString:telephone];
    [[UIApplication  sharedApplication] openURL:url];
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
- (IBAction)btnFB:(id)sender {
}
- (IBAction)btnLinked:(id)sender {
}
- (IBAction)btnTwitter:(id)sender {
}
- (IBAction)btnYoutube:(id)sender {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
