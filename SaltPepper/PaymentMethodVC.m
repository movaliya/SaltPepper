//
//  PaymentMethodVC.m
//  SaltPepper
//
//  Created by Dharmraj Vora on 02/06/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "PaymentMethodVC.h"
#import <Stripe/Stripe.h>
#import "OrderCompleteVC.h"


typedef NS_ENUM(NSInteger, STPBackendChargeResult) {
    STPBackendChargeResultSuccess,
    STPBackendChargeResultFailure,
};
typedef void (^STPSourceSubmissionHandler)(STPBackendChargeResult status, NSError *error);

@interface PaymentMethodVC ()<STPPaymentCardTextFieldDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    STPCardParams *CardParam;
}
@property (weak, nonatomic) STPPaymentCardTextField *paymentTextField;
@property (weak, nonatomic) UIActivityIndicatorView *activityIndicator;

@end

@implementation PaymentMethodVC
@synthesize txtCVV,txtCardName,txtCardNumber,txtExipireDate,CardImage;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // TextField Set
    CardTypeRegx = [[NSMutableArray alloc]initWithObjects:@"^4[0-9]$" , @"^5[1-5]" , @"^3[47]" , nil];
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    
    cyear = [formatter stringFromDate:[NSDate date]];
    
    years = [[NSMutableArray alloc] init];
    int toyear = [cyear intValue] + 20;
    for (int i=[cyear intValue]; i<=toyear; i++)
    {
        [years addObject:[NSString stringWithFormat:@"%d",i]];
    }
    months=[[NSMutableArray alloc]initWithObjects:@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",@"10",@"11",@"12",nil];
    
    
    [_viewDetail.layer setShadowColor:[UIColor grayColor].CGColor];
    [_viewDetail.layer setShadowOpacity:0.8];
    [_viewDetail.layer setShadowRadius:3.0];
    [_viewDetail.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    if([[SharedClass sharedSingleton].storyBaordName isEqualToString:@"Main"])
    {
        _viewName.layer.cornerRadius = 20;
        _viewName.layer.borderWidth = 1.0;
        _viewName.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _viewNumber.layer.cornerRadius = 20;
        _viewNumber.layer.borderWidth = 1.0;
        _viewNumber.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _viewExpireDate.layer.cornerRadius = 20;
        _viewExpireDate.layer.borderWidth = 1.0;
        _viewExpireDate.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _viewCVV.layer.cornerRadius = 20;
        _viewCVV.layer.borderWidth = 1.0;
        _viewCVV.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _btnConfirmPayment.layer.cornerRadius = 20;
    }
    else
    {
        _viewName.layer.cornerRadius = 25;
        _viewName.layer.borderWidth = 1.0;
        _viewName.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _viewNumber.layer.cornerRadius = 25;
        _viewNumber.layer.borderWidth = 1.0;
        _viewNumber.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _viewExpireDate.layer.cornerRadius = 25;
        _viewExpireDate.layer.borderWidth = 1.0;
        _viewExpireDate.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _viewCVV.layer.cornerRadius = 25;
        _viewCVV.layer.borderWidth = 1.0;
        _viewCVV.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _btnConfirmPayment.layer.cornerRadius = 25;
    }
    
    _viewPayOn.hidden = YES;
    _viewCredit.hidden = NO;
    payType=@"Online Pay";
    PAYMENTTYPE=@"stripe";
    
  Userdata=[AppDelegate GetData:@"LoginUserDic"];
    NSString *customer_name = [[[[[[[Userdata valueForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"myProfile"] objectForKey:@"customer_name"];
    NSString *customer_email = [[[[[[[Userdata valueForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"myProfile"] objectForKey:@"email"];
    NSString *customer_Mobile = [[[[[[[Userdata valueForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"myProfile"] objectForKey:@"mobile"];
    self.lblName.text=customer_name;
    self.lblEmail.text=customer_email;
     self.lblPhone.text=customer_Mobile;
    self.lblAmount.text=self.FinalTotal;
    self.lblOrderType.text=self.OrderType;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Click Action

- (IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)btnCreditClicked:(id)sender
{
    if ([payType isEqualToString:@"Pay on collection"])
    {
        [_btnCredit setBackgroundColor:[UIColor colorWithRed:123.0/255.0 green:11.0/255.0 blue:12.0/255.0 alpha:1.0]];
        [_btnPayOnCollection setBackgroundColor:[UIColor lightGrayColor]];
        _viewPayOn.hidden = YES;
        _viewCredit.hidden = NO;
        payType=@"Online Pay";
        PAYMENTTYPE=@"stripe";
    }
    
}
- (IBAction)btnPayClicked:(id)sender
{
   
    if ([payType isEqualToString:@"Online Pay"])
    {
        [_btnPayOnCollection setBackgroundColor:[UIColor colorWithRed:123.0/255.0 green:11.0/255.0 blue:12.0/255.0 alpha:1.0]];
        [_btnCredit setBackgroundColor:[UIColor lightGrayColor]];
        _viewCredit.hidden = YES;
        _viewPayOn.hidden = NO;
         payType=@"Pay on collection";
         PAYMENTTYPE=@"pay_on_collection";
    }
    
}
- (IBAction)btnConfirmClicked:(id)sender
{
    if ([payType isEqualToString:@"Online Pay"])
    {
        // Online Pay
        
        if ([txtCardName.text isEqualToString:@""])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Name" delegate:nil];
        }
        else if ([txtCardNumber.text isEqualToString:@""])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Card Number" delegate:nil];
        }
        else  if ([txtExipireDate.text isEqualToString:@""])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter Expire Date" delegate:nil];
        }
        else  if ([txtCVV.text isEqualToString:@""])
        {
            [AppDelegate showErrorMessageWithTitle:@"Error!" message:@"Please enter CVC number" delegate:nil];
        }
        else
        {
            NSString *cardNumber=[txtCardNumber.text stringByReplacingOccurrencesOfString:@"-"
                                                                               withString:@""];
            CardParam = [[STPCardParams alloc]init];
            CardParam.number = cardNumber;
            CardParam.cvc = txtCVV.text;
            CardParam.expMonth =[monthNo integerValue];
            CardParam.expYear = [year integerValue];
            
            
            if ([self validateCustomerInfo]) {
                _btnConfirmPayment.enabled=NO;
               _btnConfirmPayment.backgroundColor=[UIColor grayColor];
                [self performStripeOperation];
            }
        }
    }
    else
    {
        // Pay on Collection
          PAIDAMOUNT=@"0";
         [self PlaceOrderServiceCall];
    }
}
- (void)performStripeOperation
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    NSLog(@"defaultPublishableKey=%@",[Stripe defaultPublishableKey]);
    if (![Stripe defaultPublishableKey])
    {
        NSString *PublishableKey = [[NSUserDefaults standardUserDefaults]
                                    stringForKey:@"PublishableKey"];
        if (!PublishableKey) {
            [self storeDataWithCompletion:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString * PublishableKey = [[NSUserDefaults standardUserDefaults]
                                                 stringForKey:@"PublishableKey"];
                    [[STPPaymentConfiguration sharedConfiguration] setPublishableKey:PublishableKey];
                });
            }];
        }
        else
        {
            [[STPPaymentConfiguration sharedConfiguration] setPublishableKey:PublishableKey];
        }
    }
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    
    [[STPAPIClient sharedClient] createTokenWithCard:CardParam
                                          completion:^(STPToken *token, NSError *error) {
                                              if (error) {
                                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                  [self exampleViewController:self didFinishWithError:error];
                                              }
                                              NSLog(@"token===%@",token.tokenId);
                                              [self createBackendChargeWithSource:token.tokenId completion:^(STPBackendChargeResult result, NSError *error) {
                                                  if (error) {
                                                      [self exampleViewController:self didFinishWithError:error];
                                                      return;
                                                  }
                                                  [MBProgressHUD hideHUDForView:self.view animated:YES];
                                                  // [self.delegate exampleViewController:self didFinishWithMessage:@"Payment successfully created"];
                                              }];
                                          }];
   [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    
    
}
- (void)storeDataWithCompletion:(void (^)(void))completion
{
    // Store Data Processing...
    if (completion) {
        [KmyappDelegate GetPublishableKey];
    }
}
#pragma mark STPAddCardViewControllerDelegate

#pragma mark - STPBackendCharging

- (void)createBackendChargeWithSource:(NSString *)sourceID completion:(STPSourceSubmissionHandler)completion {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSLog(@"Token==%@",sourceID);
    if (sourceID)
    {
        completion(STPBackendChargeResultSuccess, nil);
        BOOL internet=[AppDelegate connectedToNetwork];
        if (internet)
        {
           NSString *OrderAmount = [self.FinalTotal stringByReplacingOccurrencesOfString:@"£"
                                                                 withString:@""];

            [self ChargeCard:sourceID paidAmount:OrderAmount];
        }
        else
        {
            NSError *error;
            [self exampleViewController:self didFinishWithError:error];
            //[AppDelegate showErrorMessageWithTitle:@"" message:@"Please check your internet connection or try again later." delegate:nil];
        }
    }
    return;
    
   
}
-(void)ChargeCard:(NSString *)token paidAmount:(NSString *)Amoumnt
{
    //[MBProgressHUD showHUDAddedTo:self.view animated:YES];

     NSString *customer_email = [[[[[[[Userdata valueForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"myProfile"] objectForKey:@"email"];
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
    [dictInner setObject:Amoumnt forKey:@"AMOUNT"];
    [dictInner setObject:token forKey:@"TOKEN"];
    [dictInner setObject:customer_email forKey:@"EMAIL"];
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    
    [dictSub setObject:@"action" forKey:@"MODULE"];
    
    [dictSub setObject:@"chargeCard" forKey:@"METHOD"];
    
    [dictSub setObject:dictInner forKey:@"PARAMS"];
    
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
    NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
    
    [dictREQUESTPARAM setObject:arr forKey:@"REQUESTPARAM"];
    [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
    NSLog(@"dictREQUESTPARAM==%@",dictREQUESTPARAM);
    
    NSError* error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
    // NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    
    
    NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,CHARGECARD];

     [Utility postRequest:json url:makeURL success:^(id responseObject) {
         NSLog(@"charge card responseObject==%@",responseObject);
         
         NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"chargeCard"] objectForKey:@"SUCCESS"];
         if ([SUCCESS boolValue] ==YES)
         {
             PAIDAMOUNT=Amoumnt;
            [self PlaceOrderServiceCall];
         }
         else
         {
             [AppDelegate showErrorMessageWithTitle:@"" message:@"Server Error." delegate:nil];
             _btnConfirmPayment.enabled=YES;
             _btnConfirmPayment.backgroundColor=[UIColor colorWithRed:123.0/255.0 green:11.0/255.0 blue:12.0/255.0 alpha:1.0];
         }
         
         [MBProgressHUD hideHUDForView:self.view animated:YES];

     }
      failure:^(NSError *error) {
          
          NSLog(@"Fail");
          //[AppDelegate showErrorMessageWithTitle:@"Payment Failures" message:@"Keep calm and retry!" delegate:nil];
          [self exampleViewController:self didFinishWithError:error];
          [MBProgressHUD hideHUDForView:self.view animated:YES];
      }];

}
#pragma mark - ExampleViewControllerDelegate

- (void)exampleViewController:(UIViewController *)controller didFinishWithMessage:(NSString *)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            _btnConfirmPayment.enabled=YES;
            _btnConfirmPayment.backgroundColor=[UIColor colorWithRed:123.0/255.0 green:11.0/255.0 blue:12.0/255.0 alpha:1.0];
            //[self.navigationController popToRootViewControllerAnimated:YES];
           // [self.navigationController popViewControllerAnimated:YES ];
        }];
        [alertController addAction:action];
        [controller presentViewController:alertController animated:YES completion:nil];
    });
}

- (void)exampleViewController:(UIViewController *)controller didFinishWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(__unused UIAlertAction *action) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            _btnConfirmPayment.enabled=YES;
            _btnConfirmPayment.backgroundColor=[UIColor colorWithRed:123.0/255.0 green:11.0/255.0 blue:12.0/255.0 alpha:1.0];
            [controller dismissViewControllerAnimated:YES completion:nil];
            //[self.navigationController popViewControllerAnimated:YES];
        }];
        [alertController addAction:action];
        [controller presentViewController:alertController animated:YES completion:nil];
    });
}
#pragma mark - Card Validation
- (BOOL)validateCustomerInfo {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    //2. Validate card number, CVC, expMonth, expYear
    [STPCardValidator validationStateForExpirationMonth:monthNo];
    [STPCardValidator validationStateForExpirationYear:year inMonth:monthNo];
    if ([checkCardName isEqualToString:@"VISA"]) {
        [STPCardValidator validationStateForCVC:txtCVV.text cardBrand:STPCardBrandVisa];
        [STPCardValidator validationStateForNumber:txtCardNumber.text validatingCardBrand:STPCardBrandVisa];
    }
    else if ([checkCardName isEqualToString:@"MasterCard"]){
        [STPCardValidator validationStateForCVC:txtCVV.text cardBrand:STPCardBrandMasterCard];
        [STPCardValidator validationStateForNumber:txtCardNumber.text validatingCardBrand:STPCardBrandMasterCard];
    }
    else if ([checkCardName isEqualToString:@"American Express"]){
        
        [STPCardValidator validationStateForCVC:txtCVV.text cardBrand:STPCardBrandAmex];
        [STPCardValidator validationStateForNumber:txtCardNumber.text validatingCardBrand:STPCardBrandAmex];
    }
    else if ([checkCardName isEqualToString:@"Maestro"]){
        [STPCardValidator validationStateForCVC:txtCVV.text cardBrand:STPCardBrandDiscover];
        [STPCardValidator validationStateForNumber:txtCardNumber.text validatingCardBrand:STPCardBrandDiscover];
    }
    else if ([checkCardName isEqualToString:@"Diners Club"]){
        [STPCardValidator validationStateForCVC:txtCVV.text cardBrand:STPCardBrandDinersClub];
        [STPCardValidator validationStateForNumber:txtCardNumber.text validatingCardBrand:STPCardBrandDinersClub];
    }
    else if ([checkCardName isEqualToString:@"JCB"]){
        [STPCardValidator validationStateForCVC:txtCVV.text cardBrand:STPCardBrandJCB];
        [STPCardValidator validationStateForNumber:txtCardNumber.text validatingCardBrand:STPCardBrandJCB];
    }
    else if ([checkCardName isEqualToString:@"Unknown"]){
        [STPCardValidator validationStateForCVC:txtCVV.text cardBrand:STPCardBrandUnknown];
        [STPCardValidator validationStateForNumber:txtCardNumber.text validatingCardBrand:STPCardBrandUnknown];
    }
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    return YES;
}


#pragma mark - TextfildDelegate
- (NSArray *) toCharArray : (NSString *)string
{
    
    NSMutableArray *characters = [[NSMutableArray alloc] initWithCapacity:string.length];
    for (int i=0; i < string.length; i++) {
        NSString *ichar  = [NSString stringWithFormat:@"%C", [string characterAtIndex:i]];
        [characters addObject:ichar];
    }
    
    return characters;
}

- (BOOL) luhnCheck:(NSString *)stringToTest
{
    
    NSArray *stringAsChars = [self toCharArray:stringToTest];
    
    BOOL isOdd = YES;
    int oddSum = 0;
    int evenSum = 0;
    
    //49927398716
    
    for (int i = stringToTest.length - 1; i >= 0; i--) {
        
        int digit = [(NSString *)stringAsChars[i] intValue];
        
        if (isOdd)
        oddSum += digit;
        else
        evenSum += digit/5 + (2*digit) % 10;
        
        isOdd = !isOdd;
    }
    
    return ((oddSum + evenSum) % 10 == 0);
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == txtExipireDate)
    {
        //UIPickerView *yourpicker = [[UIPickerView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 100, 150)];
        UIPickerView *yourpicker = [[UIPickerView alloc]initWithFrame:CGRectMake(txtExipireDate.frame.origin.x - 10, txtExipireDate.frame.size.height + 20, 100, 200)];
        [yourpicker setDataSource: self];
        [yourpicker setDelegate: self];
        yourpicker.showsSelectionIndicator = YES;
        
        txtExipireDate.inputView = yourpicker;
    }
}

-(NSString *)RemoveChar:(NSString *)string
{
    NSMutableCharacterSet *characterSet =
    [NSMutableCharacterSet characterSetWithCharactersInString:@"-"];
    
    // Build array of components using specified characters as separtors
    NSArray *arrayOfComponents = [string componentsSeparatedByCharactersInSet:characterSet];
    
    // Create string from the array components
    NSString *strOutput = [arrayOfComponents componentsJoinedByString:@""];
    
    return strOutput;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL test0;
    NSString *cardString;
    if(textField == txtCardNumber)
    {
        if (range.length == 0 &&
            (range.location == 4 || range.location == 9 || range.location == 14))
        {
            textField.text = [NSString stringWithFormat:@"%@-%@", textField.text, string];
            return NO;
        }
        if (range.length == 1 &&
            (range.location == 5 || range.location == 10 || range.location == 15))
        {
            range.location--;
            textField.text = [textField.text stringByReplacingCharactersInRange:range withString:@""];
        }
        
        //NSLog(@"%@",[NSString stringWithFormat:@"%@%@",textField.text,string]);
        
        if(range.location > 18)
        {
            [txtExipireDate becomeFirstResponder];
            return NO;
        }
        //NSLog(@"%@",[NSString stringWithFormat:@"%@%@",textField.text,string]);
        if(range.location > 12)
        {
            const char * _char = [string cStringUsingEncoding:NSUTF8StringEncoding];
            int isBackSpace = strcmp(_char, "\b");
            
            if (isBackSpace == -8)
            {
                NSLog(@"Backspace was pressed");
                NSString *str = textField.text;
                NSString *truncatedString = [self RemoveChar:[str substringToIndex:[str length]-1]];
                test0 = [self luhnCheck:truncatedString];
            }
            else
            {
                NSString *truncatedString = [self RemoveChar:[NSString stringWithFormat:@"%@%@",textField.text,string]];
                test0 = [self luhnCheck:truncatedString];
            }
            
            
            if(test0)
            {
                txtCardNumber.textColor = [UIColor blackColor];
            }
            else
            {
                txtCardNumber.textColor = [UIColor redColor];
                 //CardImage.image=[UIImage imageNamed:@"ic_card_error.png"];
            }
        }
        else
        {
            txtCardNumber.textColor = [UIColor blackColor];
        }
        
        for(int i = 0; i < CardTypeRegx.count; i++)
        {
            if(range.location < 1)
            {
                checkCardName = @"";
            }
            
            NSPredicate *CardVISA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CardTypeRegx[i]];
            NSString *cardString = [self RemoveChar:[NSString stringWithFormat:@"%@%@",textField.text,string]];
            if ([CardVISA evaluateWithObject:cardString] == YES )
            {
                if(i == 0)
                {
                    checkCardName = @"VISA";
                    CardImage.image=[UIImage imageNamed:@"ic_visa.png"];
                }
                else if (i == 1)
                {
                    checkCardName = @"MasterCard";
                     CardImage.image=[UIImage imageNamed:@"ic_mastercard.png"];
                }
                else if (i == 2)
                {
                    checkCardName = @"American Express";
                     CardImage.image=[UIImage imageNamed:@"ic_amex.png"];
                }
                else if (i == 3)
                {
                    checkCardName = @"Maestro";
                    CardImage.image=[UIImage imageNamed:@"ic_maestra.png"];
                }
                else
                {
                    checkCardName = @"";
                    CardImage.image=[UIImage imageNamed:@"ic_unknown.png"];
                }
            }
        }
    }
    else if(textField == txtCVV)
    {
        if(range.location > 2)
        {
            return NO;
        }
    }
    else if (textField == txtExipireDate)
    {
        return NO;
    }
    return YES;
}

- (NSInteger)numberOfComponentsInPickerView: (UIPickerView*)thePickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)thePickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component == 0)
    {
        return [months count];
    }
    else
    {
        return [years count];
    }
}
- (NSString *)pickerView:(UIPickerView *)thePickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0)
    {
        return [months objectAtIndex:row];
    }
    else
    {
        return [years objectAtIndex:row];
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component == 0)
    {
        monthNo = [months objectAtIndex:row];
    }
    else
    {
        year = [years objectAtIndex:row];
    }
    
    if(year == nil || monthNo == nil)
    {
        txtExipireDate.text = [NSString stringWithFormat:@"12/%@",cyear];
    }
    else
    {
        txtExipireDate.text = [NSString stringWithFormat:@"%@/%@",monthNo,year];
    }
}

