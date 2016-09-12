//
//  OrderViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/13.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "OrderViewController.h"
#import "OrderTableViewCell.h"
#import "OrderDetailViewController.h"
#import "StoreInfoViewController.h"
#import "CommentViewController.h"
#import "OrderDataModel.h"
#import "PayOrderViewController.h"
#import "LoginViewController.h"
#import "CategoryViewController.h"
#import "PaymentOrderViewController.h"
#import "LMSJJudgeViewController.h"
#import "SJXQViewController.h"
#import "PaySuccessViewController.h"
@interface OrderViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    
    NSString       *firstQueryTime;
    NSString       *totalCount;
    int            page;
    TBActivityView *activityView;
    
    UIView         *noOrderView;
    UIView         *noLoginView;
    NSString       *_orderId;
    int            _fresh;//0 上拉；1 下拉
}

@property(nonatomic,strong)NSMutableArray     *orderListArr;

@end



@implementation OrderViewController
//-(void)viewWillAppear:(BOOL)animated
//{
//    self.navigationController.navigationBarHidden=NO;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"订单";
    
    
    self.view.backgroundColor=BGMAINCOLOR;
    
    //self.fd_prefersNavigationBarHidden=NO;
    _orderListArr=[NSMutableArray arrayWithCapacity:0];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:0];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=0;
    [self.view addSubview:_tableView];
    
    _dataArr=[NSMutableArray arrayWithCapacity:0];
    page=1;
    [self addLegendHeader];
    firstQueryTime=@"";
    if (![NSString isLogin]) {
        
        [self loginUser];
        _tableView.hidden=YES;
        
    }else{
        
        [activityView startAnimate];
    }
    
    
    [self createAlartView];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    //self.navigationController.navigationBarHidden=NO;
    if (![NSString isLogin]) {
        
        noLoginView.hidden=NO;
        noOrderView.hidden=YES;
        _tableView.hidden=YES;
    }else{
        [self.orderListArr removeAllObjects];
        noLoginView.hidden=YES;
        noOrderView.hidden=YES;
        _tableView.hidden =NO;
        [activityView startAnimate];
        page=1;
        firstQueryTime=@"";
      
        [self merchantsList];
        
    }

}

-(void)createAlartView
{
    if (!noOrderView) {
        
        noOrderView=[[UIView alloc]initWithFrame:CGRectMake(KScreenWidth/2.-87, KScreenHeight/2.-55, 174, 110)];
        [self.view addSubview:noOrderView];
        
        UIImageView *myImageView=[[UIImageView alloc]initWithFrame:CGRectMake(87, 0, 72, 72)];
        myImageView.center=CGPointMake(174/2., 0);
        myImageView.image=[UIImage imageNamed:@"无订单"];
        [noOrderView addSubview:myImageView];
        
        UILabel *noOrderlable=[[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(myImageView.frame)+10,174 , 21)];
        noOrderlable.text=@"亲，您暂时没有订单哦～";
        noOrderlable.textColor=[UIColor grayColor];
        noOrderlable.font=[UIFont systemFontOfSize:14];
        noOrderlable.textAlignment=1;
        [noOrderView addSubview:noOrderlable];
    }
    if (!noLoginView) {
        noLoginView=[[UIView alloc]initWithFrame:CGRectMake(KScreenWidth/2.-105, KScreenHeight/2.-90, 210, 182)];
        [self.view addSubview:noLoginView];
        
        UIImageView *myImageView=[[UIImageView alloc]initWithFrame:CGRectMake(105, 0, 100, 100)];
        myImageView.center=CGPointMake(210/2., 0);
        myImageView.image=[UIImage imageNamed:@"未登录头像"];
        [noLoginView addSubview:myImageView];
        
        UILabel *noOrderlable=[[UILabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(myImageView.frame)+10,210 , 21)];
        noOrderlable.text=@"您当前没有登录，无法查看订单";
        noOrderlable.textColor=[UIColor grayColor];
        noOrderlable.font=[UIFont systemFontOfSize:14];
        noOrderlable.textAlignment=1;
        [noLoginView addSubview:noOrderlable];
        
        UIButton *loginBtn=[UIButton buttonWithType:0];
        loginBtn.backgroundColor=MAINCOLOR;
        loginBtn.frame=CGRectMake(210/2.-50, CGRectGetMaxY(noOrderlable.frame)+10, 100, 35) ;
        [loginBtn setTitle:@"登录" forState:0];
        [loginBtn setTitleColor:[UIColor whiteColor] forState:0];
        [loginBtn addTarget:self action:@selector(loginUser) forControlEvents:1<<6];
        [noLoginView addSubview:loginBtn];
        
        loginBtn.layer.cornerRadius=5;
        loginBtn.layer.masksToBounds=YES;
    }
}


