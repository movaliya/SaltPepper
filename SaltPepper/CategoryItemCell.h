//
//  CategoryItemCell.h
//  SaltPepper
//
//  Created by Dharmraj Vora on 26/05/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryItemCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgCategoryItem;
@property (weak, nonatomic) IBOutlet UIButton *btnFav;
@property (weak, nonatomic) IBOutlet UILabel *lblCatItemName;
@property (weak, nonatomic) IBOutlet UIImageView *imgVegNonVeg;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UIButton *btnModify;
@property (weak, nonatomic) IBOutlet UIButton *btnMinus;
@property (weak, nonatomic) IBOutlet UIButton *btnPlus;
@property (weak, nonatomic) IBOutlet UILabel *lblQty;
@property (weak, nonatomic) IBOutlet UIButton *btnAdd;

@end
