//
//  NewsVW.h
//  MirchMasala
//
//  Created by Mango SW on 09/09/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsVW : UIViewController
{
    NSMutableArray *NewsDataArr;
}
@property (strong, nonatomic) IBOutlet UITableView *News_TBL;
@end
