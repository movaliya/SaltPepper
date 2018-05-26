//
//  OptionView.h
//  SaltPepper
//
//  Created by kaushik on 24/05/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASJTagsView.h"

@interface OptionView : UIViewController
{
    
}
@property (strong, nonatomic) IBOutlet UICollectionView *WithCollection;
@property (strong, nonatomic) IBOutlet UICollectionView *WithoutCollection;

- (IBAction)Back_Click:(id)sender;
@property (strong, nonatomic) IBOutlet ASJTagsView *WithTagView;
@property (strong, nonatomic) IBOutlet ASJTagsView *WithoutTagsView;
@end
