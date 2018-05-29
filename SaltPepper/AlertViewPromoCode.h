//
//  AlertView.h
//

//  Copyright © 2017 Kaushik Movaliya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertViewPromoCode : UIView

@property (strong, nonatomic) IBOutlet UIView *BackView;
@property (strong, nonatomic) IBOutlet UILabel *Title_LBL;

@property (strong, nonatomic) IBOutlet UITextField *Promo_TXT;
@property (strong, nonatomic) IBOutlet UIButton *Applay_BTN;
@property (strong, nonatomic) IBOutlet UIButton *Cancel_BTN;
@end
