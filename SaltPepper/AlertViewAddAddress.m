//
//  AlertView.m
//
//  Copyright © 2017 Kaushik Movaliya. All rights reserved.
//

#import "AlertViewAddAddress.h"

@implementation AlertViewAddAddress
@synthesize BackView,Applay_BTN,Cancel_BTN,Promo_TXT;


- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//    label.text = @"mg";
//    label.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.0];
//    textField.rightViewMode = UITextFieldViewModeAlways;
//    textField.rightView = label;
//    [self.view addSubview:textField];
    
    
    
    BackView.layer.cornerRadius=8.0f;
    BackView.layer.borderColor=[[UIColor darkTextColor] CGColor];
    BackView.layer.borderWidth=1.5f;
    
    Applay_BTN.layer.cornerRadius=18.0f;
    Cancel_BTN.layer.cornerRadius=18.0f;
    
    
    
 
}


@end
