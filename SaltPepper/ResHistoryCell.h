//
//  ResHistoryCell.h
//  SaltPepper
//
//  Created by Dharmraj Vora on 30/05/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *viewBack;
@property (weak, nonatomic) IBOutlet UILabel *lblCusName;
@property (weak, nonatomic) IBOutlet UILabel *lblResNo;
@property (weak, nonatomic) IBOutlet UILabel *lblStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblNoOfGuest;
@property (weak, nonatomic) IBOutlet UILabel *lblResDate;
@property (weak, nonatomic) IBOutlet UILabel *lblSpecialInstruction;

@end
