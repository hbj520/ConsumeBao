//
//  DeliveryAddressViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/28.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "DeliveryAddressViewController.h"
#import "DeliveryAddressTableViewCell.h"
#import "AddressViewController.h"
#import "EditAdressViewController.h"
#import "SubmitViewController.h"
#import "ConsumerModel.h"
#import "LoginViewController.h"
#import "PaymentOrderViewController.h"
@interface DeliveryAddressViewController ()<UITableViewDataSource,UITableViewDelegate>
{
//    UITableView * _tableView;
    NSString * oneFirstQueryTime;
    int onePage;
    
    NSString       *firstQueryTime;
    NSString       *totalCount;
    int            page;
    UIButton       *managmentBtn;//编辑按钮
    UIButton       *addNewBtn;//添加新地址
    
    TBActivityView *activityView;
    int            _fresh;//0 上拉；1 下拉
    UIView        * _bottomView;
}

@end

@implementation DeliveryAddressViewController

-(void)viewWillAppear:(BOOL)animated
{
    
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [self.view addSubview:activityView];
    
    [activityView startAnimate];
    
     _nearDataArr=[NSMutableArray arrayWithCapacity:0];
    page=1;
    firstQueryTime=@"";
    
    if (![NSString isLogin]) {
        [self loginUser];
    }
    else
    {
        
        [self merchantsList];
    }
    
    
//    self.tableView.isEditing;
    
}

-(void)loginUser
{
    LoginViewController * loginVC=[[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
}
-(void)createManagmentBtn
{
    
    managmentBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 44.0f, 44.0f)];
    [managmentBtn setTitle:@"管理" forState:UIControlStateNormal];
    managmentBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [managmentBtn addTarget:self action:@selector(managmentBunClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *managmentBun=[[UIBarButtonItem alloc]initWithCustomView:managmentBtn];
    self.navigationItem.rightBarButtonItem=managmentBun;
}

-(void)managmentBunClick
{
    DMLog(@"管理");
    addNewBtn.hidden=!addNewBtn.hidden;
    [self deleteData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"managementBtn" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    if (_addressType==1) {
        
        self.title=@"收货地址";
    }else{
        self.title=@"收货地址管理";
    }
    
    [self createBottomView];
    
    self.view.backgroundColor=BGMAINCOLOR;
   
    // 加载UI
    [self loadUI];
    [self backOtherButton];
    
    //上拉
    __block DeliveryAddressViewController * weakSelf=self;
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
        if ([totalCount intValue]==_nearDataArr.count&&[totalCount intValue]>10) {
            [weakSelf.tableView.footer endRefreshing];
            [weakSelf.tableView.footer setTitle:@"没有更多了..." forState:MJRefreshFooterStateIdle];
            return ;
        }
        [weakSelf merchantsList];
    }];
    
    //下拉刷新
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        _fresh=1;
        page=1;
        firstQueryTime=@"";
        
        [weakSelf merchantsList];
        
    }];

    //[self managmentBunClick];
    [self createManagmentBtn];
   
    // Do any additional setup after loading the view.
}

-(void)createBottomView
{
    
    _bottomView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, H(50))];
    addNewBtn=[UIButton buttonWithType:0];
    //_bottomView.backgroundColor=MAINCOLOR;
    addNewBtn.frame=CGRectMake(W(20), H(10), WIDTH-W(20)*2, 40);
    addNewBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
    [addNewBtn addTarget:self action:@selector(jump) forControlEvents:1<<6];
    [addNewBtn setTitle:@"新增" forState:0];
    addNewBtn.layer.cornerRadius=3;
    addNewBtn.layer.masksToBounds=YES;
    [addNewBtn setTitleColor:[UIColor whiteColor] forState:0];
    [_bottomView addSubview:addNewBtn];
    //addNewBtn.hidden=NO;
}

