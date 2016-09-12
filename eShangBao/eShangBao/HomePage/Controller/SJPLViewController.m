//
//  SJPLViewController.m
//  eShangBao
//
//  Created by Dev on 16/7/4.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "SJPLViewController.h"
#import "SellerDataModel.h"
#import "HHRTableViewCell.h"

@interface SJPLViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    TBActivityView                    *activityView;
    NSString                          *totalCount;
    int                          _fresh;
    int                          page;
    NSString                          *firstQueryTime;
}
@property(nonatomic,strong)NSMutableArray *storeCommentsArr;
@end

@implementation SJPLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"商家全部评论";
    [self backButton];
    [self createTableView];
    page=1;
    firstQueryTime=@"";
    [self requestCommentsList];
    // Do any additional setup after loading the view.
}

-(void)createTableView
{
    _storeCommentsArr=[NSMutableArray arrayWithCapacity:0];
    
    _myTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _myTableView.delegate=self;
    _myTableView.dataSource=self;
    _myTableView.separatorStyle=0;
    [self.view addSubview:_myTableView];
    
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [self.view addSubview:activityView];
    [activityView startAnimate];
    [self refreshData];
}

-(void)refreshData
{
    [_myTableView addLegendFooterWithRefreshingBlock:^{
        
        _fresh=0;
        if ([totalCount intValue]==0) {
            
            [_myTableView.footer setTitle:@"没有相关数据" forState:MJRefreshFooterStateIdle];
            [_myTableView.footer endRefreshing];
            
            return ;
        }
        if ([totalCount intValue]>0&&[totalCount intValue]<=10) {
            [_myTableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            [_myTableView.footer endRefreshing];
            return ;
        }
        if ([totalCount intValue]==_storeCommentsArr.count&&[totalCount intValue]>10) {
            [_myTableView.footer endRefreshing];
            [_myTableView.footer setTitle:@"没有更多了..." forState:MJRefreshFooterStateIdle];
            return ;
        }
        [self requestCommentsList];
    }];
    
    //下拉刷新
    __block SJPLViewController *weakSelf=self;
    [_myTableView addLegendHeaderWithRefreshingBlock:^{
        
        _fresh=1;
        page=1;
        firstQueryTime=@"";
        //        [_categoryArr removeAllObjects];
        //        [_listDataArr removeAllObjects];
        [weakSelf requestCommentsList];
        
    }];
}

-(void)requestCommentsList
{
    //
    NSDictionary *param=@{@"shopId":_shopId,@"scoreLevel":@"0"};
    NSDictionary *pagination=@{@"page":[NSString stringWithFormat:@"%d",page],@"rows":@"10",@"firstQueryTime":firstQueryTime};
    [RequstEngine pagingRequestHttp:@"1013" paramDic:param pageDic:pagination blockObject:^(NSDictionary *dic) {
        
        [activityView stopAnimate];
        [self.myTableView.footer endRefreshing];
        [self.myTableView.header endRefreshing];
        
        DMLog(@"%@",dic);
        if ([dic[@"errorCode"] intValue]==0) {
            
            if (_fresh==1) {
                [_storeCommentsArr removeAllObjects];
            }
            if ([dic[@"totalCount"] intValue]==0) {
                [self.myTableView.footer setTitle:@"没有相关数据" forState:MJRefreshFooterStateIdle];
            }
            if ([dic[@"totalCount"] intValue]>0&&[dic[@"totalCount"] intValue]<=10) {
                [self.myTableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            }
            NSDictionary *newDic=dic[@"recordList"];
            if (newDic.count>0) {
                page++;
            }
            firstQueryTime=dic[@"firstQueryTime"];
            totalCount=dic[@"totalCount"];
            
            
            for (NSDictionary *newDic in dic[@"recordList"]) {
                
                CommentList *commentModel=[[CommentList alloc]init];
                [commentModel setValuesForKeysWithDictionary:newDic];
                [_storeCommentsArr addObject:commentModel];
                
            }
            [_myTableView reloadData];
            
        }
    }];
    
}

#pragma mark - delegate & DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _storeCommentsArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentList *model=_storeCommentsArr[indexPath.row];
    float strH=[NSString calculatemySizeWithFont:14. Text:model.content width:KScreenWidth-63];
    return 60+strH;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommentList *commentModel=_storeCommentsArr[indexPath.row];
    HHRTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"HHRPLCell"];
    if (!cell) {
        cell=[[[NSBundle mainBundle] loadNibNamed:@"HHRTableViewCell" owner:nil options:nil] objectAtIndex:2];
    }
    cell.storeComment=commentModel;
    cell.selectionStyle=0;
    return cell;
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}


@end