-(void)addLegendHeader
{
    //上拉
    __block OrderViewController * weakSelf=self;
    [_tableView addLegendFooterWithRefreshingBlock:^{
        
        _fresh=0;
        if ([totalCount intValue]==0) {
            
            [weakSelf.tableView.footer setTitle:@"没有相关数据" forState:MJRefreshFooterStateIdle];
            [weakSelf.tableView.footer endRefreshing];
            
            return ;
        }
        if ([totalCount intValue]>0&&[totalCount intValue]<=10) {
            [weakSelf.tableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            [weakSelf.tableView.footer endRefreshing];
            return ;
        }
        if ([totalCount intValue]==_orderListArr.count&&[totalCount intValue]>10) {
            [weakSelf.tableView.footer endRefreshing];
            [weakSelf.tableView.footer setTitle:@"没有更多了..." forState:MJRefreshFooterStateIdle];
            return ;
        }
        [weakSelf merchantsList];
    }];
    
    //下拉刷新
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        _fresh=1;
        [activityView startAnimate];
        page=1;
        firstQueryTime=@"";
//        [weakSelf.orderListArr removeAllObjects];
        [weakSelf merchantsList];
    }];
    [_tableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    
    activityView.showVC=self;
    [self.view addSubview:activityView];
}

-(void)merchantsList
{
    //重要请求 就消失
    noOrderView.hidden=YES;
    
    NSDictionary *param=@{@"status":@"",@"memberId":USERID,@"shopId":@""};
    NSDictionary *pagination=@{@"page":[NSString stringWithFormat:@"%d",page],@"rows":@"10",@"firstQueryTime":firstQueryTime};
    
    [RequstEngine pagingRequestHttp:@"1021" paramDic:param pageDic:pagination blockObject:^(NSDictionary *dic) {
        DMLog(@"1021--%@",dic);
        DMLog(@"error---%@",dic[@"errorMsg"]);
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
        [activityView stopAnimate];
        if ([dic[@"errorCode"] intValue]==0) {
            
            if (_fresh==1) {
                [_orderListArr removeAllObjects];
            }
            if ([dic[@"totalCount"] intValue]==0) {
                
                _tableView.hidden=YES;
                noOrderView.hidden=NO;
                [self.tableView.footer setTitle:@"没有相关数据" forState:MJRefreshFooterStateIdle];
            }
            if ([dic[@"totalCount"] intValue]>0&&[dic[@"totalCount"] intValue]<=10) {
                [self.tableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            }
            
            NSDictionary *newDic=dic[@"orderList"];
            if (newDic.count>0) {
                page++;
            }
            firstQueryTime=dic[@"firstQueryTime"];
            totalCount=dic[@"totalCount"];
            for (NSDictionary *dataDic in dic[@"orderList"]) {
                OrderInfoModel  *model=[[OrderInfoModel alloc]init];
                [model setValuesForKeysWithDictionary:dataDic];
                [_orderListArr addObject:model];
                
            }
            [_tableView reloadData];
        }
        
        
    }];
    
}


#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _orderListArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[OrderTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
    }
    
    OrderInfoModel *model;
    if (_orderListArr.count>0)
    {
        model=_orderListArr[indexPath.row];
    }
    cell.gotoBtn.tag=indexPath.row;
    [cell.gotoBtn addTarget:self action:@selector(gotoBusiness:) forControlEvents:1<<6];
    cell.commentBtn.tag=indexPath.row;
    [cell.commentBtn addTarget:self action:@selector(gotoComment:) forControlEvents:1<<6];
    cell.payOrderBtn.tag=indexPath.row;
    [cell.payOrderBtn addTarget:self action:@selector(againPayOrder:) forControlEvents:1<<6];
    [cell.cancelBtn addTarget:self action:@selector(cancelOrder:) forControlEvents:1<<6];
    cell.cancelBtn.tag=indexPath.row;
    cell.orderInfo=model;
    cell.selectionStyle=0;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return H(140);
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    OrderInfoModel *model;
    if (_orderListArr.count>0) {
        model=_orderListArr[indexPath.row];
    }
