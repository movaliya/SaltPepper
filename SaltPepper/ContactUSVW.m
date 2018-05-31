//
//  ContactUSVW.m
//  SaltPepper
//
//  Created by jignesh solanki on 01/04/2018.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "ContactUSVW.h"
#import "SendFeedbackVC.h"

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
- (IBAction)btnCall:(id)sender
{
    NSURL *url = [NSURL URLWithString:@"telprompt://0138478007"];
    [[UIApplication  sharedApplication] openURL:url];
}
- (IBAction)btnFeedback:(id)sender
{
    SendFeedbackVC *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"SendFeedbackVC"];
    [self.navigationController pushViewController:mainVC animated:YES];
}
- (IBAction)btnGetLocation:(id)sender {
}
- (IBAction)btnFB:(id)sender {
}
- (IBAction)btnLinked:(id)sender {
}
- (IBAction)btnTwitter:(id)sender {
}
- (IBAction)btnYoutube:(id)sender {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
