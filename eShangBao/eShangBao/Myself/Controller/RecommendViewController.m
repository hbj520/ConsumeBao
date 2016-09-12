//
//  RecommendViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/18.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "RecommendViewController.h"
#import "WantRecommendViewController.h"
#import "TuijianTableViewCell.h"
#import "ConsumerModel.h"
@interface RecommendViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSString       *firstQueryTime;
    NSString       *totalCount;
    int            page;
    

    TBActivityView *activityView;
    NSString *     _userID;
    int            _fresh;//0 上拉；1 下拉
    NSString   *   _lastRefereeId;
    NSString   *  _lastImgUrl;
    NSString   *  _lastUserName;
    int           _type;
    int           i;
    int           j;
    int           _count;
}

@property(nonatomic,strong)NSMutableArray          *nameAndUrl;
@property(nonatomic,strong)NSMutableArray          *nearDataArr;//附近的数据
@end

@implementation RecommendViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    _nameAndUrl=[NSMutableArray array];
    
    NSDictionary *other=@{@"Url":_myImgUrl,@"Name":_myNickName,@"userId":USERID};
    [_nameAndUrl addObject:other];
    i=0;
    j=0;
    _count=0;
    self.title=@"我的推荐";
    _type=0;
    self.view.backgroundColor=BGMAINCOLOR;
    
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [self.view addSubview:activityView];
    
    [activityView startAnimate];
    page=1;
    firstQueryTime=@"";
    _userID=USERID;
    [self backButton];
    
    _nearDataArr=[NSMutableArray arrayWithCapacity:0];
    
    [self merchantsList];
    [self loadTableView];
    __block RecommendViewController * weakSelf=self;
    //上拉
    [_myTableVeiw addLegendFooterWithRefreshingBlock:^{
        
        _fresh=0;
        if ([totalCount intValue]==0) {
            
            [weakSelf.myTableVeiw.footer setTitle:@"没有相关数据" forState:MJRefreshFooterStateIdle];
            [weakSelf.myTableVeiw.footer endRefreshing];
            
            return ;
        }
        if ([totalCount intValue]>0&&[totalCount intValue]<=10) {
            [weakSelf.myTableVeiw.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            [weakSelf.myTableVeiw.footer endRefreshing];
            return ;
        }
        if ([totalCount intValue]==_nearDataArr.count&&[totalCount intValue]>10) {
            [weakSelf.myTableVeiw.footer endRefreshing];
            [weakSelf.myTableVeiw.footer setTitle:@"没有更多了..." forState:MJRefreshFooterStateIdle];
            return ;
        }
        [weakSelf merchantsList];
    }];
    
    //下拉刷新
    [_myTableVeiw addLegendHeaderWithRefreshingBlock:^{
        _fresh=1;
        page=1;
        firstQueryTime=@"";
//        [weakSelf.nearDataArr removeAllObjects];
        [weakSelf merchantsList];
        
    }];

    // 加载UI
//    [self loadUI];
//    [self loadTableView];
    _lastBtn=[UIButton buttonWithType:0];
    _lastBtn.frame=CGRectMake(0, 0, W(60), H(40));
    _lastBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [_lastBtn setTitle:@"上一级" forState:0];
    _lastBtn.hidden=YES;
    [_lastBtn setTitleColor:[UIColor whiteColor] forState:0];
//    [_lastBtn setImage:[UIImage imageNamed:@"saveAddress"] forState:0];
    [_lastBtn addTarget:self action:@selector(saveMsg) forControlEvents:1<<6];
    UIBarButtonItem * rightBtn=[[UIBarButtonItem alloc]initWithCustomView:_lastBtn];
    self.navigationItem.rightBarButtonItem=rightBtn;
    // Do any additional setup after loading the view.
}

