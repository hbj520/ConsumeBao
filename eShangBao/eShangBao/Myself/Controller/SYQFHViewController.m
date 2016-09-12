//
//  SYQFHViewController.m
//  eShangBao
//
//  Created by Dev on 16/7/6.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "SYQFHViewController.h"
#import "SYQJLTableViewCell.h"
#import "ConsumerModel.h"
#import "SYQViewController.h"
@interface SYQFHViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    UILabel        *syqfeLable;
    UILabel        *bottom;
    NSString       *firstQueryTime;
    NSString       *totalCount;
    int            page;
    NSMutableArray * _nearArr;
    TBActivityView *activityView;
    int            _fresh;//0 上拉；1 下拉
    NSString       * _totalNum;//收益权份额
    NSString       * _todayNum;//今日分红
}
@end

@implementation SYQFHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _nearArr=[NSMutableArray arrayWithCapacity:0];
    self.title=@"收益权分红";
    [self backButton];
    _fresh=1;
    page=1;
    firstQueryTime=@"";
    [self createTableView];
    [self createListRequset];
    
    // Do any additional setup after loading the view.
}

-(void)createTableView
{
    
    _myTabelView=[[UITableView alloc]initWithFrame:self.view.bounds];
    _myTabelView.dataSource=self;
    _myTabelView.delegate=self;
    _myTabelView.separatorStyle=0;
    [self.view addSubview:_myTabelView];
    
    UIView *titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 150)];
    titleView.backgroundColor=[UIColor whiteColor];
    
    UILabel *syqLable=[[UILabel alloc]initWithFrame:CGRectMake(0, 15, KScreenWidth, 18)];
    syqLable.text=@"累计收益分红(元)";
    syqLable.font=[UIFont systemFontOfSize:18];
    syqLable.textColor=MAINCHARACTERCOLOR;
    syqLable.textAlignment=1;
    [titleView addSubview:syqLable];
    
    syqfeLable=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(syqLable.frame)+18, KScreenWidth, 33)];
    syqfeLable.font=[UIFont systemFontOfSize:33];
    syqfeLable.textColor=MAINCOLOR;
    syqfeLable.textAlignment=1;
    [titleView addSubview:syqfeLable];
    
    
    bottom=[[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(syqfeLable.frame)+15, KScreenWidth, 14)];
    bottom.textColor=GRAYCOLOR;
    bottom.font=[UIFont systemFontOfSize:14];
    bottom.textAlignment=1;
    bottom.text=@"昨日分红:0.00元";
    [titleView addSubview:bottom];
    
    
    _myTabelView.tableHeaderView=titleView;
    
    
    //上拉
    __block SYQFHViewController * weakSelf=self;
    [_myTabelView addLegendFooterWithRefreshingBlock:^{
        
        _fresh=0;
        if ([totalCount intValue]==0) {
            
            [weakSelf.myTabelView.footer setTitle:@"没有相关数据" forState:MJRefreshFooterStateIdle];
            [weakSelf.myTabelView.footer endRefreshing];
            
            return ;
        }
        if ([totalCount intValue]>0&&[totalCount intValue]<=10) {
            [weakSelf.myTabelView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            [weakSelf.myTabelView.footer endRefreshing];
            return ;
        }
        if ([totalCount intValue]==_nearArr.count&&[totalCount intValue]>10) {
            [weakSelf.myTabelView.footer endRefreshing];
            [weakSelf.myTabelView.footer setTitle:@"没有更多了..." forState:MJRefreshFooterStateIdle];
            return ;
        }
        [weakSelf createListRequset];
    }];
    
    //下拉刷新
    [_myTabelView addLegendHeaderWithRefreshingBlock:^{
        _fresh=1;
        page=1;
        firstQueryTime=@"";
        //        [weakSelf.nearArr removeAllObjects];
        [weakSelf createListRequset];
        
    }];

}


-(void)createListRequset
{
    NSDictionary *pagination=@{@"page":[NSString stringWithFormat:@"%d",page],@"rows":@"10",@"firstQueryTime":firstQueryTime};
    [RequstEngine pagingRequestHttp:@"1091" paramDic:nil pageDic:pagination blockObject:^(NSDictionary *dic) {
        DMLog(@"1091----%@",dic);
        DMLog(@"error----%@",dic[@"errorMsg"]);
        [self.myTabelView.footer endRefreshing];
        [self.myTabelView.header endRefreshing];
        [activityView stopAnimate];
        if ([dic[@"errorCode"] intValue]==0) {
            
            syqfeLable.text=[NSString stringWithFormat:@"%.2f",[dic[@"totalNum"] floatValue]];
            bottom.text=[NSString stringWithFormat:@"昨日分红：%.2f元",[dic[@"todayNum"] floatValue]];
            if (_fresh==1) {
                [_nearArr removeAllObjects];
            }
            if ([dic[@"totalCount"] intValue]==0) {
                [self.myTabelView.footer setTitle:@"没有相关数据" forState:MJRefreshFooterStateIdle];
            }
            if ([dic[@"totalCount"] intValue]>0&&[dic[@"totalCount"] intValue]<=10) {
                [self.myTabelView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            }
            
            NSDictionary *newDic=dic[@"record"];
            if (newDic.count>0) {
                page++;
            }
            firstQueryTime=dic[@"firstQueryTime"];
            totalCount=dic[@"totalCount"];
            //
            
            for (NSDictionary *myDic in dic[@"record"]) {
                ProfitShareModel * model=[[ProfitShareModel alloc]init];
                [model setValuesForKeysWithDictionary:myDic];
                [_nearArr addObject:model];
            }
            
            [_myTabelView reloadData];
        }
        else if([dic[@"errorCode"] intValue]==109101)
        {
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:dic[@"errorMsg"] delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"去购买", nil];
            alert.delegate=self;
            [alert show];
        }
        
        
    }];

    
}
#pragma mark - tabelViewDelegate & dataSource

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *title=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    title.text=@"     分红记录";
    title.backgroundColor=BGMAINCOLOR;
    title.font=[UIFont systemFontOfSize:14.];
    title.textColor=GRAYCOLOR;
    return title;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _nearArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ProfitShareModel * model;
    if (_nearArr.count>0) {
        model=_nearArr[indexPath.row];
    }
    SYQJLTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"syfhlCell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"SYQJLTableViewCell" owner:nil options:nil] objectAtIndex:1];
        
    }
    
    cell.incomeNum.text=[NSString stringWithFormat:@"%@",model.num];
    
    cell.createDate.text=[NSString stringWithFormat:@"%@",model.createDate];
    
    cell.selectionStyle=0;
    return cell;
}


#pragma mark - UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            [self.navigationController popViewControllerAnimated:YES];
            break;
            
        case 1:
        {
            SYQViewController * syqVC=[[SYQViewController alloc]init];
            [self.navigationController pushViewController:syqVC animated:YES];
        }
            
            break;
        default:
            break;
    }
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
