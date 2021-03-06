//
//  ProfileView.m
//  SaltPepper
//
//  Created by kaushik on 26/05/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "ProfileView.h"
#import "saltPepper.pch"
#import <FacebookSDK/FacebookSDK.h>


@interface ProfileView ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ASProgressPopUpViewDataSource>
{
    UIDatePicker *DOBdatePicker,*ADdatePicker;
}

@end

@implementation ProfileView
@synthesize BasicDetail_BTN,BasicDetailHight,BasicArrowIMG,BasicCancel_BTN,BasicUpdate_BTN,Search_BTN,UserIMG;
@synthesize MobileNO_TXT,Street_TXT,PostCode_TXT,HouseNO_TXT,Town_TXT,Country_TXT,DOB_TXT,Anniversary_TXT,State_TXT,Logout_BTN;

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(IS_IPHONE_X)
    {
        _headerHeight.constant = 90;
    }
    else
    {
        _headerHeight.constant = 70;
    }
    
    UserIMG.layer.cornerRadius=60.0f;
    UserIMG.layer.masksToBounds=YES;
    
    [ self.navDownView.layer setShadowColor:[UIColor grayColor].CGColor];
    [ self.navDownView.layer setShadowOpacity:0.8];
    [ self.navDownView.layer setShadowRadius:3.0];
    [ self.navDownView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
   
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden=YES;
    
   

    BasicDetailHight.constant=50.0f;
    [self ShowhideBasicDetailViewData:YES];
   
    [self performSelector:@selector(Updateslider:) withObject:nil afterDelay:1.0f];
    
    [self updateButton:BasicUpdate_BTN];
    [self updateButton:BasicCancel_BTN];
    [self updateButton:Logout_BTN];
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        [self GetProfileDetail];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
    //Set DOB DatePicker
    DOBdatePicker = [[UIDatePicker alloc]init];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSDate *currentDate = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:[NSDate date]];
    
    NSInteger year = components.year;
    NSInteger month = components.month;
    NSInteger day = components.day;
    NSInteger minimumYear = year - 1900;//Given some year here for example
    NSInteger minimumMonth = month - 1;
    NSInteger minimumDay = day - 1;
    [comps setYear:-minimumYear];
    [comps setMonth:-minimumMonth];
    [comps setDay:-minimumDay];
    NSDate *minDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    
    [DOBdatePicker setMinimumDate:minDate];
    [DOBdatePicker setMaximumDate:[NSDate date]];
    
    // repeat the same logic for theMinimumDate if needed
    
   // [DOBdatePicker setMaximumDate:theMaximumDate]; //the min age restriction
    //[DOBdatePicker setMinimumDate:theMinimumDate]; //the max age restriction (if needed, or else dont use this line)
    
    // set the mode
    [DOBdatePicker setDatePickerMode:UIDatePickerModeDate];
    [DOBdatePicker addTarget:self action:@selector(updateDOBTextField:) forControlEvents:UIControlEventValueChanged];
    [DOB_TXT setInputView:DOBdatePicker];
    
    //Set AD DatePicker
    ADdatePicker = [[UIDatePicker alloc]init];
    [ADdatePicker setDate:[NSDate date]]; //this returns today's date
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    NSString *string = [formatter stringFromDate:[NSDate date]];
    NSString *maxDateStringforad = string;
    // NSString *minDateString = @"01-Jan-1950";
    
    //NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // dateFormatter.dateFormat = @"dd-MMM-yyyy";
    NSDate *theMaximumDateforad = [formatter dateFromString: maxDateStringforad];
    //NSDate *theMinimumDate = [dateFormatter dateFromString: minDateString];
    
    // repeat the same logic for theMinimumDate if needed
    
    [ADdatePicker setMaximumDate:theMaximumDateforad]; //the min age restriction
    // [ADdatePicker setMinimumDate:theMinimumDate]; //the max age restriction (if needed, or else dont use this line)
    
    // set the mode
    [ADdatePicker setDatePickerMode:UIDatePickerModeDate];
    [ADdatePicker addTarget:self action:@selector(updateADTextField:) forControlEvents:UIControlEventValueChanged];
    [Anniversary_TXT setInputView:ADdatePicker];
    
    
    
    
}
-(void)updateDOBTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)DOB_TXT.inputView;
    DOB_TXT.text = [self formatDate:picker.date];
}

