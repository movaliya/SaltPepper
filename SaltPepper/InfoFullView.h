//
//  InfoFullView.h
//  SaltPepper
//
//  Created by Dharmraj Vora on 13/07/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoFullView : UIViewController

@property (strong, nonatomic) NSMutableArray *infoSelectArr;

@property (strong, nonatomic) IBOutlet UIImageView *InfoImg;
@property (strong, nonatomic) IBOutlet UILabel *InfoTitle_LBL;
@property (strong, nonatomic) IBOutlet UILabel *InfoDes_LBL;

@property (strong, nonatomic) IBOutlet UIView *BackView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ViewHight;
- (IBAction)Back_Click:(id)sender;

@end
