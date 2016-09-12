//
//  CategoryViewController.m
//  eShangBao
//
//  Created by doumee on 16/4/5.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "CategoryViewController.h"
#import "GorundingCollectionViewCell.h"
#import "categoryView.h"
#import "GoodsDetailsViewController.h"
#import "CategoryGoodsCollectionViewCell.h"
@interface CategoryViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>
{
    NSString       *groundingFirstQueryTime;
    NSString       *groundingTotalCount;
    int            groundingPage;
    
    categoryView * _cateView;
//    NSMutableArray * _groundingArr;
    NSString       * sellerCount;
    NSString       * sortType;
    UIView *       coverView;
//    UIView         * _coverView;
}
@property(nonatomic,retain)NSMutableArray * groundingArr;
@property(nonatomic,retain)UIView         * coverView;
@property (nonatomic,strong) TBActivityView * activityView;
@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"消费宝直营";
    [self backButton];
    if (_categoryName.length==0) {
        _categoryName=@"全部";
    }
    
    self.view.backgroundColor=[UIColor whiteColor];
    _groundingArr=[NSMutableArray arrayWithCapacity:0];
    
    groundingFirstQueryTime=@"";
    groundingPage=1;
    sortType=@"0";
    if (_goodsName.length==0) {
        _goodsName=@"";
    }
    
    if (_categoryId.length==0) {
        _categoryId=@"";
    }
    
    [self loadUI];
    [self mercharList];
    _activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    
    _activityView.rectBackgroundColor=MAINCOLOR;
    
    _activityView.showVC=self;
    [self.view addSubview:_activityView];
    
    [_activityView startAnimate];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark - 加载数据
-(void)mercharList
{
    NSDictionary *pagination=@{@"page":[NSString stringWithFormat:@"%d",groundingPage],@"rows":@"6",@"firstQueryTime":groundingFirstQueryTime};
    
    NSDictionary * param=@{@"categoryId":_categoryId,@"name":_goodsName,@"isDeleted":@"",@"sortType":sortType};
    
    [RequstEngine pagingRequestHttp:@"1067" paramDic:param pageDic:pagination blockObject:^(NSDictionary *dic) {
        DMLog(@"1067--%@",dic);
        DMLog(@"error---%@",dic[@"errorMsg"]);
        [self.collectionView.footer endRefreshing];
        [self.collectionView.header endRefreshing];
        [_activityView stopAnimate];
        
        if ([dic[@"errorCode"] intValue]==0) {
            
            if ([dic[@"totalCount"] intValue]==0) {
                [self.collectionView.footer setTitle:@"没有相关数据" forState:MJRefreshFooterStateIdle];
            }
            if ([dic[@"totalCount"] intValue]>0&&[dic[@"totalCount"] intValue]<=6) {
                [self.collectionView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            }
            
            NSDictionary *newDic=dic[@"proList"];
            if (newDic.count>0) {
                groundingPage++;
            }
            
            groundingFirstQueryTime=dic[@"firstQueryTime"];
            groundingTotalCount=dic[@"totalCount"];
            for (NSDictionary *dataDic in dic[@"proList"]) {
                GroundingModel * model=[[GroundingModel alloc]init];
                [model setValuesForKeysWithDictionary:dataDic];
                [_groundingArr addObject:model];
                //
            }
            
            [_collectionView reloadData];
        }
        
    }];

}

-(void)loadUI
{
    coverView=[[UIView alloc]initWithFrame:CGRectMake(W(12), H(5)+64, WIDTH-W(12)*2, 30)];
    coverView.backgroundColor=BGMAINCOLOR;
    coverView.layer.cornerRadius=3;
    coverView.layer.masksToBounds=YES;
    [self.view addSubview:coverView];
    
    _searchTF=[[UITextField alloc]initWithFrame:CGRectMake(12, 0, WIDTH-W(12)*2-12*2, 30)];
    _searchTF.placeholder=@"请输入您要搜索的商品";
    _searchTF.delegate=self;
    _searchTF.clearButtonMode=UITextFieldViewModeWhileEditing;
    _searchTF.returnKeyType=UIReturnKeySearch;
    _searchTF.layer.masksToBounds=YES;
    _searchTF.layer.cornerRadius=3;
    [_searchTF addTarget:self action:@selector(changeGoods:) forControlEvents:UIControlEventEditingChanged];
    _searchTF.backgroundColor=BGMAINCOLOR;
    _searchTF.font=[UIFont systemFontOfSize:12];
    _searchTF.textColor=MAINCHARACTERCOLOR;
    [coverView addSubview:_searchTF];
    
//    _searchBtn=[UIButton buttonWithType:0];
//    _searchBtn.layer.masksToBounds=YES;
//    _searchBtn.layer.cornerRadius=4;
//    _searchBtn.frame=CGRectMake(kRight(_searchTF)+W(10), H(5)+64, W(44), H(40));
//    _searchBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
//    _searchBtn.titleLabel.font=[UIFont systemFontOfSize:12];
//    [_searchBtn setTitle:@"搜索" forState:0];
//    [_searchBtn addTarget:self action:@selector(searchGoods) forControlEvents:1<<6];
//    [_searchBtn setTitleColor:[UIColor whiteColor] forState:0];
//    [self.view addSubview:_searchBtn];
//    
    for (int i=0; i<2; i++) {
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(coverView)+H(5)+i*H(40)+H(5), WIDTH, 1)];
        lineLabel.backgroundColor=BGMAINCOLOR;
        [self.view addSubview:lineLabel];
    }
    
    for (int i=0; i<3; i++) {
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/4-1+i*WIDTH/4, kDown(coverView)+H(5)*2+H(5), 1, H(30))];
        lineLabel.backgroundColor=BGMAINCOLOR;
        [self.view addSubview:lineLabel];
    }
    
    _categoryImg=[[UIImageView alloc]initWithFrame:CGRectMake(W(12), kDown(coverView)+H(5)*2+H(10)+H(5), W(10), H(10))];
    _categoryImg.image=[UIImage imageNamed:@"menu_icon"];
    _categoryImg.contentMode=2;
    _categoryImg.layer.masksToBounds=YES;
