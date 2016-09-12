//
//  StoreInfoViewController.m
//  eShangBao
//
//  Created by Dev on 16/1/19.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "StoreInfoViewController.h"
#import "ClassInfoTableViewCell.h"
#import "ClassHeadView.h"
#import "MerchantsTableViewCell.h"
#import "MerchantListTableViewCell.h"
#import "SearchViewController.h"
#import "SubmitViewController.h"
#import "goodsInfoViewController.h"

@interface StoreInfoViewController ()<UITableViewDataSource,UITableViewDelegate,classListInfoDelegate,chooseCommentDelegate>
{
    ClassHeadView                     *commentHeadView;//评价头
    UIView                            *nearbyHeadView;//附近商家
    int                               totalMoney;
    UIView                            *chooseListView;
    SellerInfoModel                   *infoModel;
    NSInteger                         selectedRow;//记录当钱的选择
    NSString                          *scoreLevel;//评论种类
    
    //评论的请求参数
    int                                comment_page;
    NSString                          *comment_firstQueryTime;
    NSString                          *comment_totalCount;
    
    //商品分类列表
    int                                goods_page;
    NSString                          *goods_firstQueryTime;
    NSString                          *goods_totalCount;
    NSString                          *goodsCategoryId;
    
    //附近商家
    int                               near_page;
    NSString                          *near_firstQueryTime;
    NSString                          *near_totalCount;
    
    UIView                            *deleteAllChoose;//删除所有的选的
    UIButton                          *deleteBtn;//删除按钮
    float                            chooseTotalMoney;//选择的总价钱
    
    TBActivityView                    *activityView;
    int                               _fresh;//0 上拉；1 下拉
    int                               _count;
    
}

@property(nonatomic,strong)UITableView             *chooseListTableView;
@property(nonatomic,strong)NSMutableArray          *chooseListArr;//选择的商品的数组
@property(nonatomic,strong)NSMutableArray          *goodsCategoryArr;
@property(nonatomic,strong)NSMutableArray          *comment_DataArr;//评论数据
@property(nonatomic,strong)NSMutableArray          *goods_DataArr;//商品分类
@property(nonatomic,strong)NSMutableArray          *near_dataArr;

@property(nonatomic,strong)NSMutableDictionary     *chooseGoodsListDic;//选择的商品字典
@property(nonatomic,strong)UIButton                *selectedBtn;

@end

@implementation StoreInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    DMLog(@"------------%@",_isCollected);
    self.fd_prefersNavigationBarHidden=YES;
    _chooseListArr=[NSMutableArray arrayWithCapacity:0];
    _headView.layer.cornerRadius=_headView.frame.size.height/2.;
    _headView.layer.masksToBounds=YES;
    _headImage.layer.cornerRadius=_headImage.frame.size.height/2.;
    _headImage.layer.masksToBounds=YES;
    _chooseGoodsNum.layer.cornerRadius=_chooseGoodsNum.frame.size.height/2.;
    _chooseGoodsNum.layer.masksToBounds=YES;
    totalMoney=0;
    scoreLevel=@"0";
    infoModel=[[SellerInfoModel alloc]init];
    _goodsCategoryArr=[NSMutableArray arrayWithCapacity:0];
    //
    comment_firstQueryTime=@"";
    comment_page=1;
    _comment_DataArr=[NSMutableArray arrayWithCapacity:0];
    
    //
    goods_firstQueryTime=@"";
    goods_page=1;
    _goods_DataArr=[NSMutableArray arrayWithCapacity:0];
    
    //
    near_page=1;
    near_firstQueryTime=@"";
    _near_dataArr=[NSMutableArray arrayWithCapacity:0];
    
    
    _chooseGoodsListDic=[NSMutableDictionary dictionaryWithCapacity:0];
    _chooseGoodsBtn.userInteractionEnabled=NO;
    
    [self shopBasicInformation];
    [self tableviewType];
    
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [self.view addSubview:activityView];
    [activityView stopAnimate];
    
    
    
    //请求详情
    [self requsetShopInfo];
    //分类
    [self goodsCategoryRequste];
    [self goodsListAddLegend];
    //评论列表
    [self commentMessageRequset];
    [self commentAddLegend];
    //附近商家
    [self requsetNearShopData];
    [self nearTableAddLegend];
    
    _count=0;
    
    // 通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(cleanAll) name:@"cleanMsg" object:nil];
    //[self goodsCategoryListRequest];
    
    // Do any additional setup after loading the view from its nib.
}


