//
//  TrackOrderVC.h
//  SaltPepper
//
//  Created by Dharmraj Vora on 03/06/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TrackOrderVC : UIViewController
@property (weak, nonatomic) IBOutlet UIView *viewOrdPlaced;
@property (weak, nonatomic) IBOutlet UILabel *lblOrdPlaced;
@property (weak, nonatomic) IBOutlet UIView *viewProcessing;
@property (weak, nonatomic) IBOutlet UILabel *lblProcessing;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIView *viewDispatched;
@property (weak, nonatomic) IBOutlet UILabel *lblDispatched;
@property (weak, nonatomic) IBOutlet UIView *viewDelevered;
@property (weak, nonatomic) IBOutlet UILabel *lblDelevered;
@property (weak, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;

@end
