//
//  AlertView.m
//
//  Copyright © 2017 Kaushik Movaliya. All rights reserved.
//

#import "AlertViewPromoCode.h"

@implementation AlertViewPromoCode
@synthesize BackView,Applay_BTN,Cancel_BTN,Promo_TXT;


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    BackView.layer.cornerRadius=8.0f;
    BackView.layer.borderColor=[[UIColor darkTextColor] CGColor];
    BackView.layer.borderWidth=1.5f;
    
    Applay_BTN.layer.cornerRadius=18.0f;
    Cancel_BTN.layer.cornerRadius=18.0f;
 
}


@end
