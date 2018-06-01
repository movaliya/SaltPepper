//
//  ReservationHistoryVC.h
//  SaltPepper
//
//  Created by Dharmraj Vora on 30/05/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReservationHistoryVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray* filteredResHistory;
    BOOL isFiltered;
}
@property (weak, nonatomic) IBOutlet UITableView *tblResHistory;
@property (weak, nonatomic) IBOutlet UILabel *lblHeader;
@property (weak, nonatomic) IBOutlet UIButton *btnCart;
@property (weak, nonatomic) IBOutlet UIButton *btnSearch;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end
