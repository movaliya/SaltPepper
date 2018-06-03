//
//  OptionWithCell.m
//  SaltPepper
//
//  Created by kaushik on 24/05/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "OptionWithCell.h"

@implementation OptionWithCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.Bedge_LBL.layer.cornerRadius=15.0f;
    self.Bedge_LBL.layer.masksToBounds=YES;
}

@end
