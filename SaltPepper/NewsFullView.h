//
//  NewsFullView.h
//  MirchMasala
//
//  Created by kaushik on 09/09/17.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsFullView : UIViewController
{
    
}
@property (strong, nonatomic) NSMutableArray *NewsSelectArr;

@property (weak, nonatomic) IBOutlet UILabel *lblHeader;
@property (strong, nonatomic) IBOutlet UIImageView *NewsImg;
@property (strong, nonatomic) IBOutlet UILabel *NewsTitle_LBL;
@property (strong, nonatomic) IBOutlet UILabel *NewsDate_LBL;
@property (strong, nonatomic) IBOutlet UILabel *NewsDes_LBL;

@property (strong, nonatomic) IBOutlet UIView *BackView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ViewHight;
- (IBAction)Back_Click:(id)sender;
@end