-(void)updateADTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)Anniversary_TXT.inputView;
    Anniversary_TXT.text = [self formatDate:picker.date];
}

- (NSString *)formatDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == Anniversary_TXT)
    {
        Anniversary_TXT.text = [self formatDate:[NSDate date]];
    }
    if (textField == DOB_TXT)
    {
        DOB_TXT.text = [self formatDate:[NSDate date]];
    }
}

-(void)GetProfileDetail
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   // NSMutableArray *Userdata=[AppDelegate GetData:@"LoginUserDic"];
   // NSString *CutomerID = [[[[[[Userdata valueForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
    NSString *CutomerID=_ro(@"LoginUserDic");

    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    
    NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
    [dictInner setObject:CutomerID forKey:@"CUSTOMERID"];
    
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
    // NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,GETPROFILE];
    
    [Utility postRequest:json url:makeURL success:^(id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"responseObject==%@",responseObject);
        NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"myProfile"] objectForKey:@"SUCCESS"];
        if ([SUCCESS boolValue] ==YES)
        {
            ProgressValue=0.0;
            ProfileData=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"myProfile"] objectForKey:@"result"]objectForKey:@"myProfile"];
            NSString *profileDetl=@"Male";
            
            if ([ProfileData valueForKey:@"customerName"] != (id)[NSNull null])
            {
                self.Name_LBL.text=[ProfileData valueForKey:@"customerName"];
                 ProgressValue=ProgressValue+0.1;
            }
            if ([ProfileData valueForKey:@"mobile"] != (id)[NSNull null])
            {
                MobileNO_TXT.text=[ProfileData valueForKey:@"mobile"];
               ProgressValue=ProgressValue+0.1;
            }
            if ([ProfileData valueForKey:@"postCode"] != (id)[NSNull null])
            {
                PostCode_TXT.text=[ProfileData valueForKey:@"postCode"];
                ProgressValue=ProgressValue+0.1;
            }
            if ([ProfileData valueForKey:@"houseNo"] != (id)[NSNull null])
            {
                HouseNO_TXT.text=[ProfileData valueForKey:@"houseNo"];
                ProgressValue=ProgressValue+0.1;
            }
            if ([ProfileData valueForKey:@"street"] != (id)[NSNull null])
            {
                Street_TXT.text=[ProfileData valueForKey:@"street"];
                ProgressValue=ProgressValue+0.1;
            }
            if ([ProfileData valueForKey:@"post_town"] != (id)[NSNull null])
            {
                Town_TXT.text=[ProfileData valueForKey:@"post_town"];
                ProgressValue=ProgressValue+0.1;
            }
            if ([ProfileData valueForKey:@"state"] != (id)[NSNull null])
            {
                State_TXT.text=[ProfileData valueForKey:@"state"];
                ProgressValue=ProgressValue+0.1;
            }
            if ([ProfileData valueForKey:@"dateOfBirth"] != (id)[NSNull null])
            {
                DOB_TXT.text=[ProfileData valueForKey:@"dateOfBirth"];
                ProgressValue=ProgressValue+0.1;
                NSString *DOBYEAR=[DOB_TXT.text substringToIndex:4];
                if (![DOBYEAR isEqualToString:@"0000"]) {
                      profileDetl=[NSString stringWithFormat:@"%@,%@",profileDetl,DOBYEAR];
                }
            }
            if ([ProfileData valueForKey:@"country"] != (id)[NSNull null])
            {
                Country_TXT.text=[ProfileData valueForKey:@"country"];
                profileDetl=[NSString stringWithFormat:@"%@,%@",profileDetl,Country_TXT.text];
                ProgressValue=ProgressValue+0.1;
            }
            if ([ProfileData valueForKey:@"anniverseryDate"] != (id)[NSNull null])
            {
                Anniversary_TXT.text=[ProfileData valueForKey:@"anniverseryDate"];
               ProgressValue=ProgressValue+0.1;
            }
            NSString *tempSTR=[NSString stringWithFormat:@"%@ point %@ order",[ProfileData valueForKey:@"membership_points"],[ProfileData valueForKey:@"nooforder"]];
            
            NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:tempSTR];
            
            [string1 setColorForText:@"point" withColor:[UIColor grayColor]];
            [string1 setColorForText:@"order" withColor:[UIColor grayColor]];
            self.profilePoint_LBL.attributedText = string1;
            
            self.ProfileDetail_LBL.text=profileDetl;
             [self performSelector:@selector(Updateslider:) withObject:nil afterDelay:1.0f];
        }
        else
        {
            NSString *DESCRIPTION=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"myProfile"] objectForKey:@"ERROR"] objectForKey:@"DESCRIPTION"];
            [AppDelegate showErrorMessageWithTitle:@"" message:DESCRIPTION delegate:nil];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"Fail");
        
    }];

}


