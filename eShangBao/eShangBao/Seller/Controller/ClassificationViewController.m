//
//  ClassificationViewController.m
//  eShangBao
//
//  Created by Dev on 16/1/19.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "ClassificationViewController.h"
#import "ClassTableViewCell.h"
#import "StoreInfoViewController.h"
#import "SearchViewController.h"
#import "SellerDataModel.h"
#import "LMSJTableViewCell.h"
#import "SJXQViewController.h"

@interface ClassificationViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSMutableArray    *chooseOne;//第一个选择数组
    NSArray           *chooseTwo;//第一个选择数组
    NSArray           *chooseThree;//第一个选择数组
    NSArray           *chooseImageArr;//
    NSArray           *chooseHImageArr;//选择的图片的样子
    
    
    int               choose1;//第一个选择的位置
    int               choose2;//
    int               choose3;//
    int               chooseType;//标示第几个类的选择操作
    
    //请求基本参数
    NSString          *categoryId;
    int               type;//列表排序类型
    NSString          *isSupportGold;
    int               page;
    NSString          *firstQueryTime;
    NSString          *totalCount;
    
    TBActivityView    *activityView;
    
    int            _fresh;//0 上拉；1 下拉
    NSString         *isShop;//判断是否是线下商家 0 不是 1 是
}


@property (weak, nonatomic) IBOutlet UIImageView      *bgView;
@property(nonatomic,strong)UIButton                   *selectedBtn;//当前选择的Button
@property(nonatomic,strong)UILabel                    *selectedLabel;
@property(nonatomic,strong)NSMutableArray             *listDataArr;
@end

@implementation ClassificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    
    
    chooseOne=[NSMutableArray arrayWithCapacity:0];
    [self navigationRightButton];
    
    _chooseTableView.backgroundColor=[UIColor clearColor];
    
    
    UITapGestureRecognizer *tapgesture=[[UITapGestureRecognizer alloc]init];
    [tapgesture addTarget:self action:@selector(hiddenTheChooseView)];
    _bgView.userInteractionEnabled=YES;
    [_bgView addGestureRecognizer:tapgesture];
    
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [self.view addSubview:activityView];
    [activityView startAnimate];
    
    choose1=_index;
    page=1;
    type=6;
    isSupportGold=@"";
    firstQueryTime=@"";
    
    _listDataArr=[NSMutableArray arrayWithCapacity:0];
    if (_vcType==0) {
        
        isShop=@"0";
        CategoryListModel *model=[_categoryArr objectAtIndex:_index];
        self.title=model.cateName;
        categoryId=model.cateId;
        _oneName.text=self.title;
        
        [self createChooseTableView];

    }else{
//#warning  待处理。。。
        isShop=@"1";
        _categoryArr=[NSMutableArray arrayWithCapacity:0];
        self.title=@"联盟商家";
        categoryId=@"";
        _oneName.text=@"全部商家";
        //[activityView stopAnimate];
        [self requestStoreListData];
        
    }
    [self requestCategoryList];
    [self refreshData];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)requestStoreListData
{
    [RequstEngine requestHttp:@"1008" paramDic:nil blockObject:^(NSDictionary *dic) {
        [activityView stopAnimate];
        DMLog(@"%@",dic);
        if ([dic[@"errorCode"] intValue]==0) {
            
            //自加一个全部商家
            CategoryListModel *model1=[[CategoryListModel alloc]init];
            model1.cateId=@"";
            model1.cateName=@"全部商家";
            model1.iconUrl=@"";
            [_categoryArr addObject:model1];
            
            for (NSDictionary *newDic in dic[@"categoryList"]) {
                
                CategoryListModel *model=[[CategoryListModel alloc]init];
                [model setValuesForKeysWithDictionary:newDic];
                [_categoryArr addObject:model];
            }
            [self createChooseTableView];
//            [self createCategoryButton];
        }
        else{
            
            //[];
            
        }
        
        
    }];
}




