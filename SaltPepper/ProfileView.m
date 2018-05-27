//
//  ProfileView.m
//  SaltPepper
//
//  Created by kaushik on 26/05/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "ProfileView.h"


@interface ProfileView ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ASProgressPopUpViewDataSource>

@end

@implementation ProfileView
@synthesize BasicDetail_BTN,BasicDetailHight,BasicArrowIMG,BasicCancel_BTN,BasicUpdate_BTN,Search_BTN,UserIMG;
@synthesize MobileNO_TXT,Street_TXT,PostCode_TXT,HouseNO_TXT,Town_TXT,Country_TXT,DOB_TXT,Anniversary_TXT,State_TXT,Logout_BTN;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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
    
}

-(void)GetProfileDetail
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSString *CutomerID = [[[[[[_ro(@"LoginUserDic") objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
    
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
            
            ProfileData=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"myProfile"] objectForKey:@"SUCCESS"];
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
    
    [self.UpdateSlider setProgress:0.5 animated:YES];

    

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
        
    }
    else
    {
        
    }
}

- (IBAction)LogOut_Click:(id)sender
{
    
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