-(void)Updateslider :(float)val
{
    self.UpdateSlider.popUpViewCornerRadius = 15.0f;
    self.UpdateSlider.font = [UIFont boldSystemFontOfSize:12];
    self.UpdateSlider.popUpViewAnimatedColors = @[[UIColor colorWithRed:123.0f/255.0f green:11.0f/255.0f blue:12.0f/255.0f alpha:1.0f],[UIColor colorWithRed:123.0f/255.0f green:11.0f/255.0f blue:12.0f/255.0f alpha:1.0f]];
    
    [self.UpdateSlider showPopUpViewAnimated:YES];
    
    [self.UpdateSlider setProgress:ProgressValue animated:YES];

    

}

-(void)ShowhideBasicDetailViewData :(BOOL)Status
{
    MobileNO_TXT.hidden=Status;
    HouseNO_TXT.hidden=Status;
    PostCode_TXT.hidden=Status;
    Street_TXT.hidden=Status;
    Town_TXT.hidden=Status;
    State_TXT.hidden=Status;
    Country_TXT.hidden=Status;
    DOB_TXT.hidden=Status;
    Anniversary_TXT.hidden=Status;
    BasicUpdate_BTN.hidden=Status;
    BasicCancel_BTN.hidden=Status;
    Search_BTN.hidden=Status;
    
}
-(void)updateButton :(UIButton *)BTN
{
    BTN.layer.cornerRadius=20.0f;
    BTN.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    BTN.layer.borderWidth=1.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)Back_Click:(id)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];
}


- (IBAction)AddressUpdate_Click:(id)sender
{
    
}

- (IBAction)BasicDeatil_Click:(id)sender
{
    if (BasicDetail_BTN.selected==YES)
    {
        BasicDetail_BTN.selected=NO;
        BasicDetailHight.constant = 50.0f;
        [UIView animateWithDuration:1
                         animations:^{
                             [self.view setNeedsLayout];
                             [self ShowhideBasicDetailViewData:YES];
                             BasicArrowIMG.image=[UIImage imageNamed:@"RightArrow"];
                         }];
    }
    else
    {
        BasicDetail_BTN.selected=YES;
        BasicDetailHight.constant = 542.0f;
        [UIView animateWithDuration:1
                         animations:^{
                             [self.view setNeedsLayout];
                             [self ShowhideBasicDetailViewData:NO];
                             BasicArrowIMG.image=[UIImage imageNamed:@"DownArrow"];
                         }];
    }
}

