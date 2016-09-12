
//
//  GoodsDetailsViewController.m
//  eShangBao
//
//  Created by doumee on 16/4/6.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "GoodsDetailsViewController.h"
#import "CommentDetailsTableViewCell.h"
#import "HomeModel.h"
#import "ShoppingViewController.h"
#import "SubmitViewController.h"
@interface GoodsDetailsViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIScrollView * _scrollView;
    UIScrollView * _hengScrollView;
    int            _count;//购买数量

    NSString       *firstQueryTime;
    NSString       *totalCount;
    int            page;
    float          chooseTotalMoney;
    NSMutableArray *_listArr;
    NSString       *_totleCount;
}
@property(nonatomic,strong)NSMutableArray          *chooseListArr;//选择的商品的数组
@property(nonatomic,strong)NSMutableDictionary     *chooseGoodsListDic;//选择的商品字典
@end

@implementation GoodsDetailsViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//    [self mercharList];
    [self loadtotleCount];
}

-(void)loadtotleCount
{
    NSDictionary * param=@{@"goodsId":_goodsId};
    [RequstEngine requestHttp:@"1075" paramDic:param blockObject:^(NSDictionary *dic) {
        DMLog(@"1075----%@",dic);
        DMLog(@"error----%@",dic[@"errorMsg"]);
        if ([dic[@"errorCode"] intValue]==0) {
            _totleCount=dic[@"data"][@"shopcartNum"];
            if ([_totleCount intValue]==0) {
                _totleCountLabel.hidden=YES;
            }
            else
            {
                _totleCountLabel.hidden=NO;
            }

            _totleCountLabel.text=[NSString stringWithFormat:@"%@",_totleCount];
        }
    }];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"详情";
    self.view.backgroundColor=[UIColor whiteColor];
    _chooseListArr=[NSMutableArray arrayWithCapacity:0];
    _chooseGoodsListDic=[NSMutableDictionary dictionaryWithCapacity:0];
    _nearArr=[NSMutableArray arrayWithCapacity:0];
    _listArr=[NSMutableArray arrayWithCapacity:0];
    _deliveryFeeArr=[NSMutableArray arrayWithCapacity:0];
    _startPriceArr=[NSMutableArray arrayWithCapacity:0];
    _count=1;
    [self mercharList];
    
    [self backButton];
//    [self loadUI];
    // Do any additional setup after loading the view.
}

