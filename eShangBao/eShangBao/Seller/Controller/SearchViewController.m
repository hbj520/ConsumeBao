//
//  SearchViewController.m
//  eShangBao
//
//  Created by Dev on 16/1/21.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "SearchViewController.h"
#import "MerchantListTableViewCell.h"
#import "SellerDataModel.h"
#import "SellerTableViewCell.h"
#import "StoreInfoViewController.h"
#import "ManageGoodsTableViewCell.h"
#import "AddGoodsViewController.h"
#import "goodsInfoViewController.h"
#import "LMSJTableViewCell.h"
#import "SJXQViewController.h"



@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,manageGoodsDelegate>
{
    int                    page;
    NSString               *firstQueryTime;
    NSString               *totalCount;
    SellerGoodsListModel   *chooseModel;
    
    TBActivityView         *activityView;
    int                    _fresh;//0 上拉；1 下拉
    

    NSString               *isShop;
}

@property(nonatomic,strong)NSMutableArray *searchDataArr;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    self.fd_prefersNavigationBarHidden=YES;
    page=1;
    firstQueryTime=@"";
    _searchDataArr=[NSMutableArray arrayWithCapacity:0];
    
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [self.view addSubview:activityView];
    
    if (_type==1||_type==3) {
        
        isShop=(_type==1)?@"0":@"1";
        _searchContentText.placeholder=@"请输入商家";
    }else
    {
        _searchContentText.placeholder=@"请输入店内商品";
    }
    
    [self addLegendHeader];
    _searchView.layer.cornerRadius=5;
    _searchView.layer.masksToBounds=YES;
    _searchButton.layer.cornerRadius=5;
    _searchButton.layer.masksToBounds=YES;
    _myTableView.backgroundColor=[UIColor clearColor];
    _searchContentText.returnKeyType=UIReturnKeyDone;
    _searchContentText.delegate=self;
    _searchButton.userInteractionEnabled=NO;
    [_searchContentText addTarget:self action:@selector(searchStrChange) forControlEvents:UIControlEventEditingChanged];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)searchStrChange
{
    DMLog(@"%@",_searchContentText.text);
    
    if (_searchContentText.text.length==0) {
        
        _searchButton.userInteractionEnabled=NO;
//        _searchButton.backgroundColor=RGBACOLOR(170, 170, 170, 1);
        
        
    }else{
        
        _searchButton.userInteractionEnabled=YES;
//        _searchButton.backgroundColor=MAINCOLOR;
    }

}



-(void)addLegendHeader
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
        if ([totalCount intValue]==_searchDataArr.count&&[totalCount intValue]>10) {
            [_myTableView.footer endRefreshing];
            [_myTableView.footer setTitle:@"没有更多了..." forState:MJRefreshFooterStateIdle];
            return ;
        }
        [self searchShopName];
    }];
    [_myTableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
}

-(void)searchShopName
{
    
    
    if (_type==1||_type==3) {
        
        NSDictionary *param=@{@"isRecommend":@"",@"type":@"",@"shopName":_searchContentText.text,@"categoryId":@"",@"isSupportGold":@"",@"latitude":LATITUDE,@"longitude":LONGITUDE,@"cityId":@"",@"isShop":isShop};
        NSDictionary *pagination=@{@"page":[NSString stringWithFormat:@"%d",page],@"rows":@"10",@"firstQueryTime":firstQueryTime};
        [RequstEngine pagingRequestHttp:@"1006" paramDic:param pageDic:pagination blockObject:^(NSDictionary *dic) {
            
            [activityView stopAnimate];
            [_myTableView.footer endRefreshing];
            [_myTableView.header endRefreshing];
            DMLog(@"%@",dic);
            if ([dic[@"errorCode"] intValue]==0) {
                
                
                if ([dic[@"totalCount"] intValue]==0) {
                    [_myTableView.footer setTitle:@"没有相关数据" forState:MJRefreshFooterStateIdle];
                }
                if ([dic[@"totalCount"] intValue]>0&&[dic[@"totalCount"] intValue]<=10) {
                    [_myTableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
                }
                NSDictionary *newDic=dic[@"recordList"];
                if (newDic.count>0) {
                    
                    page++;
                }
                
                firstQueryTime=dic[@"firstQueryTime"];
                totalCount=dic[@"totalCount"];
                for (NSDictionary *newDic in dic[@"recordList"]) {
                    
                    SellerListModel *shopModel=[[SellerListModel alloc]init];
                    [shopModel setValuesForKeysWithDictionary:newDic];
                    [_searchDataArr addObject:shopModel];
                }
                [_myTableView reloadData];
            }
        }];
    }else
    {
        
        NSDictionary *param=@{@"shopId":USERID,@"categoryId":@"",@"name":_searchContentText.text,@"sortType":@"",@"isDeleted":@""};
        NSDictionary *pagination=@{@"page":[NSString stringWithFormat:@"%d",page],@"rows":@"10",@"firstQueryTime":firstQueryTime};
        [RequstEngine pagingRequestHttp:@"1010" paramDic:param pageDic:pagination blockObject:^(NSDictionary *dic) {
            
            DMLog(@"%@",dic);
            [_myTableView.footer endRefreshing];
            [_myTableView.header endRefreshing];
            [activityView stopAnimate];
            DMLog(@"%@",dic);
            if ([dic[@"errorCode"] intValue]==0) {
                
                
                if ([dic[@"totalCount"] intValue]==0) {
                    [_myTableView.footer setTitle:@"没有相关数据" forState:MJRefreshFooterStateIdle];
                }
                if ([dic[@"totalCount"] intValue]>0&&[dic[@"totalCount"] intValue]<=10) {
                    [_myTableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
                }
                NSDictionary *newDic=dic[@"proList"];
                if (newDic.count>0) {
                    
                    page++;
                }
                
                firstQueryTime=dic[@"firstQueryTime"];
                totalCount=dic[@"totalCount"];
                for (NSDictionary *newDic in dic[@"proList"]) {
                    
                    SellerGoodsListModel *shopModel=[[SellerGoodsListModel alloc]init];
                    [shopModel setValuesForKeysWithDictionary:newDic];
                    [_searchDataArr addObject:shopModel];
                }
                [_myTableView reloadData];
            }

            
            
            
        }];
        
    }
}

#pragma mark - TableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchDataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type==1) {
        return 93.;
    }
    if (_type==3) {
        
        return 95;
    }
    return 140;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_type==1) {
        
        SellerListModel *model=_searchDataArr[indexPath.row];
        SellerTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (!cell) {
            
            cell=[[[NSBundle mainBundle]loadNibNamed:@"SellerTableViewCell" owner:nil options:nil] firstObject];
        }
        cell.listModel=model;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        cell.selectionStyle=0;
        return cell;

    }
    if (_type==3) {
        
        SellerListModel *model=_searchDataArr[indexPath.row];
        LMSJTableViewCell *lmsjCell=[tableView dequeueReusableCellWithIdentifier:@"lmsjCell"];
        if (!lmsjCell) {
            
            lmsjCell=[[[NSBundle mainBundle] loadNibNamed:@"LMSJTableViewCell" owner:nil options:nil] firstObject];
        }
        lmsjCell.ListModel=model;
        lmsjCell.selectionStyle=UITableViewCellSelectionStyleNone;
        return lmsjCell;
    }
    
    SellerGoodsListModel *model=_searchDataArr[indexPath.row];
    ManageGoodsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"manageGoods"];
    if (!cell) {
        
        cell=[[[NSBundle mainBundle]loadNibNamed:@"ManageGoodsTableViewCell" owner:nil options:nil] firstObject];
    }
    cell.delegate=self;
    cell.goodsModel=model;
    cell.isDelete=model.isDeleted;
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.selectionStyle=0;
    return cell;
}

