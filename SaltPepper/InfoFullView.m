//
//  InfoFullView.m
//  SaltPepper
//
//  Created by Dharmraj Vora on 13/07/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "InfoFullView.h"

@interface InfoFullView ()

@end

@implementation InfoFullView
@synthesize InfoImg,InfoTitle_LBL,InfoDes_LBL,BackView,ViewHight;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if(IS_IPHONE_X)
    {
        _headerHeight.constant = 90;
    }
    else
    {
        _headerHeight.constant = 70;
    }
    
    _lblHeader.text = [self.infoSelectArr valueForKey:@"title"];
    InfoTitle_LBL.text=[self.infoSelectArr valueForKey:@"title"];
    InfoDes_LBL.text=[self.infoSelectArr valueForKey:@"content"];
    
    NSString *Urlstr=[self.infoSelectArr valueForKey:@"image_path"];
    [InfoImg sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
    //[NewsImg setShowActivityIndicatorView:YES];
    
    InfoImg.layer.masksToBounds = NO;
    InfoImg.layer.shadowOffset = CGSizeMake(0, 1);
    InfoImg.layer.shadowRadius = 1.0;
    InfoImg.layer.shadowColor = [UIColor colorWithRed:115.0f/255.0f green:115.0f/255.0f blue:115.0f/255.0f alpha:1.0f].CGColor;
    InfoImg.layer.shadowOpacity = 0.7;
    
    //NewsImg.image=[UIImage imageNamed:@"testImage.jpg"];
    BackView.layer.masksToBounds = NO;
    BackView.layer.shadowOffset = CGSizeMake(0, 1);
    BackView.layer.shadowRadius = 1.0;
    BackView.layer.shadowColor = [UIColor colorWithRed:115.0f/255.0f green:115.0f/255.0f blue:115.0f/255.0f alpha:1.0f].CGColor;
    BackView.layer.shadowOpacity = 0.5;
    
    
    CGFloat labelSize = [self getLabelHeight:InfoDes_LBL];
    if (labelSize>18)
    {
        ViewHight.constant=ViewHight.constant+labelSize;
    }
    
}

- (CGFloat)getLabelHeight:(UILabel*)label
{
    CGSize constraint = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)Back_Click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