//    if ([model.orderType intValue]==0) {
//        OrderDetailViewController * orderDetailVC=[[OrderDetailViewController alloc]init];
//        orderDetailVC.orderID=model.orderId;
//        orderDetailVC.orderType=model.orderType;
//        orderDetailVC.whichType=0;
//        orderDetailVC.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:orderDetailVC animated:YES];
//
//    }
    if([model.orderType intValue]==1)
    {
        PaySuccessViewController * payVC=[[PaySuccessViewController alloc]init];
        payVC.orderId=model.orderId;
        payVC.hidesBottomBarWhenPushed=YES;
        payVC.whichPage=@"0";
        payVC.buyOrSeller=@"12";
        payVC.model=model;
        payVC.upOrDown=@"21";
        payVC.status=model.status;
        [self.navigationController pushViewController:payVC animated:YES];

    }
    else if([model.orderType intValue]==2)
    {
        OrderDetailViewController * orderDetailVC=[[OrderDetailViewController alloc]init];
        orderDetailVC.orderID=model.orderId;
        orderDetailVC.orderType=model.orderType;
        orderDetailVC.whichType=0;
        orderDetailVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    }
    
    
    

    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            break;
        case 1:
        {
            if (alertView.tag==1) {
                DMLog(@"买家确认收货----%@",_orderId);
                NSDictionary * param=@{@"orderId":_orderId,@"status":@"5"};
                [RequstEngine requestHttp:@"1019" paramDic:param blockObject:^(NSDictionary *dic) {
                    DMLog(@"1019---%@",dic);
                    DMLog(@"error---%@",dic[@"errorMsg"]);
                    if ([dic[@"errorCode"]intValue]==00000) {
                        [UIAlertView alertWithTitle:@"温馨提示" message:@"确认收货成功" buttonTitle:nil];
                        [_orderListArr removeAllObjects];
                        page=1;
                        firstQueryTime=@"";
                        [self merchantsList];
                    }
                }];

            }
            else
            {
                DMLog(@"买家取消---%@",_orderId);
                NSDictionary * param=@{@"orderId":_orderId,@"status":@"6"};
                [RequstEngine requestHttp:@"1019" paramDic:param blockObject:^(NSDictionary *dic) {
                    DMLog(@"1019----%@",dic);
                    DMLog(@"error-----%@",dic[@"errorMsg"]);
                    if ([dic[@"errorCode"]intValue]==00000) {
                        [UIAlertView alertWithTitle:@"温馨提示" message:@"取消订单成功" buttonTitle:nil];
                        [_orderListArr removeAllObjects];
                        page=1;
                        firstQueryTime=@"";
                        [self merchantsList];
                    }
                }];

            }
           
        }
            break;
        default:
            break;
    }
}
#pragma mark - 按钮绑定的方法
//
-(void)gotoBusiness:(UIButton *)btn
{
    OrderInfoModel *model=_orderListArr[btn.tag];
    if ([model.orderType intValue]==1) {
        SJXQViewController * sjxqVC=[[SJXQViewController alloc]init];
        sjxqVC.hidesBottomBarWhenPushed=YES;
        sjxqVC.shopID=model.shopId;
        [self.navigationController pushViewController:sjxqVC animated:YES];
    }
    else if(model.orderType.length==0)
    {
        DMLog(@"----");
        if (model.shopId.length==0) {
            DMLog(@"----+++++++++++");
        }
        else
        {
            StoreInfoViewController * storeVC=[[StoreInfoViewController alloc]init];
            storeVC.hidesBottomBarWhenPushed=YES;
            storeVC.shopID=model.shopId;
            [self.navigationController pushViewController:storeVC animated:YES];

        }
        //        if (model.shopId.length==0) {
        //            [UIAlertView alertWithTitle:@"温馨提示" message:@"直营超市功能暂时关闭" buttonTitle:nil];
        //        }
    }
//    else if ([model.orderType intValue]==0)
//    {
//        StoreInfoViewController * storeVC=[[StoreInfoViewController alloc]init];
//        storeVC.hidesBottomBarWhenPushed=YES;
//        storeVC.shopID=model.shopId;
//        [self.navigationController pushViewController:storeVC animated:YES];
//    }
    
    
//    if (model.shopId.length!=0) {
//        StoreInfoViewController * storeVC=[[StoreInfoViewController alloc]init];
//        storeVC.hidesBottomBarWhenPushed=YES;
//        storeVC.shopID=model.shopId;
//        [self.navigationController pushViewController:storeVC animated:YES];
//    }
//    else
//    {
////        CategoryViewController * storeVC=[[CategoryViewController alloc]init];
////        storeVC.hidesBottomBarWhenPushed=YES;
////        [self.navigationController pushViewController:storeVC animated:YES];
//        [UIAlertView alertWithTitle:@"温馨提示" message:@"直营超市功能暂时关闭" buttonTitle:nil];
//    }
   

    
}