-(void)PlaceOrderServiceCall
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     KmyappDelegate.MainCartArr = [AppDelegate GetData:@"CartDIC"];
    NSMutableArray *ProdArr=[[NSMutableArray alloc]init];
    NSLog(@"===%@",KmyappDelegate.MainCartArr);
    
     NSString *CutomerID = [[[[[[Userdata valueForKey:@"RESPONSE"] objectForKey:@"action"] objectForKey:@"authenticate"] objectForKey:@"result"] objectForKey:@"authenticate"]  objectForKey:@"customerid"];
    
    for (int k=0; k<KmyappDelegate.MainCartArr.count; k++)
    {
        NSMutableArray *Array=[[[KmyappDelegate.MainCartArr objectAtIndex:k] valueForKey:@"ingredients"] mutableCopy];
        NSMutableArray *Withindgarr=[[NSMutableArray alloc]init];
        NSMutableArray *Withoutindgarr=[[NSMutableArray alloc]init];
        NSMutableDictionary *inddic=[[NSMutableDictionary alloc]init];
        
        
        // ProdArr=[[NSMutableArray alloc]init];
        NSString *ProdidSr=[[NSString alloc]init];
        if ([Array isKindOfClass:[NSArray class]])
        {
            //NSLog(@"Array===%@",Array);
            for (int i=0; i<Array.count; i++)
            {
                if ([[[Array objectAtIndex:i] valueForKey:@"is_with"] isEqualToString:@"1"])
                {
                    [Withindgarr addObject:[[Array objectAtIndex:i] valueForKey:@"ingredient_id"]];
                }
                else
                {
                    [Withoutindgarr addObject:[[Array objectAtIndex:i] valueForKey:@"ingredient_id"]];
                }
                ProdidSr=[[Array objectAtIndex:i] valueForKey:@"product_id"];
            }
            if (Withindgarr.count>0)
            {
                [inddic setObject:Withindgarr forKey:@"WITHINGREDIENTID"];
            }
            if (Withoutindgarr.count>0)
            {
                [inddic setObject:Withoutindgarr forKey:@"WITHOUTINGREDIENTID"];
            }
        }
        
        [inddic setObject:[[KmyappDelegate.MainCartArr objectAtIndex:k] valueForKey:@"id"] forKey:@"ID"];
        [inddic setObject:[[KmyappDelegate.MainCartArr objectAtIndex:k] valueForKey:@"Quantity"] forKey:@"QUANTITY"];
        [ProdArr addObject:inddic];
    }
    
    
    NSString *OrderAmount = [self.FinalTotal stringByReplacingOccurrencesOfString:@"£"
                                                                       withString:@""];
    NSString *DicountAmount = [self.OrderDiscount stringByReplacingOccurrencesOfString:@"£"
                                                                       withString:@""];
    NSMutableDictionary *dict1 = [[NSMutableDictionary alloc] init];
    
    [dict1 setValue:KAPIKEY forKey:@"APIKEY"];
    
    NSMutableDictionary *dictInner = [[NSMutableDictionary alloc] init];
    [dictInner setObject:CutomerID forKey:@"CUSTOMERID"];
    [dictInner setObject:self.OrderType forKey:@"ORDERTYPE"];
     [dictInner setObject:DicountAmount forKey:@"DISCOUNT"];
    [dictInner setObject:OrderAmount forKey:@"MYPRICE"];
    
    [dictInner setObject:PAYMENTTYPE forKey:@"PAYMENTTYPE"];
    [dictInner setObject:PAIDAMOUNT forKey:@"PAIDAMOUNT"];
    if ([self.OrderType isEqualToString:@"Delivery"]) {
        [dictInner setObject:@"0" forKey:@"DELIVERYCHARGE"];
        [dictInner setObject:@"1" forKey:@"USEALTERNATEADDRESS"];
    }
    else
    {
        [dictInner setObject:@"0" forKey:@"USEALTERNATEADDRESS"];
    }
    
    [dictInner setObject:ProdArr forKey:@"PRODUCTS"];
    
    if (self.CommentTxt.length>0)
    {
        [dictInner setObject:self.CommentTxt forKey:@"COMMENTS"];
    }
    
    
    NSMutableDictionary *dictSub = [[NSMutableDictionary alloc] init];
    
    [dictSub setObject:@"putitem" forKey:@"MODULE"];
    
    [dictSub setObject:@"webOrder" forKey:@"METHOD"];
    
    [dictSub setObject:dictInner forKey:@"PARAMS"];
    
    
    NSMutableArray *arrs = [[NSMutableArray alloc] initWithObjects:dictSub, nil];
    NSMutableDictionary *dictREQUESTPARAM = [[NSMutableDictionary alloc] init];
    
    [dictREQUESTPARAM setObject:arrs forKey:@"REQUESTPARAM"];
    [dictREQUESTPARAM setObject:dict1 forKey:@"RESTAURANT"];
    
    
    NSLog(@"dictREQUESTPARAM===%@",dictREQUESTPARAM);
    
    
    NSError* error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dictREQUESTPARAM options:NSJSONWritingPrettyPrinted error:&error];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers  error:&error];
    
    NSString *makeURL=[NSString stringWithFormat:@"%@%@",kBaseURL,WEBORDER];
    [Utility postRequest:json url:makeURL success:^(id responseObject)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
         NSString *SUCCESS=[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"putitem"] objectForKey:@"webOrder"] objectForKey:@"SUCCESS"];
         if ([SUCCESS boolValue] ==YES)
         {
             NSString *result=[[[[[responseObject objectForKey:@"RESPONSE"] objectForKey:@"putitem"] objectForKey:@"webOrder"] objectForKey:@"result"] objectForKey:@"webOrder"];
             NSLog(@"place order result=%@",result);
             //[AppDelegate showErrorMessageWithTitle:@"" message:result delegate:nil];
             
             [KmyappDelegate.MainCartArr removeAllObjects];
             KmyappDelegate.MainCartArr=[[NSMutableArray alloc]init];
             [AppDelegate WriteData:@"CartDIC" RootObject:KmyappDelegate.MainCartArr];
             
             OrderCompleteVC *vcr = [[UIStoryboard storyboardWithName:[SharedClass sharedSingleton].storyBaordName  bundle:nil] instantiateViewControllerWithIdentifier:@"OrderCompleteVC"];
             [self.navigationController pushViewController:vcr animated:YES];
             //[self.navigationController popToRootViewControllerAnimated:YES];
         }
     }
    failure:^(NSError *error) {
         
         [MBProgressHUD hideHUDForView:self.view animated:YES];
         
         NSLog(@"Fail");
     }];
}

@end