-(void)scanAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)mercharList
{
    NSDictionary * param=@{@"goodsId":_goodsId};
    [RequstEngine requestHttp:@"1075" paramDic:param blockObject:^(NSDictionary *dic) {
        DMLog(@"1075----%@",dic);
        DMLog(@"error----%@",dic[@"errorMsg"]);
        if ([dic[@"errorCode"] intValue]==0) {
            _imgUrl=dic[@"data"][@"imgUrl"];
            _goodsName=dic[@"data"][@"goodsName"];
            _price=dic[@"data"][@"price"];
            _returnBate=dic[@"data"][@"returnBate"];
            _details=dic[@"data"][@"details"];
            _monthOrderNum=dic[@"data"][@"stock"];
            _totleCount=dic[@"data"][@"shopcartNum"];
            if ([_totleCount intValue]==0) {
                _totleCountLabel.hidden=YES;
            }
            else
            {
                _totleCountLabel.hidden=NO;
            }
            [RequstEngine requestHttp:@"1058" paramDic:nil blockObject:^(NSDictionary *dict) {
                DMLog(@"1058----%@",dict);
                DMLog(@"error---%@",dict[@"errorMsg"]);
                if ([dict[@"errorCode"] intValue]==0) {
                    for (NSDictionary * newDic in dict[@"dataList"]) {
                        
                        [_deliveryFeeArr addObject:newDic[@"name"]];
                        [_startPriceArr addObject:newDic[@"content"]];
                        
                        for (int i=0; i<_deliveryFeeArr.count; i++) {
                            if ([_deliveryFeeArr[i] isEqualToString:@"ZY_SEND_FEE"]) {
                                _deliveryFee=_startPriceArr[i];
                            }
                            if ([_deliveryFeeArr[i] isEqualToString:@"ZY_START_FEE"]) {
                                _startPrice=_startPriceArr[i];
                            }
                        }
                    }
                }
                DMLog(@"----%@,%@,%@",_deliveryFeeArr,_startPriceArr,_deliveryFee);
                [self loadUI];
            }];
        }
    }];
}
-(void)loadUI
{
    UIView * views=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 1)];
    [self.view addSubview:views];
    
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-H(50))];
//    _scrollView.backgroundColor=[UIColor cyanColor];
    _scrollView.showsHorizontalScrollIndicator=NO;
    _scrollView.showsVerticalScrollIndicator=NO;
    if (HEIGHT<=480) {
        _scrollView.contentSize=CGSizeMake(WIDTH, HEIGHT+H(250)+H(100));
    }
    else
    {
        _scrollView.contentSize=CGSizeMake(WIDTH, HEIGHT+H(200));
    }
    [self.view addSubview:_scrollView];
    
    _headImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 180)];
    [_headImg setImageWithURLString:_imgUrl placeholderImage:@"默认banner"];
    _headImg.contentMode=2;
    _headImg.layer.masksToBounds=YES;
    [_scrollView addSubview:_headImg];
    
    _goodsNameLabel=[[UILabel alloc]init];
    _goodsNameLabel.text=_goodsName;
    _goodsNameLabel.numberOfLines=0;
    _goodsNameLabel.font=[UIFont systemFontOfSize:14];
    CGSize size= [self calculateSizeWithFont:14 Text:_goodsNameLabel.text];
    _goodsNameLabel.frame=CGRectMake(W(12), kDown(_headImg)+10, size.width, size.height);
    _goodsNameLabel.textColor=MAINCHARACTERCOLOR;
    [_scrollView addSubview:_goodsNameLabel];
    
    _priceLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(_goodsNameLabel)+10, W(250), H(20))];
    _priceLabel.textColor=RGBACOLOR(255, 97, 0, 1);
    _priceLabel.text=[NSString stringWithFormat:@"价格：￥%.2f",[_price floatValue]];
    _priceLabel.font=[UIFont systemFontOfSize:14];
    [_scrollView addSubview:_priceLabel];
    
    UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_priceLabel), kDown(_headImg)+10, 1, H(40)+H(10))];
    lineLabel.backgroundColor=BGMAINCOLOR;
    [_scrollView addSubview:lineLabel];
    
    UILabel * line=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(_priceLabel)+10, WIDTH, 1)];
    line.backgroundColor=BGMAINCOLOR;
    [_scrollView addSubview:line];
    
    _returnBateLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(lineLabel)+10, kDown(_headImg)+5, W(30), H(60))];
    _returnBateLabel.numberOfLines=0;
    NSString *intBate=[NSString stringWithFormat:@"%.1f",[_returnBate floatValue]*100];
    if ([intBate isEqualToString:@"0.0"]) {
        _returnBateLabel.hidden=YES;
        lineLabel.hidden=YES;
    }
    else
    {
        _returnBateLabel.text=[NSString stringWithFormat:@"%.1f%@\n返币",[_returnBate floatValue]*100,@"%"];
    }
    
    _returnBateLabel.font=[UIFont boldSystemFontOfSize:14];
    _returnBateLabel.textColor=RGBACOLOR(255, 97, 0, 1);
    [_scrollView addSubview:_returnBateLabel];
    
    _deliveryFeeLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(line)+10, WIDTH, H(20))];
    _deliveryFeeLabel.textColor=MAINCHARACTERCOLOR;
    _deliveryFeeLabel.text=[NSString stringWithFormat:@"配送费：￥%@",_deliveryFee];
    _deliveryFeeLabel.font=[UIFont systemFontOfSize:14];
    [_scrollView addSubview:_deliveryFeeLabel];
    
    UILabel * lineLabel2=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(line)+H(44), WIDTH, 1)];
    lineLabel2.backgroundColor=BGMAINCOLOR;
    [_scrollView addSubview:lineLabel2];
    
    _startLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(lineLabel2)+10, WIDTH, H(20))];
    _startLabel.textColor=MAINCHARACTERCOLOR;
    _startLabel.text=[NSString stringWithFormat:@"起送价：￥%@",_startPrice];
    _startLabel.font=[UIFont systemFontOfSize:14];
    [_scrollView addSubview:_startLabel];
    
    UILabel * lineLabel1=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(lineLabel2)+H(44), WIDTH, 1)];
    lineLabel1.backgroundColor=BGMAINCOLOR;
    [_scrollView addSubview:lineLabel1];
    
    _monthOrderNumLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(lineLabel1)+10, WIDTH, H(20))];
    _monthOrderNumLabel.textColor=MAINCHARACTERCOLOR;
    _monthOrderNumLabel.text=[NSString stringWithFormat:@"库存量：%@",_monthOrderNum];
    _monthOrderNumLabel.font=[UIFont systemFontOfSize:14];
    [_scrollView addSubview:_monthOrderNumLabel];
    
    UILabel * lineLabel5=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(lineLabel1)+H(44), WIDTH, 1)];
    lineLabel5.backgroundColor=BGMAINCOLOR;
    [_scrollView addSubview:lineLabel5];
    
    _countTitleLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(lineLabel5)+10, W(60), H(20))];
    _countTitleLabel.text=@"购买数量";
    _countTitleLabel.textColor=MAINCHARACTERCOLOR;
    _countTitleLabel.font=[UIFont systemFontOfSize:14];
    [_scrollView addSubview:_countTitleLabel];
    
    _reduceBtn=[UIButton buttonWithType:0];
