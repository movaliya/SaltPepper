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

    // Do any additional setup after loading the view.
}
- (IBAction)MenuBtn_click:(id)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
