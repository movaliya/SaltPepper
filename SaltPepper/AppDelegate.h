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
#import "Reachability.h"
#import <GoogleSignIn/GoogleSignIn.h>
@import GoogleSignIn;
#define GOOGLE_SCHEME @"com.googleusercontent.apps.628114390774-ps3bah0jagd4pnm3aflmfije8rlr3r56"

@interface AppDelegate : UIResponder <UIApplicationDelegate,GIDSignInUIDelegate,GIDSignInDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) AFHTTPSessionManager *manager;
+(BOOL)connectedToNetwork;
+ (AppDelegate *)sharedInstance;
+(BOOL)IsValidEmail:(NSString *)checkString;

+ (void)showErrorMessageWithTitle:(NSString *)title
                          message:(NSString*)message
                         delegate:(id)delegate;

+(void)showInternetErrorMessageWithTitle:(NSString *)title delegate:(id)delegate;

@end