//    _reduceBtn.hidden=YES;
    
    _reduceBtn.layer.masksToBounds=YES;
    _reduceBtn.layer.cornerRadius=3;
    _reduceBtn.layer.borderColor=BGMAINCOLOR.CGColor;
    _reduceBtn.layer.borderWidth=1;
    if (_count==1) {
        _reduceBtn.enabled=NO;
    }
    else
    {
        _reduceBtn.enabled=YES;
    }
    [_reduceBtn setTitle:@"-" forState:0];
    [_reduceBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
    _reduceBtn.tag=10;
    _reduceBtn.frame=CGRectMake(W(230), kDown(lineLabel5)+10, W(20), H(20));
    [_reduceBtn addTarget:self action:@selector(changeGoodsCount:) forControlEvents:1<<6];
    [_scrollView addSubview:_reduceBtn];
    
    _countLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_reduceBtn), kDown(lineLabel5)+10, W(30), H(20))];
    _countLabel.textColor=MAINCHARACTERCOLOR;
    _countLabel.text=[NSString stringWithFormat:@"%d",_count];
    _countLabel.textAlignment=NSTextAlignmentCenter;
    _countLabel.font=[UIFont systemFontOfSize:14];
    [_scrollView addSubview:_countLabel];
    
    _addBtn=[UIButton buttonWithType:0];
    _addBtn.frame=CGRectMake(kRight(_countLabel), kDown(lineLabel5)+10, W(20), H(20));
    _addBtn.layer.masksToBounds=YES;
    _addBtn.layer.cornerRadius=3;
    _addBtn.layer.borderColor=BGMAINCOLOR.CGColor;
    _addBtn.layer.borderWidth=1;
    _addBtn.tag=11;
    [_addBtn setTitle:@"+" forState:0];
    [_addBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
    [_addBtn addTarget:self action:@selector(changeGoodsCount:) forControlEvents:1<<6];
    [_scrollView addSubview:_addBtn];
    
    UILabel * line1=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(lineLabel5)+H(44), WIDTH, 5)];
    line1.backgroundColor=BGMAINCOLOR;
    [_scrollView addSubview:line1];
    
    _parameterBtn=[UIButton buttonWithType:0];
    _parameterBtn.frame=CGRectMake(0, kDown(line1)+10, WIDTH/2, H(40));
    [_parameterBtn setTitle:@"产品参数" forState:0];
    [_parameterBtn setTitleColor:RGBACOLOR(255, 97, 0, 1) forState:0];
    _parameterBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    _parameterBtn.tag=100;
    [_parameterBtn addTarget:self action:@selector(changeStyle:) forControlEvents:1<<6];
    [_scrollView addSubview:_parameterBtn];
    
    _commentBtn=[UIButton buttonWithType:0];
    _commentBtn.frame=CGRectMake(kRight(_parameterBtn), kDown(line1)+10, WIDTH/2, H(40));
    [_commentBtn setTitle:@"评论详情" forState:0];
    _commentBtn.tag=101;
    [_commentBtn addTarget:self action:@selector(changeStyle:) forControlEvents:1<<6];
    [_commentBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
    _commentBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [_scrollView addSubview:_commentBtn];
    
    _rollLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(_parameterBtn), WIDTH/2, 2)];
    _rollLabel.backgroundColor=RGBACOLOR(255, 97, 0, 1);
    [_scrollView addSubview:_rollLabel];
    
