//
//  BillViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/29.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "BillViewController.h"
#import "BillTableViewCell.h"
#import "WithdrawMoneyViewController.h"
@interface BillViewController ()<UITableViewDataSource,UITableViewDelegate>
{
//    UITableView * _tableView;
    int _fresh;
    NSString       *firstQueryTime;
    NSString       *totalCount;
    int            page;
}

@property(nonatomic,retain)UITableView    * tableView;
@property(nonatomic,retain)NSMutableArray * nearArr;
@end

@implementation BillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.title=@"账单详情";
    self.view.backgroundColor=BGMAINCOLOR;
    _nearArr=[NSMutableArray arrayWithCapacity:0];
    _fresh=0;
    page=1;
    firstQueryTime=@"";
    [self merchartList];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-10) style:0];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=0;
    _tableView.sectionFooterHeight=0;
    _tableView.sectionHeaderHeight=0;
    _tableView.rowHeight=H(50);
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.view addSubview:_tableView];
    // Do any additional setup after loading the view.
    
    //上拉
    __block BillViewController * weakSelf=self;
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
        if ([totalCount intValue]==_nearArr.count&&[totalCount intValue]>10) {
            [weakSelf.tableView.footer endRefreshing];
            [weakSelf.tableView.footer setTitle:@"没有更多了..." forState:MJRefreshFooterStateIdle];
            return ;
        }
        [weakSelf merchartList];
    }];
    
    //下拉刷新
    [_tableView addLegendHeaderWithRefreshingBlock:^{
        _fresh=1;
        page=1;
        firstQueryTime=@"";
        //        [weakSelf.nearArr removeAllObjects];
        [weakSelf merchartList];
        
    }];

    
}

-(void)merchartList
{
    NSDictionary * param=@{@"shopId":USERID};
    NSDictionary *pagination=@{@"page":[NSString stringWithFormat:@"%d",page],@"rows":@"10",@"firstQueryTime":firstQueryTime};
    [RequstEngine pagingRequestHttp:@"1076" paramDic:param pageDic:pagination blockObject:^(NSDictionary *dic) {
        DMLog(@"1076---%@",dic);
        DMLog(@"error----%@",dic[@"errorMsg"]);
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
//        [activityView stopAnimate];
        if ([dic[@"errorCode"] intValue]==0) {
            
            if (_fresh==1) {
                [_nearArr removeAllObjects];
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
                BillModel * model=[[BillModel alloc]init];
                [model setValuesForKeysWithDictionary:myDic];
                [_nearArr addObject:model];
            }
            
            [_tableView reloadData];
        }

    }];
}

#pragma mark - UITalbeViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _nearArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BillModel * model;
    if (_nearArr.count>0) {
        model=_nearArr[indexPath.row];
    }
    
    BillTableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[BillTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
    }
    
    cell.balanceLabel.text=[NSString stringWithFormat:@"￥%.2f",[model.remain floatValue]];
    if ([model.type intValue]==0) {
        cell.countLabel.text=[NSString stringWithFormat:@"+￥%.2f",[model.money floatValue]];
    }
    else
    {
        cell.countLabel.text=[NSString stringWithFormat:@"-￥%.2f",[model.money floatValue]];
    }
    cell.storeLabel.text=model.info;
    cell.timeLabel.text=model.createDate;
//    cell.timeLabel.text=[NSString showTimeFormat:[NSString stringWithFormat:@"%@",model.createDate] Format:@"YYYY-MM-dd HH:mm:ss"];
    cell.selectionStyle=0;
//    cell.textLabel.text=@"yanguoqiang";
    
    UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(43), WIDTH, H(1))];
    lineLabel.backgroundColor=BGMAINCOLOR;
    [cell.contentView addSubview:lineLabel];
    return cell;
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
