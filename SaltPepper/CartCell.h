//
//  CartCell.h
//  Dopple
//
//  Created by Kaushik on 5/29/18.
//  Copyright © 2018 Bacancy Technology Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CartCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ProductTitle_LBL;
@property (weak, nonatomic) IBOutlet UILabel *ProductPrice_LBL;
@property (weak, nonatomic) IBOutlet UILabel *QTY_LBL;
@property (weak, nonatomic) IBOutlet UIButton *MinusBtn;
@property (weak, nonatomic) IBOutlet UIButton *PlusBtn;
@property (weak, nonatomic) IBOutlet UIButton *DeleteBtn;

@end
