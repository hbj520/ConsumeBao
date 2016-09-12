//
//  ManageOrderViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/21.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "ManageOrderViewController.h"
#import "ManageOrderTableViewCell.h"
#import "ConsumerModel.h"
#import "OrderDataModel.h"
#import "OrderDetailViewController.h"
#import "PaySuccessViewController.h"
@interface ManageOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
{
//    NSString       *firstQueryTime;
    NSString       *totalCount;
//    int            page;
    int            _choose;
    
    TBActivityView *activityView;
    int            _fresh;//0 上拉；1 下拉
    
}
@property(nonatomic,strong)NSMutableArray * nearDataArr;//附近的数据
@property(nonatomic,strong)NSMutableArray * accomplishArr;//已完成的
@property(nonatomic,strong)NSMutableArray * closeArr;//已关闭的
@end

@implementation ManageOrderViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    _nearDataArr=[NSMutableArray arrayWithCapacity:0];
    _accomplishArr=[NSMutableArray arrayWithCapacity:0];
    _closeArr=[NSMutableArray arrayWithCapacity:0];
//    _choose=0;
//    page=1;
//    firstQueryTime=@"";
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [self.view addSubview:activityView];
    
    [activityView startAnimate];
    DMLog(@"------%d",_choose);
    [self merchantsList:_choose];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self backButton];
   
    self.title=@"订单管理";
    self.view.backgroundColor=BGMAINCOLOR;
    
        
//    [self backButton];
//    [self createNavigationButton];
   
     __block NSMutableArray *newArr=[NSMutableArray arrayWithCapacity:0];
    //上拉
    [_tableView addLegendFooterWithRefreshingBlock:^{
        _fresh=0;
        OrderInfoModel *mianModl=[self backCurrentModel];
        totalCount=mianModl.totalCount;
        if (_choose==0) {
            
            newArr=_nearDataArr;
        }if (_choose==1) {
            newArr=_accomplishArr;
        }if (_choose==2) {
            newArr=_closeArr;
        }
        
        
        if ([totalCount intValue]==0) {
            
            [self.tableView.footer setTitle:@"没有相关数据" forState:MJRefreshFooterStateIdle];
            [self.tableView.footer endRefreshing];
            
            return ;
        }
        if ([totalCount intValue]>0&&[totalCount intValue]<=10) {
            [self.tableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            [self.tableView.footer endRefreshing];
            return ;
        }
        if ([totalCount intValue]==newArr.count&&[totalCount intValue]>10) {
            [self.tableView.footer endRefreshing];
            [self.tableView.footer setTitle:@"没有更多了..." forState:MJRefreshFooterStateIdle];
            return ;
        }
        [self merchantsList:_choose];
    }];
    
    //下拉刷新
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        _fresh=1;
//        page=1;
//        firstQueryTime=@"";
        
        [self merchantsList:_choose];
        
    }];

    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=0;
    // Do any additional setup after loading the view from its nib.
}