- (IBAction)BasicUpdate_Click:(id)sender
{
    if ([sender isEqual:BasicUpdate_BTN])
    {
        if ([Street_TXT.text isEqualToString:@""])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter street" delegate:nil];
        }
        else if ([PostCode_TXT.text isEqualToString:@""])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter post code" delegate:nil];
        }
        else if ([MobileNO_TXT.text isEqualToString:@""])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter mobile number" delegate:nil];
        }
        else if ([Country_TXT.text isEqualToString:@""])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter country" delegate:nil];
        }
        else
        {
            BOOL internet=[AppDelegate connectedToNetwork];
            if (internet)
            {
                [self UpdateUserProfileData];
            }
            else
                [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        }
    }
    else
    {
        
    }
}
-(void)UpdateUserProfileData
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
   //  NSMutableArray *Userdata=[AppDelegate GetData:@"LoginUserDic"];
    // NSString *CutomerID = [[[[[[Userdata valueForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
     NSString *CutomerID=_ro(@"LoginUserDic");
    if (CutomerID)
    {
        NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
        
        [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
        
        
        NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
        
        [dictInner setObject:CutomerID forKey:@"CUSTOMERID"];
        [dictInner setObject:Street_TXT.text forKey:@"STREET"];
        [dictInner setObject:PostCode_TXT.text forKey:@"POSTCODE"];
        [dictInner setObject:Country_TXT.text forKey:@"COUNTRY"];
        [dictInner setObject:MobileNO_TXT.text forKey:@"MOBILE"];
        
        NSString *profileDetl=@"Male";
        if (![HouseNO_TXT.text isEqualToString:@""]) {
            [dictInner setObject:HouseNO_TXT.text forKey:@"HOUSENO"];
        }
        
        if (![Town_TXT.text isEqualToString:@""]) {
            [dictInner setObject:Town_TXT.text forKey:@"TOWN"];
        }
        if (![State_TXT.text isEqualToString:@""]) {
            [dictInner setObject:State_TXT.text forKey:@"STATE"];
        }
        if (![DOB_TXT.text isEqualToString:@""])
        {
            NSString *DOBYEAR=[DOB_TXT.text substringToIndex:4];
            if (![DOBYEAR isEqualToString:@"0000"]) {
                profileDetl=[NSString stringWithFormat:@"%@,%@",profileDetl,DOBYEAR];
            }
            [dictInner setObject:DOB_TXT.text forKey:@"DATEOFBIRTH"];
        }
        if (![Anniversary_TXT.text isEqualToString:@""]) {
            [dictInner setObject:Anniversary_TXT.text forKey:@"ANNIVERSARYDATE"];
            NSLog(@"anniveryDate=%@",Anniversary_TXT.text);
        }
         profileDetl=[NSString stringWithFormat:@"%@,%@",profileDetl,Country_TXT.text];
        NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
        
        [dictSub setObject:@"putitem" forKey:@"MODULE"];
        
        [dictSub setObject:@"myProfile" forKey:@"METHOD"];
        
        [dictSub setObject:dictInner forKey:@"PARAMS"];
        
        
        NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
        NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
        
        [dictREQUESTPARAM setObject:arr forKey:@"REQUESTPARAM"];
        [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
        
        
        NSError* error = nil;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
        
        NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,UPDATEPROFILE];
        
        [Utility postRequest:json url:makeURL success:^(id responseObject) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSLog(@"responseObject==%@",responseObject);
            NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"putitem"] objectForKey:@"myProfile"] objectForKey:@"SUCCESS"];
            if ([SUCCESS boolValue] ==YES)
            {
                self.ProfileDetail_LBL.text=profileDetl;
                NSString *DESCRIPTION=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"putitem"] objectForKey:@"myProfile"] objectForKey:@"result"] objectForKey:@"myProfile"];
                [AppDelegate showErrorMessageWithTitle:@"" message:DESCRIPTION delegate:nil];
            }
            else
            {
                NSString *DESCRIPTION=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"putitem"] objectForKey:@"myProfile"] objectForKey:@"ERROR"] objectForKey:@"DESCRIPTION"];
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

