//
//  ReservationVW.h
//  MirchMasala
//
//  Created by Mango SW on 09/09/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReservationVW : UIViewController
@property (weak, nonatomic) IBOutlet UIView *BackView;
@property (weak, nonatomic) IBOutlet UITextField *NameTXT;
@property (weak, nonatomic) IBOutlet UITextField *PhoneNumberTXT;
@property (weak, nonatomic) IBOutlet UITextField *EmailTXT;
@property (weak, nonatomic) IBOutlet UITextField *MessageTXT;

@property (strong, nonatomic) NSString *aultNo;
@property (strong, nonatomic) NSString *childerNo;
@property (strong, nonatomic) NSString *Res_Time;
@property (strong, nonatomic) NSString *Res_date;
@property (strong, nonatomic) NSString *Stay_Hour;
@property (strong, nonatomic) NSString *Stay_Mint;
@property (strong, nonatomic) NSString *InfantsNo;



@end