//上一级
-(void)saveMsg
{
    DMLog(@"count------%d,%d",_count,i);
    
        _fresh=2;
    firstQueryTime=@"";
    page=1;
    _type=1;
    [_nameAndUrl removeLastObject];
    i--;
    if (_count==1) {
        _userID=USERID;
    }
    else
    {
        _userID=_nameAndUrl[i][@"userId"];
    }
    _count--;
    if ([_userID isEqualToString:USERID]) {
        _lastBtn.hidden=YES;
    }

    [self merchantsList];
    DMLog(@"----%@,%@",_myImgUrl,_myNickName);
//    [_myTableVeiw reloadData];
}

-(void)merchantsList
{
    
    NSDictionary *param=@{@"memberId":_userID,@"type":@"",@"floor":_floor};
    NSDictionary *pagination=@{@"page":[NSString stringWithFormat:@"%d",page],@"rows":@"10",@"firstQueryTime":firstQueryTime};
    [RequstEngine pagingRequestHttp:@"1030" paramDic:param pageDic:pagination blockObject:^(NSDictionary *dic) {
        DMLog(@"1030--%@",dic);
        
        [self.myTableVeiw.footer endRefreshing];
        [self.myTableVeiw.header endRefreshing];
        [activityView stopAnimate];
        if ([dic[@"errorCode"] intValue]==0) {
            
            if (_fresh==1||_fresh==2) {
                [_nearDataArr removeAllObjects];
            }
            if ([dic[@"totalCount"] intValue]==0) {
                [self.myTableVeiw.footer setTitle:@"没有相关数据" forState:MJRefreshFooterStateIdle];
                //                [self loadUI];
            }
            if ([dic[@"totalCount"] intValue]>0&&[dic[@"totalCount"] intValue]<=10) {
                [self.myTableVeiw.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            }
            
            NSDictionary *newDic=dic[@"recordList"];
            if (newDic.count>0) {
                page++;
            }
            if (dic[@"lastRefreeModel"]==nil) {
                _lastBtn.hidden=YES;
            }
            else
            {
                _lastImgUrl=dic[@"lastRefreeModel"][@"imgUrl"];
                _lastUserName=dic[@"lastRefreeModel"][@"name"];
            }
            firstQueryTime=dic[@"firstQueryTime"];
            totalCount=dic[@"totalCount"];
            _lastRefereeId=dic[@"lastRefereeId"];
           

            for (NSDictionary * newDic in dic[@"recordList"]) {
                RecommendModel * model =[[RecommendModel alloc]init];
                [model setValuesForKeysWithDictionary:newDic];
                [_nearDataArr addObject:model];
            }
            [_myTableVeiw reloadData];
        }
        else
        {
            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
        }
        
        
    }];
    
}

#pragma mark - 加载UI
-(void)loadUI
{
    _coverView=[[UIView alloc]initWithFrame:CGRectMake(W(85), H(120)+64+H(60), W(150), H(40))];
    _coverView.backgroundColor=RGBACOLOR(211, 208, 207, 1);
    [self.view addSubview:_coverView];
    
    UILabel * tuijianLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(10), W(80), H(20))];
    tuijianLabel.text=@"去推荐";
    tuijianLabel.font=[UIFont systemFontOfSize:16];
    tuijianLabel.textColor=RGBACOLOR(0, 0, 0, 1);
    [_coverView addSubview:tuijianLabel];
    
    UIImageView * jiantouImg=[[UIImageView alloc]initWithFrame:CGRectMake(kRight(tuijianLabel)+W(20), H(10), W(20), H(20))];
    jiantouImg.image=[UIImage imageNamed:@"shuang_jt"];
    jiantouImg.contentMode=2;
    [_coverView addSubview:jiantouImg];
    
    UIButton * recommendManBtn=[UIButton buttonWithType:0];
    recommendManBtn.frame=CGRectMake(W(85), 0, W(150), H(40));
    [recommendManBtn addTarget:self action:@selector(recommend) forControlEvents:1<<6];
//    recommendManBtn.backgroundColor=[UIColor cyanColor];
    [_coverView addSubview:recommendManBtn];

}

