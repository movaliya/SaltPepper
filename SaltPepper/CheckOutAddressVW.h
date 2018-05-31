//
//  CheckOutAddressVW.h
//  SaltPepper
//
//  Created by jignesh solanki on 30/05/2018.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertViewAddAddress.h"

@interface CheckOutAddressVW : UIViewController
{
    NSString *getAcceptedOrderTypes;
    NSDictionary *orderDiscount;
    UIDatePicker *datepicker,*datepicke1;
    UIBarButtonItem *rightBtn;
    NSString *UserOrderType;
}
@property (strong, nonatomic) NSString *GrandTotal;
@property (strong, nonatomic) NSString *Discount;


@property (weak, nonatomic) IBOutlet UILabel *UserName_LBL;
@property (weak, nonatomic) IBOutlet UILabel *UserEmail_LBL;
@property (weak, nonatomic) IBOutlet UIButton *CollectionBtn;
@property (weak, nonatomic) IBOutlet UIButton *DeliveryBtn;
@property (weak, nonatomic) IBOutlet UIView *CollectionView;
@property (weak, nonatomic) IBOutlet UIView *DeliveryView;
@property (weak, nonatomic) IBOutlet UIButton *AddAddressBtn;
@property (weak, nonatomic) IBOutlet UILabel *FullAddress_LBL;
@property (weak, nonatomic) IBOutlet UILabel *DeliveryTime_LBL;
@property (weak, nonatomic) IBOutlet UILabel *CollectionTime_LBL;
@property (weak, nonatomic) IBOutlet UILabel *Discount_LBL;
@property (weak, nonatomic) IBOutlet UILabel *GrandTotal_LBL;
@property (weak, nonatomic) IBOutlet UITextField *DeliveryTimeTXT;
@property (weak, nonatomic) IBOutlet UITextField *CollectionTimeTXT;

@property (strong,nonatomic)AlertViewAddAddress *POPView;

@end
