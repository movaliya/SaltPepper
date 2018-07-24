//
//  OrderHistoryVC.h
//  SaltPepper
//
//  Created by Dharmraj Vora on 02/06/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderHistoryVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray* filteredResHistory;
    BOOL isFiltered;
}
@property (weak, nonatomic) IBOutlet UILabel *lblCartCount;
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *btnCart;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UITableView *tblHistory;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;

@end
