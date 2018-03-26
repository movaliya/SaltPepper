//
//  AppDelegate.h
//  SaltPepper
//
//  Created by kaushik on 11/03/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking/AFNetworkActivityIndicatorManager.h"
#import "AFHTTPSessionManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) AFHTTPSessionManager *manager;


@end

