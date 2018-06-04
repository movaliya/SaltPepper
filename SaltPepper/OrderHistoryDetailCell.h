//
//  OrderHistoryDetailCell.h
//  SaltPepper
//
//  Created by Dharmraj Vora on 04/06/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderHistoryDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *viewBack;
@property (weak, nonatomic) IBOutlet UILabel *lblProductName;
@property (weak, nonatomic) IBOutlet UILabel *lblWith;
@property (weak, nonatomic) IBOutlet UILabel *lblWithout;
@property (weak, nonatomic) IBOutlet UILabel *lblQty;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lblQtyTopSpace;

@end
