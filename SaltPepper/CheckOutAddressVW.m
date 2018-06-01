//
//  CheckOutAddressVW.m
//  SaltPepper
//
//  Created by jignesh solanki on 30/05/2018.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "CheckOutAddressVW.h"
@interface CheckOutAddressVW ()

@end

@implementation CheckOutAddressVW
@synthesize POPView;
- (void)viewDidLoad {
    self.navigationController.navigationBar.hidden=YES;

    [super viewDidLoad];
    NSMutableArray *Userdata=[AppDelegate GetData:@"LoginUserDic"];
    NSString *customer_name = [[[[[[[Userdata valueForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"myProfile"] objectForKey:@"customer_name"];
    NSString *customer_email = [[[[[[[Userdata valueForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"myProfile"] objectForKey:@"email"];
    self.UserName_LBL.text=customer_name;
    self.UserEmail_LBL.text=customer_email;
    
    
    POPView = [[[NSBundle mainBundle] loadNibNamed:@"AlertViewAddAddress" owner:nil options:nil] firstObject];
    POPView.frame = self.view.frame;
    
    POPView.hidden=YES;
    POPView.alpha = 0;
    
    [POPView.Applay_BTN addTarget:self action:@selector(ApplyAddress_Click:) forControlEvents:UIControlEventTouchUpInside];
    [POPView.Cancel_BTN addTarget:self action:@selector(CancelAddress_Click:) forControlEvents:UIControlEventTouchUpInside];
    
    self.CollectionView.hidden=NO;
    self.DeliveryView.hidden=YES;
    
    self.GrandTotal_LBL.text=self.GrandTotal;
    self.Discount_LBL.text=self.Discount;
    
    //Set Collection DatePicker
    datepicker = [[UIDatePicker alloc]init];
    [datepicker setDate:[NSDate date]]; //this returns today's date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *string = [formatter stringFromDate:[NSDate date]];
    NSString *maxDateStringforad = string;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDate *theMaximumDateforad = [dateFormatter dateFromString: maxDateStringforad];
    [datepicker setMaximumDate:theMaximumDateforad]; //the min age restriction
    // set the mode
    [datepicker setDatePickerMode:UIDatePickerModeDateAndTime];
    [datepicker addTarget:self action:@selector(CollTimeTextField:) forControlEvents:UIControlEventValueChanged];
    [self.CollectionTimeTXT setInputView:datepicker];
    
    //Set Delivery DatePicker
    datepicke1 = [[UIDatePicker alloc]init];
    [datepicke1 setDate:[NSDate date]]; //this returns today's date
    formatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    [datepicke1 setMaximumDate:theMaximumDateforad]; //the min age restriction
    // set the mode
    [datepicke1 setDatePickerMode:UIDatePickerModeDateAndTime];
    [datepicke1 addTarget:self action:@selector(DeliveyTimeTextField:) forControlEvents:UIControlEventValueChanged];
    [self.DeliveryTimeTXT setInputView:datepicke1];
    
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
        [self AcceptedOrderTypes];
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    // Do any additional setup after loading the view.
}
-(void)CollTimeTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.CollectionTimeTXT.inputView;
    self.CollectionTime_LBL.text = [self formatDate:picker.date];
  
}
-(void)DeliveyTimeTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.DeliveryTimeTXT.inputView;
    self.DeliveryTime_LBL.text = [self formatDate:picker.date];
}
- (NSString *)formatDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    
    [dateFormatter setDateFormat:@"EEEE"];
    NSLog(@"%@",[dateFormatter stringFromDate:date]);
    [self Discount:[dateFormatter stringFromDate:date]];
    return formattedDate;
}

-(void)AcceptedOrderTypes
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    [dictSub setObject:@"getAcceptedOrderTypes" forKey:@"METHOD"];
    
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
    NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,ORDERTYPE];
    [Utility postRequest:json url:makeURL success:^(id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"getAcceptedOrderTypes"] objectForKey:@"SUCCESS"];
        if ([SUCCESS boolValue] ==YES)
        {
            getAcceptedOrderTypes=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"getAcceptedOrderTypes"] objectForKey:@"RESULT"] objectForKey:@"getAcceptedOrderTypes"];
            
            NSLog(@"getAcceptedOrderTypes==%@",getAcceptedOrderTypes);
            
            if ([getAcceptedOrderTypes isEqualToString:@"Collection & Delivery"])
            {
                self.CollectionBtn.hidden=NO;
                self.DeliveryBtn.hidden=NO;
                self.CollectionView.hidden=NO;
                self.DeliveryView.hidden=YES;
                UserOrderType=@"Collection";
            }
            else if ([getAcceptedOrderTypes isEqualToString:@"Collection"])
            {
                [self.CollectionBtn setImage:[UIImage imageNamed:@"RadioON"] forState:UIControlStateNormal];
                self.CollectionBtn.hidden=NO;
                self.DeliveryBtn.hidden=YES;
                self.CollectionView.hidden=NO;
                self.DeliveryView.hidden=YES;
                 UserOrderType=@"Collection";
            }
            else
            {
                [self.DeliveryBtn setImage:[UIImage imageNamed:@"RadioON"] forState:UIControlStateNormal];
                
                self.CollectionBtn.hidden=YES;
                self.DeliveryBtn.hidden=NO;
                self.CollectionView.hidden=YES;
                self.DeliveryView.hidden=NO;
                 UserOrderType=@"Delivery";
            }
        }

        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"Fail");
    }];
    
}
- (IBAction)Radio_Collection_Delivery_Click:(id)sender
{
    [self.CollectionBtn setImage:[UIImage imageNamed:@"RadioON"] forState:UIControlStateNormal];
    [self.DeliveryBtn setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
   
    switch ([sender tag])
    {
        case 0:
            if([self.CollectionBtn isSelected]==YES)
            {
                [self.CollectionBtn setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
                [self.DeliveryBtn setImage:[UIImage imageNamed:@"RadioON"] forState:UIControlStateNormal];
                self.CollectionView.hidden=YES;
                self.DeliveryView.hidden=NO;
                 UserOrderType=@"Delivery";
            }
            else{
                [self.CollectionBtn setImage:[UIImage imageNamed:@"RadioON"] forState:UIControlStateNormal];
                [self.DeliveryBtn setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
                self.CollectionView.hidden=NO;
                self.DeliveryView.hidden=YES;
                 UserOrderType=@"Collection";
                
            }
            
            break;
        case 1:
            if([self.DeliveryBtn isSelected]==YES)
            {
                [self.DeliveryBtn setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
                [self.CollectionBtn setImage:[UIImage imageNamed:@"RadioON"] forState:UIControlStateNormal];
                self.CollectionView.hidden=NO;
                self.DeliveryView.hidden=YES;
                UserOrderType=@"Collection";
                
            }
            else{
                [self.DeliveryBtn setImage:[UIImage imageNamed:@"RadioON"] forState:UIControlStateNormal];
                [self.CollectionBtn setImage:[UIImage imageNamed:@"RadioOFF"] forState:UIControlStateNormal];
                self.CollectionView.hidden=YES;
                self.DeliveryView.hidden=NO;
                 UserOrderType=@"Delivery";
            }
            
            break;
        default:
            break;
    }
}
-(void)Discount:(NSString *)day
{
   
    self.GrandTotal = [ self.GrandTotal stringByReplacingOccurrencesOfString:@"£"  withString:@""];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    
    NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
    [dictInner setObject:self.GrandTotal forKey:@"TOTALSUM"];
    [dictInner setObject:day forKey:@"DAY"];
    [dictInner setObject:UserOrderType forKey:@"ORDERTYPE"];
    
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    [dictSub setObject:@"orderDiscount" forKey:@"METHOD"];
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
    NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,DISCOUNT];
    [Utility postRequest:json url:makeURL success:^(id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"orderDiscount"] objectForKey:@"SUCCESS"];
        if ([SUCCESS boolValue] ==YES)
        {
            orderDiscount=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"orderDiscount"] objectForKey:@"RESULT"] objectForKey:@"orderDiscount"];
            
            self.GrandTotal_LBL.text=[NSString stringWithFormat:@"£%@",[orderDiscount objectForKey:@"totalprice"]];
            self.Discount_LBL.text=[NSString stringWithFormat:@"£%@",[orderDiscount objectForKey:@"discount"]];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"Fail");
    }];
    
}
- (IBAction)SetAddress_Click:(id)sender
{
    [self ShowPopUpAnimation];
    
}
-(void)ApplyAddress_Click:(id)sender
{
    
    if ([POPView.StreetTXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter street" delegate:nil];
    }
    else if ([POPView.HouseNoNameTXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter House No/Name" delegate:nil];
    }
    else if ([POPView.TownTXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Town" delegate:nil];
    }
    else if ([POPView.StateTXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter State" delegate:nil];
    }
    else if ([POPView.PostCodeTXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter post code" delegate:nil];
    }
    else if ([POPView.ContactNumberTXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter mobile number" delegate:nil];
    }
    else if ([POPView.CountryTXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter country" delegate:nil];
    }
    else
    {
        NSString *fulladd=[NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@",POPView.HouseNoNameTXT.text,POPView.StreetTXT.text,POPView.TownTXT.text,POPView.StateTXT.text,POPView.PostCodeTXT.text ,POPView.ContactNumberTXT.text,POPView.ContactNumberTXT.text];
        
        self.FullAddress_LBL.text=fulladd;
        [self HidePopUpAnimation];
    }
}
-(void)CancelAddress_Click:(id)sender
{
    [self HidePopUpAnimation];
}

#pragma mark - POPUP CODE

-(void)ShowPopUpAnimation
{
    [self.view endEditing:YES];
    POPView.alpha = 0;
    [KmyappDelegate.window addSubview:POPView];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        POPView.hidden=NO;
        POPView.alpha = 1;
        
        POPView.BackView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        POPView.BackView.frame = CGRectMake(SCREEN_WIDTH/2 - 150, SCREEN_HEIGHT/2 - 90,300, 200);
        
    } completion:^(BOOL finished) {
        
    }];
}

-(void)HidePopUpAnimation
{
    [UIView animateWithDuration:0.175 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        POPView.alpha = 0;
        POPView.BackView.transform = CGAffineTransformMakeScale(0.9, 0.9);
        
    } completion:^(BOOL finished) {
        
        POPView.hidden=YES;
        [POPView removeFromSuperview];
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)BackBtn_Click:(id)sender
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
