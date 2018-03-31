//
//  GalleryVW.h
//  MirchMasala
//
//  Created by Mango SW on 09/09/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"

@interface GalleryVW : UIViewController
{
    NSMutableArray *GalleryDataArr;
}

@property (strong, nonatomic) IBOutlet UICollectionView *IMGCollection;
@end
