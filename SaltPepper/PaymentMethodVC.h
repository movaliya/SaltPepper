//
//  PaymentMethodVC.h
//  SaltPepper
//
//  Created by Dharmraj Vora on 02/06/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentMethodVC : UIViewController

@property (weak, nonatomic) IBOutlet UIView *viewDetail;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UIButton *btnCredit;
@property (weak, nonatomic) IBOutlet UIButton *btnPayOnCollection;
@property (weak, nonatomic) IBOutlet UIButton *btnConfirmPayment;
@property (weak, nonatomic) IBOutlet UIView *viewCredit;
@property (weak, nonatomic) IBOutlet UIView *viewPayOn;
@property (weak, nonatomic) IBOutlet UIView *viewName;
@property (weak, nonatomic) IBOutlet UIView *viewNumber;
@property (weak, nonatomic) IBOutlet UIView *viewExpireDate;
@property (weak, nonatomic) IBOutlet UIView *viewCVV;
@property (weak, nonatomic) IBOutlet UITextField *txtCardName;
@property (weak, nonatomic) IBOutlet UITextField *txtCardNumber;
@property (weak, nonatomic) IBOutlet UITextField *txtExipireDate;
@property (weak, nonatomic) IBOutlet UITextField *txtCVV;


@end