//    if (HEIGHT<=480) {
//        _hengScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, kDown(_rollLabel), WIDTH, H(120)*2+H(80))];
//    }
//    else
//    {
//        _hengScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, kDown(_rollLabel), WIDTH, HEIGHT+H(180)-180-H(40)*5-5-H(40)-H(60))];
//    }
    _hengScrollView=[[UIScrollView alloc]init];
//    _hengScrollView.backgroundColor=[UIColor redColor];
    _hengScrollView.showsHorizontalScrollIndicator=NO;
    _hengScrollView.showsVerticalScrollIndicator=NO;
    _hengScrollView.scrollEnabled=NO;
    _hengScrollView.contentSize=CGSizeMake(WIDTH*2, 0);
    [_scrollView addSubview:_hengScrollView];
    
    UIView * view=[[UIView alloc]init];
//    view.backgroundColor=[UIColor cyanColor];
    [_hengScrollView addSubview:view];
    
    UILabel * label=[[UILabel alloc]init];
    label.text=_details;
//    label.backgroundColor=[UIColor redColor];
    label.textColor=MAINCHARACTERCOLOR;
    label.font=[UIFont systemFontOfSize:14];
    CGSize labelsize = [self sizeWithStrings:label.text font:label.font];
    label.frame=CGRectMake(12, 5, labelsize.width, labelsize.height);
    label.numberOfLines=0;
   
    [view addSubview:label];
    
//    NSInteger hang=label.numberOfLines;
    view.frame=CGRectMake(0, 0, WIDTH, labelsize.height+10);
//    _hengScrollView.frame=CGRectMake(0, 64, WIDTH, HEIGHT-H(50));
//    if (labelsize.height>) {
//        <#statements#>
//    }
        if (HEIGHT<=480) {
            if (labelsize.height>H(120)*2) {
//                _scrollView.frame=CGRectMake(0, 64, WIDTH, HEIGHT-H(50)+labelsize.height);
                _scrollView.contentSize=CGSizeMake(WIDTH, HEIGHT+labelsize.height-10);
                _hengScrollView.frame=CGRectMake(0, kDown(_rollLabel), WIDTH, labelsize.height+20);
            }
            else
            {
//                _scrollView.frame=CGRectMake(0, 64, WIDTH, HEIGHT-H(50));
                _scrollView.contentSize=CGSizeMake(WIDTH, HEIGHT+H(250)+H(100));
                _hengScrollView.frame=CGRectMake(0, kDown(_rollLabel), WIDTH, H(120)*2);
            }
            
        }
        else
        {
            if (labelsize.height>HEIGHT+H(180)-180-H(40)*5-5-H(40)-H(60)+H(20)) {
//                _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT-H(50))];
//                _scrollView.frame=CGRectMake(0, 64, WIDTH, HEIGHT-H(50)+labelsize.height);
                _scrollView.contentSize=CGSizeMake(WIDTH, HEIGHT+labelsize.height-10);
                _hengScrollView.frame=CGRectMake(0, kDown(_rollLabel), WIDTH, labelsize.height+20);
            }
            else
            {
//                _scrollView.frame=CGRectMake(0, 64, WIDTH, HEIGHT-H(50));
                _scrollView.contentSize=CGSizeMake(WIDTH, HEIGHT+H(200));
                _hengScrollView.frame=CGRectMake(0, kDown(_rollLabel), WIDTH, HEIGHT+H(180)-180-H(40)*5-5-H(40)-H(60));
            }
            
        }
        
    
    
    if (HEIGHT<=480) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(WIDTH, kDown(_rollLabel), WIDTH, H(120)*2) style:0];
    }
    else
    {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(WIDTH, kDown(_rollLabel), WIDTH, HEIGHT+H(180)-180-H(40)*5-5-H(40)-H(60)) style:0];
    }
    
    _tableView.sectionFooterHeight=0;
    _tableView.sectionHeaderHeight=0;
