//
//  DEMOLeftMenuViewController.m
//  RESideMenuStoryboards
//
//  Created by Roman Efimov on 10/9/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "DEMOLeftMenuViewController.h"
#import "UIViewController+RESideMenu.h"
#import "HomeVC.h"
#import "LoginVW.h"
#import "ProfileView.h"

@interface DEMOLeftMenuViewController ()

@property (strong, readwrite, nonatomic) UITableView *tableView;

@end

@implementation DEMOLeftMenuViewController
@synthesize profilePictIMVW,Username_LBL,Notification_LBL;

- (void)viewDidLoad
{
    [super viewDidLoad];
//    self.tableView = ({
//        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 5) / 2.0f, self.view.frame.size.width, 54 * 5) style:UITableViewStylePlain];
//        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
//        tableView.delegate = self;
//        tableView.dataSource = self;
//        tableView.opaque = NO;
//        tableView.backgroundColor = [UIColor clearColor];
//        tableView.backgroundView = nil;
//        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        tableView.bounces = NO;
//        tableView.scrollsToTop = NO;
//        tableView;
//    });
//    [self.view addSubview:self.tableView];
    
    self.MenuTBL.backgroundColor = [UIColor clearColor];
    self.MenuTBL.backgroundView = nil;
    self.MenuTBL.bounces = NO;
    
    profilePictIMVW.layer.cornerRadius = profilePictIMVW.frame.size.width / 2;
    profilePictIMVW.clipsToBounds = YES;
    profilePictIMVW.layer.borderWidth = 3.0f;
    profilePictIMVW.layer.borderColor = [UIColor blackColor].CGColor;
    
    Notification_LBL.layer.masksToBounds = YES;
    Notification_LBL.layer.cornerRadius = 14.0;
    
    NSLog(@"side menu call");
    [self checkReservationState];
   
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self SetMenuItem];
}
-(void)SetMenuItem
{
    if (_ro(@"LoginUserDic") != nil)
    {
        CheckReservationState = [[NSUserDefaults standardUserDefaults]
                                 stringForKey:@"reservationState"];
        if ([CheckReservationState isEqualToString:@"YES"])
        {
            titles = @[@"Home", @"Cart", @"Reservation",@"Reservation History", @"Gallery", @"News", @"Profile",@"Order History" ,@"Favourite",@"Information", @"Video Gallery",@"Message",@"Contact Us", @"Logout"];
            
            images = @[@"ic_home", @"ic_cart",@"ic_reservation",@"ic_reservation", @"ic_gallery", @"ic_news",@"ic_profile",@"ic_orderHistry",@"ic_profile",@"ic_info", @"ic_videogallery", @"ic_message", @"ic_contactus", @"ic_logout"];
        }
        else
        {
            titles = @[@"Home", @"Cart", @"Gallery", @"News", @"Profile",@"Order History" ,@"Favourite",@"Information", @"Video Gallery",@"Message",@"Contact Us", @"Logout"];
            
            images = @[@"ic_home", @"ic_cart", @"ic_gallery", @"ic_news",@"ic_profile",@"ic_orderHistry",@"ic_profile",@"ic_info", @"ic_videogallery", @"ic_message", @"ic_contactus", @"ic_logout"];
        }
        
    }
    else
    {
        CheckReservationState = [[NSUserDefaults standardUserDefaults]
                                 stringForKey:@"reservationState"];
        if ([CheckReservationState isEqualToString:@"YES"])
        {
            titles = @[@"Home", @"Cart", @"Reservation",@"Reservation History", @"Gallery", @"News", @"Information", @"Video Gallery",@"Message",@"Contact Us", @"Login or Signup"];
            
            images = @[@"ic_home", @"ic_cart",@"ic_reservation",@"ic_reservation", @"ic_gallery", @"ic_news", @"ic_info", @"ic_videogallery", @"ic_message", @"ic_contactus", @"ic_logout"];
        }
        else
        {
            titles = @[@"Home", @"Cart", @"Gallery", @"News", @"Information", @"Video Gallery",@"Message",@"Contact Us", @"Login or Signup"];
            
            images = @[@"ic_home", @"ic_cart", @"ic_gallery", @"ic_news", @"ic_info", @"ic_videogallery", @"ic_message", @"ic_contactus", @"ic_logout"];
        }
        
    }
}
-(void)checkReservationState
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    [dictSub setObject:@"reservationState" forKey:@"METHOD"];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
    NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
    
    [dictREQUESTPARAM setObject:arr forKey:@"REQUESTPARAM"];
    [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
    
    NSError* error = nil;
    
    NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,RESERVATIONSTATE];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
    // NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    
    [Utility postRequest:json url:makeURL success:^(id responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"responseObject==%@",responseObject);
        NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"reservationState"] objectForKey:@"SUCCESS"];
        if ([SUCCESS boolValue] ==YES)
        {
            NSString *checkRevState=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"reservationState"] objectForKey:@"RESULT"] objectForKey:@"reservationState"];
            
            if ([checkRevState boolValue] ==YES)
            {
               // NSString *valueToSave = @"YES";
                NSString *valueToSave = @"NO";
                [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"reservationState"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else
            {
                NSString *valueToSave = @"NO";
                [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"reservationState"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            [self SetMenuItem];
             [self.MenuTBL reloadData];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"Fail");
    }];
}