#pragma mark - cellDelegate
-(void)manageDelegate:(int)type
{
    DMLog(@"%d",type);
    switch (type) {
        case 1:
        {
            [self nextBtnClick];
        }
            break;
        case 2:
        {
            
            AddGoodsViewController *businessVC=[[AddGoodsViewController alloc]init];
            businessVC.type=1;
            businessVC.goodsId=chooseModel.goodsId;
            //self.navigationController.navigationBarHidden=NO;
            [self.navigationController pushViewController:businessVC animated:YES];
            
        }
            break;
        case 3:
        {
            DMLog(@"xiajia");
            [self shelvesGoods];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}
-(void)nextBtnClick
{
    goodsInfoViewController *goodsInfoVC=[[goodsInfoViewController alloc]init];
    //self.navigationController.navigationBarHidden=NO;
    goodsInfoVC.goodsID=chooseModel.goodsId;
    [self.navigationController pushViewController:goodsInfoVC animated:YES];
}

-(void)shelvesGoods
{
    
    NSString *isType;
    if ([chooseModel.isDeleted intValue]==0) {
        isType=@"1";
    }else{
        
        isType=@"0";
    }
    NSDictionary *param=@{@"goodsId":chooseModel.goodsId,@"isDeleted":isType,@"returnBate":@"0"};
    ;
    [RequstEngine requestHttp:@"1037" paramDic:param blockObject:^(NSDictionary *dic) {
        
        DMLog(@"%@",dic[@"errorMsg"]);
        if ([dic[@"errorCode"] intValue]==0) {
            
            [_searchDataArr removeAllObjects];
            page=1;
            firstQueryTime=@"";
            [self searchShopName];
        }
        
    }];
    
}

-(void)manageModelDelegate:(SellerGoodsListModel *)goodsModel
{
    chooseModel=goodsModel;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SellerListModel *model=_searchDataArr[indexPath.row];
    if (_type==1) {
        

//        StoreInfoViewController *storeVC=[[StoreInfoViewController alloc]init];
//        storeVC.shopModel=model;
//        storeVC.shopID=model.shopId;
//        [self.navigationController pushViewController:storeVC animated:YES];
    }
    if (_type==3) {
        
        SJXQViewController *SJXQView=[[SJXQViewController alloc]init];
        SJXQView.shopID=model.shopId;
        [self.navigationController pushViewController:SJXQView animated:YES];
        
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
    
}

- (void)setNeedsStatusBarAppearanceUpdate
{
//    return YES;
}

//- (UIViewController *)childViewControllerForStatusBarStyle
//{
//    return self;
//}
#pragma mark - navigationButton
- (IBAction)backButtonClick:(id)sender {
    
    //self.navigationController.navigationBarHidden=NO;
    [self.navigationController popViewControllerAnimated:YES];

}
- (IBAction)searchbutton:(id)sender {
    
    page=1;
    firstQueryTime=@"";
    [_searchDataArr removeAllObjects];
    [activityView startAnimate];
    
    [self searchShopName];
    [self.view endEditing:YES];
}



-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
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
