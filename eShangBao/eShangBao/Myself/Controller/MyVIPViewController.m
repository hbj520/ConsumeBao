
//
//  MyVIPViewController.m
//  eShangBao
//
//  Created by doumee on 16/7/23.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "MyVIPViewController.h"
#import "MyVIPTableViewCell.h"
#import "CollectModel.h"
@interface MyVIPViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView * _tableView;
    
    NSString       *firstQueryTime;
    NSString       *totalCount;
    int            page;
    
    
    TBActivityView *activityView;
    NSString *     _userID;
    int            _fresh;//0 上拉；1 下拉
}

@property(nonatomic,strong)UITableView * tableView;

@property(nonatomic,strong)NSMutableArray          *nearDataArr;//附近的数据
@end

@implementation MyVIPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"我的会员";
    self.view.backgroundColor=BGMAINCOLOR;
    _nearDataArr=[NSMutableArray arrayWithCapacity:0];
    [self backButton];
    [self loadUI];
    _fresh=0;
    page=1;
    firstQueryTime=@"";
    [self merchantsList];
    
    // Do any additional setup after loading the view.
}

-(void)loadUI
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:0];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=0;
    _tableView.rowHeight=90;
    [self.view addSubview:_tableView];
    
    __block MyVIPViewController * weakSelf=self;
    //上拉
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
        //        [weakSelf.nearDataArr removeAllObjects];
        [weakSelf merchantsList];
        
    }];

}

-(void)merchantsList
{
    
    NSDictionary *param=@{@"shopId":_shopId};
    NSDictionary *pagination=@{@"page":[NSString stringWithFormat:@"%d",page],@"rows":@"10",@"firstQueryTime":firstQueryTime};
    [RequstEngine pagingRequestHttp:@"1093" paramDic:param pageDic:pagination blockObject:^(NSDictionary *dic) {
        DMLog(@"1093--%@",dic);
        
        [self.tableView.footer endRefreshing];
        [self.tableView.header endRefreshing];
        [activityView stopAnimate];
        if ([dic[@"errorCode"] intValue]==0) {
            
            if (_fresh==1) {
                [_nearDataArr removeAllObjects];
            }
            if ([dic[@"totalCount"] intValue]==0) {
                [self.tableView.footer setTitle:@"没有相关数据" forState:MJRefreshFooterStateIdle];
                //                [self loadUI];
            }
            if ([dic[@"totalCount"] intValue]>0&&[dic[@"totalCount"] intValue]<=10) {
                [self.tableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            }
            
            NSDictionary *newDic=dic[@"record"];
            if (newDic.count>0) {
                page++;
            }
        
            firstQueryTime=dic[@"firstQueryTime"];
            totalCount=dic[@"totalCount"];

            for (NSDictionary * newDic in dic[@"record"]) {
                VIPModel * model =[[VIPModel alloc]init];
                [model setValuesForKeysWithDictionary:newDic];
                [_nearDataArr addObject:model];
            }
            [_tableView reloadData];
        }
        else
        {
            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
        }
        
        
    }];
    
}


#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _nearDataArr.count;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VIPModel * model;
    if (_nearDataArr.count>0) {
        model=_nearDataArr[indexPath.row];
    }
    MyVIPTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"VIPcell"];
    if (!cell) {
        cell=[[MyVIPTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"VIPcell"];
    }
    
    cell.selectionStyle=0;
//    cell.accessoryType=1;
    
    [cell.headImg setImageWithURLString:model.memberImgUrl placeholderImage:@"头像"];
    cell.nameLabel.text=[NSString stringWithFormat:@"会员名称：%@",model.memberName];
    cell.dateLabel.text=[NSString stringWithFormat:@"锁定时间：%@",model.lockDate];
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
