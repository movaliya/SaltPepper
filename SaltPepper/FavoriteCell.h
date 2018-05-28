//
//  FavoriteCell.h
//  SaltPepper
//
//  Created by kaushik on 28/05/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteCell : UITableViewCell
{
    
}
@property (strong, nonatomic) IBOutlet UILabel *Title_LBL;
@property (strong, nonatomic) IBOutlet UIButton *FavoriteBTN;
@property (strong, nonatomic) IBOutlet UIButton *Delete_BTN;
@property (strong, nonatomic) IBOutlet UIButton *AddToCartBTN;
@property (strong, nonatomic) IBOutlet UILabel *Price_BTN;

@end