-(void)refreshData
{
    //上拉
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
        if ([totalCount intValue]==_listDataArr.count&&[totalCount intValue]>10) {
            [_myTableView.footer endRefreshing];
            [_myTableView.footer setTitle:@"没有更多了..." forState:MJRefreshFooterStateIdle];
            return ;
        }
        [self requestCategoryList];
    }];
    
    //下拉刷新
    [_myTableView addLegendHeaderWithRefreshingBlock:^{
        
        _fresh=1;
        page=1;
        firstQueryTime=@"";
//        [_categoryArr removeAllObjects];
//        [_listDataArr removeAllObjects];
        [self requestCategoryList];
        
    }];

}

//-(void)requset

-(void)requestCategoryList
{
    //  需要传经纬度 0：附近商家 1：最新商家 2常去商家 3：评分最高 4起送家最低 5销售最高 6综合排序
#warning isShop参数需要处理
    DMLog(@"%@,%@",LATITUDE,LONGITUDE);
    NSDictionary *param=@{@"isRecommend":@"",@"type":[NSString stringWithFormat:@"%d",type],@"shopName":@"",@"categoryId":categoryId,@"isSupportGold":isSupportGold,@"latitude":LATITUDE,@"longitude":LONGITUDE,@"isShop":isShop};
    
    NSDictionary *pagination=@{@"page":[NSString stringWithFormat:@"%d",page],@"rows":@"10",@"firstQueryTime":firstQueryTime};
    
     DMLog(@"%@－--- %@",param,pagination);
    
    [RequstEngine pagingRequestHttp:@"1006" paramDic:param pageDic:pagination blockObject:^(NSDictionary *dic) {
        
        [activityView stopAnimate];
        DMLog(@"1006----%@",dic);
        [self.myTableView.footer endRefreshing];
        [self.myTableView.header endRefreshing];
        if ([dic[@"errorCode"] intValue]==0) {
        
            if (_fresh==1) {
                [_listDataArr removeAllObjects];
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
        
            
            for (NSDictionary *myDic in dic[@"recordList"]) {
                
                SellerListModel *modl=[[SellerListModel alloc]init];
                [modl setValuesForKeysWithDictionary:myDic];
                [_listDataArr addObject:modl];
            }
            [_myTableView reloadData];
        }

        
    }];
    
}

#pragma mark - 选择的视图
-(void)createChooseTableView
{
    //这个数据得判断是否是动态获取的
    for (CategoryListModel *model in _categoryArr) {
        
        [chooseOne addObject:model.cateName];
        
    }
    chooseTwo=@[@"综合排序",@"评分最高",@"起送价最低",@"销量最高",@"离我最近"];
    chooseThree=@[@"全部商家",@"返币商家"];
    chooseImageArr=@[@"choose_ZHG",@"choose_PFG",@"choose_QSG",@"choose_XLG",@"near_bussiness_lwzjnor",@"choose_QBG",@"fan_txt"];
    chooseHImageArr=@[@"choose_ZHH",@"choose_PFH",@"choose_QSH",@"choose_XLH",@"near_bussiness_lwzj",@"choose_QBH",@"fan_txt"];
    _chooseTableView =[[UITableView alloc]initWithFrame:CGRectZero];
    _chooseTableView.backgroundColor=[UIColor clearColor];
    _chooseTableView.delegate=self;
    _chooseTableView.dataSource=self;
    _chooseTableView.tag=1;
    //_chooseTableView.scrollEnabled=NO;
    [_chooseClassView addSubview:_chooseTableView];
}
-(void)hiddenTheChooseView
{
    _arrowOne.image=[UIImage imageNamed:@"arrowBotton"];
    _arrowTwo.image=[UIImage imageNamed:@"arrowBotton"];
    _arrowThree.image=[UIImage imageNamed:@"arrowBotton"];
    _selectedLabel.textColor=MAINCHARACTERCOLOR;
    [UIView animateWithDuration:0.2 animations:^{
        
        _chooseClassView.alpha=0.0;
    }];
    DMLog(@"隐藏");
}


#pragma mark － 搜索按钮
-(void)navigationRightButton
{
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonClick)];
    self.navigationItem.rightBarButtonItem=right;
}
-(void)rightButtonClick
{
    
    SearchViewController *searchVC=[[SearchViewController alloc]init];
    searchVC.hidesBottomBarWhenPushed=YES;
    if (_vcType==1) {
        searchVC.type=3;
    }else
    {
       searchVC.type=1;
    }
    
    [self.navigationController pushViewController:searchVC animated:YES];
    DMLog(@"搜索");
}


