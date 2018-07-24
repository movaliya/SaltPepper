//
//  TrackOrderVC.m
//  SaltPepper
//
//  Created by Dharmraj Vora on 03/06/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "TrackOrderVC.h"

@interface TrackOrderVC ()

@end

@implementation TrackOrderVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(IS_IPHONE_X)
    {
        _headerHeight.constant = 90;
    }
    else
    {
        _headerHeight.constant = 70;
    }
    
    _viewOrdPlaced.layer.cornerRadius = 35;
    _viewProcessing.layer.cornerRadius = 35;
    _viewDispatched.layer.cornerRadius = 35;
    _viewDelevered.layer.cornerRadius = 35;
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(_viewOrdPlaced.frame.origin.x + 70, _viewOrdPlaced.frame.origin.y + 40)];
    [path addLineToPoint:CGPointMake(_viewOrdPlaced.frame.origin.x + 120, _viewOrdPlaced.frame.origin.y + 107)];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [UIColor darkGrayColor].CGColor;
    [_mainView.layer addSublayer:shapeLayer];
    
    CAShapeLayer *shapeLayer1 = [CAShapeLayer layer];
    UIBezierPath *path1 = [UIBezierPath bezierPath];
    [path1 moveToPoint:CGPointMake(_viewProcessing.frame.origin.x + 10, _viewProcessing.frame.origin.y + 60)];
    [path1 addLineToPoint:CGPointMake(_viewProcessing.frame.origin.x - 50, _viewProcessing.frame.origin.y + 105)];
    shapeLayer1.path = path1.CGPath;
    shapeLayer1.strokeColor = [UIColor darkGrayColor].CGColor;
    [_mainView.layer addSublayer:shapeLayer1];
    
    CAShapeLayer *shapeLayer2 = [CAShapeLayer layer];
    UIBezierPath *path2 = [UIBezierPath bezierPath];
    [path2 moveToPoint:CGPointMake(_viewDispatched.frame.origin.x + 5, _viewDispatched.frame.origin.y + 20)];
    [path2 addLineToPoint:CGPointMake(_viewDispatched.frame.origin.x - 43, _viewDispatched.frame.origin.y - 43)];
    shapeLayer2.path = path2.CGPath;
    shapeLayer2.strokeColor = [UIColor darkGrayColor].CGColor;
    [_mainView.layer addSublayer:shapeLayer2];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Click Action

- (IBAction)btnBackClicked:(id)sender
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