#pragma mark - 加载TableView
-(void)loadTableView
{
    _myTableVeiw=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-64) style:0];
    _myTableVeiw.delegate=self;
    _myTableVeiw.dataSource=self;
    _myTableVeiw.rowHeight=H(115);
    _myTableVeiw.sectionHeaderHeight=90;
    _myTableVeiw.separatorStyle=0;
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self.view addSubview:_myTableVeiw];
    
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

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RecommendModel * model;
    if (_nearDataArr.count>0) {
        model=_nearDataArr[indexPath.row];
        
    }
    TuijianTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[TuijianTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
    }
    cell.selectionStyle=0;
    cell.accessoryType=1;
    [cell.headImg setImageWithURLString:model.imgUrl placeholderImage:@"头像"];
    cell.nameLabel.text=model.memberName;
    cell.payMoneyLabel.text=[NSString stringWithFormat:@"通宝币：%.2f",[model.goldNum floatValue]];
    cell.returnCoinLabel.text=[NSString stringWithFormat:@"加入时间：%@",[NSString showTimeFormat:[NSString stringWithFormat:@"%@",model.createDate] Format:@"YYYY-MM-dd"]];
    cell.levelLabel.text=model.levelName;
    if ([model.payStatus intValue]==0) {
        cell.payStatusLabel.hidden=NO;
    }
    else
    {
        cell.payStatusLabel.hidden=YES;
    }
    return cell;
}

-(UIView * )tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * view=[[UIView alloc]initWithFrame:CGRectMake(0, 20, WIDTH, 90)];
    view.backgroundColor=BGMAINCOLOR;
    
//    UIView * coverView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 90)];
//    coverView.backgroundColor=[UIColor whiteColor];
//    [view addSubview:coverView];
    
    UIImageView * img=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 90)];
    img.image=[UIImage imageNamed:@"图层-3"];
    img.layer.masksToBounds=YES;
    img.contentMode=2;
    [view addSubview:img];
    
    UIImageView * headImg=[[UIImageView alloc]initWithFrame:CGRectMake(W(12), 10, 70, 70)];
    headImg.contentMode=2;
    headImg.layer.masksToBounds=YES;
    headImg.layer.cornerRadius=headImg.frame.size.height/2;
    if (_type==0) {
        
        [headImg setImageWithURLString:_myImgUrl placeholderImage:@"头像"];
       
    }
    else
    {
        [headImg setImageWithURLString:_nameAndUrl[i][@"Url"] placeholderImage:@"头像"];
    }
    [img addSubview:headImg];
    
    UILabel * label=[[UILabel alloc]initWithFrame:CGRectMake(kRight(headImg)+W(10), H(35), WIDTH-W(12)*2-W(10)-W(80), H(20))];
    if (_type==0) {
        
        label.text=_myNickName;
    }
    else
    {
        label.text=_nameAndUrl[i][@"Name"];
    }
    
    label.font=[UIFont systemFontOfSize:14];
    label.textColor=MAINCHARACTERCOLOR;
    [img addSubview:label];
    
    return view;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    RecommendModel * model;
    if (_nearDataArr.count>0) {
        model=_nearDataArr[indexPath.row];
    }
    _userID=model.memberId;
    _myImgUrl=model.imgUrl;
    
    NSDictionary *other=@{@"Url":model.imgUrl,@"Name":model.memberName,@"userId":model.memberId};
    [_nameAndUrl addObject:other];
    
    
    _myNickName=model.memberName;
    page=1;
    firstQueryTime=@"";
    _fresh=1;
    _type=0;
    i++;
    _count++;
    _lastBtn.hidden=NO;
    [self merchantsList];
    
    
}
#pragma mark - 按钮绑定的方法
-(void)recommend
{
    WantRecommendViewController *wantVC=[[WantRecommendViewController alloc]init];
    [self.navigationController pushViewController:wantVC animated:YES];
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
