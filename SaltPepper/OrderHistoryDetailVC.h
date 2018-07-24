//
//  OrderHistoryDetailVC.h
//  SaltPepper
//
//  Created by Dharmraj Vora on 04/06/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderHistoryDetailVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray* arrOrderHistoryProduct;
}
@property (nonatomic ,retain) NSMutableDictionary *orderDetail;
@property (weak, nonatomic) IBOutlet UIView *viewOrderDetail;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderNo;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblDiscount;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderAmount;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderDate;
@property (weak, nonatomic) IBOutlet UILabel *lblOrderComments;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;

@property (weak, nonatomic) IBOutlet UITableView *tblOrderDetail;
@end