- (IBAction)LogOut_Click:(id)sender
{
    FCAlertView *alert = [KmyappDelegate ShowAlertWithBtnAction:@"Are you sure want to Logout?" andStrTile:nil andbtnTitle:@"NO" andButtonArray:@[]];
    
    [alert addButton:@"YES" withActionBlock:^{
        
        _Rm(@"LoginUserDic")
        _Rm(@"CartDIC")
        _Rm(@"FavDIC")
        KmyappDelegate.MainCartArr.removeAllObjects;
        [[GIDSignIn sharedInstance] signOut];
        FBSession* session = [FBSession activeSession];
        [session closeAndClearTokenInformation];
        [session close];
        [FBSession setActiveSession:nil];
        
        
        [self.sideMenuViewController hideMenuViewController];
        DEMORootViewController *vcr = [[UIStoryboard storyboardWithName:[SharedClass sharedSingleton].storyBaordName  bundle:nil] instantiateViewControllerWithIdentifier:@"rootController"];
        [self.navigationController pushViewController:vcr animated:YES];
        
    }];
}

- (IBAction)Search_Click:(id)sender
{
    if ([PostCode_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter post code" delegate:nil];
    }
    else
    {
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
        {
            [self SearchForPostcode];
        }
        else
            [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    }
}
-(void)SearchForPostcode
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
    [dictInner setObject:PostCode_TXT.text forKey:@"POSTCODE"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    [dictSub setObject:@"action" forKey:@"MODULE"];
    [dictSub setObject:@"LookUp" forKey:@"METHOD"];
    [dictSub setObject:dictInner forKey:@"PARAMS"];

    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
    NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
    
    [dictREQUESTPARAM setObject:arr forKey:@"REQUESTPARAM"];
    [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
    
    NSError* error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,LOOKUP];
    
    [Utility postRequest:json url:makeURL success:^(id responseObject)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"putitem"] objectForKey:@"LookUp"] objectForKey:@"SUCCESS"];
         if ([SUCCESS boolValue] ==YES)
         {
             NSMutableDictionary *PostcodeData=[[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"putitem"] objectForKey:@"LookUp"] objectForKey:@"result"] objectForKey:@"LookUp"] mutableCopy];
             Street_TXT.text=[PostcodeData objectForKey:@"street"];
             Town_TXT.text=[PostcodeData objectForKey:@"post_town"];
             
         }
        else
        {
            NSString *ERROR=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"putitem"] objectForKey:@"LookUp"] objectForKey:@"ERROR"]objectForKey:@"DESCRIPTION"];
            [AppDelegate showErrorMessageWithTitle:@"" message:ERROR delegate:nil];
            
        }
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"Fail");
        
    }];
}
- (IBAction)ImageBTN_Click:(id)sender
{
    [self OpenActionSheet];
}

-(void)OpenActionSheet
{
    UIAlertController* alert = [UIAlertController
                                alertControllerWithTitle:nil
                                message:nil
                                preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* button0 = [UIAlertAction
                              actionWithTitle:@"Cancel"
                              style:UIAlertActionStyleCancel
                              handler:^(UIAlertAction * action)
                              {
                                  
                              }];
    
    UIAlertAction* button = [UIAlertAction
                             actionWithTitle:@"Camera"
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action)
                             {
                                 [self openCamera];
                             }];
    
    UIAlertAction* button1 = [UIAlertAction
                              actionWithTitle:@"Gallery"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  [self OpenGallery];
                                  
                              }];
    
    [button setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    [button1 setValue:[UIColor blackColor] forKey:@"titleTextColor"];
    
    [alert addAction:button0];
    [alert addAction:button];
    [alert addAction:button1];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)OpenGallery
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

-(void)openCamera
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.allowsEditing = YES;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    UserIMG.image = chosenImage;
    
     [picker dismissViewControllerAnimated:YES completion:nil];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
     [picker dismissViewControllerAnimated:YES completion:nil];
}

@end
