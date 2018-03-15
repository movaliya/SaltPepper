//
//  MenuListCollectCELL.m
//  SaltPepper
//
//  Created by jignesh solanki on 15/03/2018.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "MenuListCollectCELL.h"

@implementation MenuListCollectCELL
@synthesize MenuImage;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    MenuImage.layer.cornerRadius = MenuImage.frame.size.width / 2;
    MenuImage.clipsToBounds = YES;
    // Initialization code
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // Initialization code
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"MenuListCollectCELL" owner:self options:nil];
        
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