- (IBAction)Logout_BT_Action:(id)sender
{
    NSLog(@"LOGOUT");
}

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_ro(@"LoginUserDic") != nil)
    {
        //User Login
        CheckReservationState = [[NSUserDefaults standardUserDefaults]
                                 stringForKey:@"reservationState"];
        if ([CheckReservationState isEqualToString:@"YES"])
        {
            switch (indexPath.row) {
                case 0:
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"]]
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    break;
                case 1:
                    //Cart
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"CartVW"]]
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    break;
                case 2:
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ReservationSubVW"]]
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    break;
                case 3:
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ReservationHistoryVC"]]
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    // Reservation Histry
                    break;
                case 4:
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"GalleryVW"]]
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    break;
                case 5:
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"NewsVW"]]
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    break;
                case 6:
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ProfileView"]]//  OptionView // ProfileView
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    break;
                case 7:
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"OrderHistoryVC"]]//  OptionView // ProfileView
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    //Order Histry
                    break;
                case 8:
                    //Favourite
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"FavouriteVW"]]//  Favourite //
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    break;
                case 9:
                    //Information
                    break;
                case 10:
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"VideoGallaryView"]]
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    break;
                case 11:
                    //Message
                    break;
                case 12:
                    //ContactUs
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ContactUSVW"]]
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    break;
                case 13:
                    if (_ro(@"LoginUserDic") != nil)
                    {
                        FCAlertView *alert = [KmyappDelegate ShowAlertWithBtnAction:@"Are you sure want to Logout?" andStrTile:nil andbtnTitle:@"NO" andButtonArray:@[]];
                        
                        [alert addButton:@"YES" withActionBlock:^{
                            
                            titles = @[@"Home", @"Cart", @"Reservation",@"Reservation History", @"Gallery", @"News", @"Information", @"Video Gallery",@"Message",@"Contact Us", @"Login or Signup"];
                            
                            images = @[@"ic_home", @"ic_cart",@"ic_reservation",@"ic_reservation", @"ic_gallery", @"ic_news", @"ic_info", @"ic_videogallery", @"ic_message", @"ic_contactus", @"ic_logout"];
                            
                            _Rm(@"LoginUserDic")
                            _Rm(@"CartDIC")
                            _Rm(@"FavDIC")
                            KmyappDelegate.MainCartArr.removeAllObjects;
                            [[GIDSignIn sharedInstance] signOut];
                            [self.MenuTBL reloadData];
                            [self.sideMenuViewController hideMenuViewController];
                            
                            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"]]
                                                                         animated:YES];
                            [self.sideMenuViewController hideMenuViewController];
                        }];
                        
                    }
                    else
                    {
                        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginVW"]]
                                                                     animated:YES];
                        [self.sideMenuViewController hideMenuViewController];
                    }
                    
                    break;
                default:
                    break;
            }
        }
        else
        {
            switch (indexPath.row) {
                case 0:
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"]]
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    break;
                case 1:
                    //Cart
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"CartVW"]]
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    break;
               
                case 3:
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"GalleryVW"]]
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    break;
                case 4:
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"NewsVW"]]
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    break;
                case 5:
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ProfileView"]]//  OptionView // ProfileView
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    break;
                case 6:
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"OrderHistoryVC"]]//  OptionView // ProfileView
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    //Order Histry
                    break;
                case 7:
                    //Favourite
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"FavouriteVW"]]//  Favourite //
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    break;
                case 8:
                    //Information
                    break;
                case 9:
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"VideoGallaryView"]]
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    break;
                case 10:
                    //Message
                    break;
                case 11:
                    //ContactUs
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ContactUSVW"]]
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    break;
                case 12:
                    if (_ro(@"LoginUserDic") != nil)
                    {
                        FCAlertView *alert = [KmyappDelegate ShowAlertWithBtnAction:@"Are you sure want to Logout?" andStrTile:nil andbtnTitle:@"NO" andButtonArray:@[]];
                        
                        [alert addButton:@"YES" withActionBlock:^{
                            
                            titles = @[@"Home", @"Cart",@"Gallery", @"News", @"Information", @"Video Gallery",@"Message",@"Contact Us", @"Login or Signup"];
                            
                            images = @[@"ic_home", @"ic_cart",@"ic_gallery", @"ic_news", @"ic_info", @"ic_videogallery", @"ic_message", @"ic_contactus", @"ic_logout"];
                            
                            _Rm(@"LoginUserDic")
                            _Rm(@"CartDIC")
                            _Rm(@"FavDIC")
                            KmyappDelegate.MainCartArr.removeAllObjects;
                            [[GIDSignIn sharedInstance] signOut];
                            [self.MenuTBL reloadData];
                            [self.sideMenuViewController hideMenuViewController];
                            
                            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"]]
                                                                         animated:YES];
                            [self.sideMenuViewController hideMenuViewController];
                        }];
                        
                    }
                    else
                    {
                        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginVW"]]
                                                                     animated:YES];
                        [self.sideMenuViewController hideMenuViewController];
                    }
                    
                    break;
                default:
                    break;
            }
        }
       
    }
    else
    {
        //Usernot Login
        if ([CheckReservationState isEqualToString:@"YES"])
        {
            switch (indexPath.row) {
                case 0:
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"]]
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    break;
                case 1:
                    //Cart View CartVW
                    if (_ro(@"LoginUserDic") != nil)
                    {
                    }
                    else
                    {
                        FCAlertView *alert = [KmyappDelegate ShowAlertWithBtnAction:@"Please First Login" andStrTile:nil andbtnTitle:@"Cancel" andButtonArray:@[]];
                        
                        [alert addButton:@"Login" withActionBlock:^{
                            
                            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginVW"]]
                                                                         animated:YES];
                            [self.sideMenuViewController hideMenuViewController];
                            
                        }];
                    }
                    break;
                case 2:
                    if (_ro(@"LoginUserDic") != nil)
                    {
                    }
                    else
                    {
                        FCAlertView *alert = [KmyappDelegate ShowAlertWithBtnAction:@"Please First Login" andStrTile:nil andbtnTitle:@"Cancel" andButtonArray:@[]];
                        
                        [alert addButton:@"Login" withActionBlock:^{
                            
                            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginVW"]]
                                                                         animated:YES];
                            [self.sideMenuViewController hideMenuViewController];
                            
                        }];
                    }
                    break;
                case 3:
                    if (_ro(@"LoginUserDic") != nil)
                    {
                    }
                    else
                    {
                        FCAlertView *alert = [KmyappDelegate ShowAlertWithBtnAction:@"Please First Login" andStrTile:nil andbtnTitle:@"Cancel" andButtonArray:@[]];
                        
                        [alert addButton:@"Login" withActionBlock:^{
                            
                            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginVW"]]
                                                                         animated:YES];
                            [self.sideMenuViewController hideMenuViewController];
                            
                        }];
                    }
                    // Reservation Histry
                    break;
                case 4:
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"GalleryVW"]]
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    break;
                case 5:
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"NewsVW"]]
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    break;
                case 6:
                    //Information VW
                    break;
                case 7:
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"VideoGallaryView"]]
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    break;
                case 8:
                    //Message
                    break;
                case 9:
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ContactUSVW"]]
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    break;
                case 10:
                    if (_ro(@"LoginUserDic") != nil)
                    {
                        FCAlertView *alert = [KmyappDelegate ShowAlertWithBtnAction:@"Are you sure want to Logout?" andStrTile:nil andbtnTitle:@"NO" andButtonArray:@[]];
                        
                        [alert addButton:@"YES" withActionBlock:^{
                            
                            titles = @[@"Home", @"Cart", @"Reservation",@"Reservation History", @"Gallery", @"News", @"Information", @"Video Gallery",@"Message",@"Contact Us", @"Login or Signup"];
                            
                            images = @[@"ic_home", @"ic_cart",@"ic_reservation",@"ic_reservation", @"ic_gallery", @"ic_news", @"ic_info", @"ic_videogallery", @"ic_message", @"ic_contactus", @"ic_logout"];
                            
                            _Rm(@"LoginUserDic")
                            [[GIDSignIn sharedInstance] signOut];
                            [self.MenuTBL reloadData];
                            [self.sideMenuViewController hideMenuViewController];
                            
                        }];
                    }
                    else
                    {
                        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginVW"]]
                                                                     animated:YES];
                        [self.sideMenuViewController hideMenuViewController];
                    }
                    
                    break;
                default:
                    break;
            }
        }
        else
        {
            switch (indexPath.row) {
                case 0:
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"]]
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    break;
                case 1:
                    //Cart View CartVW
                    if (_ro(@"LoginUserDic") != nil)
                    {
                    }
                    else
                    {
                        FCAlertView *alert = [KmyappDelegate ShowAlertWithBtnAction:@"Please First Login" andStrTile:nil andbtnTitle:@"Cancel" andButtonArray:@[]];
                        
                        [alert addButton:@"Login" withActionBlock:^{
                            
                            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginVW"]]
                                                                         animated:YES];
                            [self.sideMenuViewController hideMenuViewController];
                            
                        }];
                    }
                    break;
                case 2:
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"GalleryVW"]]
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    break;
                case 3:
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"NewsVW"]]
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    break;
                case 4:
                    //Information VW
                    break;
                case 5:
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"VideoGallaryView"]]
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    break;
                case 6:
                    //Message
                    break;
                case 7:
                    [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ContactUSVW"]]
                                                                 animated:YES];
                    [self.sideMenuViewController hideMenuViewController];
                    break;
                case 8:
                    if (_ro(@"LoginUserDic") != nil)
                    {
                        FCAlertView *alert = [KmyappDelegate ShowAlertWithBtnAction:@"Are you sure want to Logout?" andStrTile:nil andbtnTitle:@"NO" andButtonArray:@[]];
                        
                        [alert addButton:@"YES" withActionBlock:^{
                            
                            titles = @[@"Home", @"Cart",@"Gallery", @"News", @"Information", @"Video Gallery",@"Message",@"Contact Us", @"Login or Signup"];
                            
                            images = @[@"ic_home", @"ic_cart",@"ic_gallery", @"ic_news", @"ic_info", @"ic_videogallery", @"ic_message", @"ic_contactus", @"ic_logout"];
                            
                            _Rm(@"LoginUserDic")
                            [[GIDSignIn sharedInstance] signOut];
                            [self.MenuTBL reloadData];
                            [self.sideMenuViewController hideMenuViewController];
                            
                        }];
                    }
                    else
                    {
                        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"LoginVW"]]
                                                                     animated:YES];
                        [self.sideMenuViewController hideMenuViewController];
                    }
                    
                    break;
                default:
                    break;
            }
        }
       

    }
}


#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[SharedClass sharedSingleton].storyBaordName isEqualToString:@"Main"])
    {
        return 54;
    }
    else
    {
        return 80;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        if([[SharedClass sharedSingleton].storyBaordName isEqualToString:@"Main"])
        {
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
            cell.textLabel.textColor = [UIColor colorWithRed:254.0/255.0f green:238.0/255.0f
                                                        blue:207.0/255.0f alpha:1.0];
        }
        else
        {
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:25];
            cell.textLabel.textColor = [UIColor colorWithRed:254.0/255.0f green:238.0/255.0f
                                                        blue:207.0/255.0f alpha:1.0];
        }
        //cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    cell.textLabel.text = titles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    cell.imageView.image = [ [UIImage imageNamed:images[indexPath.row]] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

    cell.imageView.tintColor=[UIColor colorWithRed:254.0/255.0f green:238.0/255.0f
                                              blue:207.0/255.0f alpha:1.0];
    return cell;
}

@end
