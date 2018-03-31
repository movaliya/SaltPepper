//
//  NewsFullView.m
//  MirchMasala
//
//  Created by kaushik on 09/09/17.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "NewsFullView.h"

@interface NewsFullView ()

@end

@implementation NewsFullView
@synthesize NewsImg,NewsTitle_LBL,NewsDes_LBL,NewsDate_LBL,BackView,ViewHight;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /*
    NewsTitle_LBL=[self.NewsSelectArr valueForKey:@"title"];
    NewsDate_LBL=[self.NewsSelectArr valueForKey:@"news_date"];
    NewsDes_LBL.text=[self.NewsSelectArr valueForKey:@"content"];
    
    NSString *Urlstr=[self.NewsSelectArr valueForKey:@"image_path"];
    [NewsImg sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
    [NewsImg setShowActivityIndicatorView:YES];*/
    
    NewsImg.image=[UIImage imageNamed:@"testImage.jpg"];
    BackView.layer.masksToBounds = NO;
    BackView.layer.shadowOffset = CGSizeMake(0, 1);
    BackView.layer.shadowRadius = 1.0;
    BackView.layer.shadowColor = [UIColor colorWithRed:115.0f/255.0f green:115.0f/255.0f blue:115.0f/255.0f alpha:1.0f].CGColor;
    BackView.layer.shadowOpacity = 0.5;
    
    
    CGFloat labelSize = [self getLabelHeight:NewsDes_LBL];
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
@end
