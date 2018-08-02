//
//  AlertView.h
//

//  Copyright © 2017 Kaushik Movaliya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertViewAddAddress : UIView

@property (strong, nonatomic) IBOutlet UIView *BackView;
@property (strong, nonatomic) IBOutlet UILabel *Title_LBL;

@property (strong, nonatomic) IBOutlet UITextField *Promo_TXT;
@property (strong, nonatomic) IBOutlet UIButton *Applay_BTN;
@property (strong, nonatomic) IBOutlet UIButton *Cancel_BTN;
@property (weak, nonatomic) IBOutlet UITextField *PostCodeTXT;

@property (weak, nonatomic) IBOutlet UITextField *HouseNoNameTXT;
@property (weak, nonatomic) IBOutlet UITextField *StreetTXT;
@property (weak, nonatomic) IBOutlet UITextField *TownTXT;
@property (weak, nonatomic) IBOutlet UITextField *StateTXT;
@property (weak, nonatomic) IBOutlet UITextField *CountryTXT;
@property (weak, nonatomic) IBOutlet UITextField *ContactNumberTXT;
@property (weak, nonatomic) IBOutlet UIButton *SearchBtn;

@end
