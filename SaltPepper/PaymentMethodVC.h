//
//  PaymentMethodVC.h
//  SaltPepper
//
//  Created by Dharmraj Vora on 02/06/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaymentMethodVC : UIViewController
{
    NSString *payType;
    NSMutableArray *Userdata;
    NSString *PAIDAMOUNT,*PAYMENTTYPE;
    NSString *checkCardName;
    
    NSString *previousTextFieldContent;
    UITextRange *previousSelection;
    NSString *cyear;
    NSMutableArray *years;
    NSMutableArray *months;
    NSString *year;
    NSString *monthNo;
    NSMutableArray *CardTypeRegx;
    
}
@property (nonatomic) NSDecimalNumber *amount;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;

@property (strong, nonatomic) NSString *FinalTotal;
@property (strong, nonatomic) NSString *OrderType;
@property (strong, nonatomic) NSString *CommentTxt;
@property (strong, nonatomic) NSString *OrderDiscount;
@property (strong, nonatomic) NSMutableDictionary *UserProfileData;
@property (weak, nonatomic) IBOutlet UIImageView *CardImage;

@property (weak, nonatomic) IBOutlet UIView *viewDetail;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UILabel *lblPhone;
@property (weak, nonatomic) IBOutlet UILabel *lblAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderType;
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
