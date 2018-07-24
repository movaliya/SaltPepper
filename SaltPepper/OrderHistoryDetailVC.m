//
//  OrderHistoryDetailVC.m
//  SaltPepper
//
//  Created by Dharmraj Vora on 04/06/18.
//  Copyright © 2018 kaushik. All rights reserved.
//

#import "OrderHistoryDetailVC.h"
#import "OrderHistoryDetailCell.h"

@interface OrderHistoryDetailVC ()

@end

@implementation OrderHistoryDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if(IS_IPHONE_X)
    {
        _headerHeight.constant = 90;
    }
    else
    {
        _headerHeight.constant = 70;
    }
    
    [_viewOrderDetail.layer setShadowColor:[UIColor grayColor].CGColor];
    [_viewOrderDetail.layer setShadowOpacity:0.8];
    [_viewOrderDetail.layer setShadowRadius:3.0];
    [_viewOrderDetail.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    arrOrderHistoryProduct = [[NSMutableArray alloc]init];
    
    _lblOrderNo.text = [_orderDetail valueForKey:@"order_id"];
    _lblStatus.text = [_orderDetail valueForKey:@"status"];
    _lblDiscount.text = [NSString stringWithFormat:@"£%@",[_orderDetail valueForKey:@"discount"]];
    _lblOrderAmount.text = [NSString stringWithFormat:@"£%@",[_orderDetail valueForKey:@"total"]];
    _lblOrderDate.text = [_orderDetail valueForKey:@"order_date"];
    _lblOrderComments.text = [_orderDetail valueForKey:@"comments"];
    
    arrOrderHistoryProduct = [[_orderDetail valueForKey:@"children"]valueForKey:@"product"];
    [_tblOrderDetail reloadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Tableview Delegate Method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return arrOrderHistoryProduct.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([[arrOrderHistoryProduct valueForKey:@"ingredient"]objectAtIndex:indexPath.row] == [NSNull null])
    {
        return 90;
    }
    else
    {
        return 140;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OrderHistoryDetailCell *cell = (OrderHistoryDetailCell*)[tableView dequeueReusableCellWithIdentifier:@"OrderHistoryDetailCell"];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.viewBack.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    cell.viewBack.layer.borderWidth = 0.5;
    [cell.viewBack.layer setShadowColor:[UIColor grayColor].CGColor];
    [cell.viewBack.layer setShadowOpacity:0.8];
    [cell.viewBack.layer setShadowRadius:3.0];
    [cell.viewBack.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    cell.lblProductName.text = [[arrOrderHistoryProduct valueForKey:@"product_name"]objectAtIndex:indexPath.row];
    cell.lblQty.text = [[arrOrderHistoryProduct valueForKey:@"product_qty"]objectAtIndex:indexPath.row];
    cell.lblPrice.text = [NSString stringWithFormat:@"Price £%@",[[arrOrderHistoryProduct valueForKey:@"web_order_price"] objectAtIndex:indexPath.row]];
    if([[arrOrderHistoryProduct valueForKey:@"ingredient"]objectAtIndex:indexPath.row] == [NSNull null])
    {
        cell.lblQtyTopSpace.constant = 12;
        cell.lblWith.hidden = YES;
        cell.lblWithout.hidden = YES;
    }
    else
    {
        cell.lblQtyTopSpace.constant = 60;
        cell.lblWith.hidden = NO;
        cell.lblWithout.hidden = NO;
        NSMutableArray *arringrd = [[NSMutableArray alloc]init];
        arringrd = [[arrOrderHistoryProduct valueForKey:@"ingredient"]objectAtIndex:indexPath.row];
        NSString *strWith = @"with : ";
        NSString *strWithout = @"without : ";
        BOOL isFirstWith = YES;
        BOOL isFirstWithout = YES;
        for (int i = 0; i < arringrd.count; i++)
        {
            if([[[arringrd valueForKey:@"is_with"]objectAtIndex:i] isEqualToString:@"1"])
            {
                if(isFirstWith)
                {
                    strWith = [strWith stringByAppendingString:[NSString stringWithFormat:@"%@",[[arringrd valueForKey:@"ingredient_name"]objectAtIndex:i]]];
                }
                else
                {
                    strWith = [strWith stringByAppendingString:[NSString stringWithFormat:@",%@",[[arringrd valueForKey:@"ingredient_name"]objectAtIndex:i]]];
                }
                isFirstWith = NO;
            }
            else
            {
                if(isFirstWithout)
                {
                    strWithout = [strWithout stringByAppendingString:[NSString stringWithFormat:@"%@",[[arringrd valueForKey:@"ingredient_name"]objectAtIndex:i]]];
                }
                else
                {
                    strWithout = [strWithout stringByAppendingString:[NSString stringWithFormat:@",%@",[[arringrd valueForKey:@"ingredient_name"]objectAtIndex:i]]];
                }
                isFirstWithout = NO;
               
            }
        }
        cell.lblWith.text = strWith;
        cell.lblWithout.text = strWithout;
    }
    return cell;
    
}

#pragma mark - Button Click Action

- (IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
