//
//  CartCell.m
//  Dopple
//
//  Created by Kaushik on 5/29/18.
//  Copyright © 2018 Bacancy Technology Pvt. Ltd. All rights reserved.
//

#import "CartCell.h"

@implementation CartCell
@synthesize PlusBtn,MinusBtn;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    PlusBtn.layer.cornerRadius = PlusBtn.frame.size.height / 2.0;
    MinusBtn.layer.cornerRadius = MinusBtn.frame.size.height / 2.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
