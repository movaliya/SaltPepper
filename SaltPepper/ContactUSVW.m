//
//  ContactUSVW.m
//  SaltPepper
//
//  Created by jignesh solanki on 01/04/2018.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "ContactUSVW.h"

@interface ContactUSVW ()

@end

@implementation ContactUSVW

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;

}
- (IBAction)MenuBtn_click:(id)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