//    _categoryImg.backgroundColor=[UIColor redColor];
    [self.view addSubview:_categoryImg];
    
    _categoryLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_categoryImg)+5, kDown(coverView)+H(5)+H(10)+H(5), W(50), H(20))];
//    _categoryLabel.text=@"分类";
    _categoryLabel.text=_categoryName;
    _categoryLabel.font=[UIFont systemFontOfSize:12];
    _categoryLabel.textColor=MAINCHARACTERCOLOR;
    [self.view addSubview:_categoryLabel];
    
    _defaultLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/4, kDown(coverView)+H(5)+H(10)+H(5), WIDTH/4, H(20))];
    _defaultLabel.textColor=RGBACOLOR(255, 97, 0, 1);
    _defaultLabel.text=@"默认";
    _defaultLabel.textAlignment=NSTextAlignmentCenter;
    _defaultLabel.font=[UIFont systemFontOfSize:12];
    [self.view addSubview:_defaultLabel];
    
    _countLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/4*2+W(20), kDown(coverView)+H(5)+H(10)+H(5), W(30), H(20))];
    _countLabel.text=@"销量";
    _countLabel.textColor=MAINCHARACTERCOLOR;
    _countLabel.font=[UIFont systemFontOfSize:12];
    [self.view addSubview:_countLabel];
    
    _countImg=[[UIImageView alloc]initWithFrame:CGRectMake(kRight(_countLabel), kDown(coverView)+H(5)*2+H(10)+H(5), W(10), H(10))];
    _countImg.image=[UIImage imageNamed:@"px_2_nor"];
    _countImg.contentMode=3;
    [self.view addSubview:_countImg];
    
    _priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(WIDTH/4*3+W(20), kDown(coverView)+H(5)+H(10)+H(5), W(30), H(20))];
    _priceLabel.textColor=MAINCHARACTERCOLOR;
    _priceLabel.text=@"价格";
    _priceLabel.font=[UIFont systemFontOfSize:12];
    [self.view addSubview:_priceLabel];
    
    _priceImg=[[UIImageView alloc]initWithFrame:CGRectMake(kRight(_priceLabel), kDown(coverView)+H(5)*2+H(10)+H(5), W(10), H(10))];
    _priceImg.image=[UIImage imageNamed:@"px_2_nor"];
    _priceImg.contentMode=3;
    [self.view addSubview:_priceImg];
    
    
    for (int i=0; i<4; i++) {
        UIButton * button=[UIButton buttonWithType:0];
        button.frame=CGRectMake(WIDTH/4*i, kDown(coverView)+H(5)+H(5), WIDTH/4, H(40));
//        button.backgroundColor=RGBACOLOR(50*i, 30*i, 20*i, 1);
        button.tag=i;
        [button addTarget:self action:@selector(choose:) forControlEvents:1<<6];
        [self.view addSubview:button];
    }

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kDown(coverView)+H(5)*2+H(40)+1+H(5), WIDTH, HEIGHT-H(85)-64) collectionViewLayout:flowLayout];
    // 注册一个复用的xib文件
    [_collectionView registerClass:[CategoryGoodsCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
//    _collectionView.scrollEnabled=NO;
    //    _recommendCollectionView.backgroundColor = [UIColor colorWithRed:39/255.0 green:39/255.0 blue:39/255.0 alpha:1];
    //collectionView.backgroundColor=[UIColor redColor];
    _collectionView.backgroundColor=[UIColor whiteColor];
    _collectionView.pagingEnabled=YES;
    _collectionView.allowsMultipleSelection = YES;//默认为NO,是否可以多选
    [self.view addSubview:_collectionView];
    
    //上拉
    __block CategoryViewController * weakSelf=self;
    [_collectionView addLegendFooterWithRefreshingBlock:^{
        
//        _fresh=0;
        if ([groundingTotalCount intValue]==0) {
            
            [weakSelf.collectionView.footer setTitle:@"没有相关数据" forState:MJRefreshFooterStateIdle];
            [weakSelf.collectionView.footer endRefreshing];
            
            return ;
        }
        if ([groundingTotalCount intValue]>0&&[groundingTotalCount intValue]<=6) {
            [weakSelf.collectionView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            [weakSelf.collectionView.footer endRefreshing];
            return ;
        }
        if ([groundingTotalCount intValue]==_groundingArr.count&&[groundingTotalCount intValue]>6) {
            [weakSelf.collectionView.footer endRefreshing];
            [weakSelf.collectionView.footer setTitle:@"没有更多了..." forState:MJRefreshFooterStateIdle];
            return ;
        }
        [weakSelf mercharList];
    }];
    
    //下拉刷新
    [_collectionView addLegendHeaderWithRefreshingBlock:^{
//        _fresh=1;
        groundingPage=1;
        groundingFirstQueryTime=@"";
        [weakSelf.groundingArr removeAllObjects];
        [weakSelf mercharList];
        
    }];
}

#pragma mark - UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//    return _dataArr.count;
    
//        return 16;
    return _groundingArr.count;
//    DMLog(@"count---%ld",(long)_dataArr.count);
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GroundingModel* model=_groundingArr[indexPath.row];
    //    SellerListModel * model=_dataArr[indexPath.row];
//    GroundingModel * model=_dataArr[indexPath.row];
    CategoryGoodsCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.recImg setImageWithURLString:model.imgUrl placeholderImage:DEFAULTIMAGE];
    cell.nameLabel.text=model.goodsName;
    cell.priceLabel.text=[NSString stringWithFormat:@"售价￥%.2f",[model.price floatValue]];
    cell.salesLabel.text=[NSString stringWithFormat:@"销量%@",model.monthOrderNum];
    NSString * intBate=[NSString stringWithFormat:@"%.1f",[model.returnBate floatValue]*100];
    if ([intBate isEqualToString:@"0.0"]) {
        cell.backCoinLabel.hidden=YES;
    }
    else
    {
        cell.backCoinLabel.hidden=NO;
        cell.backCoinLabel.text=[NSString stringWithFormat:@"返%.1f%@",[model.returnBate floatValue]*100,@"%"];
    }
    
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (HEIGHT<=568) {
        return CGSizeMake(W(150), 150);
    }
    else
    {
        return CGSizeMake(W(150), H(150));
    }
//    return CGSizeMake(W(150), H(150));
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(H(5), W(5), H(5), W(5));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return W(5);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GroundingModel * model;
    if (_groundingArr.count>0) {
        model=_groundingArr[indexPath.row];
    }
    GoodsDetailsViewController * goodsVC=[[GoodsDetailsViewController alloc]init];
    goodsVC.goodsId=model.goodsId;
    [self.navigationController pushViewController:goodsVC animated:YES];
}

