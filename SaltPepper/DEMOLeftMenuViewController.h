//
//  DEMOLeftMenuViewController.h
//  RESideMenuStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@interface DEMOLeftMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, RESideMenuDelegate>
{
    NSArray *titles;
    NSArray *images;
    NSString *CheckReservationState;
}
@property (weak, nonatomic) IBOutlet UIImageView *profilePictIMVW;
@property (weak, nonatomic) IBOutlet UILabel *Username_LBL;
@property (weak, nonatomic) IBOutlet UILabel *Notification_LBL;
@property (strong, nonatomic) IBOutlet UITableView *MenuTBL;

@end