#pragma mark - tableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    
    if (tableView.tag==1) {
        if (chooseType==1) {
            return chooseOne.count;
        }
        return chooseTwo.count;
    }
    
    
    return _listDataArr.count;
    //return 10;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView.tag==1) {
        
        return 40;
    }
    
    if (_vcType==1) {
        
        return 95;
    }
    return 90;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
    ClassTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"classCell"];
    
    if (tableView.tag==1) {
        
        if (chooseType==1) {
            
            cell=[[[NSBundle mainBundle] loadNibNamed:@"ClassTableViewCell" owner:nil options:nil] objectAtIndex:1];
            if (choose1==indexPath.row) {
                cell.chooseName.textColor=MAINCOLOR;
                cell.chooseOne.hidden=NO;
            }
            cell.chooseName.text=chooseOne[indexPath.row];
            
        }else{
            
            cell=[[[NSBundle mainBundle] loadNibNamed:@"ClassTableViewCell" owner:nil options:nil] objectAtIndex:2];
            
            if (chooseType==2) {
                
                cell.chooseImageName.text=chooseTwo[indexPath.row];
                if (choose2==indexPath.row) {
                    cell.chooseImageName.textColor=MAINCOLOR;
                    cell.shooseImage.image=[UIImage imageNamed:chooseHImageArr[indexPath.row]];
                    cell.chooseTwo.hidden=NO;
                    
                }else
                {
                    cell.shooseImage.image=[UIImage imageNamed:chooseImageArr[indexPath.row]];
                }
                
            }else{
                
                if (choose3==indexPath.row) {
                    cell.chooseImageName.textColor=MAINCOLOR;
                    cell.shooseImage.image=[UIImage imageNamed:chooseHImageArr[indexPath.row+5]];
                    cell.chooseTwo.hidden=NO;
                }else
                {
                    cell.shooseImage.image=[UIImage imageNamed:chooseImageArr[indexPath.row+5]];
                }

                cell.chooseImageName.text=chooseThree[indexPath.row];
            }
        }
    }
    else
    {
        //联盟商家
        if (_vcType==1) {
            
            SellerListModel *model=_listDataArr[indexPath.row];
            LMSJTableViewCell *lmsjCell=[tableView dequeueReusableCellWithIdentifier:@"lmsjCell"];
            if (!lmsjCell) {
                
                lmsjCell=[[[NSBundle mainBundle] loadNibNamed:@"LMSJTableViewCell" owner:nil options:nil] objectAtIndex:0];
            }
            lmsjCell.ListModel=model;
            lmsjCell.selectionStyle=UITableViewCellSelectionStyleNone;
            return lmsjCell;
        }
        
        //一般商家
        SellerListModel *model=_listDataArr[indexPath.row];
        //列表数据待处理 
        if (!cell) {
            cell=[[[NSBundle mainBundle] loadNibNamed:@"ClassTableViewCell" owner:nil options:nil] firstObject];
        }
        cell.ListModel=model;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}