#pragma mark - UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_activityView startAnimate];
    if (_groundingArr.count>0) {
        [_groundingArr removeAllObjects];
        DMLog(@"搜索");
        [self.view endEditing:YES];
        //    _categoryId=@"";
        sortType=@"0";
        groundingFirstQueryTime=@"";
        groundingPage=1;
        [self mercharList];
    }
    else{
        DMLog(@"搜索");
        [self.view endEditing:YES];
        //    _categoryId=@"";
        sortType=@"0";
        groundingFirstQueryTime=@"";
        groundingPage=1;
        [self mercharList];
    }

    [self.view endEditing:YES];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    _goodsName=textField.text;
}
#pragma mark - 按钮绑定的方法
-(void)choose:(UIButton * )sender
{
//    _goodsName=@"";
    
    switch (sender.tag) {
        case 0:
            DMLog(@"分类");
        {
            static int i=0;
            i++;
            if (i%2==1) {
                
                _cateView=[[categoryView alloc]initWithFrame:CGRectMake(0, kDown(coverView)+H(5)+H(5)+H(40)+1, WIDTH, H(180))];
                _cateView.cateName=_categoryName;
//                _cateView.categoryArr=_groundingArr;
//                _cateView.backgroundColor=[UIColor cyanColor];
                CATransition *transition = [CATransition animation];    //创建动画效果类
                transition.duration = 0.7;//设置动画时长
                transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];  //设置动画淡入淡出的效果
                transition.type = kCATransitionFromTop;//{kCATransitionMoveIn, kCATransitionPush, kCATransitionReveal, kCATransitionFade};设置动画类型，移入，推出等
                //更多私有{@"cube",@"suckEffect",@"oglFlip",@"rippleEffect",@"pageCurl",@"pageUnCurl",@"cameraIrisHollowOpen",@"cameraIrisHollowClose"};
                transition.subtype = kCATransitionFromLeft;//{kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom};
                transition.delegate = self;//设置属性依赖
                [_cateView.layer addAnimation:transition forKey:nil];       //在图层增加动画效果
                // 要做的
                [_cateView exchangeSubviewAtIndex:1 withSubviewAtIndex:0];
                __block CategoryViewController * weakSelf=self;
                [_cateView setBlock:^(NSDictionary *dict) {
                    [weakSelf.activityView startAnimate];
                    [weakSelf.groundingArr removeAllObjects];
                    _categoryId=dict[@"cateId"];
                    weakSelf.categoryLabel.text=dict[@"cateName"];
                    _categoryName=dict[@"cateName"];
                    groundingFirstQueryTime=@"";
                    groundingPage=1;
                    [weakSelf mercharList];
                    i=0;
                    [weakSelf.coverView removeFromSuperview];
                }];
                [self.view addSubview:_cateView];
                
                _coverView=[[UIView alloc]initWithFrame:CGRectMake(0, kDown(_cateView), WIDTH, HEIGHT-H(40)-H(5))];
//                _coverView.backgroundColor=[UIColor cyanColor];
                [self.view addSubview:_coverView];
                
                UITapGestureRecognizer *longPressGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo)];
                //                longPressGR.minimumPressDuration = 1.0;
                [_coverView addGestureRecognizer:longPressGR];

            }
            else
            {
//                __block CategoryViewController * weakSelf=self;
//                [_activityView startAnimate];
                [_coverView removeFromSuperview];
                [_cateView removeFromSuperview];
//                groundingFirstQueryTime=@"";
//                groundingPage=1;
//                [self mercharList];
            }
            
        }
            
            break;
            
        case 1:
            DMLog(@"默认");
            
        {
            if (_groundingArr.count>0) {
                [_groundingArr removeAllObjects];
            }
            [_activityView startAnimate];
            _countImg.image=[UIImage imageNamed:@"px_2_nor"];
            _priceImg.image=[UIImage imageNamed:@"px_2_nor"];
            _countLabel.textColor=MAINCHARACTERCOLOR;
            _defaultLabel.textColor=RGBACOLOR(255, 97, 0, 1);
            _priceLabel.textColor=MAINCHARACTERCOLOR;
            sortType=@"0";
            groundingFirstQueryTime=@"";
            groundingPage=1;
            [self mercharList];
        }
            break;
            
        case 2:
            DMLog(@"销量");
        {
            if (_groundingArr.count>0) {
                [_groundingArr removeAllObjects];
            }
            [_activityView startAnimate];
            _defaultLabel.textColor=MAINCHARACTERCOLOR;
            _priceImg.image=[UIImage imageNamed:@"px_2_nor"];
            _countLabel.textColor=RGBACOLOR(255, 97, 0, 1);
            _priceLabel.textColor=MAINCHARACTERCOLOR;
            static int i=0;
            i++;
            if (i%2==1) {
                _countImg.image=[UIImage imageNamed:@"px_2_clk"];
                sortType=@"1";
                groundingFirstQueryTime=@"";
                groundingPage=1;
                [self mercharList];
            }
            else
            {
                _countImg.image=[UIImage imageNamed:@"px_1_clk"];
                sortType=@"3";
                groundingFirstQueryTime=@"";
                groundingPage=1;
                [self mercharList];
            }
            
        }
            break;
            
        case 3:
            DMLog(@"价格");
        {
            if (_groundingArr.count>0) {
                [_groundingArr removeAllObjects];
            }
            [_activityView startAnimate];
            _defaultLabel.textColor=MAINCHARACTERCOLOR;
            _countImg.image=[UIImage imageNamed:@"px_2_nor"];
            _countLabel.textColor=MAINCHARACTERCOLOR;
            _priceLabel.textColor=RGBACOLOR(255, 97, 0, 1);
            static int i=0;
            i++;
            if (i%2==1) {
                _priceImg.image=[UIImage imageNamed:@"px_2_clk"];
                sortType=@"2";
                groundingFirstQueryTime=@"";
                groundingPage=1;
                [self mercharList];
            }
            else
            {
                _priceImg.image=[UIImage imageNamed:@"px_1_clk"];
                sortType=@"4";
                groundingFirstQueryTime=@"";
                groundingPage=1;
                [self mercharList];
            }

        }
            break;
        default:
            break;
    }
}

-(void)changeGoods:(UITextField*)textField;
{
    _goodsName=textField.text;
}

//
//-(void)searchGoods
//{
//    
//  
//    
//}

#pragma mark - 手势绑定的方法
-(void)longPressToDo
{
//    __block CategoryViewController * weakSelf=self;
    [_coverView removeFromSuperview];
    [_cateView removeFromSuperview];
//    groundingFirstQueryTime=@"";
//    groundingPage=1;
//    [self mercharList];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