#pragma mark - 评价
-(void)gotoComment:(UIButton *)btn
{
    OrderInfoModel *model=_orderListArr[btn.tag];
    _orderId=model.orderId;
    if ([model.status intValue]==4) {
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否确认收货" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        alert.tag=1;
        [alert show];
    }
    else
    {
        if ([model.orderType intValue]==1) {
            
            
            LMSJJudgeViewController * lmsjVC=[[LMSJJudgeViewController alloc]init];
            lmsjVC.infoModel=model;
            lmsjVC.shopId=model.shopId;
            lmsjVC.price=[NSString stringWithFormat:@"%.2f",[model.price floatValue]+[model.goldNum floatValue]];
            lmsjVC.shopName=model.shopName;
            lmsjVC.headImgUrl=model.doorImg;
            lmsjVC.orderId=model.orderId;
            lmsjVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:lmsjVC animated:YES];
            return;
        }
        
        
        CommentViewController * commentVC=[[CommentViewController alloc]init];
        commentVC.hidesBottomBarWhenPushed=YES;
        commentVC.orderId=model.orderId;
        [self.navigationController pushViewController:commentVC animated:YES];
    }
   
}

#pragma mark - 支付
-(void)againPayOrder:(UIButton *)btn
{
    
    
    
    DMLog(@"重新支付");
    OrderInfoModel *model=_orderListArr[btn.tag];
    
//    if (model.shopId.length==0) {
//        
//        PaymentOrderViewController *payVC=[[PaymentOrderViewController alloc]init];
//        payVC.hidesBottomBarWhenPushed=YES;
//        [self.navigationController pushViewController:payVC animated:YES];
//        return;
//        
//    }
    
    PayOrderViewController *payVC=[[PayOrderViewController alloc]init];
    payVC.hidesBottomBarWhenPushed=YES;
    payVC.orderID=model.orderId;
    payVC.shopName=model.shopName;
    payVC.jumpWhichPage=1;
    payVC.paramStr=model.paramStr;
    payVC.totalPrice=[NSString stringWithFormat:@"%@",model.price];
    [self.navigationController pushViewController:payVC animated:YES];
}

#pragma mark - 取消订单

-(void)cancelOrder:(UIButton*)button
{
    OrderInfoModel * model=_orderListArr[button.tag];
    _orderId=model.orderId;
    UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否取消订单" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    alert.tag=2;
    [alert show];
    
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