-(void)cleanAll
{
    [self deleteAllChooseGoods];
}
//-(void)viewWillAppear:(BOOL)animated
//
//{
//    [super viewWillAppear:YES];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//}
-(void)goodsListAddLegend
{
    

    [_goodsListTable addLegendFooterWithRefreshingBlock:^{
        
        if ([goods_totalCount intValue]==0) {
            
            [_goodsListTable.footer setTitle:@"没有相关数据" forState:MJRefreshFooterStateIdle];
            [_goodsListTable.footer endRefreshing];
            
            return ;
        }
        if ([goods_totalCount intValue]>0&&[goods_totalCount intValue]<=10) {
            [_goodsListTable.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            [_goodsListTable.footer endRefreshing];
            return ;
        }
        if ([goods_totalCount intValue]==_goods_DataArr.count&&[goods_totalCount intValue]>10) {
            [_goodsListTable.footer endRefreshing];
            [_goodsListTable.footer setTitle:@"没有更多了..." forState:MJRefreshFooterStateIdle];
            return ;
        }
        [self goodsCategoryListRequest];
    }];
   [_goodsListTable.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
}
-(void)commentAddLegend
{
    
    [_evaluationTable.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
    [_evaluationTable addLegendFooterWithRefreshingBlock:^{
        
        
        if ([comment_totalCount intValue]==0) {
            
            [_evaluationTable.footer setTitle:@"没有相关数据" forState:MJRefreshFooterStateIdle];
            [_evaluationTable.footer endRefreshing];
            
            return ;
        }
        if ([comment_totalCount intValue]>0&&[comment_totalCount intValue]<=10) {
            [_evaluationTable.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            [_evaluationTable.footer endRefreshing];
            return ;
        }
        if ([comment_totalCount intValue]==_comment_DataArr.count&&[comment_totalCount intValue]>10) {
            [_evaluationTable.footer endRefreshing];
            [_evaluationTable.footer setTitle:@"没有更多了..." forState:MJRefreshFooterStateIdle];
            return ;
        }
        [self commentMessageRequset];
    }];
    [_evaluationTable.footer setTitle:@"" forState:MJRefreshFooterStateIdle];

}
-(void)nearTableAddLegend
{
    [_merchantsTable.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
    [_merchantsTable addLegendFooterWithRefreshingBlock:^{

        if ([near_totalCount intValue]==0) {
            
            [_merchantsTable.footer setTitle:@"没有相关数据" forState:MJRefreshFooterStateIdle];
            [_merchantsTable.footer endRefreshing];
            
            return ;
        }
        if ([near_totalCount intValue]>0&&[near_totalCount intValue]<=10) {
            [_merchantsTable.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            [_merchantsTable.footer endRefreshing];
            return ;
        }
        if ([near_totalCount intValue]==_near_dataArr.count&&[near_totalCount intValue]>10) {
            [_merchantsTable.footer endRefreshing];
            [_merchantsTable.footer setTitle:@"没有更多了..." forState:MJRefreshFooterStateIdle];
            return ;
        }
        [self requsetNearShopData];
    }];
    [_merchantsTable.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
}


-(void)shopBasicInformation
{
    [_headImage setImageWithURLString:infoModel.doorImg placeholderImage:DEFAULTIMAGE];
    if (infoModel.shopName) {
        
    }
    if (infoModel.shopName.length==0&&infoModel.branchName.length!=0) {
        _storeName.text=infoModel.branchName;
    }
    if (infoModel.shopName.length!=0&&infoModel.branchName.length==0) {
        _storeName.text=infoModel.shopName;
    }
    if (infoModel.shopName.length==0&&infoModel.branchName.length==0) {
        _storeName.text=@"";
    }
    if (infoModel.shopName.length!=0&&infoModel.branchName.length!=0) {
         _storeName.text=[NSString stringWithFormat:@"%@(%@)",infoModel.shopName,infoModel.branchName];
    }
   
    NSString *startSendPrice=(infoModel.startSendPrice.length==0)?@"0":infoModel.startSendPrice;
    NSString *sendPrice=(infoModel.sendPrice.length==0)?@"0":infoModel.sendPrice;
    _starLabel.text=[NSString stringWithFormat:@"起送¥%@｜配送¥%@",startSendPrice,sendPrice];
    _submitBtn.userInteractionEnabled=NO;
    [_submitBtn setTitle:[NSString stringWithFormat:@"还差¥%@",startSendPrice] forState:0];
    _timeLabel.text=[NSString stringWithFormat:@"%@分钟送达",(infoModel.transitTime==nil)?@"0":infoModel.transitTime];
    if ([infoModel.isCollected intValue]==1) {
        [_likeBtn setImage:[UIImage imageNamed:@"dianzan_red1"] forState:0];
    }
}

#pragma mark - 重置请求参数
//分类列表
-(void)resetGoodsListParameter
{
    [_goods_DataArr removeAllObjects];
    goods_firstQueryTime=@"";
    goods_page=1;
    goods_totalCount=@"0";
}
//评论列表
-(void)resetCommentParameter
{
    [_comment_DataArr removeAllObjects];
    comment_firstQueryTime=@"";
    comment_page=1;
    comment_totalCount=@"0";
}

#pragma mark - 请求方法
//商店详情
-(void)requsetShopInfo{
    
    NSDictionary *param=@{@"shopId":_shopID};
    [RequstEngine requestHttp:@"1012" paramDic:param blockObject:^(NSDictionary *dic) {
        DMLog(@"%@",dic);
        [activityView stopAnimate];
        if ([dic[@"errorCode"] intValue]==0) {
            [infoModel setValuesForKeysWithDictionary:dic[@"shop"]];
            _isCollected=dic[@"shop"][@"isCollected"];
        }else{
            
            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
        }
        [self shopBasicInformation];
        commentHeadView.infoMedel=infoModel;
    }];
}
//商品分类列表
-(void)goodsCategoryRequste
{
//#warning 等待数据
    NSDictionary *param=@{@"shopId":_shopID};
    [RequstEngine requestHttp:@"1009" paramDic:param blockObject:^(NSDictionary *dic) {
        [activityView stopAnimate];
        DMLog(@"1009---%@",dic);
        if ([dic[@"errorCode"] intValue]==0) {
            
            
            for (NSDictionary *newDic in dic[@"categoryList"]) {
                
                CategoryListModel *model=[[CategoryListModel alloc]init];
                [model setValuesForKeysWithDictionary:newDic];
                [_goodsCategoryArr addObject:model];
                
            }
            [_goodsTable reloadData];
            
            if (_goodsCategoryArr.count>0) {
                CategoryListModel *model=[_goodsCategoryArr objectAtIndex:0];
                goodsCategoryId=model.cateId;
                [self goodsCategoryListRequest];
            }
            
            if (_goodsCategoryArr.count>0) {
                [_goodsTable selectRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
            }
            
        }
        

    }];
}
//评论请求
-(void)commentMessageRequset
{
    NSDictionary *param=@{@"shopId":_shopID,@"scoreLevel":scoreLevel};
    NSDictionary *pagination=@{@"page":[NSString stringWithFormat:@"%d",comment_page],@"rows":@"10",@"firstQueryTime":comment_firstQueryTime};
    [RequstEngine pagingRequestHttp:@"1013" paramDic:param pageDic:pagination blockObject:^(NSDictionary *dic) {
        
        [activityView stopAnimate];
        DMLog(@"1013----%@",dic);
        [_evaluationTable.footer endRefreshing];
        if ([dic[@"errorCode"] intValue]==0) {
            
            if ([dic[@"totalCount"] intValue]==0) {
                [_evaluationTable.footer setTitle:@"没有相关数据" forState:MJRefreshFooterStateIdle];
            }
            if ([dic[@"totalCount"] intValue]>0&&[dic[@"totalCount"] intValue]<=10) {
                [_evaluationTable.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            }
            NSDictionary *newDic=dic[@"recordList"];
            if (newDic.count>0) {
                comment_page++;
            }
            comment_firstQueryTime=dic[@"firstQueryTime"];
            comment_totalCount=dic[@"totalCount"];
            
            for (NSDictionary *newDic in dic[@"recordList"]) {
                
                CommentList *modle=[[CommentList alloc]init];
                [modle setValuesForKeysWithDictionary:newDic];
                [_comment_DataArr addObject:modle];
            }
            [_evaluationTable reloadData];
            
        }
        
    }];
}
//店家商品分类
-(void)goodsCategoryListRequest
{
    
    NSDictionary *param=@{@"shopId":_shopID,@"categoryId":goodsCategoryId,@"name":@"",@"isDeleted":@"0"};
    NSDictionary *pagination=@{@"page":[NSString stringWithFormat:@"%d",goods_page],@"rows":@"10",@"firstQueryTime":goods_firstQueryTime};
    [RequstEngine pagingRequestHttp:@"1010" paramDic:param pageDic:pagination blockObject:^(NSDictionary *dic) {
        
        [activityView stopAnimate];
        DMLog(@"1010----%@",dic);
        [_goodsListTable.footer endRefreshing];
        if ([dic[@"errorCode"] intValue]==0) {
            if ([dic[@"totalCount"] intValue]==0) {
                [_goodsListTable.footer setTitle:@"没有相关数据" forState:MJRefreshFooterStateIdle];
            }
            if ([dic[@"totalCount"] intValue]>0&&[dic[@"totalCount"] intValue]<=10) {
                [_goodsListTable.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            }

            NSDictionary *newDic=dic[@"proList"];
            if (newDic.count>0) {
                goods_page++;
            }
            
            goods_firstQueryTime=dic[@"firstQueryTime"];
            goods_totalCount=dic[@"totalCount"];
            for (NSDictionary *newDic in dic[@"proList"]) {
                
                SellerGoodsListModel *model=[[SellerGoodsListModel alloc]init];
                [model setValuesForKeysWithDictionary:newDic];
                [_goods_DataArr addObject:model];
   
            }
            [_goodsListTable reloadData];
        }
        
    }];
}
-(void)requsetNearShopData
{
    // 需要传经纬度 0：附近商家 1：最新商家 2常去商家 3：评分最高 4起送家最低 5销售最高 6综合排序
    NSDictionary *param=@{@"isRecommend":@"",@"type":@"0",@"shopName":@"",@"categoryId":@"",@"isSupportGold":@"",@"latitude":LATITUDE,@"longitude":LONGITUDE,@"cityId":@""};
    NSDictionary *pagination=@{@"page":[NSString stringWithFormat:@"%d",near_page],@"rows":@"10",@"firstQueryTime":near_firstQueryTime};
    [RequstEngine pagingRequestHttp:@"1006" paramDic:param pageDic:pagination blockObject:^(NSDictionary *dic) {
        [_merchantsTable.footer endRefreshing];
        DMLog(@"1006----%@",dic);
        if ([dic[@"errorCode"] intValue]==0) {
            if ([dic[@"totalCount"] intValue]==0) {
                [_merchantsTable.footer setTitle:@"没有相关数据" forState:MJRefreshFooterStateIdle];
            }
            if ([dic[@"totalCount"] intValue]>0&&[dic[@"totalCount"] intValue]<=10) {
                [_merchantsTable.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            }
            
            NSDictionary *newDic=dic[@"recordList"];
            if (newDic.count>0) {
                near_page++;
            }
            
            near_firstQueryTime=dic[@"firstQueryTime"];
            near_totalCount=dic[@"totalCount"];
            for (NSDictionary *newDic in dic[@"recordList"]) {
                
                SellerListModel *model=[[SellerListModel alloc]init];
                [model setValuesForKeysWithDictionary:newDic];
                [_near_dataArr addObject:model];
                
            }
            [_merchantsTable reloadData];
        }

    }];
    
    
    
}


#pragma mark - 配置表
-(void)tableviewType
{
    
    _chooseListTableView=[[UITableView alloc]initWithFrame:CGRectZero];
    _chooseListTableView.backgroundColor=[UIColor whiteColor];
    _chooseListTableView.delegate=self;
    _chooseListTableView.dataSource=self;
    _chooseListTableView.tag=5;
    
    _goodsListTable.backgroundColor=[UIColor clearColor];
    _goodsTable.backgroundColor=RGBACOLOR(220, 220, 220, 1);
    _evaluationTable.backgroundColor=[UIColor clearColor];
    _merchantsTable.backgroundColor=[UIColor clearColor];
    commentHeadView=[[[NSBundle mainBundle] loadNibNamed:@"ClassHeadView" owner:nil options:nil] firstObject];
   // commentHeadView=[[ClassHeadView alloc]init];
    commentHeadView.frame=CGRectMake(0, 0, KScreenWidth, 125);
    [commentHeadView.allComments addTarget:self action:@selector(chooseCommenType:) forControlEvents:1<<6];
    [commentHeadView.goodsComments addTarget:self action:@selector(chooseCommenType:) forControlEvents:1<<6];
    [commentHeadView.generalComments addTarget:self action:@selector(chooseCommenType:) forControlEvents:1<<6];
    [commentHeadView.poorComments addTarget:self action:@selector(chooseCommenType:) forControlEvents:1<<6];
    //commentHeadView.delegate=self;
    
    nearbyHeadView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
    nearbyHeadView.backgroundColor=BGMAINCOLOR;
    
    UILabel *nearbyStore=[[UILabel alloc]initWithFrame:CGRectMake(8, 0, 100, 30)];
    nearbyStore.text=@"附近商家";
    nearbyStore.font=[UIFont systemFontOfSize:13.];
    [nearbyHeadView addSubview:nearbyStore];
    
//    UIImageView *moreImage=[[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth-20, 7, 9, 15)];
//    moreImage.image=[UIImage imageNamed:@"icon1_15"];
//    [nearbyHeadView addSubview:moreImage];
}
#pragma mark - tablviewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView.tag==3) {
        return 125;
    }if (tableView.tag==4&&section==1) {
        return 30;
    }
    
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView.tag==4) {
        return 2;
    }
    return 1;
}




-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView.tag==3) {
        
        return commentHeadView;
    }
    return nearbyHeadView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (tableView.tag) {
        case 1:
        {
            return _goodsCategoryArr.count;
        }
            break;
        case 2:
        {
            return _goods_DataArr.count;
        }
            break;
        case 3:
        {
            return _comment_DataArr.count;
        }
            break;
        case 4:
        {
            if (section==0) {
                
                if (infoModel.isSupportGold==nil||[infoModel.isSupportGold intValue]==0) {
                    
                    return 3;
                }
                
                return 4;
            }
            return _near_dataArr.count;
        }
            break;
        case 5:
        {
            return _chooseGoodsListDic.count;
        }
            
        default:
            break;
    }
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (tableView.tag) {
        case 1:
        {
            return 35;
        }
            break;
        case 2:
        {
            return 78;
        }
            break;
        case 3:
        {
         
            CommentList *model=_comment_DataArr[indexPath.row];
            float strH=[NSString calculateSizeWithFont:12. Text:model.content].height;
            
            return 70-15+strH;
        }
            break;
        case 4:
        {
            if (indexPath.section==0) {
                
                return 45;
            }else{
                return 90;
            }
            
        }
            break;
        case 5:
        {
            return 40;
        }
        default:
            break;
    }
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (tableView.tag) {
        case 1:
        {
            CategoryListModel *model=[_goodsCategoryArr objectAtIndex:indexPath.row];
            ClassInfoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"classList"];
            if (!cell) {
                cell=[[[NSBundle mainBundle] loadNibNamed:@"ClassInfoTableViewCell" owner:nil options:nil] objectAtIndex:0];
            }
            cell.listName.text=model.cateName;
            //cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.selectedBackgroundView=[[UIView alloc]initWithFrame:cell.frame] ;
            cell.selectedBackgroundView.backgroundColor=RGBACOLOR(252, 249, 249, 1);
            return cell;
        }
            break;
        case 2:
        {
            
            SellerGoodsListModel *model=[_goods_DataArr objectAtIndex:indexPath.row];

            SellerGoodsListModel *chooseModel=[_chooseGoodsListDic objectForKey:model.goodsId];
            ClassInfoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"classInfoCell"];
            if (!cell) {
                
                cell=[[[NSBundle mainBundle] loadNibNamed:@"ClassInfoTableViewCell" owner:nil options:nil] objectAtIndex:1];
            }
            cell.goodListModel=model;
            cell.chooseGoodsNum=chooseModel.chooseNum;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell.delegate=self;
            return cell;
        }
            break;
        case 3:
        {
            CommentList *model=_comment_DataArr[indexPath.row];
            ClassInfoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"commentCell"];
            if (!cell) {
                
                cell=[[[NSBundle mainBundle] loadNibNamed:@"ClassInfoTableViewCell" owner:nil options:nil] objectAtIndex:2];
            }
            cell.commentModel=model;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;

        }
            break;
        case 4:
        {
            
            if (indexPath.section==0) {
                
                MerchantsTableViewCell *cell=[[[NSBundle mainBundle] loadNibNamed:@"MerchantsTableViewCell" owner:nil options:nil] objectAtIndex:indexPath.row];
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                if (infoModel.startBusinessTime.length==0&&infoModel.endBusinessTime.length!=0) {
                    cell.businessTime.text=[NSString stringWithFormat:@"暂定-%@",infoModel.endBusinessTime];
                }
                else if (infoModel.startBusinessTime.length!=0&&infoModel.endBusinessTime.length==0)
                {
                    cell.businessTime.text=[NSString stringWithFormat:@"%@-暂定",infoModel.startBusinessTime];
                }
                else if (infoModel.startBusinessTime.length==0&&infoModel.endBusinessTime.length==0)
                {
                    cell.businessTime.text=[NSString stringWithFormat:@"暂定"];
                }
                else
                {
                    cell.businessTime.text=[NSString stringWithFormat:@"%@-%@",infoModel.startBusinessTime,infoModel.endBusinessTime];
                }

                cell.storeCall.text=(infoModel.branchPhone.length==0)?@"":[NSString stringWithFormat:@"%@",infoModel.branchPhone];
                cell.storeAddress.text=infoModel.shopAddr;
                return cell;
            }
            
            
            SellerListModel *model=_near_dataArr[indexPath.row] ;
            MerchantListTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"merchantsListCell"];
            if (!cell) {
                
                cell=[[[NSBundle mainBundle] loadNibNamed:@"MerchantListTableViewCell" owner:nil options:nil] objectAtIndex:0];
            }
            cell.nearModel=model;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;

        }
            break;
        case 5:
        {
            
            NSString *goodsId=_chooseListArr[indexPath.row];
            SellerGoodsListModel *model=[_chooseGoodsListDic objectForKey:goodsId];
            ClassInfoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"classList"];
            if (!cell) {
                cell=[[[NSBundle mainBundle] loadNibNamed:@"ClassInfoTableViewCell" owner:nil options:nil] objectAtIndex:3];
            }
            cell.delegate=self;
            cell.goodsName.text=model.goodsName;
            cell.chooseNum.text=model.chooseNum;
            cell.goodListModel=model;
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            return cell;
        }
            
        default:
            break;
    }
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"mycell"];
    if (!cell) {
        
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycell"];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (tableView.tag) {
        case 1:
        {
            [activityView startAnimate];
            selectedRow=indexPath.row;
            CategoryListModel *model=[_goodsCategoryArr objectAtIndex:indexPath.row];
            goodsCategoryId=model.cateId;
            [self resetGoodsListParameter];
            [self goodsCategoryListRequest];
        }
            break;
        case 2:
        {
            SellerGoodsListModel *model=[_goods_DataArr objectAtIndex:indexPath.row];
            goodsInfoViewController *goodsInfo=[[goodsInfoViewController alloc]init];
            goodsInfo.goodsID=model.goodsId;
            [self.navigationController pushViewController:goodsInfo animated:YES];
        }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            if (indexPath.section==0) {
                
            }
            else
            {
                DMLog(@"调啊");
                SellerListModel *model=_near_dataArr[indexPath.row] ;
                StoreInfoViewController *myself=[[StoreInfoViewController alloc]init];
                myself.shopID=model.shopId;
                myself.latitude=_latitude;
                myself.longitude=_longitude;
                [self.navigationController pushViewController:myself animated:YES];
            }
            
            
        }
            break;
        case 5:
        {
            
        }
            break;
            
        default:
            break;
    }
}

