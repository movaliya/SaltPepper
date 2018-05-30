//
//  AppDelegate.m
//  SaltPepper
//
//  Created by kaushik on 11/03/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "AppDelegate.h"
#import "DEMORootViewController.h"

@interface AppDelegate ()
{
}
@end

@implementation AppDelegate
@synthesize manager,MainCartArr,MainFavArr;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    if(_rb(@"isSkip"))
    {
        DEMORootViewController *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"rootController"];
        self.window.rootViewController = vcr;
        //[self.window.rootViewController.navigationController pushViewController:vcr animated:YES];
    }
    //Google
    [GIDSignIn sharedInstance].clientID = @"628114390774-ps3bah0jagd4pnm3aflmfije8rlr3r56.apps.googleusercontent.com";
    [GIDSignIn sharedInstance].delegate = self;
    return YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options
{
    if([[url scheme] isEqualToString:GOOGLE_SCHEME])
    {
        return [[GIDSignIn sharedInstance] handleURL:url
                                   sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                          annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    }
    
    return NO;
}
+ (BOOL)connectedToNetwork{
    Reachability* reachability = [Reachability reachabilityWithHostName:@"www.google.com"];
    NetworkStatus remoteHostStatus = [reachability currentReachabilityStatus];
    BOOL isInternet;
    if(remoteHostStatus == NotReachable)
    {
        isInternet =NO;
    }
    else if (remoteHostStatus == ReachableViaWWAN)
    {
        isInternet = TRUE;
    }
    else if (remoteHostStatus == ReachableViaWiFi)
    { isInternet = TRUE;
        
    }
    return isInternet;
}
+(void)WriteData:(NSString *)DictName RootObject:(id)rootObject
{
    NSData *dataSave = [NSKeyedArchiver archivedDataWithRootObject:rootObject];
    [[NSUserDefaults standardUserDefaults] setObject:dataSave forKey:DictName];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+(NSMutableArray*)GetData:(NSString *)DictName
{
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:DictName];
   NSMutableArray *Temparry = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return Temparry;
}

+ (AppDelegate *)sharedInstance
{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

+(BOOL)IsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = NO;
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}

+ (void)showErrorMessageWithTitle:(NSString *)title
                          message:(NSString*)message
                         delegate:(id)delegate {
    
    UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    topWindow.rootViewController = [UIViewController new];
    topWindow.windowLevel = UIWindowLevelAlert + 1;
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *OK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        
        // No Action
    }];
    [alert addAction:OK];
    // Present action where needed
    [topWindow makeKeyAndVisible];
    [topWindow.rootViewController presentViewController:alert animated:YES completion:nil];
    //[self presentViewController:alert animated:YES completion:nil];
    
    
    
    //UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    //[alert show];
    
    float duration = 3.0; // duration in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        //[alert dismissWithClickedButtonIndex:0 animated:YES];
    });
}

+(void)showInternetErrorMessageWithTitle:(NSString *)title delegate:(id)delegate
{
    
    UIWindow* topWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    topWindow.rootViewController = [UIViewController new];
    topWindow.windowLevel = UIWindowLevelAlert + 1;
    
    UIAlertController *toast = [UIAlertController alertControllerWithTitle:@"" message:title preferredStyle:UIAlertControllerStyleAlert];
    [topWindow makeKeyAndVisible];
    [topWindow.rootViewController presentViewController:toast animated:YES completion:nil];
    
    /*
     UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
     message:title
     delegate:nil
     cancelButtonTitle:nil
     otherButtonTitles:nil, nil];
     [toast show];*/
    
    float duration = 2.5; // duration in seconds
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissViewControllerAnimated:YES completion:nil];
    });
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(NSMutableDictionary*)replaceNULL:(id)dictData
{
    NSMutableDictionary * dictUserData = [[NSMutableDictionary alloc] init];
    dictUserData=[dictData mutableCopy];
    for (id dict in [dictData allKeys])
    {
        ([dictData valueForKey:dict] == [NSNull null]) ? [dictUserData setValue:@"" forKey:dict] :[dictUserData setValue:[dictData valueForKey:dict] forKey:dict];
    }
    
    return dictUserData;
}

#pragma mark - Custom Alert

-(void)ShowAlertWithOneBtn:(NSString*)strMessage andStrTitle:(NSString *)strTitle andbtnTitle:(NSString *)strButtonTitle
{
    alert = [self ShowAlertWithBtnAction:strMessage andStrTile:strTitle andbtnTitle:strButtonTitle andButtonArray:@[]];
    
    [alert showAlertInWindow:self.window
                   withTitle:strTitle
                withSubtitle:strMessage
             withCustomImage:nil
         withDoneButtonTitle:strButtonTitle
                  andButtons:@[]];
}