//    _tableView.backgroundColor=[UIColor redColor];
    _tableView.separatorStyle=0;
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [_hengScrollView addSubview:_tableView];
    
    //上拉
    __block GoodsDetailsViewController * weakSelf=self;
    [_tableView addLegendFooterWithRefreshingBlock:^{
        
//        _fresh=0;
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
        [weakSelf loadData];
    }];
    
    //下拉刷新
    [_tableView addLegendHeaderWithRefreshingBlock:^{
//        _fresh=1;
        page=1;
        firstQueryTime=@"";
        [weakSelf.nearArr removeAllObjects];
        [weakSelf loadData];
        
    }];

//    _sizeLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(_goodsLabel), WIDTH, H(20))];
//    _sizeLabel.text=
    
    UIView * covewView=[[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-H(50), WIDTH, H(50))];
    covewView.backgroundColor=RGBACOLOR(249, 249, 249, 1);
    [self.view addSubview:covewView];
    
    _dailBtn=[UIButton buttonWithType:0];
    _dailBtn.layer.masksToBounds=YES;
    _dailBtn.layer.cornerRadius=3;
    _dailBtn.layer.borderColor=BGMAINCOLOR.CGColor;
    _dailBtn.layer.borderWidth=1;
    _dailBtn.frame=CGRectMake(W(12), 10, W(30), W(30));
    [_dailBtn setImage:[UIImage imageNamed:@"phone_icon"] forState:0];
    [_dailBtn addTarget:self action:@selector(dailPhone) forControlEvents:1<<6];
    [covewView addSubview:_dailBtn];
    
    _shoppingBtn=[UIButton buttonWithType:0];
    _shoppingBtn.layer.masksToBounds=YES;
    _shoppingBtn.layer.cornerRadius=3;
    _shoppingBtn.layer.borderColor=BGMAINCOLOR.CGColor;
    _shoppingBtn.layer.borderWidth=1;
    _shoppingBtn.frame=CGRectMake(kRight(_dailBtn)+W(15), 10, W(30), W(30));
    [_shoppingBtn setImage:[UIImage imageNamed:@"gwcs_icon"] forState:0];
    [_shoppingBtn addTarget:self action:@selector(jumpToShopping) forControlEvents:1<<6];
    [covewView addSubview:_shoppingBtn];
    
    _totleCountLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(_shoppingBtn)-5, 8, 20, 20)];
    _totleCountLabel.textAlignment=NSTextAlignmentCenter;
    _totleCountLabel.font=[UIFont systemFontOfSize:10];
    _totleCountLabel.textColor=[UIColor whiteColor];
    if ([_totleCount intValue]==0) {
        _totleCountLabel.hidden=YES;
    }
    else
    {
        _totleCountLabel.hidden=NO;
    }
    _totleCountLabel.text=[NSString stringWithFormat:@"%@",_totleCount];
    _totleCountLabel.layer.cornerRadius=_totleCountLabel.frame.size.height/2;
    _totleCountLabel.layer.masksToBounds=YES;
    _totleCountLabel.backgroundColor=RGBACOLOR(255, 97, 0, 1);
    [covewView addSubview:_totleCountLabel];
    
    _addGoodsBtn=[UIButton buttonWithType:0];
    _addGoodsBtn.layer.masksToBounds=YES;
    _addGoodsBtn.layer.cornerRadius=3;
    _addGoodsBtn.layer.borderColor=BGMAINCOLOR.CGColor;
    _addGoodsBtn.layer.borderWidth=1;
    _addGoodsBtn.frame=CGRectMake(kRight(_shoppingBtn)+W(25), 5, W(90), H(40));
    _addGoodsBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
    _addGoodsBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [_addGoodsBtn addTarget:self action:@selector(addGoods) forControlEvents:1<<6];
    [_addGoodsBtn setTitle:@"加入购物车" forState:0];
    [covewView addSubview:_addGoodsBtn];
    
    _purchaseBtn=[UIButton buttonWithType:0];
    _purchaseBtn.layer.masksToBounds=YES;
    _purchaseBtn.layer.cornerRadius=3;
    _purchaseBtn.layer.borderColor=BGMAINCOLOR.CGColor;
    _purchaseBtn.layer.borderWidth=1;
    _purchaseBtn.frame=CGRectMake(kRight(_addGoodsBtn)+W(15), 5, W(90), H(40));
    _purchaseBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
    _purchaseBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [_purchaseBtn addTarget:self action:@selector(purchaseGoods) forControlEvents:1<<6];
    [_purchaseBtn setTitle:@"立即购买" forState:0];
    [covewView addSubview:_purchaseBtn];
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentModel * model;
    if (_nearArr.count>0) {
        model =_nearArr[indexPath.row];
    }
    UIFont *font = [UIFont systemFontOfSize:12];
    //        CGSize size = CGSizeMake(300,2000);
    CGSize labelsize = [self sizeWithString:model.content font:font];
    return labelsize.height+H(50);
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _nearArr.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    CommentModel * model;
    if (_nearArr.count>0) {
        model =_nearArr[indexPath.row];
    }
    CommentDetailsTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[CommentDetailsTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
    }
    CGSize size =  [self sizeWithString:model.content font:cell.contentLabel.font];
    cell.contentLabel.frame = CGRectMake(kRight(cell.headImg)+W(10), kDown(cell.scoreLabel), size.width, size.height);
    cell.contentLabel.text=model.content;
    [cell.headImg setImageWithURLString:model.memberImgUrl placeholderImage:@"头像"];
    if (model.memberName.length==0) {
        cell.nameLabel.text=@"匿名用户";
    }
    else
    {
        cell.nameLabel.text=model.memberName;
    }
    
    if ([model.score isEqualToString:@"1"]) {
        cell.scoreImg.image=[UIImage imageNamed:@"1_05"];
    }
    if ([model.score isEqualToString:@"2"]) {
        cell.scoreImg.image=[UIImage imageNamed:@"2_05"];
    }
    if ([model.score isEqualToString:@"3"]) {
        cell.scoreImg.image=[UIImage imageNamed:@"3_05"];
    }
    if ([model.score isEqualToString:@"4"]) {
        cell.scoreImg.image=[UIImage imageNamed:@"4_05"];
    }
    if ([model.score isEqualToString:@"5"]) {
        cell.scoreImg.image=[UIImage imageNamed:@"5_05"];
    }
    cell.selectionStyle=0;
    
    return cell;
}
#pragma mark - 按钮绑定的方法
-(void)changeGoodsCount:(UIButton * )sender
{
    switch (sender.tag) {
        case 10:
            _count--;
            _countLabel.text=[NSString stringWithFormat:@"%d",_count];
            if (_count==1) {
                _reduceBtn.enabled=NO;
            }
            break;
        case 11:
            _count++;
            _reduceBtn.enabled=YES;
            _countLabel.text=[NSString stringWithFormat:@"%d",_count];
            _reduceBtn.hidden=NO;
            break;
        default:
            break;
    }
}