-(void)merchantsList:(int)status
{
    NSString *pageStr;
    NSString *firstQueryTime;
    if (_fresh==1) {
        pageStr=@"1";
        firstQueryTime=@"";
    }
    else
    {
        OrderInfoModel *mianModl=[self backCurrentModel];
        pageStr=(mianModl==nil)?[NSString stringWithFormat:@"%d",1]:mianModl.page;
        firstQueryTime=(mianModl==nil)?@"":mianModl.firstQueryTime;
    }
    NSDictionary *param=@{@"status":@"",@"memberId":@"",@"shopId":USERID,@"statusType":[NSString stringWithFormat:@"%d",status]};
    //拿到当前最后一个的model
//    OrderInfoModel *mianModl=[self backCurrentModel];
//    NSString  *pageStr=(mianModl==nil)?[NSString stringWithFormat:@"%d",1]:mianModl.page;
//    firstQueryTime=(mianModl==nil)?@"":mianModl.firstQueryTime;
    NSDictionary *pagination=@{@"page":pageStr,@"rows":@"10",@"firstQueryTime":firstQueryTime};
    
//    NSDictionary *pagination=@{@"page":[NSString stringWithFormat:@"%d",page],@"rows":@"10",@"firstQueryTime":firstQueryTime};
    [RequstEngine pagingRequestHttp:@"1021" paramDic:param pageDic:pagination blockObject:^(NSDictionary *dic) {
        DMLog(@"1021/1040--%@",dic);
        DMLog(@"error---%@",dic[@"errorMsg"]);
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
        [activityView stopAnimate];
        if ([dic[@"errorCode"] intValue]==0) {
            
            if (_fresh==1) {
                if (_choose==0) {
                    [_nearDataArr removeAllObjects];
                }
                if (_choose==1) {
                    [_accomplishArr removeAllObjects];
                }
                if (_choose==2) {
                    [_closeArr removeAllObjects];
                }

            }
            if ([dic[@"totalCount"] intValue]==0) {
                [self.tableView.footer setTitle:@"没有相关数据" forState:MJRefreshFooterStateIdle];
            }
            if ([dic[@"totalCount"] intValue]>0&&[dic[@"totalCount"] intValue]<=10) {
                [self.tableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            }
            
            NSDictionary *newDic=dic[@"orderList"];
            int    newpage=[pageStr intValue];
            if (newDic.count>0) {
                
                newpage++;
            }
            NSString * firstQueryTime=dic[@"firstQueryTime"];
            totalCount=dic[@"totalCount"];
            
            for (NSDictionary *myDic in dic[@"orderList"]) {
                
                OrderInfoModel * model=[[OrderInfoModel alloc]init];
                model.firstQueryTime=firstQueryTime;
                model.page=[NSString stringWithFormat:@"%d",newpage];
                model.totalCount=totalCount;
                [model setValuesForKeysWithDictionary:myDic];
                if (_choose==0) {
                    [_nearDataArr addObject:model];
                }
                if (_choose==1) {
                    [_accomplishArr addObject:model];
                }
                if (_choose==2) {
                    [_closeArr addObject:model];
                }
               
                
            }
            DMLog(@"model---%@",_nearDataArr);
            [_tableView reloadData];
        }
        
        
    }];
    
}

-(OrderInfoModel *)backCurrentModel
{
    OrderInfoModel *modl;
    switch (_choose) {
        case 0:
        {
            modl=[_nearDataArr lastObject];
        }
            break;
        case 1:
        {
            modl=[_accomplishArr lastObject];
        }
            break;
        case 2:
        {
            modl=[_closeArr lastObject];
        }
            break;
            
        default:
            break;
    }
    return  modl;
}


#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_choose==0) {
        return _nearDataArr.count;
    }
    else if (_choose==1)
    {
        return _accomplishArr.count;
    }
    else
    {
        return _closeArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    ManageOrderTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"orderCell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"ManageOrderTableViewCell" owner:nil options:nil]firstObject];
    }
    if (_choose==0) {
        
        OrderInfoModel * model;
        if (_nearDataArr.count>0) {
            model=_nearDataArr[indexPath.row];
        }
        cell.orderCode.text=model.orderId;
        
        if ([model.orderType intValue]==1) {
            
            cell.userName.text=(model.memberName.length==0)?@"":model.memberName;
            cell.phoneLable.text=@"支付方式:";
            cell.userPhone.text=@"线上收款";
            cell.addressLable.text=@"订单金额:";
            cell.userAddress.text=[NSString stringWithFormat:@"实付¥%@+通宝币%@",model.price,model.goldNum];
            cell.arrowImage.hidden=NO;
            
        }else{
            
            cell.addressLable.text=@"地址:";
            cell.phoneLable.text=@"电话:";
            cell.userName.text=[NSString stringWithFormat:@"%@",model.addr[@"name"]];
            cell.userPhone.text=[NSString stringWithFormat:@"%@",model.addr[@"phone"]];
            cell.userAddress.text=[NSString stringWithFormat:@"%@",model.addr[@"addrFull"]];
            cell.arrowImage.hidden=NO;
        }
        [cell.headImageView setImageWithURLString:model.memberImgUrl placeholderImage:DEFAULTIMAGE];
        
        switch ([model.status intValue]) {
            case 0:
                cell.payState.text=@"未付款";
                break;
            case 1:
                cell.payState.text=@"已付款";
                break;
            case 2:
                cell.payState.text=@"已确认 ";
                break;
            case 4:
                cell.payState.text=@"已发货";
                break;
            default:
                break;
        }

    }
    else if(_choose==1)
    {
        OrderInfoModel * model;
        if (_accomplishArr.count>0) {
            model=_accomplishArr[indexPath.row];
        }
        
        if ([model.orderType intValue]==1) {
            
            cell.userName.text=(model.memberName.length==0)?@"":model.memberName;
            cell.phoneLable.text=@"支付方式:";
            cell.userPhone.text=@"线上收款";
            cell.addressLable.text=@"订单金额:";
            cell.userAddress.text=[NSString stringWithFormat:@"实付¥%@+通宝币%@",model.price,model.goldNum];
            cell.arrowImage.hidden=NO;
            
        }else{
            
            cell.addressLable.text=@"地址:";
            cell.phoneLable.text=@"电话:";
            cell.userName.text=[NSString stringWithFormat:@"%@",model.addr[@"name"]];
            cell.userPhone.text=[NSString stringWithFormat:@"%@",model.addr[@"phone"]];
            cell.userAddress.text=[NSString stringWithFormat:@"%@",model.addr[@"addrFull"]];
            cell.arrowImage.hidden=NO;
        }

        cell.orderCode.text=model.orderId;
        [cell.headImageView setImageWithURLString:model.memberImgUrl placeholderImage:DEFAULTIMAGE];
        cell.payState.text=@"已收货";
  

    }else
    {
        OrderInfoModel * model;
        if (_closeArr.count>0) {
            model=_closeArr[indexPath.row];
        }
        
        
        if ([model.orderType intValue]==1) {
            
            cell.userName.text=(model.memberName.length==0)?@"":model.memberName;
            cell.phoneLable.text=@"支付方式:";
            cell.userPhone.text=@"线上收款";
            cell.addressLable.text=@"订单金额:";
            cell.userAddress.text=[NSString stringWithFormat:@"实付¥%@+通宝币%@",model.price,model.goldNum];
            cell.arrowImage.hidden=YES;
            
        }else{
            cell.addressLable.text=@"地址:";
            cell.phoneLable.text=@"电话:";
            cell.userName.text=[NSString stringWithFormat:@"%@",model.addr[@"name"]];
            cell.userPhone.text=[NSString stringWithFormat:@"%@",model.addr[@"phone"]];
            cell.userAddress.text=[NSString stringWithFormat:@"%@",model.addr[@"addrFull"]];
            cell.arrowImage.hidden=NO;
            
        }

        cell.orderCode.text=model.orderId;
        
        [cell.headImageView setImageWithURLString:model.memberImgUrl placeholderImage:DEFAULTIMAGE];
        switch ([model.status intValue]) {
            case 3:
                cell.payState.text=@"已拒接";
                break;
            case 6:
                cell.payState.text=@"已取消";
                break;
            default:
                break;
        }

    }
   

    cell.selectionStyle=0;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