#pragma cellDelegate 数量变化

-(void)addAndReductionDelegateType:(int)type
{
    
   // DMLog(@"%@",goodsListModel.chooseNum);
    
    switch (type) {
        case 1:
        {
            _nothingLabel.hidden=YES;
            _chooseGoodsNum.hidden=NO;
            totalMoney++;
            DMLog(@"＋");
            //_chooseGoodsNum.text=[NSString stringWithFormat:@"%d",totalMoney];
            [_chooseGoodsBtn setBackgroundImage:[UIImage imageNamed:@"gwc_icon"] forState:0];
            _chooseGoodsBtn.userInteractionEnabled=YES;
            
        }
            break;
        case 2:
        {
            
            totalMoney--;
            DMLog(@"－");
            if (totalMoney==0) {
                
                _nothingLabel.hidden=NO;
                _chooseGoodsNum.hidden=YES;
                [_chooseGoodsBtn setBackgroundImage:[UIImage imageNamed:@"gwc_grey"] forState:0];
                _chooseGoodsBtn.userInteractionEnabled=NO;
            }
            //_chooseGoodsNum.text=[NSString stringWithFormat:@"%d",totalMoney];

        }
            break;
            
        default:
            break;
    }
}
-(void)getGoodsinfoData:(SellerGoodsListModel *)goodsListModel
{
    [_chooseListArr removeAllObjects];
    NSString *chooseID=goodsListModel.goodsId;
    
    if ([goodsListModel.chooseNum intValue]==0) {
        
        [_chooseGoodsListDic removeObjectForKey:chooseID];
        [self shoppingCartBtn:nil];
       // [_chooseListTableView reloadData];
        
    }else{
        
        [_chooseGoodsListDic setObject:goodsListModel forKey:chooseID];
    }
    for (NSString *goodsId in [_chooseGoodsListDic allKeys]) {
        
        [_chooseListArr addObject:goodsId];
        
    }
    
    
    float sumTotal=0.00;
    int    changeChooseNum=0;
    for (SellerGoodsListModel *goodsModel in [_chooseGoodsListDic allValues]) {
        
        float goodsPrice=[goodsModel.price floatValue]*[goodsModel.chooseNum intValue];
        changeChooseNum=changeChooseNum+[goodsModel.chooseNum intValue];
        sumTotal=goodsPrice+sumTotal;
        
    }
    if (sumTotal==0) {
        
        _totalMoneyNum.hidden=YES;
        
    }else{
        
        _totalMoneyNum.hidden=NO;
    }
    
    if (sumTotal>=[infoModel.startSendPrice floatValue]&&sumTotal>0) {
        
        [_submitBtn setTitle:@"选好了" forState:0];
        _submitBtn.backgroundColor=MAINCOLOR;
        _submitBtn.userInteractionEnabled=YES;
        
        
    }else{
        
        float startSendPrice=[infoModel.startSendPrice floatValue];
        float difference=startSendPrice-sumTotal;
        [_submitBtn setTitle:[NSString stringWithFormat:@"还差¥%.2f",difference] forState:0];
        _submitBtn.backgroundColor=RGBACOLOR(203, 200, 200, 1);
        _submitBtn.userInteractionEnabled=NO;
        
        
    }
    //totalMoney=changeChooseNum;
    _chooseGoodsNum.text=[NSString stringWithFormat:@"%d",changeChooseNum];
    _totalMoneyNum.text=[NSString stringWithFormat:@"¥%.2f",sumTotal];
    NSString * totleStr=[NSString stringWithFormat:@"%.2f",sumTotal];
    chooseTotalMoney=[totleStr floatValue];
    [_chooseListTableView reloadData];
    [_goodsListTable reloadData];
    DMLog(@"%@",goodsListModel.chooseNum);
    DMLog(@"%f",sumTotal);

}