-(void)changeStyle:(UIButton* )button
{
    switch (button.tag) {
        case 100:
            _hengScrollView.contentOffset=CGPointMake(0, 0);
            _rollLabel.frame=CGRectMake(0, kDown(_parameterBtn), WIDTH/2, 2);
            [_parameterBtn setTitleColor:RGBACOLOR(255, 97, 0, 1) forState:0];
            [_commentBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
            break;
        case 101:
            _hengScrollView.contentOffset=CGPointMake(WIDTH, kDown(_rollLabel));
            _rollLabel.frame=CGRectMake(WIDTH/2, kDown(_parameterBtn), WIDTH/2, 2);
            [_commentBtn setTitleColor:RGBACOLOR(255, 97, 0, 1) forState:0];
            [_parameterBtn setTitleColor:MAINCHARACTERCOLOR forState:0];
            if (_nearArr.count>0) {
                [_nearArr removeAllObjects];
            }
            page=1;
            firstQueryTime=@"";
            [self loadData];
            break;
        default:
            break;
    }
}

-(void)addGoods
{
    if (![NSString isLogin]) {
        [self loginUser];
    }
    else
    {
        if (_count==0) {
            [UIAlertView alertWithTitle:@"温馨提示" message:@"请选择购买数量" buttonTitle:nil];
        }
        else
        {
            NSDictionary * param=@{@"productId":_goodsId,@"num":[NSString stringWithFormat:@"%d",_count]};
            [RequstEngine requestHttp:@"1069" paramDic:param blockObject:^(NSDictionary *dic) {
                DMLog(@"1069---%@",dic);
                DMLog(@"error---%@",dic[@"errorMsg"]);
                if ([dic[@"errorCode"] intValue]==0) {
                    _totleCountLabel.hidden=NO;
//                    [UIAlertView alertWithTitle:@"温馨提示" message:@"加入购物车成功" buttonTitle:nil];
                    _totleCountLabel.text=[NSString stringWithFormat:@"%@",dic[@"shopcartNum"]];
                }
                else
                {
                    [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
                }
            }];
            
        }
        DMLog(@"加入购物车");

    }
}

-(void)purchaseGoods
{
    if (![NSString isLogin]) {
        [self loginUser];
    }
    else
    {
        //    int totle
        if (_count==0) {
            [UIAlertView alertWithTitle:@"温馨提示" message:@"请选择购买数量" buttonTitle:nil];
        }
        //    else if ((_count*[_price intValue]<[_startPrice intValue])
        else
        {
            DMLog(@"立即购买");
            NSDictionary * newDic=@{@"num":[NSString stringWithFormat:@"%d",_count],@"goodsId":_goodsId,@"goodsName":_goodsName,@"price":_price} ;
            ShoppingModel * model=[[ShoppingModel alloc]init];
            [model setValuesForKeysWithDictionary:newDic];
            [self getGoodsinfoData:model];
            
            if (chooseTotalMoney<20) {
                [UIAlertView alertWithTitle:@"温馨提示" message:@"总价格低于起送价格" buttonTitle:nil];
            }
            else
            {
                SubmitViewController *submitVC=[[SubmitViewController alloc]init];
                submitVC.chooseListDic=_chooseGoodsListDic;
                submitVC.chooseListArr=_chooseListArr;
                submitVC.whichPage=1;
                submitVC.deliveryFee=_deliveryFee;
                //    submitVC.shopInfo=infoModel;
                submitVC.chooseTotalMoney=chooseTotalMoney;
                //self.navigationController.navigationBarHidden=NO;
                [self.navigationController pushViewController:submitVC animated:YES];
            }
            
        }

    }

    
}

-(void)jumpToShopping
{
    if (![NSString isLogin]) {
        [self loginUser];
    }
    else
    {
        ShoppingViewController*shoppingVC=[[ShoppingViewController alloc]init];
        [self.navigationController pushViewController:shoppingVC animated:YES];
    }
    
}

-(void)dailPhone
{
    [UIAlertView alertWithTitle:@"温馨提示" message:@"暂未开通电话功能" buttonTitle:nil];
}
#pragma mark - 自适应字体大小
// 定义成方法方便多个label调用 增加代码的复用性
- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(WIDTH-W(12)-W(40)-W(12), 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}

- (CGSize)sizeWithStrings:(NSString *)string font:(UIFont *)font
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(WIDTH-24, 8000)//限制最大的宽度和高度
                                       options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading  |NSStringDrawingUsesLineFragmentOrigin//采用换行模式
                                    attributes:@{NSFontAttributeName: font}//传人的字体字典
                                       context:nil];
    
    return rect.size;
}