- (IBAction)changeState:(id)sender {
    UIButton * button =(UIButton * )sender;
    switch (button.tag) {
        case 1:
            DMLog(@"进行中");
            _choose=0;
            [_proceedBtn setTitleColor:RGBACOLOR(247, 137, 0, 1) forState:0];
            [_accomplishBtn setTitleColor:RGBACOLOR(80, 80, 80, 1) forState:0];
            [_closeBtn setTitleColor:RGBACOLOR(80, 80, 80, 1) forState:0];
            break;
        case 2:
            DMLog(@"已完成");
            _choose=1;
            [_accomplishBtn setTitleColor:RGBACOLOR(247, 137, 0, 1) forState:0];
            [_proceedBtn setTitleColor:RGBACOLOR(80, 80, 80, 1) forState:0];
            [_closeBtn setTitleColor:RGBACOLOR(80, 80, 80, 1) forState:0];
            break;
        case 3:
            DMLog(@"已关闭");
            _choose=2;
            [_closeBtn setTitleColor:RGBACOLOR(247, 137, 0, 1) forState:0];
            [_accomplishBtn setTitleColor:RGBACOLOR(80, 80, 80, 1) forState:0];
            [_proceedBtn setTitleColor:RGBACOLOR(80, 80, 80, 1) forState:0];
            break;
        default:
            break;
    }
    [self merchantsList:_choose];
    [UIView animateWithDuration:0.3 animations:^{
        _scrollLabel.center=CGPointMake(button.center.x, _scrollLabel.center.y);
    }];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    OrderInfoModel * model;
    if (_choose==0) {
        model=_nearDataArr[indexPath.row];
        if ([model.orderType intValue]==0) {
            OrderDetailViewController * orderVC=[[OrderDetailViewController alloc]init];
            orderVC.orderID=model.orderId;
            orderVC.type=1;
            orderVC.orderType=model.orderType;
            orderVC.status=model.status;
            orderVC.whichType=1;
            [self.navigationController pushViewController:orderVC animated:YES];
        }
        else if([model.orderType intValue]==1)
        {
            PaySuccessViewController * payVC=[[PaySuccessViewController alloc]init];
            payVC.orderId=model.orderId;
            payVC.hidesBottomBarWhenPushed=YES;
            payVC.whichPage=@"0";
            payVC.buyOrSeller=@"10";
            payVC.upOrDown=@"21";//线上or线下
            payVC.status=model.status;
            [self.navigationController pushViewController:payVC animated:YES];
        }

        
    }
    if (_choose==1) {
        model=_accomplishArr[indexPath.row];
        if ([model.orderType intValue]==0) {
            OrderDetailViewController * orderVC=[[OrderDetailViewController alloc]init];
            orderVC.orderID=model.orderId;
            orderVC.type=1;
            orderVC.orderType=model.orderType;
            orderVC.status=model.status;
            orderVC.whichType=1;
            [self.navigationController pushViewController:orderVC animated:YES];
        }
        else if([model.orderType intValue]==1)
        {
            PaySuccessViewController * payVC=[[PaySuccessViewController alloc]init];
            payVC.orderId=model.orderId;
            payVC.hidesBottomBarWhenPushed=YES;
            payVC.whichPage=@"0";
            payVC.buyOrSeller=@"10";
            payVC.upOrDown=@"21";//线上or线下
            payVC.status=model.status;
            [self.navigationController pushViewController:payVC animated:YES];
        }

        
    }
    if (_choose==2) {
         model=_closeArr[indexPath.row];
        if ([model.orderType intValue]==1) {
            return;
        }
        OrderDetailViewController * orderVC=[[OrderDetailViewController alloc]init];
        orderVC.orderID=model.orderId;
        orderVC.type=1;
        orderVC.orderType=model.orderType;
        orderVC.status=model.status;
        orderVC.whichType=1;
        [self.navigationController pushViewController:orderVC animated:YES];
        
    }
    
//    if ([model.orderType intValue]==0) {

//        [self.navigationController pushViewController:orderVC animated:YES];
//    }
//    else if([model.orderType intValue]==1)
//    {
//        PaySuccessViewController * payVC=[[PaySuccessViewController alloc]init];
//        payVC.orderId=model.orderId;
//        payVC.hidesBottomBarWhenPushed=YES;
//        payVC.whichPage=@"0";
//        [self.navigationController pushViewController:payVC animated:YES];
//    }
    
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
