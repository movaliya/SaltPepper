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
#import "FCAlertView.h"

@import GoogleSignIn;
#define GOOGLE_SCHEME @"com.googleusercontent.apps.628114390774-ps3bah0jagd4pnm3aflmfije8rlr3r56"

@interface AppDelegate : UIResponder <UIApplicationDelegate,GIDSignInUIDelegate,GIDSignInDelegate>
{
    FCAlertView *alert;
    NSMutableArray *MainCartArr,*MainFavArr;

}
@property (strong, nonatomic) NSMutableArray *MainCartArr,*MainFavArr;
@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) AFHTTPSessionManager *manager;
+(BOOL)connectedToNetwork;
+ (AppDelegate *)sharedInstance;
-(void)openActiveSessionWithPermissions:(NSArray *)permissions allowLoginUI:(BOOL)allowLoginUI;

+(void)WriteData:(NSString *)DictName RootObject:(id)rootObject;
+(NSMutableArray*)GetData:(NSString *)DictName;

+(BOOL)IsValidEmail:(NSString *)checkString;

@property (nonatomic,weak) NSArray *arrCategories;
+ (void)showErrorMessageWithTitle:(NSString *)title
                          message:(NSString*)message
                         delegate:(id)delegate;

+(void)showInternetErrorMessageWithTitle:(NSString *)title delegate:(id)delegate;
-(void)GetPublishableKey;

-(NSMutableDictionary*)replaceNULL:(id)dictData;

//Alert Methods
-(void)ShowAlertWithOneBtn:(NSString*)strMessage andStrTitle:(NSString*)strTitle andbtnTitle:(NSString*)strButtonTitle;
-(FCAlertView*)ShowAlertWithOneBtnWithAttribute:(NSAttributedString*)strMessage andStrTitle:(NSString*)strTitle andbtnTitle:(NSString*)strButtonTitle;
-(void)ShowAlertWithMutableAttribute:(NSMutableAttributedString*)strMessage andStrTitle:(NSString*)strTitle andbtnTitle:(NSString*)strButtonTitle;
-(FCAlertView*)ShowAlertWithBtnAction:(NSString*)strMessage andStrTile:(NSString*)strTitle andbtnTitle:(NSString*)strButtonTitle andButtonArray:(NSArray*)arrBtnTitle;
-(void)ShowAlertWithBtnActionCenter:(NSString*)strMessage andStrTile:(NSString*)strTitle andbtnTitle:(NSString*)strButtonTitle andButtonArray:(NSArray*)arrBtnTitle;
@end

