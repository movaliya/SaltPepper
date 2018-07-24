//
//  ProductDetailVC.h
//  SaltPepper
//
//  Created by Dharmraj Vora on 28/05/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblCartCount;

@property (weak, nonatomic) IBOutlet UIImageView *imgProduct;
@property (weak, nonatomic) IBOutlet UIView *viewDetail;
@property (weak, nonatomic) IBOutlet UILabel *lblProductName;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (weak, nonatomic) IBOutlet UITextView *txtDetail;
@property (weak, nonatomic) IBOutlet UIButton *btnModify;
@property (weak, nonatomic) IBOutlet UIButton *btnPlus;
@property (weak, nonatomic) IBOutlet UIButton *btnMinus;
@property (weak, nonatomic) IBOutlet UIButton *btnAddToCart;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckOut;
@property (weak, nonatomic) IBOutlet UILabel *lblQty;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;

@property (nonatomic ,retain) NSMutableDictionary *productDetail;

@end