//处理选择后的状态 数据请求
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //3：评分最高 4起送家最低 5销售最高 6综合排序
    if (tableView.tag==1) {
        if (chooseType==1) {
            
            CategoryListModel *model=[_categoryArr objectAtIndex:indexPath.row];
            categoryId=model.cateId;
            if (_vcType==0) {
                self.title=chooseOne[indexPath.row];
            }
            
            choose1=(int)indexPath.row;
            _oneName.text=chooseOne[indexPath.row];
        }
        if (chooseType==2) {
            
            switch (indexPath.row) {
                case 0:
                {
                    type=6;
                }
                    break;
                case 1:
                {
                    type=3;
                }
                    break;
                case 2:
                {
                    type=4;
                }
                    break;
                case 3:
                {
                    type=5;
                }
                    break;
                case 4:
                {
                    type=0;
                }
                    break;
                    
                default:
                    break;
            }
            choose2=(int)indexPath.row;
            _twoName.text=chooseTwo[indexPath.row];
        }
        if (chooseType==3) {
            if (indexPath.row==1) {
                isSupportGold=@"1";
            }else{
                isSupportGold=@"";
            }
            choose3=(int)indexPath.row;
            _threeName.text=chooseThree[indexPath.row];
        }
        page=1;
        firstQueryTime=@"";
        [_listDataArr removeAllObjects];
        [self hiddenTheChooseView];
        //刷新列表
        [activityView startAnimate];
        [self requestCategoryList];
        return;
    }
    SellerListModel *model=_listDataArr[indexPath.row];
    if (_vcType==1) {
        
        //联盟商家
        SJXQViewController *SJXQView=[[SJXQViewController alloc]init];
        SJXQView.shopID=model.shopId;
        [self.navigationController pushViewController:SJXQView animated:YES];
        return;
        
    }
    
    
    
//    StoreInfoViewController *storeVC=[[StoreInfoViewController alloc]init];
//    storeVC.shopModel=model;
//    storeVC.shopID=model.shopId;
//    storeVC.latitude=_latitude;
//    storeVC.longitude=_longitude;
//    [self.navigationController pushViewController:storeVC animated:YES];
    DMLog(@"选择了");
}

#pragma mark - 选择类的方法
- (IBAction)chooseTheSortingButtonClick:(id)sender {
    

    
    UIButton *newBtn=(UIButton *)sender;
    UILabel *newName=(UILabel *)[self.view viewWithTag:10*newBtn.tag];
    
    if (newBtn==_selectedBtn&&_chooseClassView.alpha==1.) {
        
        newName.textColor=MAINCOLOR;
        [UIView animateWithDuration:0.2 animations:^{
            
            _chooseClassView.alpha=0.;
        }];
        [self hiddenTheChooseView];
        _selectedBtn=nil;
        _selectedLabel=nil;
        return;
        
    }
    
    
    
    [UIView animateWithDuration:0.2 animations:^{
        
        _chooseClassView.alpha=1.;
    }];
    if (newBtn!=_selectedBtn) {
        
        newName.textColor=MAINCOLOR;
        _selectedLabel.textColor=MAINCHARACTERCOLOR;
        _selectedLabel=newName;
        
    }
    switch (newBtn.tag) {
        case 1:
        {
            chooseType=1;
            
            float tabelH=(40*chooseOne.count>(KScreenHeight-108))?KScreenHeight-108:40*chooseOne.count;
            _chooseTableView.scrollEnabled=(40*chooseOne.count>(KScreenHeight-108))?YES:NO;
            _chooseTableView.frame=CGRectMake(0, 0, KScreenWidth, tabelH);
            _arrowOne.image=[UIImage imageNamed:@"arrowTop"];
            _arrowTwo.image=[UIImage imageNamed:@"arrowBotton"];
            _arrowThree.image=[UIImage imageNamed:@"arrowBotton"];
            DMLog(@"超市");
        }
            break;
        case 2:
        {
            chooseType=2;
            _chooseTableView.frame=CGRectMake(0, 0, KScreenWidth, 40*chooseTwo.count);
            _chooseTableView.scrollEnabled=NO;
            _arrowTwo.image=[UIImage imageNamed:@"arrowTop"];
            _arrowThree.image=[UIImage imageNamed:@"arrowBotton"];
            _arrowOne.image=[UIImage imageNamed:@"arrowBotton"];
            DMLog(@"排序");
        }
            break;
        case 3:
        {
            chooseType=3;
            _chooseTableView.frame=CGRectMake(0, 0, KScreenWidth, 40*2);
            _chooseTableView.scrollEnabled=NO;
            _arrowThree.image=[UIImage imageNamed:@"arrowTop"];
            _arrowTwo.image=[UIImage imageNamed:@"arrowBotton"];
            _arrowOne.image=[UIImage imageNamed:@"arrowBotton"];
            DMLog(@"优惠");
        }
            break;
        default:
            break;
    }
    _selectedBtn=newBtn;
    [_chooseTableView reloadData];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
