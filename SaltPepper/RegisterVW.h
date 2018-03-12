//
//  RegisterVW.h
//  SaltPepper
//
//  Created by jignesh solanki on 12/03/2018.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterVW : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *Name_TXT;

@property (weak, nonatomic) IBOutlet UITextField *Email_TXT;
@property (weak, nonatomic) IBOutlet UITextField *Password_TXT;
@property (weak, nonatomic) IBOutlet UITextField *Mobile_TXT;
@property (weak, nonatomic) IBOutlet UITextField *ConfirmPasswd_TXT;
@property (weak, nonatomic) IBOutlet UIButton *RegisterBtn;

@end
