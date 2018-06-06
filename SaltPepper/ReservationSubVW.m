//
//  ReservationSubVW.m
//  MirchMasala
//
//  Created by Mango SW on 09/09/2017.
//  Copyright © 2017 jkinfoway. All rights reserved.
//

#import "ReservationSubVW.h"
#import "ReservationVW.h"

@interface ReservationSubVW ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIPickerView *pickerViewChild;
@property (nonatomic, strong) UIPickerView *pickerViewInfants;
@property (nonatomic, strong) UIPickerView *pickerViewStaytime;
@property (nonatomic, strong) UIPickerView *pickerViewComingtime;

@property (nonatomic, strong) NSArray *pickerNames;
@property (nonatomic, strong) NSArray *AdultpickerNames;
@property (nonatomic, strong) NSArray *StaypickerNames;
@property (nonatomic, strong) NSArray *ComingTimepickerNames;


@end

@implementation ReservationSubVW
@synthesize SelectDate_TXT,StayTime_TXT,ComingTime_TXT,Ault14_TXT,Children_TXT;
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden=YES;

    self.backView.layer.masksToBounds = NO;
    self.backView.layer.shadowOffset = CGSizeMake(0, 1);
    self.backView.layer.shadowRadius = 1.0;
    self.backView.layer.shadowColor = [UIColor colorWithRed:115.0f/255.0f green:115.0f/255.0f blue:115.0f/255.0f alpha:1.0f].CGColor;
    self.backView.layer.shadowOpacity = 0.5;
    
    [self setPickerToTXT];
   // [self SelectTimeFuc];
   // [self SelectStayTimeNMint];
    
    
    self.pickerView = [[UIPickerView alloc] init];
    self.pickerView.delegate = self;     //#2
    self.pickerView.dataSource = self;   //#2
    
    self.pickerViewChild = [[UIPickerView alloc] init];
    self.pickerViewChild.delegate = self;     //#2
    self.pickerViewChild.dataSource = self;   //#2
    
    self.pickerViewInfants = [[UIPickerView alloc] init];
    self.pickerViewInfants.delegate = self;     //#2
    self.pickerViewInfants.dataSource = self;   //#2
    
    self.pickerViewStaytime = [[UIPickerView alloc] init];
    self.pickerViewStaytime.delegate = self;     //#2
    self.pickerViewStaytime.dataSource = self;   //#2
    
    self.pickerViewComingtime = [[UIPickerView alloc] init];
    self.pickerViewComingtime.delegate = self;     //#2
    self.pickerViewComingtime.dataSource = self;   //#2
    
    Ault14_TXT.inputView = self.pickerView;
    Children_TXT.inputView = self.pickerViewChild;
    _infantsAge_TXT.inputView = self.pickerViewInfants;
     StayTime_TXT.inputView = self.pickerViewStaytime;
    ComingTime_TXT.inputView = self.pickerViewComingtime;
    
    
    self.pickerNames = @[ @"1", @"2", @"3", @"4", @"5", @"6",@"7", @"8", @"9", @"10", @"11", @"12",@"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20"];
    
    self.AdultpickerNames = @[ @"1", @"2", @"3", @"4", @"5", @"6",@"7", @"8", @"9", @"10", @"11", @"12",@"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20",@"Larger Party"];
    
    
    self.StaypickerNames = @[ @"30 minutes", @"1 hour", @"1 hour 30 minutes", @"2 hour", @"2 hour 30 minutes", @"3 hour",@"3 hour 30 minutes", @"4 hour", @"4 hour 30 minutes", @"5 hour", @"5 hour 30 minutes"];
    
    self.ComingTimepickerNames = @[ @"5:30 PM", @"5:45 PM", @"6:00 PM", @"6:15 PM", @"6:30 PM", @"6:45 PM",@"7:00 PM", @"7:15 PM", @"7:30 PM", @"7:45 PM", @"8:00 PM", @"8:15 PM",@"8:30 PM", @"8:45 PM", @"9:00 PM", @"9:15 PM", @"9:30 PM", @"9:45 PM", @"10:00 PM", @"10:15 PM", @"10:30 PM", @"10:45 PM", @"11:00 PM", @"11:15 PM", @"11:30 PM"];
    
    // Do any additional setup after loading the view.
}
#pragma mark - UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == self.pickerView) {
        return 1;
    }else
    {
        return 1;
    }
    
    return 0;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.pickerView) {
        return [self.AdultpickerNames count];
    }
    else if (pickerView == self.pickerViewStaytime)
    {
        return [self.StaypickerNames count];
    }
    else if (pickerView == self.pickerViewComingtime)
    {
        return [self.ComingTimepickerNames count];
    }
    else
    {
        return [self.pickerNames count];
    }
    
    return 0;
}

