//
//  NewsCell.m
//  MirchMasala
//
//  Created by kaushik on 09/09/17.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "NewsCell.h"

@implementation NewsCell
@synthesize NewsIMG;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //NewsIMG.layer.cornerRadius=30.0f;
   // NewsIMG.layer.masksToBounds=YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
