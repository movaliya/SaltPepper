//
//  ProfileView.m
//  SaltPepper
//
//  Created by kaushik on 26/05/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "ProfileView.h"

@interface ProfileView ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>

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
   
    [self performSelector:@selector(Updateslider) withObject:nil afterDelay:1.0f];
    
    [self updateButton:BasicUpdate_BTN];
    [self updateButton:BasicCancel_BTN];
    [self updateButton:Logout_BTN];
    
}
-(void)Updateslider
{
    self.UpdateSlider.value=70.0f;
    self.UpdateSlider.popover.textLabel.text = [NSString stringWithFormat:@"%.2f", 70.00f];
    [UIView animateWithDuration:3
                     animations:^{
                         
                         [self.view setNeedsLayout];
                     }];

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
