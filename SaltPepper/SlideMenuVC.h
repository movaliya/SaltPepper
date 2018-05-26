//
//  SlideMenuVC.h
//  SaltPepper
//
//  Created by Dharmraj Vora on 24/05/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EHHorizontalSelectionView.h"

@interface SlideMenuVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *arrCategories;
    NSArray *arrItems;
}
@property (nonatomic ) NSInteger index;
@property (weak, nonatomic) IBOutlet EHHorizontalSelectionView *HSSelView;
@property (weak, nonatomic) IBOutlet UITableView *tblItem;

@end