-(FCAlertView*)ShowAlertWithOneBtnWithAttribute:(NSAttributedString *)strMessage andStrTitle:(NSString *)strTitle andbtnTitle:(NSString *)strButtonTitle
{
    alert = [[FCAlertView alloc] init];
    
    [self setUpAttribute:alert];
    
    if (strTitle == nil)
    {
        alert.subtitleFont = [self setFont:HelveticaNLig andSize:14];
        alert.messageAlignment = NSTextAlignmentCenter;
    }
    else
    {
        alert.subtitleFont = [self setFont:HelveticaNLig andSize:13];
        alert.messageAlignment = NSTextAlignmentLeft;
    }
    
    [alert showAlertWithTitle:strTitle
       withAttributedSubtitle:strMessage
              withCustomImage:nil
          withDoneButtonTitle:strButtonTitle
                   andButtons:@[]];
    return alert;
}

-(void)ShowAlertWithMutableAttribute:(NSMutableAttributedString*)strMessage andStrTitle:(NSString*)strTitle andbtnTitle:(NSString*)strButtonTitle
{
    alert = [[FCAlertView alloc] init];
    
    [self setUpAttribute:alert];
    
    if (strTitle == nil)
    {
        alert.subtitleFont = [self setFont:HelveticaNLig andSize:14];
        alert.messageAlignment = NSTextAlignmentCenter;
    }
    else
    {
        alert.subtitleFont = [self setFont:HelveticaNLig andSize:13];
        alert.messageAlignment = NSTextAlignmentLeft;
    }
    
    [alert showAlertWithTitle:strTitle
       withAttributedSubtitle:strMessage
              withCustomImage:nil
          withDoneButtonTitle:strButtonTitle
                   andButtons:@[]];
}

-(FCAlertView*)ShowAlertWithBtnAction:(NSString*)strMessage andStrTile:(NSString*)strTitle andbtnTitle:(NSString*)strButtonTitle andButtonArray:(NSArray*)arrBtnTitle
{
    alert = [[FCAlertView alloc] init];
    
    [self setUpAttribute:alert];
    
    if (strTitle == nil)
    {
        alert.subtitleFont = [self setFont:HelveticaNLig andSize:14];
        alert.messageAlignment = NSTextAlignmentCenter;
    }
    else
    {
        alert.subtitleFont = [self setFont:HelveticaNLig andSize:13];
        alert.messageAlignment = NSTextAlignmentLeft;
    }
    
    [alert showAlertInWindow:self.window
                   withTitle:nil
                withSubtitle:strMessage
             withCustomImage:nil
         withDoneButtonTitle:strButtonTitle
                  andButtons:arrBtnTitle];
    
    return alert;
}

-(void)ShowAlertWithBtnActionCenter:(NSString*)strMessage andStrTile:(NSString*)strTitle andbtnTitle:(NSString*)strButtonTitle andButtonArray:(NSArray*)arrBtnTitle
{
    alert = [[FCAlertView alloc] init];
    
    [self setUpAttribute:alert];
    
    alert.subtitleFont = [self setFont:HelveticaNLig andSize:14];
    alert.messageAlignment = NSTextAlignmentCenter;
    
    [alert showAlertInWindow:self.window
                   withTitle:strTitle
                withSubtitle:strMessage
             withCustomImage:nil
         withDoneButtonTitle:strButtonTitle
                  andButtons:arrBtnTitle];
}

-(void)setUpAttribute:(FCAlertView*)alertView
{
    alert.titleFont = [self setFont:HelveticaNBold andSize:16];
    alert.titleColor = [UIColor blackColor];
    alert.subTitleColor = [UIColor blackColor];
    alert.detachButtons = YES;
    alert.doneButtonTitleColor = [UIColor whiteColor];
    alert.doneButtonCustomFont = [self setFont:HelveticaNBold andSize:15];
    alert.cornerRadius = 7.0f;
    
    alert.firstButtonCustomFont = [self setFont:HelveticaNBold andSize:15];
    alert.firstButtonTitleColor = [UIColor whiteColor];
    alert.firstButtonBackgroundColor = kMarunColor;
    
    alert.titleAlignment = NSTextAlignmentCenter;
}

-(UIFont*)setFont:(NSString *)strFontName andSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:strFontName size:fontSize];
}

@end
