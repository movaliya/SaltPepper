//
//  LoginVW.m
//  SaltPepper
//
//  Created by jignesh solanki on 12/03/2018.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "LoginVW.h"
#import "saltPepper.pch"
#import "ForgotPasswordVC.h"
#import "RegisterVW.h"
#import "DEMORootViewController.h"
#import <FacebookSDK/FacebookSDK.h>
@interface LoginVW ()
-(void)handleFBSessionStateChangeWithNotification:(NSNotification *)notification;
@property AppDelegate *appDelegate;

@end

@implementation LoginVW
@synthesize LoginBtn,Email_TXT,Password_TXT;

- (void)viewDidLoad {
    [super viewDidLoad];
    
      self.appDelegate = [AppDelegate sharedInstance];
    LoginBtn.layer.cornerRadius = 22;
    LoginBtn.clipsToBounds = YES;
    
    //Google SignIn
    NSString *userScope = @"https://www.googleapis.com/auth/plus.me";
    NSString *loginScope = @"https://www.googleapis.com/auth/plus.login";
    NSArray *arrScopes = [NSArray arrayWithObjects:loginScope,userScope, nil];
    NSArray *currentScopes = [GIDSignIn sharedInstance].scopes;
    [GIDSignIn sharedInstance].scopes   = [currentScopes arrayByAddingObjectsFromArray:arrScopes];
    
    GIDSignIn *signin = [GIDSignIn sharedInstance];
    signin.shouldFetchBasicProfile = true;
    signin.delegate = self;
    signin.uiDelegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleFBSessionStateChangeWithNotification:)
                                                 name:@"SessionStateChangeNotification"
                                               object:nil];
    
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = YES;
    [super viewWillAppear:YES];
}

- (IBAction)LoginBtn_Click:(id)sender
{
    if ([Email_TXT.text isEqualToString:@""])
    {
        //[self ShowPOPUP];
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter email" delegate:nil];
    }
    else
    {
        if (![AppDelegate IsValidEmail:Email_TXT.text])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter valid email" delegate:nil];
        }
        else
        {
            if ([Password_TXT.text isEqualToString:@""])
            {
                [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter password" delegate:nil];
            }
            else
            {
                BOOL internet=[AppDelegate connectedToNetwork];
                if (internet)
                    [self CallForloging:Email_TXT.text Password:Password_TXT.text];
                else
                    [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
            }
        }
    }
}


-(void)CallForloging :(NSString *)EmailStr Password:(NSString *)PasswordStr
{
   
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
    
    [dictInner setObject:EmailStr forKey:@"EMAIL"];
    [dictInner setObject:PasswordStr forKey:@"PASSWORD"];
    [dictInner setObject:@"firebase" forKey:@"REGID"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    
    [dictSub setObject:@"action" forKey:@"MODULE"];
    
    [dictSub setObject:@"authenticate" forKey:@"METHOD"];
    
    [dictSub setObject:dictInner forKey:@"PARAMS"];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
    NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
    
    [dictREQUESTPARAM setObject:arr forKey:@"REQUESTPARAM"];
    [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
    
    NSError* error = nil;
    
    NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,LOGINKEY];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
    // NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    
    [Utility postRequest:json url:makeURL success:^(id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"responseObject==%@",responseObject);
        NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"SUCCESS"];
        if ([SUCCESS boolValue] ==YES)
        {
            [AppDelegate WriteData:@"LoginUserDic" RootObject:responseObject];
            _wb(@"isSkip", YES);
            Email_TXT.text=@"";
            Password_TXT.text=@"";
            DEMORootViewController *vcr = [[UIStoryboard storyboardWithName:[SharedClass sharedSingleton].storyBaordName  bundle:nil] instantiateViewControllerWithIdentifier:@"rootController"];
            [self.navigationController pushViewController:vcr animated:YES];
            
            [AppDelegate showErrorMessageWithTitle:@"" message:@"Login successful" delegate:nil];
        }
        else
        {
            [AppDelegate showErrorMessageWithTitle:@"" message:@"Email and/or Password did not matched." delegate:nil];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"Fail");
    }];
    
    /*AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", nil];
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:makeURL parameters:json success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         NSLog(@"responseObject==%@",responseObject);
         NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"SUCCESS"];
         if ([SUCCESS boolValue] ==YES)
         {
             [[NSUserDefaults standardUserDefaults]setObject:responseObject forKey:@"LoginUserDic"];
             Email_TXT.text=@"";
             Password_TXT.text=@"";
             DEMORootViewController *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"rootController"];
             [self.navigationController pushViewController:vcr animated:YES];
             
             [AppDelegate showErrorMessageWithTitle:@"" message:@"Login successful" delegate:nil];
         }
         else
         {
             [AppDelegate showErrorMessageWithTitle:@"" message:@"Email and/or Password did not matched." delegate:nil];
         }
     }
     
          failure:^(NSURLSessionDataTask *operation, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];

         NSLog(@"Fail");
     }];*/
}

