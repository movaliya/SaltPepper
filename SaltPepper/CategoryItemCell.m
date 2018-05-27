//
//  CategoryItemCell.m
//  SaltPepper
//
//  Created by Dharmraj Vora on 26/05/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "CategoryItemCell.h"

@implementation CategoryItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _btnModify.layer.cornerRadius = 10;
    _btnPlus.layer.cornerRadius = _btnPlus.frame.size.height / 2.0;
    _btnMinus.layer.cornerRadius = _btnMinus.frame.size.height / 2.0;
    // Initialization code
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"CategoryItemCell" owner:self options:nil];
        
        if ([arrayOfViews count] < 1) {
            return nil;
        }
        
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        self = [arrayOfViews objectAtIndex:0];
    }
    return self;
}


@end