-(void)loadData
{
    NSDictionary *param=@{@"productId":_goodsId};
    NSDictionary *pagination=@{@"page":[NSString stringWithFormat:@"%d",page],@"rows":@"10",@"firstQueryTime":firstQueryTime};
    [RequstEngine pagingRequestHttp:@"1073" paramDic:param pageDic:pagination blockObject:^(NSDictionary *dic) {
        DMLog(@"1073--%@",dic);
        
        [_tableView.footer endRefreshing];
        [_tableView.header endRefreshing];
//        [activityView stopAnimate];
        if ([dic[@"errorCode"] intValue]==0) {
            
//            if (_fresh==1) {
//                [_nearArr removeAllObjects];
//            }
            if ([dic[@"totalCount"] intValue]==0) {
                [_tableView.footer setTitle:@"没有相关数据" forState:MJRefreshFooterStateIdle];
            }
            if ([dic[@"totalCount"] intValue]>0&&[dic[@"totalCount"] intValue]<=10) {
                [_tableView.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            }
            
            NSDictionary *newDic=dic[@"recordList"];
            if (newDic.count>0) {
                page++;
            }
            firstQueryTime=dic[@"firstQueryTime"];
            totalCount=dic[@"totalCount"];
            for (NSDictionary * newDic in dic[@"recordList"]) {
                CommentModel * model=[[CommentModel alloc]init];
                [model setValuesForKeysWithDictionary:newDic];
                [_nearArr addObject:model];
            }
            [_tableView reloadData];
        }
        
        
    }];

}

-(void)getGoodsinfoData:(ShoppingModel *)shoppingModel
{
    [_chooseListArr removeAllObjects];
    NSString *chooseID=shoppingModel.goodsId;
    if ([chooseID isEqualToString:_goodsId]) {
        if ([shoppingModel.num intValue]==0) {
            
            [_chooseGoodsListDic removeObjectForKey:chooseID];
            //        [self shoppingCartBtn:nil];
            // [_chooseListTableView reloadData];
            
        }else{
            
            [_chooseGoodsListDic setObject:shoppingModel forKey:chooseID];
        }
        for (NSString *goodsId in [_chooseGoodsListDic allKeys]) {
            
            [_chooseListArr addObject:goodsId];
            
        }
        
        double sumTotal=0;
        int    changeChooseNum=0;
        for (ShoppingModel *goodsModel in [_chooseGoodsListDic allValues]) {
            
            double goodsPrice=[goodsModel.price doubleValue]*[goodsModel.num intValue];
            changeChooseNum=changeChooseNum+[goodsModel.num intValue];
            sumTotal=goodsPrice+sumTotal;
            
        }
        chooseTotalMoney=sumTotal;

    }
    
    
}

-(CGSize)calculateSizeWithFont:(NSInteger)Fone Text:(NSString *)string
{
    NSDictionary *attr = @{NSFontAttributeName :[UIFont systemFontOfSize:Fone]};
    CGSize retSize = [string boundingRectWithSize:CGSizeMake(WIDTH-W(55), 0)
                                          options:
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                       attributes:attr
                                          context:nil].size;
    return retSize;
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
