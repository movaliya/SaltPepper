//
//  VideoGallaryView.m
//  MirchMasala
//
//  Created by kaushik on 16/09/17.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "VideoGallaryView.h"
#import "AVKit/AVKit.h"
#import "AVFoundation/AVFoundation.h"
#import "VideoCell.h"
#import <MediaPlayer/MediaPlayer.h>

@interface VideoGallaryView ()<UIWebViewDelegate>
{
    NSMutableArray *ImageNameSection;
    NSMutableArray *VideoArr,*VideoIdArr;

}
@end

@implementation VideoGallaryView

@synthesize VideoTBL,Web,ShowWebView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    _lblNoVideo.hidden = YES;
    if(IS_IPHONE_X)
    {
        _headerHeight.constant = 90;
    }
    else
    {
        _headerHeight.constant = 70;
    }
    
    self.navigationController.navigationBar.hidden=YES;

    ShowWebView.hidden=YES;
    Web.delegate=self;
    
    UINib *nib = [UINib nibWithNibName:@"VideoCell" bundle:nil];
    VideoCell *cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    VideoTBL.rowHeight = cell.frame.size.height;
    
    [VideoTBL registerNib:nib forCellReuseIdentifier:@"VideoCell"];
    
    //VideoArr=[[NSMutableArray alloc]initWithObjects:@"https://youtu.be/wWUzXFG_F4g",@"https://www.youtube.com/watch?v=b_J7ByLJw5A",@"https://www.youtube.com/watch?v=C0DPdy98e4c", nil];

 //   [VideoTBL reloadData];
    
    BOOL internet=[AppDelegate connectedToNetwork];
    if (internet)
    {
        [self VideoGalleryService];
    }
    else
        [AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
    
    
}


-(void)VideoGalleryService
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    [dictSub setObject:@"getitem" forKey:@"MODULE"];
    [dictSub setObject:@"videoGallery" forKey:@"METHOD"];
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
    NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
    
    [dictREQUESTPARAM setObject:arr forKey:@"REQUESTPARAM"];
    [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
    
    
    NSError* error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
    
    NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,VIDEOGALLERY];
    
    [Utility postRequest:json url:makeURL success:^(id result)
     {
         if (![result isKindOfClass:[NSString class]])
         {
             [MBProgressHUD hideHUDForView:self.view animated:YES];
             NSString *SUCCESS=[[[[result objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"videoGallery"] objectForKey:@"SUCCESS"];
             if ([SUCCESS boolValue] ==YES)
             {
                 VideoArr=[[[[[[result objectForKey:@"RESPONSE"] objectForKey:@"getitem"] objectForKey:@"videoGallery"] objectForKey:@"result"] objectForKey:@"videoGallery"] mutableCopy];
                 if(VideoArr.count == 0)
                 {
                     _lblNoVideo.hidden = NO;
                     VideoTBL.hidden = YES;
                 }
                 else
                 {
                     _lblNoVideo.hidden = YES;
                     VideoTBL.hidden = NO;
                     VideoIdArr=[[NSMutableArray alloc]init];
                     for (int i=0; i<VideoArr.count; i++)
                     {
                         NSString *VideoID= [self extractYoutubeIdFromLink:[[VideoArr valueForKey:@"content"] objectAtIndex:i]];
                         [VideoIdArr addObject:VideoID];
                     }
                     [VideoTBL reloadData];
                 }
                     
             }
         }
     }failure:^(NSError *error)
     {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         if (![Utility connected])
         {
             //[sharedAppDel ShowAlertWithOneBtn:kReachability andStrTitle:nil andbtnTitle:@"OK"];
         }
         else
         {
             //[sharedAppDel ShowAlertWithOneBtn:[result valueForKey:@"message"] andStrTitle:nil andbtnTitle:@"OK"];
         }
     }];
}

- (NSString *)extractYoutubeIdFromLink:(NSString *)link
{
    NSString *regexString = @"((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)";
    NSRegularExpression *regExp = [NSRegularExpression regularExpressionWithPattern:regexString
                                                                            options:NSRegularExpressionCaseInsensitive
                                                                              error:nil];
    
    NSArray *array = [regExp matchesInString:link options:0 range:NSMakeRange(0,link.length)];
    if (array.count > 0) {
        NSTextCheckingResult *result = array.firstObject;
        return [link substringWithRange:result.range];
    }
    return nil;
}

-(void)PlayYoutubeVideo:(NSString*)url frame:(CGRect)frame
{
    NSString* embedHTML = @"\
    <html><head>\
    <style type=\"text/css\">\
    body {\
    background-color: transparent;\
    color: white;\
    }\
    </style>\
    </head><body style=\"margin:0\">\
    <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
    width=\"%0.0f\" height=\"%0.0f\"></embed>\
    </body></html>";
    NSString* html = [NSString stringWithFormat:embedHTML, url, frame.size.width, frame.size.height];
    
    Web.backgroundColor = [UIColor clearColor];
    Web.opaque = NO;
    Web.mediaPlaybackRequiresUserAction = NO;
    
    [Web loadHTMLString:html baseURL:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)Back_click:(id)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];

}

#pragma mark UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return VideoIdArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 13.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if([[SharedClass sharedSingleton].storyBaordName isEqualToString:@"Main"])
    {
        return 190;
    }
    else
    {
        return 250;
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VideoCell";
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell=nil;
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
    }
    
    [cell.Thumbimg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://img.youtube.com/vi/%@/0.jpg",[VideoIdArr objectAtIndex:indexPath.section]]] placeholderImage:[UIImage imageNamed:@"slider_image_1.png"]];
    
    //[cell.Thumbimg setShowActivityIndicatorView:YES];
    
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSString *ExtLink_Str=[NSString stringWithFormat:@"https://www.youtube.com/watch?v=%@",[VideoIdArr objectAtIndex:indexPath.section]];
    
    ShowWebView.hidden=NO;
    [self.view bringSubviewToFront:ShowWebView];
    [self PlayYoutubeVideo:ExtLink_Str frame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-65)];
}

- (IBAction)WebView_Back:(id)sender
{
    [self.view sendSubviewToBack:ShowWebView];
    ShowWebView.hidden=YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (webView.isLoading)
    {
        NSLog(@"YES");
    }
    else
    {
        NSLog(@"NO");
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"finish");
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    NSLog(@"Error for WEBVIEW: %@", [error description]);
}

@end