-(void)merchantsList
{
    
//    NSDictionary *param=@{@"isRecommend":@"",@"type":@"",@"shopName":@"",@"categoryId":@"0",@"isSupportGold":@"",@"latitude":@"0",@"longitude":@"0"};
    NSDictionary *pagination=@{@"page":[NSString stringWithFormat:@"%d",page],@"rows":@"10",@"firstQueryTime":firstQueryTime};
    [RequstEngine pagingRequestHttp:@"1017" paramDic:nil pageDic:pagination blockObject:^(NSDictionary *dic) {
        DMLog(@"1017--%@",dic);
        
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
        [activityView stopAnimate];
        if ([dic[@"errorCode"] intValue]==0) {
            if (_fresh==1) {
                [_nearDataArr removeAllObjects];
            }
            
            if ([dic[@"totalCount"] intValue]==0) {
                [self.tableView.footer setTitle:@"没有相关数据" forState:MJRefreshFooterStateIdle];
            }
            if ([dic[@"totalCount"] intValue]>0&&[dic[@"totalCount"] intValue]<=10) {
                [self.tableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            }
            
            NSDictionary *newDic=dic[@"recordList"];
            if (newDic.count>0) {
                page++;
            }
            firstQueryTime=dic[@"firstQueryTime"];
            totalCount=dic[@"totalCount"];
//            
            for (NSDictionary *myDic in dic[@"recordList"]) {

                AddressModel * model=[[AddressModel alloc]init];
                [model setValuesForKeysWithDictionary:myDic];
                [_nearDataArr addObject:model];
                
            }
            
            [_tableView reloadData];
        }
        
        
    }];
    
}

-(void)loadUI
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 44, WIDTH, HEIGHT) style:1];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=0;
    _tableView.rowHeight=H(80);
    //_tableView.editing=YES;
    _tableView.sectionFooterHeight=H(60);
    _tableView.sectionHeaderHeight=0;
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.view addSubview:_tableView];
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _nearDataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressModel * model;
    if (_nearDataArr.count>0) {
        
        model=_nearDataArr[indexPath.row];
    }

    DeliveryAddressTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[DeliveryAddressTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle=0;
    //cell.accessoryType=1;
    cell.nameLabel.text=model.name;
    cell.phoneLabel.text=model.phone;
    cell.addressLabel.text=[NSString stringWithFormat:@"%@%@",model.positon,model.details];
    cell.longitudeLabel.text=[NSString stringWithFormat:@"%@",model.longitude];
    cell.latitudeLabel.text=[NSString stringWithFormat:@"%@",model.latitude];
    cell.addIDLabel.text=model.addrId;
    cell.managmentBtn.tag=indexPath.row;
    [cell.managmentBtn addTarget:self action:@selector(managmentBtnClick:) forControlEvents:1<<6];
//    cell.addIDLabel.text=model.
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_addressType==1) {
        AddressModel * model=_nearDataArr[indexPath.row];
        NSArray *viewArr=[self.navigationController viewControllers];
        SubmitViewController *submitVC=[viewArr objectAtIndex:viewArr.count-2];
        submitVC.chooseAddr=model;
        [self.navigationController popToViewController:submitVC animated:YES];
        DMLog(@"%@",viewArr);
    }
    if (_addressType==2) {
        
        AddressModel * model=_nearDataArr[indexPath.row];
        NSArray *viewArr=[self.navigationController viewControllers];
        PaymentOrderViewController *submitVC=[viewArr objectAtIndex:viewArr.count-2];
        submitVC.chooseAddr=model;
        [self.navigationController popToViewController:submitVC animated:YES];
        
    }
}
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        AddressModel * model=_nearDataArr[indexPath.row];
        NSDictionary * param=@{@"addrId":model.addrId};
        [RequstEngine requestHttp:@"1016" paramDic:param blockObject:^(NSDictionary *dic) {
            DMLog(@"1016--**%@",dic);
            DMLog(@"error---%@",dic[@"errorMsg"]);
            if ([dic[@"errorCode"] intValue]==00000) {
                
                [_nearDataArr removeObjectAtIndex:indexPath.row];
                [UIAlertView alertWithTitle:@"温馨提示" message:@"删除成功" buttonTitle:nil];
                NSArray *indexPaths = @[indexPath];
                [_tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:(UITableViewRowAnimationLeft)];
 
            }
        }];
        
        DMLog(@"删除操作");
        
    }
}

-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    return _bottomView;
}
-(void)deleteData
{
    BOOL isEditing= self.tableView.isEditing;
    if (!isEditing) {
        
        [managmentBtn setTitle:@"完成" forState:0];
    }
    else{
        [managmentBtn setTitle:@"管理" forState:0];
    }
    [self.tableView setEditing:!isEditing animated:YES];
    //[self.tableView reloadData];
}
#pragma mark - 按钮绑定的方法 新增收货地址


-(void)managmentBtnClick:(UIButton *)button
{
//    DMLog(@"%ld",button.tag);
    AddressModel * model=_nearDataArr[button.tag];
    AddressViewController * addressVC=[[AddressViewController alloc]init];
    addressVC.addrModel=model;
    [self.navigationController pushViewController:addressVC animated:YES];

}

-(void)jump
{
//    self.tableView.isEditing=YES;
//    addNewBtn.hidden=!addNewBtn.hidden;
//    [self deleteData];
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"managementBtn" object:nil];
    AddressViewController * addressVC=[[AddressViewController alloc]init];
    [self.navigationController pushViewController:addressVC animated:YES];
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
