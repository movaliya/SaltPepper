//
//  ReservationSubVW.h
//  MirchMasala
//
//  Created by Mango SW on 09/09/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReservationSubVW : UIViewController
{
    NSString *Hour,*Mint,*ReservationDate,*ReservationTime;
}
@property (weak, nonatomic) IBOutlet UILabel *lblCartCount;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITextField *SelectDate_TXT;
@property (weak, nonatomic) IBOutlet UITextField *Ault14_TXT;
@property (weak, nonatomic) IBOutlet UITextField *Children_TXT;
@property (weak, nonatomic) IBOutlet UITextField *ComingTime_TXT;
@property (weak, nonatomic) IBOutlet UITextField *StayTime_TXT;
@property (weak, nonatomic) IBOutlet UITextField *infantsAge_TXT;

@end
