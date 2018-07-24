//
//  InfoVW.h
//  SaltPepper
//
//  Created by Dharmraj Vora on 13/07/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoVW : UIViewController
{
    NSMutableArray *InfoDataArr;
}
@property (strong, nonatomic) IBOutlet UITableView *Info_TBL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;
@end
