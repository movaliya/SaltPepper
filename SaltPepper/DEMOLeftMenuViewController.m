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
    
    
   
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_ro(@"LoginUserDic") != nil)
    {
        titles = @[@"Home", @"Cart", @"Reservation",@"Reservation History", @"Gallery", @"News", @"Profile",@"Order History" ,@"Favourite",@"Information", @"Video Gallery",@"Message",@"Contact Us", @"Logout"];
        
        images = @[@"ic_home", @"ic_cart",@"ic_reservation",@"ic_reservation", @"ic_gallery", @"ic_news",@"ic_profile",@"ic_orderHistry",@"ic_profile",@"ic_info", @"ic_videogallery", @"ic_message", @"ic_contactus", @"ic_logout"];
    }
    else
    {
        titles = @[@"Home", @"Cart", @"Reservation",@"Reservation History", @"Gallery", @"News", @"Information", @"Video Gallery",@"Message",@"Contact Us", @"Login or Signup"];
        
        images = @[@"ic_home", @"ic_cart",@"ic_reservation",@"ic_reservation", @"ic_gallery", @"ic_news", @"ic_info", @"ic_videogallery", @"ic_message", @"ic_contactus", @"ic_logout"];
    }
    
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
        switch (indexPath.row) {
            case 0:
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"]]
                                                             animated:YES];
                [self.sideMenuViewController hideMenuViewController];
                break;
            case 1:
                //Cart
                break;
            case 2:
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ReservationSubVW"]]
                                                             animated:YES];
                [self.sideMenuViewController hideMenuViewController];
                break;
            case 3:
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
                //Order Histry
                break;
            case 8:
                //Favourite
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
        //Usernot Login
        switch (indexPath.row) {
            case 0:
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"HomeVC"]]
                                                             animated:YES];
                [self.sideMenuViewController hideMenuViewController];
                break;
            case 1:
                //Cart View
                break;
            case 2:
                [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"ReservationSubVW"]]
                                                             animated:YES];
                [self.sideMenuViewController hideMenuViewController];
                break;
            case 3:
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
}


#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
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
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        cell.textLabel.textColor = [UIColor colorWithRed:254.0/255.0f green:238.0/255.0f
                                                    blue:207.0/255.0f alpha:1.0];
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