- (IBAction)btnFavClicked:(id)sender
{
    if (_ro(@"LoginUserDic") != nil)
    {
        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"FavouriteVW"]]
                                                     animated:YES];
        [self.sideMenuViewController hideMenuViewController];
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
    
}

- (IBAction)btnCartClicked:(id)sender
{
    if (_ro(@"LoginUserDic") != nil)
    {
        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"CartVW"]]
                                                     animated:YES];
        [self.sideMenuViewController hideMenuViewController];
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
}


#pragma mark - UIPickerViewDelegate
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (pickerView == self.pickerView) {
        return self.AdultpickerNames[row];
    }
    else  if (pickerView == self.pickerViewStaytime)
    {
        return self.StaypickerNames[row];
    }
    else  if (pickerView == self.pickerViewComingtime)
    {
        return self.ComingTimepickerNames[row];
    }
    else
    {
        return self.pickerNames[row];
    }
    return nil;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (pickerView == self.pickerView) {
        Ault14_TXT.text = self.AdultpickerNames[row];
    }
    if (pickerView == self.pickerViewInfants)
    {
         _infantsAge_TXT.text = self.pickerNames[row];
    }
    if (pickerView == self.pickerViewChild)
    {
        Children_TXT.text = self.pickerNames[row];
    }
    if (pickerView == self.pickerViewStaytime)
    {
        StayTime_TXT.text = self.StaypickerNames[row];
        
        NSString *removeStrstr = [StayTime_TXT.text stringByReplacingOccurrencesOfString:@"hour"
                                                                withString:@""];
        removeStrstr = [removeStrstr stringByReplacingOccurrencesOfString:@"minutes"  withString:@""];
        removeStrstr = [removeStrstr stringByReplacingOccurrencesOfString:@" "  withString:@","];
        removeStrstr = [removeStrstr stringByReplacingOccurrencesOfString:@",,"  withString:@","];
        removeStrstr = [removeStrstr stringByReplacingOccurrencesOfString:@" "  withString:@""];
        NSLog(@"removeStrstr: %@", removeStrstr);
        NSArray * arr = [removeStrstr componentsSeparatedByString:@","];
         Hour=[arr objectAtIndex:0];
        if ([[arr objectAtIndex:1]isEqualToString:@""])
        {
            Mint=@"0";
        }
        else
        {
             Mint=[arr objectAtIndex:1];
        }
        NSLog(@"Array values are : %@",arr);
    }
    if (pickerView == self.pickerViewComingtime)
    {
        ComingTime_TXT.text = self.ComingTimepickerNames[row];
       // @"5:30 PM
        
        Hour=[[ComingTime_TXT.text componentsSeparatedByString:@":"] objectAtIndex:0];
        Mint=[[ComingTime_TXT.text componentsSeparatedByString:@":"] objectAtIndex:1];
        Mint = [Mint stringByReplacingOccurrencesOfString:@"PM"  withString:@""];
        Mint = [Mint stringByReplacingOccurrencesOfString:@" "  withString:@""];
        
    }
}

