//
//  ProfileView.h
//  SaltPepper
//
//  Created by kaushik on 26/05/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NYSliderPopover.h"

@interface ProfileView : UIViewController

- (IBAction)Back_Click:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *UserIMG;
@property (strong, nonatomic) IBOutlet UILabel *Name_LBL;
@property (strong, nonatomic) IBOutlet UIButton *BasicDetail_BTN;
- (IBAction)BasicDeatil_Click:(id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *BasicDetailHight;
@property (strong, nonatomic) IBOutlet UIImageView *BasicArrowIMG;
@property (strong, nonatomic) IBOutlet UITextField *MobileNO_TXT;
@property (strong, nonatomic) IBOutlet UITextField *PostCode_TXT;
@property (strong, nonatomic) IBOutlet UITextField *HouseNO_TXT;
@property (strong, nonatomic) IBOutlet UITextField *Street_TXT;
@property (strong, nonatomic) IBOutlet UITextField *Town_TXT;
@property (strong, nonatomic) IBOutlet UITextField *State_TXT;
@property (strong, nonatomic) IBOutlet UIButton *Search_BTN;
- (IBAction)Search_Click:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *Country_TXT;
@property (strong, nonatomic) IBOutlet UITextField *DOB_TXT;
@property (strong, nonatomic) IBOutlet UITextField *Anniversary_TXT;

@property (strong, nonatomic) IBOutlet UIButton *BasicUpdate_BTN;
@property (strong, nonatomic) IBOutlet UIButton *BasicCancel_BTN;
- (IBAction)BasicUpdate_Click:(id)sender;
- (IBAction)LogOut_Click:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *Logout_BTN;
@property (strong, nonatomic) IBOutlet NYSliderPopover *UpdateSlider;
- (IBAction)ImageBTN_Click:(id)sender;

@end