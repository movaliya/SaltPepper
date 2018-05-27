//
//  SlideMenuVC.h
//  SaltPepper
//
//  Created by Dharmraj Vora on 24/05/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EHHorizontalSelectionView.h"

@interface SlideMenuVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSArray *arrCategories;
    NSMutableArray *arrProductsItems;
    NSMutableArray* filteredProducts;
    CGFloat lastContentOffset;
    BOOL isFiltered;
}
@property (nonatomic ) NSInteger index;
@property (weak, nonatomic) IBOutlet EHHorizontalSelectionView *HSSelView;
@property (weak, nonatomic) IBOutlet UITableView *tblItem;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewItem;
@property (weak, nonatomic) IBOutlet UIView *viewSearch;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet UILabel *lblTotal;

@end
