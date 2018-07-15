//
//  RegisterVW.h
//  SaltPepper
//
//  Created by jignesh solanki on 12/03/2018.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>

@interface RegisterVW : UIViewController<GIDSignInUIDelegate,GIDSignInDelegate>
{
    NSMutableDictionary *FBSignIndictParams;
}
@property (weak, nonatomic) IBOutlet UIButton *ShowHidePassBTN1;
@property (weak, nonatomic) IBOutlet UITextField *Name_TXT;
@property (weak, nonatomic) IBOutlet UIButton *ShowHidePassBTN2;

@property (weak, nonatomic) IBOutlet UITextField *Email_TXT;
@property (weak, nonatomic) IBOutlet UITextField *Password_TXT;
@property (weak, nonatomic) IBOutlet UITextField *LastName_TXT;
@property (weak, nonatomic) IBOutlet UITextField *ConfirmPasswd_TXT;
@property (weak, nonatomic) IBOutlet UIButton *RegisterBtn;

@end