- (IBAction)ForgetPasswordBtn_Click:(id)sender
{
    ForgotPasswordVC *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordVC"];
    [self.navigationController pushViewController:mainVC animated:YES];
}
- (IBAction)RegisterBtn_Click:(id)sender
{
    RegisterVW *mainVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterVW"];
    [self.navigationController pushViewController:mainVC animated:YES];
}
- (IBAction)ShowPasswordBtn_Click:(id)sender
{
    if (Password_TXT.secureTextEntry==YES)
    {
        Password_TXT.secureTextEntry=NO;
    }
    else
    {
        Password_TXT.secureTextEntry=YES;
    }
}
- (IBAction)BackBtnClick:(id)sender
{
    if(_rb(@"isSkip"))
    {
        DEMORootViewController *vcr = [[UIStoryboard storyboardWithName:[SharedClass sharedSingleton].storyBaordName  bundle:nil] instantiateViewControllerWithIdentifier:@"rootController"];
        [self.navigationController pushViewController:vcr animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (IBAction)btnLoginFB:(id)sender
{
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        
        if ([FBSession activeSession].state != FBSessionStateOpen &&
            [FBSession activeSession].state != FBSessionStateOpenTokenExtended)
        {
            [self.appDelegate openActiveSessionWithPermissions:@[@"public_profile", @"email"] allowLoginUI:YES];
        }
        else{
            // Close an existing session.
            [[FBSession activeSession] closeAndClearTokenInformation];
            // Update the UI.
        }
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
}
#pragma mark - Private method implementation

-(void)handleFBSessionStateChangeWithNotification:(NSNotification *)notification
{
    NSLog(@"result");
    // Get the session, state and error values from the notification's userInfo dictionary.
    NSDictionary *userInfo = [notification userInfo];
    
    FBSessionState sessionState = [[userInfo objectForKey:@"state"] integerValue];
    NSError *error = [userInfo objectForKey:@"error"];
    
    // Handle the session state.
    // Usually, the only interesting states are the opened session, the closed session and the failed login.
    if (!error) {
        // In case that there's not any error, then check if the session opened or closed.
        if (sessionState == FBSessionStateOpen)
        {
            [FBRequestConnection startWithGraphPath:@"me"
                                         parameters:@{@"fields": @"first_name, last_name, picture.type(normal), email"}
                                         HTTPMethod:@"GET"
                                  completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                      if (!error) {
                                          NSLog(@"result=%@",result);
                                          
                                          FBSignIndictParams = [[NSMutableDictionary alloc] init];
                                          [FBSignIndictParams setObject:[result objectForKey:@"id"]  forKey:@"facebook_id"];
                                          
                                          //[self CallFBLogin];
                                          
                                          // Get the user's profile picture.
                                          NSURL *pictureURL = [NSURL URLWithString:[[[result objectForKey:@"picture"] objectForKey:@"data"] objectForKey:@"url"]];
                                      }
                                      else
                                      {
                                          NSLog(@"%@", [error localizedDescription]);
                                      }
                                  }];
            
        }
        else if (sessionState == FBSessionStateClosed || sessionState == FBSessionStateClosedLoginFailed){
            // A session was closed or the login was failed. Update the UI accordingly.
        }
    }
    else{
        // In case an error has occurred, then just log the error and update the UI accordingly.
        NSLog(@"Error: %@", [error localizedDescription]);
    }
}
- (IBAction)btnLoginGoogle:(id)sender
{
    GIDSignIn *signin = [GIDSignIn sharedInstance];
    signin.shouldFetchBasicProfile = true;
    signin.delegate = self;
    signin.uiDelegate = self;
    [signin signIn];

}

#pragma mark - Google SignIn Delegate

- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error
{
    // Perform any operations on signed in user here.
    if (error == nil)
    {
        // [MBProgressHUD showHUDAddedTo:sharedAppDel.window animated:YES];
        //NSString *userId = user.userID;
        //NSString *fullName = user.profile.name;
        // NSString *givenName = user.profile.givenName;
        // NSString *familyName = user.profile.familyName;
        // NSString *clientID = user.authentication.clientID;
        // NSString *accessToken = user.authentication.accessToken;
        // NSString *refreshToken = user.authentication.refreshToken;
        //NSString *idToken = user.authentication.idToken;
        
        NSString *email = user.profile.email;
        NSString *fullName = user.profile.name;
        NSString *userId = user.userID;
        if ( ( ![email isEqual:[NSNull null]] ) && ( [email length] != 0 ) )
        {
           
            [self CallGmailLogin:userId Name:fullName Email:email];
        }
        else
        {
            [[GIDSignIn sharedInstance] signOut];
            [AppDelegate showErrorMessageWithTitle:@"" message:@"Privacy set in google account while getting user info." delegate:nil];
        }
       
    }
    else
    {
        //  [sharedAppDel ShowAlertWithOneBtn:@"Login Error!, Please try again" andbtnTitle:@"Ok"];
        NSLog(@"%@", error.localizedDescription);
    }
}
-(void)CallGmailLogin:(NSString *)GID Name:(NSString *)NameStr Email:(NSString *)emailStr
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    
    NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
    [dictInner setObject:emailStr forKey:@"EMAIL"];
    [dictInner setObject:NameStr forKey:@"NAME"];
    [dictInner setObject:GID forKey:@"FBID"];
    
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    [dictSub setObject:@"socialLogin" forKey:@"METHOD"];
    [dictSub setObject:dictInner forKey:@"PARAMS"];
    
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
    NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
    
    [dictREQUESTPARAM setObject:arr forKey:@"REQUESTPARAM"];
    [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
    
    
    NSError* error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
    // NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,SOCIALLOGIN];
    
    [Utility postRequest:json url:makeURL success:^(id responseObject)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"responseObject==%@",responseObject);
        NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"socialLogin"] objectForKey:@"SUCCESS"];
        if ([SUCCESS boolValue] ==YES)
        {
            [AppDelegate WriteData:@"LoginUserDic" RootObject:responseObject];
              _wb(@"isSkip", YES);
            [AppDelegate showErrorMessageWithTitle:@"" message:@"Login successful" delegate:nil];
            DEMORootViewController *vcr = [[UIStoryboard storyboardWithName:[SharedClass sharedSingleton].storyBaordName  bundle:nil] instantiateViewControllerWithIdentifier:@"rootController"];
            [self.navigationController pushViewController:vcr animated:YES];
            
        }
        else
        {
            NSString *DESCRIPTION=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"socialLogin"] objectForKey:@"ERROR"] objectForKey:@"DESCRIPTION"];
            [AppDelegate showErrorMessageWithTitle:@"" message:DESCRIPTION delegate:nil];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"Fail");
        
    }];
    
    /*AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"application/json", nil];
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [serializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    manager.requestSerializer = serializer;
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    [manager POST:makeURL parameters:json success:^(NSURLSessionDataTask *operation, NSDictionary *responseObject)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         NSLog(@"responseObject==%@",responseObject);
         NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"socialLogin"] objectForKey:@"SUCCESS"];
         if ([SUCCESS boolValue] ==YES)
         {
             [[NSUserDefaults standardUserDefaults]setObject:responseObject forKey:@"LoginUserDic"];
             [AppDelegate showErrorMessageWithTitle:@"" message:@"Login successful" delegate:nil];
             DEMORootViewController *vcr = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"rootController"];
             [self.navigationController pushViewController:vcr animated:YES];
             
         }
         else
         {
             NSString *DESCRIPTION=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"socialLogin"] objectForKey:@"ERROR"] objectForKey:@"DESCRIPTION"];
             [AppDelegate showErrorMessageWithTitle:@"" message:DESCRIPTION delegate:nil];
         }
     }
     
          failure:^(NSURLSessionDataTask *operation, NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         NSLog(@"Fail");
     }];*/
}
- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error
{
    // Perform any operations when the user disconnects from app here.
}

- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error
{
    NSLog(@"%@",error.description);
}

// Present a view that prompts the user to sign in with Google
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];
}

- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
