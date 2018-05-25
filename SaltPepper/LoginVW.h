//
//  LoginVW.h
//  SaltPepper
//
//  Created by jignesh solanki on 12/03/2018.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleSignIn/GoogleSignIn.h>

@interface LoginVW : UIViewController<GIDSignInUIDelegate,GIDSignInDelegate>


@property (weak, nonatomic) IBOutlet UIButton *LoginBtn;
@property (weak, nonatomic) IBOutlet UITextField *Email_TXT;
@property (weak, nonatomic) IBOutlet UITextField *Password_TXT;

@end
