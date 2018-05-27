//
//  ItemCell.m
//  SaltPepper
//
//  Created by Dharmraj Vora on 24/05/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "ItemCell.h"

@implementation ItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _btnModify.layer.cornerRadius = 10;
    _btnAdd.layer.cornerRadius = 12.5;
    _btnPlus.layer.cornerRadius = _btnPlus.frame.size.height / 2.0;
    _btnMinus.layer.cornerRadius = _btnMinus.frame.size.height / 2.0;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
