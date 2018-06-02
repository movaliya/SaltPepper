//
//  CartVW.h
//  SaltPepper
//
//  Created by jignesh solanki on 28/05/2018.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlertViewPromoCode.h"
@interface CartVW : UIViewController
{
     NSInteger QTYINT;
    float subTotalINT;
    NSString *dayName;
}
@property (weak, nonatomic) IBOutlet UILabel *Quantity_LBL;
@property (weak, nonatomic) IBOutlet UILabel *SubTotalUpperLBL;
@property (weak, nonatomic) IBOutlet UILabel *SubTotal;
@property (weak, nonatomic) IBOutlet UILabel *Discount_LBL;
@property (weak, nonatomic) IBOutlet UILabel *GrandTotal_LBL;
@property (weak, nonatomic) IBOutlet UIButton *ProceedToPayBTN;
@property (weak, nonatomic) IBOutlet UIView *UpperView;
@property (weak, nonatomic) IBOutlet UITableView *TableVW;
@property (weak, nonatomic) IBOutlet UILabel *NotItem_LBL;
@property (weak, nonatomic) IBOutlet UIView *TotalView;
@property (weak, nonatomic) IBOutlet UIButton *ClearBtn;
@property (weak, nonatomic) IBOutlet UIButton *PromoBtn;

- (IBAction)ClearCart_Click:(id)sender;
- (IBAction)Promocode_Click:(id)sender;

@property (strong,nonatomic)AlertViewPromoCode *POPView;

@end
