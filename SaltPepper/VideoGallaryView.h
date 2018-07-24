//
//  VideoGallaryView.h
//  MirchMasala
//
//  Created by kaushik on 16/09/17.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoGallaryView : UIViewController
{
    UIImage *Thubnil;
}
- (IBAction)Back_click:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *VideoTBL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;

- (IBAction)WebView_Back:(id)sender;
@property (strong, nonatomic) IBOutlet UIWebView *Web;
@property (strong, nonatomic) IBOutlet UIView *ShowWebView;
@end
