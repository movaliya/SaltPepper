//
//  FavoriteCell.m
//  SaltPepper
//
//  Created by kaushik on 28/05/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "FavoriteCell.h"

@implementation FavoriteCell
@synthesize AddToCartBTN;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    AddToCartBTN.layer.cornerRadius = 12;
    AddToCartBTN.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