-(void)chooseCommenType:(UIButton *)newBtn
{
    
    
    if (newBtn!=_selectedBtn) {
        
        newBtn.backgroundColor=MAINCOLOR;
        [newBtn setTitleColor:[UIColor whiteColor] forState:0];
        _selectedBtn.backgroundColor=RGBACOLOR(248, 220, 200, 1);
        [_selectedBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
        _selectedBtn=newBtn;
    }
    [_comment_DataArr removeAllObjects];
    comment_page=1;
    comment_firstQueryTime=@"";
    scoreLevel=[NSString stringWithFormat:@"%d",(int)newBtn.tag-1];
    [self commentMessageRequset];
    
}

- (IBAction)backButtonClick:(id)sender {
    
    //self.navigationController.navigationBarHidden=NO;
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark 搜索
- (IBAction)searchButtonClick:(id)sender {
    
    SearchViewController *searchVC=[[SearchViewController alloc]init];
    searchVC.hidesBottomBarWhenPushed=YES;
    searchVC.type=2;
    [self.navigationController pushViewController:searchVC animated:YES];
    DMLog(@"搜索");

}
#pragma mark 喜欢
- (IBAction)likeButtonClick:(id)sender {

    
    if (![NSString isLogin]) {
        [self loginUser];
    }
    else
    {
        if (infoModel.shopId.length==0) {
            
        }
        else
        {
            if ([_isCollected intValue]==0) {
                //        static int i=0;
                _count++;
                if (_count%2==1) {
                    NSDictionary *param=@{@"objectId":infoModel.shopId,@"type":@"0"};
                    [RequstEngine requestHttp:@"1007" paramDic:param blockObject:^(NSDictionary *dic) {
                        
                        
                        DMLog(@"-%@",dic);
                        if ([dic[@"errorCode"] intValue]==0) {
                            //                    [UIAlertView alertWithTitle:@"温馨提示" message:@"收藏成功" buttonTitle:nil];
                            
                            [_likeBtn setImage:[UIImage imageNamed:@"dianan_red"] forState:0];
                            //❤️跳动的动画
                            [UIView beginAnimations:nil context:nil];
                            [UIView setAnimationDuration:0.3];
                            CGAffineTransform trasform = CGAffineTransformMakeScale(1.4, 1.4);
                            _likeBtn.transform = trasform;
                            [UIView commitAnimations];
                            [UIView beginAnimations:nil context:nil];
                            [UIView setAnimationDuration:0.3];
                            [UIView setAnimationDelay:0.3];
                            trasform = CGAffineTransformMakeScale(1, 1);
                            _likeBtn.transform = trasform;;
                            [UIView commitAnimations];
                            
                        }else{
                            
                            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                            
                        }
                        
                        
                        
                    }];
                    
                }
                else
                {
                    NSDictionary * param=@{@"objectId":infoModel.shopId};
                    [RequstEngine requestHttp:@"1051" paramDic:param blockObject:^(NSDictionary *dic) {
                        DMLog(@"1051--%@",dic);
                        DMLog(@"error--%@",dic[@"errorMsg"]);
                        if ([dic[@"errorCode"] intValue]==00000) {
                            [_likeBtn setImage:[UIImage imageNamed:@"dianzan_btn"] forState:0];
                            //❤️跳动的动画
                            [UIView beginAnimations:nil context:nil];
                            [UIView setAnimationDuration:0.3];
                            CGAffineTransform trasform = CGAffineTransformMakeScale(1.4, 1.4);
                            _likeBtn.transform = trasform;
                            [UIView commitAnimations];
                            [UIView beginAnimations:nil context:nil];
                            [UIView setAnimationDuration:0.3];
                            [UIView setAnimationDelay:0.3];
                            trasform = CGAffineTransformMakeScale(1, 1);
                            _likeBtn.transform = trasform;;
                            [UIView commitAnimations];
                                                    }
                        else
                        {
                            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                        }
                        
                    }];
                    
                }
                DMLog(@"点赞");
                
            }
            else
            {
                //        static int j=0;
                //        j++;
                
                _count++;
                if (_count%2==1) {
                    NSDictionary * param=@{@"objectId":infoModel.shopId};
                    [RequstEngine requestHttp:@"1051" paramDic:param blockObject:^(NSDictionary *dic) {
                        DMLog(@"1051--%@",dic);
                        DMLog(@"error--%@",dic[@"errorMsg"]);
                        if ([dic[@"errorCode"] intValue]==00000) {
                            [_likeBtn setImage:[UIImage imageNamed:@"dianzan_btn"] forState:0];
                            //❤️跳动的动画
                            [UIView beginAnimations:nil context:nil];
                            [UIView setAnimationDuration:0.3];
                            CGAffineTransform trasform = CGAffineTransformMakeScale(1.4, 1.4);
                            _likeBtn.transform = trasform;
                            [UIView commitAnimations];
                            [UIView beginAnimations:nil context:nil];
                            [UIView setAnimationDuration:0.3];
                            [UIView setAnimationDelay:0.3];
                            trasform = CGAffineTransformMakeScale(1, 1);
                            _likeBtn.transform = trasform;;
                            [UIView commitAnimations];
                        }
                        else
                        {
                            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                        }
                        
                    }];
                    
                }
                else
                {
                    NSDictionary *param=@{@"objectId":infoModel.shopId,@"type":@"0"};
                    [RequstEngine requestHttp:@"1007" paramDic:param blockObject:^(NSDictionary *dic) {
                        
                        
                        DMLog(@"-%@",dic);
                        if ([dic[@"errorCode"] intValue]==0) {
                            //                    [UIAlertView alertWithTitle:@"温馨提示" message:@"收藏成功" buttonTitle:nil];
                            
                            [_likeBtn setImage:[UIImage imageNamed:@"dianan_red"] forState:0];
                            //❤️跳动的动画
                            [UIView beginAnimations:nil context:nil];
                            [UIView setAnimationDuration:0.3];
                            CGAffineTransform trasform = CGAffineTransformMakeScale(1.4, 1.4);
                            _likeBtn.transform = trasform;
                            [UIView commitAnimations];
                            [UIView beginAnimations:nil context:nil];
                            [UIView setAnimationDuration:0.3];
                            [UIView setAnimationDelay:0.3];
                            trasform = CGAffineTransformMakeScale(1, 1);
                            _likeBtn.transform = trasform;;
                            [UIView commitAnimations];
                            
                        }else{
                            
                            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                            
                        }
                        
                        
                        
                    }];
                    
                    
                }
                DMLog(@"点赞");
                
            }
            
        }
        
    }
    
    
}

#pragma mark - 选择不同类型的按钮方法
- (IBAction)chooseCategoryButtonClick:(id)sender {
    UIButton *newBtn=(UIButton *)sender;
    [UIView animateWithDuration:0.3 animations:^{
        
        //_chooseLabel.transform=CGAffineTransformMakeTranslation(newBtn.frame.origin.x, 0);
        _chooseLabel.center=CGPointMake(newBtn.center.x, _chooseLabel.center.y);
    }];
    switch (newBtn.tag) {
        case 1:
        {
            _goodsView.hidden=NO;
            _evaluationTable.hidden=YES;
            _merchantsTable.hidden=YES;
            [_goodsTable reloadData];
            [_goodsListTable reloadData];
            DMLog(@"商品");
        }
            break;
        case 2:
        {
            _goodsView.hidden=YES;
            _evaluationTable.hidden=NO;
            _merchantsTable.hidden=YES;
            [_evaluationTable reloadData];
            DMLog(@"评价");
        }
            break;
        case 3:
        {
            _goodsView.hidden=YES;
            _evaluationTable.hidden=YES;
            _merchantsTable.hidden=NO;
            [_merchantsTable reloadData];
            DMLog(@"商家");
        }
            break;
            
        default:
            break;
    }
    
    if (_goodsCategoryArr.count>0) {
        [_goodsTable selectRowAtIndexPath:[NSIndexPath indexPathForItem:selectedRow inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
    }
    
}

- (IBAction)chooseCompleteBtn:(id)sender {
    
    
    if (![NSString isLogin]) {
        [self loginUser];
        return;
    }
    if (infoModel.shopId.length==0) {
        
        [UIAlertView alertWithTitle:@"温馨提示" message:@"获取商家信息失败,请稍后重试" buttonTitle:nil];
        return;
        
    }
    SubmitViewController *submitVC=[[SubmitViewController alloc]init];
    submitVC.chooseListDic=_chooseGoodsListDic;
    submitVC.chooseListArr=_chooseListArr;
    submitVC.shopInfo=infoModel;
    submitVC.whichPage=0;
    submitVC.chooseTotalMoney=chooseTotalMoney;
    //self.navigationController.navigationBarHidden=NO;
    [self.navigationController pushViewController:submitVC animated:YES];
    
    
}

- (IBAction)shoppingCartBtn:(id)sender {
    
    if (sender!=nil) {
        chooseListView.hidden=!chooseListView.hidden;
    }
    //配置所选商品的列表TableView
    
    
    
    if (!chooseListView) {
        
        chooseListView=[[UIView alloc]init];
        chooseListView.frame=CGRectMake(0, 20,KScreenWidth , KScreenHeight-64);
        chooseListView.backgroundColor=[UIColor clearColor];
        UIImageView *bgView=[[UIImageView alloc]init];
        bgView.frame=chooseListView.bounds;
        bgView.backgroundColor=[UIColor grayColor];
        bgView.alpha=0.6;
        bgView.userInteractionEnabled=YES;
        UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]init];
        [tapGesture addTarget:self action:@selector(hiddenChooseView)];
        [bgView addGestureRecognizer:tapGesture];
        
        deleteAllChoose=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
        deleteAllChoose.backgroundColor=[UIColor clearColor];
        
        
        
        deleteBtn=[[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth-100, 0, 100, 30)];
        [deleteBtn setImage:[UIImage imageNamed:@"deleteAll_03"] forState:0];
        [deleteBtn setTitle:@"清空购物车" forState:0];
        deleteBtn.titleLabel.font=[UIFont systemFontOfSize:12];
        [deleteAllChoose addSubview:deleteBtn];
        [deleteBtn addTarget:self action:@selector(deleteAllChooseGoods) forControlEvents:1<<6];
        [chooseListView addSubview:bgView];
        
        [chooseListView addSubview:deleteAllChoose];
        [self.view addSubview:chooseListView];
        
        [chooseListView addSubview:_chooseListTableView];
#warning  此处有改动  之前为YES 有可能出显之前该过的问题 特此标注
        chooseListView.hidden=NO;
   
    }
    
//#warning 需要一个删除全部按钮
    
    
    
    float newTableViewH=(40*_chooseGoodsListDic.count>KScreenHeight-100)?KScreenHeight-100:40*_chooseGoodsListDic.count;
    float newTableViewY=(CGRectGetMaxY(chooseListView.bounds)-_chooseGoodsListDic.count*40-1<100)?CGRectGetMaxY(chooseListView.bounds)-newTableViewH:CGRectGetMaxY(chooseListView.bounds)-_chooseGoodsListDic.count*40-1;
    
    _chooseListTableView.frame=CGRectMake(0, newTableViewY, KScreenWidth, newTableViewH);
    deleteAllChoose.frame=CGRectMake(0, CGRectGetMinY(_chooseListTableView.frame)-30, KScreenWidth, 30);
    if (_chooseGoodsListDic.count==0) {
        
        chooseListView.hidden=YES;
    }
    DMLog(@"购物车");
    
}


#pragma mark - 购物删除所有
-(void)deleteAllChooseGoods
{
    DMLog(@"删除全部选择的");
    
    _submitBtn.backgroundColor=RGBACOLOR(203, 200, 200, 1);
    [_submitBtn setTitle:[NSString stringWithFormat:@"还差¥%@",infoModel.startSendPrice] forState:0];
    _submitBtn.userInteractionEnabled=NO;
    totalMoney=0;
    _chooseGoodsNum.text=@"0";
    _totalMoneyNum.text=@"0";
    _totalMoneyNum.hidden=YES;
    _nothingLabel.hidden=NO;
    [_chooseGoodsListDic removeAllObjects];
    [_chooseListArr removeAllObjects];
    [self shoppingCartBtn:nil];
    [_chooseListTableView reloadData];
    [_goodsListTable reloadData];
    _chooseGoodsNum.hidden=YES;
    [_chooseGoodsBtn setBackgroundImage:[UIImage imageNamed:@"gwc_grey"] forState:0];
    _chooseGoodsBtn.userInteractionEnabled=NO;
    
}


-(void)hiddenChooseView
{
    chooseListView.hidden=!chooseListView.hidden;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
