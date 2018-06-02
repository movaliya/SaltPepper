//
//  ProfileView.m
//  SaltPepper
//
//  Created by kaushik on 26/05/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "ProfileView.h"
#import "saltPepper.pch"

@interface ProfileView ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ASProgressPopUpViewDataSource>
{
    UIDatePicker *DOBdatePicker,*ADdatePicker;
}

@end

@implementation ProfileView
@synthesize BasicDetail_BTN,BasicDetailHight,BasicArrowIMG,BasicCancel_BTN,BasicUpdate_BTN,Search_BTN,UserIMG;
@synthesize MobileNO_TXT,Street_TXT,PostCode_TXT,HouseNO_TXT,Town_TXT,Country_TXT,DOB_TXT,Anniversary_TXT,State_TXT,Logout_BTN;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self UpdateDataInDictnory];
    self.navigationController.navigationBar.hidden=YES;
    
    UserIMG.layer.cornerRadius=60.0f;
    UserIMG.layer.masksToBounds=YES;

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
    [DOBdatePicker setDate:[NSDate date]]; //this returns today's date
    
    
    NSString *maxDateString = @"01-Jan-2000";
    NSString *minDateString = @"01-Jan-1950";
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSDate *theMaximumDate = [dateFormatter dateFromString: maxDateString];
    NSDate *theMinimumDate = [dateFormatter dateFromString: minDateString];
    
    // repeat the same logic for theMinimumDate if needed
    
    [DOBdatePicker setMaximumDate:theMaximumDate]; //the min age restriction
    [DOBdatePicker setMinimumDate:theMinimumDate]; //the max age restriction (if needed, or else dont use this line)
    
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
    NSDate *theMaximumDateforad = [dateFormatter dateFromString: maxDateStringforad];
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

-(void)GetProfileDetail
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableArray *Userdata=[AppDelegate GetData:@"LoginUserDic"];
    NSString *CutomerID = [[[[[[Userdata valueForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
    
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
            if ([ProfileData valueForKey:@"country"] != (id)[NSNull null])
            {
                Country_TXT.text=[ProfileData valueForKey:@"country"];
                ProgressValue=ProgressValue+0.1;
            }
            if ([ProfileData valueForKey:@"dateOfBirth"] != (id)[NSNull null])
            {
                DOB_TXT.text=[ProfileData valueForKey:@"dateOfBirth"];
                ProgressValue=ProgressValue+0.1;
            }
            if ([ProfileData valueForKey:@"anniverseryDate"] != (id)[NSNull null])
            {
                Anniversary_TXT.text=[ProfileData valueForKey:@"anniverseryDate"];
               ProgressValue=ProgressValue+0.1;
            }
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
     NSMutableArray *Userdata=[AppDelegate GetData:@"LoginUserDic"];
     NSString *CutomerID = [[[[[[Userdata valueForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
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
        
        if (![HouseNO_TXT.text isEqualToString:@""]) {
            [dictInner setObject:HouseNO_TXT.text forKey:@"HOUSENO"];
        }
        
        if (![Town_TXT.text isEqualToString:@""]) {
            [dictInner setObject:Town_TXT.text forKey:@"TOWN"];
        }
        if (![State_TXT.text isEqualToString:@""]) {
            [dictInner setObject:State_TXT.text forKey:@"STATE"];
        }
        if (![DOB_TXT.text isEqualToString:@""]) {
            [dictInner setObject:DOB_TXT.text forKey:@"DATEOFBIRTH"];
        }
        if (![Anniversary_TXT.text isEqualToString:@""]) {
            [dictInner setObject:Anniversary_TXT.text forKey:@"ANNIVERSARYDATE"];
            NSLog(@"anniveryDate=%@",Anniversary_TXT.text);
        }
        
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
-(void)UpdateDataInDictnory
{
    NSMutableDictionary *Userdata=[[AppDelegate GetData:@"LoginUserDic"] mutableCopy];
    NSString *CutomerID = [[[[[[Userdata valueForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
    NSMutableDictionary *myProfile=[[[[[[[Userdata valueForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"myProfile"] mutableCopy];
    
    
    [myProfile setValue:@"123" forKey:@"mobile"];
    [Userdata setValue:myProfile forKey:@"myProfile"];
    NSLog(@"userdata=%@",Userdata);
    //[UserData setValue:Address2_TXT.text forKey:@"u_address2"];
}
- (IBAction)LogOut_Click:(id)sender
{
    FCAlertView *alert = [KmyappDelegate ShowAlertWithBtnAction:@"Are you sure want to Logout?" andStrTile:nil andbtnTitle:@"NO" andButtonArray:@[]];
    
    [alert addButton:@"YES" withActionBlock:^{
        
        _Rm(@"LoginUserDic")
        [[GIDSignIn sharedInstance] signOut];
        [self.sideMenuViewController hideMenuViewController];
        DEMORootViewController *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"rootController"];
        [self.navigationController pushViewController:vcr animated:YES];
        
    }];
}

- (IBAction)Search_Click:(id)sender
{
    
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
