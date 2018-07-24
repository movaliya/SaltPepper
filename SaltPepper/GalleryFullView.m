//
//  GalleryFullView.m
//  MirchMasala
//
//  Created by Mango SW on 26/09/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "GalleryFullView.h"
@interface GalleryFullView ()

@end

@implementation GalleryFullView
@synthesize ImageScrollView,imageVW;
@synthesize ImagArr,SelectedImage;
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    if(IS_IPHONE_X)
    {
        _headerHeight.constant = 90;
    }
    else
    {
        _headerHeight.constant = 70;
    }
    
    ImageNameSection=[[NSMutableArray alloc]initWithObjects:@"cart.png",@"gallery.png",@"cart.png",@"gallery.png",@"cart.png",@"gallery.png", nil];
    
    int x=0;
    for (int i = 0; i < ImagArr.count; i++)
    {
        CGRect frame;
        frame.origin.x = SCREEN_WIDTH * i;
        frame.origin.y = 0;
        
        //frame.origin.x = 0;
       // frame.origin.y = ImageScrollView.frame.size.height * i;
        
        //frame.size = ImageScrollView.frame.size;
        UIImageView *newPageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, SCREEN_WIDTH, SCREEN_HEIGHT-60)];
        NSString *Urlstr=[[ImagArr valueForKey:@"image_path"] objectAtIndex:i];
        [newPageView sd_setImageWithURL:[NSURL URLWithString:Urlstr] placeholderImage:[UIImage imageNamed:@"placeholder_img"]];
        //[newPageView setShowActivityIndicatorView:YES];
        
        newPageView.contentMode = UIViewContentModeScaleAspectFit;
        
       // newPageView.frame = CGRectMake(frame.origin.x,frame.origin.y , self.view.frame.size.width, frame.size.height);
        
        //newPageView.frame = frame;
       
        [ImageScrollView addSubview:newPageView];\
        
        x=x+SCREEN_WIDTH;
    }
    ImageScrollView.contentSize = CGSizeMake(x , ImageScrollView.frame.size.height);
    
    //ImageScrollView.contentSize = CGSizeMake(ImageScrollView.frame.size.width , ImageScrollView.frame.size.height* ImageNameSection.count);
    
    int selectindex=[SelectedImage integerValue];
    [ImageScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*selectindex, 0.0f) animated:YES];

   
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
}

- (IBAction)BackBtn_click:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
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