-(void)setPickerToTXT
{
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:GregorianCalendar];
    NSDate *currentDate = [NSDate date];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:1];
    NSDate *maxDate = [calendar dateByAddingComponents:comps toDate:currentDate options:0];
    [comps setYear:-100];
    [datePicker setMaximumDate:maxDate];
    datePicker.backgroundColor=[UIColor whiteColor];
    
    [datePicker setMinimumDate:[NSDate date]];
    
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:self action:@selector(dateTextField:) forControlEvents:UIControlEventValueChanged];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.barStyle   = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *itemDone  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:SelectDate_TXT action:@selector(resignFirstResponder)];
    UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolbar.items = @[itemSpace,itemDone];
    
    SelectDate_TXT.inputAccessoryView = toolbar;
    [SelectDate_TXT setInputView:datePicker];
}
-(void) dateTextField:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)SelectDate_TXT.inputView;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = picker.date;
    [dateFormat setDateFormat:@"yyyy-MM-dd h:mm a"];
    
    
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    SelectDate_TXT.text = [NSString stringWithFormat:@"%@",dateString];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
     NSString *dateSep = [dateFormat stringFromDate:eventDate];
    ReservationDate = [NSString stringWithFormat:@"%@",dateSep];
    
    [dateFormat setDateFormat:@"h:mm a"];
    NSString *TimeSep = [dateFormat stringFromDate:eventDate];
    ReservationTime = [NSString stringWithFormat:@"%@",TimeSep];
}
-(void)SelectTimeFuc
{
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    datePicker.datePickerMode = UIDatePickerModeTime;
    datePicker.backgroundColor=[UIColor whiteColor];
    [datePicker addTarget:self action:@selector(dateTextField1:) forControlEvents:UIControlEventValueChanged];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.barStyle   = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *itemDone  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:ComingTime_TXT action:@selector(resignFirstResponder)];
    UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolbar.items = @[itemSpace,itemDone];
    
    ComingTime_TXT.inputAccessoryView = toolbar;
    [ComingTime_TXT setInputView:datePicker];
}
-(void) dateTextField1:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)ComingTime_TXT.inputView;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = picker.date;
    [dateFormat setDateFormat:@"hh:mm a"];
    
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    ComingTime_TXT.text = [NSString stringWithFormat:@"%@",dateString];
}
-(void)SelectStayTimeNMint
{
    UIDatePicker *datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    datePicker.backgroundColor=[UIColor whiteColor];
    [datePicker addTarget:self action:@selector(dateTextField2:) forControlEvents:UIControlEventValueChanged];
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    toolbar.barStyle   = UIBarStyleBlackTranslucent;
    
    UIBarButtonItem *itemDone  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:StayTime_TXT action:@selector(resignFirstResponder)];
    UIBarButtonItem *itemSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    toolbar.items = @[itemSpace,itemDone];
    
    StayTime_TXT.inputAccessoryView = toolbar;
    [StayTime_TXT setInputView:datePicker];
}
-(void) dateTextField2:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)StayTime_TXT.inputView;
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = picker.date;
    [dateFormat setDateFormat:@"hh:mm"];
    
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    StayTime_TXT.text = [NSString stringWithFormat:@"%@",dateString];

    [dateFormat setDateFormat:@"hh"];
    Hour=[dateFormat stringFromDate:eventDate];
    [dateFormat setDateFormat:@"mm"];
    Mint=[dateFormat stringFromDate:eventDate];
    
}



- (IBAction)SubmitBtn_Action:(id)sender
{
    //RESERVATION_DATE
    //RESERVATION_TIME
   // RESERVATION_DURATION_HOUR
   // RESERVATION_DURATION_MINUTE
   // ADULT
    
    
    
    if ([SelectDate_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please select Date." delegate:nil];
    }
    else if ([Ault14_TXT.text isEqualToString:@""])
    {
        
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please select Ault." delegate:nil];
    }
    else if ([ComingTime_TXT.text isEqualToString:@""])
    {
        [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please select coming time." delegate:nil];
    }
    else
    {
        ReservationVW *vcr = [[UIStoryboard storyboardWithName:[SharedClass sharedSingleton].storyBaordName  bundle:nil] instantiateViewControllerWithIdentifier:@"ReservationVW"];
        vcr.Res_date=ReservationDate;
        vcr.Res_Time=ReservationTime;
        vcr.aultNo=Ault14_TXT.text;
        vcr.Stay_Hour=Hour;
        vcr.Stay_Mint=Mint;
        
       // vcr.childerNo=Children_TXT.text;
        //vcr.InfantsNo=_infantsAge_TXT.text;
        
        [self.navigationController pushViewController:vcr animated:YES];
    }

   
}
- (IBAction)backBtn_Action:(id)sender
{
    [self.sideMenuViewController presentLeftMenuViewController];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
