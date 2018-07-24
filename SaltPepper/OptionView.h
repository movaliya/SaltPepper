//
//  OptionView.h
//  SaltPepper
//
//  Created by kaushik on 24/05/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASJTagsView.h"

@interface OptionView : UIViewController
{
    
}
@property (strong, nonatomic) IBOutlet NSMutableDictionary *ModifyDic;

@property (strong, nonatomic) IBOutlet UICollectionView *WithCollection;
@property (strong, nonatomic) IBOutlet UICollectionView *WithoutCollection;

- (IBAction)Back_Click:(id)sender;
@property (strong, nonatomic) IBOutlet ASJTagsView *WithTagView;
@property (strong, nonatomic) IBOutlet ASJTagsView *WithoutTagsView;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *WithHight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *WithoutHight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;

@property (strong, nonatomic) IBOutlet UILabel *HeaderTitle;
@property (strong, nonatomic) IBOutlet UILabel *Title_LBL;


@property (strong, nonatomic) IBOutlet UIButton *Clear_BTN;
@property (strong, nonatomic) IBOutlet UIButton *Applay_BTN;

@property (strong, nonatomic) IBOutlet UIButton *Plush_BTN;
@property (strong, nonatomic) IBOutlet UIButton *Minush_BTN;
@property (strong, nonatomic) IBOutlet UILabel *Qnt_LBL;

- (IBAction)Plush_Click:(id)sender;
- (IBAction)Minush_Click:(id)sender;

- (IBAction)Clear_Click:(id)sender;
- (IBAction)Applay_Click:(id)sender;

@end
