//
//  ManageGoodsViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/21.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "ManageGoodsViewController.h"
#import "ManageGoodsTableViewCell.h"
#import "goodsInfoViewController.h"
#import "AddGoodsViewController.h"
#import "SearchViewController.h"
#import "CollectModel.h"
#import "SellerDataModel.h"

@interface ManageGoodsViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,manageGoodsDelegate>
{
    NSString       *categoryNameStr;//新建分类的名字
    NSString       *sortNumStr;//排序的位置
    
    NSString       *categoryId;
    int            editorType;//1 添加分类 2 编辑分类
    NSIndexPath    *myIndexPath;
    
    
    //列表请求参数
    NSString        *isDeleted;//是否下架
    NSString        *sortType;//排序方式
    
    NSString              *totalCount;
    SellerGoodsListModel  *chooseModel;
    
    float           difference;
    
    TBActivityView *activityView;
     int            _fresh;//0 上拉；1 下拉
    
//    NSString       *firstQueryTime;
//    NSString       *totalCount;
    int            page;
}

@property(nonatomic,strong)NSMutableArray    *categoryListData;

@property(nonatomic,strong)UIButton *selectedbtn;
@property (weak, nonatomic) IBOutlet UITableView *myTableVie;

@property(nonatomic,strong)NSMutableArray   *goodsListArr;
@property (weak, nonatomic) IBOutlet UIView *titleBgView;

@end

@implementation ManageGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    //self.fd_prefersNavigationBarHidden=YES;
    _titleBgView.backgroundColor=RGBACOLOR(251, 98, 7, 1);
    
    activityView=[[TBActivityView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2.-20, KScreenWidth, 25)];
    activityView.rectBackgroundColor=MAINCOLOR;
    activityView.showVC=self;
    [self.view addSubview:activityView];
    
    [activityView startAnimate];
    self.view.backgroundColor=BGMAINCOLOR;
    _selectedbtn=(UIButton *)[self.view viewWithTag:1];
    _myTableVie.backgroundColor=[UIColor clearColor];
    _categoryTableView.backgroundColor=[UIColor clearColor];
    _categoryListData=[NSMutableArray arrayWithCapacity:0];
    editorType=1;
    isDeleted=@"0";
    sortType =@"0";
    _goodsListArr=[NSMutableArray arrayWithCapacity:0];
    
    [self registerForKeyboardNotifications];
    [self addLegendRefreshing];
    [self createEditorView];
    [self getCategoryList];
    
    
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [_goodsListArr removeAllObjects];
    [self requsetGoodsList];
}
- (IBAction)backButton:(id)sender {
    
    //self.navigationController.navigationBarHidden=NO;
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)addLegendRefreshing
{
    
    [_myTableVie addLegendHeaderWithRefreshingBlock:^{
        _fresh=1;
        page=1;
        
//        [_goodsListArr removeAllObjects];
        [self requsetGoodsList];
        
    }];
    
    [_myTableVie addLegendFooterWithRefreshingBlock:^{
        _fresh=0;
        if ([totalCount intValue]==0) {
            
            [_myTableVie.footer setTitle:@"没有相关数据" forState:MJRefreshFooterStateIdle];
            [_myTableVie.footer endRefreshing];
            
            return ;
        }
        if ([totalCount intValue]>0&&[totalCount intValue]<=10) {
            [_myTableVie.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            [_myTableVie.footer endRefreshing];
            return ;
        }
        if ([totalCount intValue]==_goodsListArr.count&&[totalCount intValue]>10) {
            [_myTableVie.footer endRefreshing];
            [_myTableVie.footer setTitle:@"没有更多了..." forState:MJRefreshFooterStateIdle];
            return ;
        }
        [self requsetGoodsList];
    }];
    [_myTableVie.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
    
}


- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
}
- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    float inputViewMaxY=CGRectGetMaxY(_inputView.frame);
    float keyboardMinY=KScreenHeight-keyboardSize.height;
    difference = inputViewMaxY-keyboardMinY;
    if (difference>0) {
        
            _inputView.center=CGPointMake(_inputView.center.x, _inputView.center.y-difference);
    }

    
    NSLog(@"keyBoard:%f", keyboardSize.height);  //216
    ///keyboardWasShown = YES;
}
- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;

    if (difference>0) {
        
        _inputView.center=CGPointMake(_inputView.center.x, _inputView.center.y+difference);
    }

    
    NSLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    // keyboardWasShown = NO;
    
}





-(void)createEditorView
{
    _editorView.backgroundColor=[UIColor clearColor];
    _inputView.layer.cornerRadius=5;
    _inputView.layer.masksToBounds=YES;
    
    _editorBgView.userInteractionEnabled=YES;
    UITapGestureRecognizer *tapGes=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenEditorView)];
    [_editorBgView addGestureRecognizer:tapGes];

}
-(void)hiddenEditorView
{
    _editorView.hidden=!_editorView.hidden;
    [self.view endEditing:YES];
}

#pragma mark- 请求方法
//类的列表
-(void)getCategoryList
{
    
    NSDictionary *param=@{@"shopId":USERID};
    [RequstEngine requestHttp:@"1009" paramDic:param blockObject:^(NSDictionary *dic) {
        
        
        DMLog(@"1009---%@",dic);
        if ([dic[@"errorCode"] intValue]==0) {
            
            for (NSDictionary *newDic in dic[@"categoryList"]) {
                categoryListModel *categoryModel=[[categoryListModel alloc]init];
                [categoryModel setValuesForKeysWithDictionary:newDic];
                [_categoryListData addObject:categoryModel];
            }
            
            [_categoryTableView reloadData];
            
        }
    }];
    
    
}

//编辑添加
-(void)editorCategoryRequste
{
    
    NSString *newSortNumStr=(sortNumStr.length==0)?@"0":sortNumStr;
    NSDictionary *param=@{@"name":categoryNameStr,@"sortNum":newSortNumStr};
   
    [RequstEngine requestHttp:@"1064" paramDic:param blockObject:^(NSDictionary *dic) {
        
        DMLog(@"1064----%@",dic);
        if ([dic[@"errorCode"] intValue]==0) {
//            [UIAlertView alertWithTitle:@"温馨提示" message:@"分类添加成功" buttonTitle:nil];
            [UIAlertView alertWithTitle:@"温馨提示" message:@"分类添加成功" UIViewController:self UITextField:nil];
            [_categoryListData removeAllObjects];
            [self getCategoryList];
        }else{
            
            
            [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
        }
    }];
}
//编辑
-(void)editorRequset
{
    
    NSString *newSortNumStr=(sortNumStr.length==0)?@"0":sortNumStr;
    DMLog(@"*****%@",newSortNumStr);
    NSDictionary *param=@{@"name":categoryNameStr,@"sortNum":newSortNumStr,@"cateId":categoryId};
    
    [RequstEngine requestHttp:@"1065" paramDic:param blockObject:^(NSDictionary *dic) {
        
        DMLog(@"1065---%@",dic);
        DMLog(@"error----%@",dic[@"errorMsg"]);
        if ([dic[@"errorCode"] intValue]==0) {
            [UIAlertView alertWithTitle:@"温馨提示" message:@"分类编辑成功" buttonTitle:nil];
            [_categoryListData removeAllObjects];
            [self getCategoryList];
        }else{
            
            
            [UIAlertView alertWithTitle:@"温馨提示" message:@"分类编辑失败" buttonTitle:nil];
        }

        
        
    }];
}
//删除
-(void)deleteCategory:(NSIndexPath *)index
{
    
    NSDictionary *param=@{@"cateId":categoryId};
    [RequstEngine requestHttp:@"1066" paramDic:param blockObject:^(NSDictionary *dic) {
        
        DMLog(@"%@",dic);
        if ([dic[@"errorCode"] intValue]==0) {
            
            [_categoryListData removeObjectAtIndex:index.row];
            [UIAlertView alertWithTitle:@"温馨提示" message:@"删除成功" buttonTitle:nil];
            [_categoryTableView reloadData];
        }
        
        
    }];
}
//获取商品的列表
-(void)requsetGoodsList
{
    NSString *pageStr;
    NSString *firstQueryTime;
    if (_fresh==1) {
        
        pageStr=@"1";
        firstQueryTime=@"";
        
    }else{
        
        SellerGoodsListModel *goodsModel=[_goodsListArr lastObject];
        pageStr=(goodsModel.pageStr.length==0)?@"1":goodsModel.pageStr;
        firstQueryTime=(goodsModel.firstQueryTime.length==0)?@"":goodsModel.firstQueryTime;
    }

    NSDictionary *param=@{@"shopId":USERID,@"categoryId":@"",@"name":@"",@"sortType":sortType,@"isDeleted":isDeleted};
    NSDictionary *pagination=@{@"page":pageStr,@"rows":@"10",@"firstQueryTime":firstQueryTime};
    [RequstEngine pagingRequestHttp:@"1010" paramDic:param pageDic:pagination blockObject:^(NSDictionary *dic) {

        DMLog(@"1010---%@",dic);
        [_myTableVie.footer endRefreshing];
        [_myTableVie.header endRefreshing];
        [activityView stopAnimate];
        if ([dic[@"errorCode"] intValue]==0) {
            
            if (_fresh==1) {
                
                [_goodsListArr removeAllObjects];
            }
            if ([dic[@"totalCount"] intValue]==0) {
                [_myTableVie.footer setTitle:@"没有相关数据" forState:MJRefreshFooterStateIdle];
            }
            if ([dic[@"totalCount"] intValue]>0&&[dic[@"totalCount"] intValue]<=10) {
                [_myTableVie.footer setTitle:@"" forState:MJRefreshFooterStateIdle];
            }
            
            NSDictionary *newDic=dic[@"proList"];
            int    newpage=[pageStr intValue];
            if (newDic.count>0) {
                
                newpage++;
            }
            totalCount=dic[@"totalCount"];
            NSString *firstQueryTime=dic[@"firstQueryTime"];
            for (NSDictionary *newDic in dic[@"proList"]) {
                SellerGoodsListModel *goodsModel=[[SellerGoodsListModel alloc]init];
                [goodsModel setValuesForKeysWithDictionary:newDic];
                goodsModel.pageStr=[NSString stringWithFormat:@"%d",newpage];
                goodsModel.firstQueryTime=firstQueryTime;
                [_goodsListArr addObject:goodsModel];
            }
            [_myTableVie reloadData];
            
        }
    }];
    
}

//下架 上架
-(void)shelvesGoods
{
    NSString *isType;
    if ([isDeleted intValue]==0) {
        isType=@"1";
    }else{
        
        isType=@"0";
    }
    NSDictionary *param=@{@"goodsId":chooseModel.goodsId,@"isDeleted":isType,@"returnBate":@"0"};
    ;
    [RequstEngine requestHttp:@"1037" paramDic:param blockObject:^(NSDictionary *dic) {
        
        DMLog(@"%@",dic[@"errorMsg"]);
        if ([dic[@"errorCode"] intValue]==0) {
            
            [_goodsListArr removeAllObjects];
            [self requsetGoodsList];
        }
        
    }];
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag==11) {
        if (buttonIndex==1) {
            
            [self deleteCategory:myIndexPath];
        }
    }
    else
    {
        switch (buttonIndex) {
            case 0:
                
                break;
                
            case 1:
                
            {
                [self shelvesGoods];
            }
                break;
            default:
                break;
        }
    }
    
}


- (IBAction)searchButtonClick:(id)sender {
    
    DMLog(@"搜索按钮");
    SearchViewController *searchVC=[[SearchViewController alloc]init];
    //self.navigationController.navigationBarHidden=YES;
    self.fd_prefersNavigationBarHidden=YES;
    searchVC.type=2;
    [self.navigationController pushViewController:searchVC animated:YES];
}


#pragma mark tableVeiwDelegate&DataSouce

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag==1) {
        return _goodsListArr.count;
    }
    return _categoryListData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag==1) {
        return 140;
    }
    return 50;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView.tag==1) {
        
        
        SellerGoodsListModel *model;
        if (_goodsListArr.count>0) {
            model =_goodsListArr[indexPath.row];
        }
       
        ManageGoodsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"manageGoods"];
        if (!cell) {
            
            cell=[[[NSBundle mainBundle] loadNibNamed:@"ManageGoodsTableViewCell" owner:nil options:nil] objectAtIndex:0];
            //[cell.nextBtn addTarget:self action:@selector(nextBtnClick) forControlEvents:1<<6];
        }
        cell.isDelete=isDeleted;
        cell.goodsModel=model;
        cell.delegate=self;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    //管理分类
    ManageGoodsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"categoryCell"];
    categoryListModel *model=_categoryListData[indexPath.row];
    cell=[[[NSBundle mainBundle] loadNibNamed:@"ManageGoodsTableViewCell" owner:nil options:nil] objectAtIndex:1];
    cell.categroyModel=model;
    cell.editorBtn.tag=indexPath.row;
    cell.deleteBtn.tag=indexPath.row;
    [cell.editorBtn addTarget:self action:@selector(editorBtnClick:) forControlEvents:1<<6];
    [cell.deleteBtn addTarget:self action:@selector(deleteBtnCLick:)
    forControlEvents:1<<6];
    if (editorType==2) {
        cell.editorBtn.hidden=NO;
        cell.deleteBtn.hidden=NO;
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}

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
           // self.navigationController.navigationBarHidden=NO;
            [self.navigationController pushViewController:businessVC animated:YES];
    
        }
            break;
        case 3:
        {
            DMLog(@"xiajia");
            if ([isDeleted intValue]==0) {
                UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"是否确认下架该商品" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
                alert.tag=10;
                [alert show];
            }
            else
            {
                [self shelvesGoods];
            }
//            [UIAlertView alertWithTitle:@"" message:<#(NSString *)#> buttonTitle:<#(NSString *)#>]
            
        }
            break;
            
        default:
            break;
    }
}

-(void)manageModelDelegate:(SellerGoodsListModel *)goodsModel
{
    DMLog(@"%@",goodsModel);
    chooseModel=goodsModel;
}

-(void)editorBtnClick:(UIButton *)sender
{
    
    
    categoryListModel *model=_categoryListData[sender.tag];
    DMLog(@"---%@",model.sortNum);
    _categoryName.text=model.cateName;
    if ([model.sortNum isEqualToString:@"null"]) {
        _sortNum.text=@"";
    }
    else
    {
        _sortNum.text=model.sortNum;
    }
    
    categoryId=model.cateId;
    [self hiddenEditorView];
    
    
    DMLog(@"编辑");
}
-(void)deleteBtnCLick:(UIButton *)sender
{
    
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"你确定要删除此分类吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    categoryListModel *model=_categoryListData[sender.tag];
    myIndexPath=[NSIndexPath indexPathForRow:sender.tag inSection:0];
    categoryId=model.cateId;

    alertView.tag=11;
    [alertView show];
    
       DMLog(@"删除");
}
- (IBAction)chooseCategoryButton:(id)sender {
    
    UISegmentedControl *new=(UISegmentedControl *)sender;
    DMLog(@"%ld",(long)new.selectedSegmentIndex);
    
}

#pragma mark - 选择分类和排序的方法
- (IBAction)choooseCategroyBtn:(id)sender {
    UISegmentedControl *new=(UISegmentedControl *)sender;
//    DMLog(@"%ld",new.selectedSegmentIndex);
    _categoryView.hidden=YES;
    switch (new.selectedSegmentIndex) {
        case 0:
        {
            DMLog(@"出售中");
            isDeleted=@"0";
            [_goodsListArr removeAllObjects];
            [self requsetGoodsList];
        }
            break;
        case 1:
        {
            DMLog(@"已下架");
            isDeleted=@"1";
            [_goodsListArr removeAllObjects];
            [self requsetGoodsList];

        }
            break;

        case 2:
        {
            
            _categoryView.hidden=NO;
            DMLog(@"分类");
        }
            break;
        default:
            break;
    }
}


- (IBAction)chooseCategory:(id)sender {
    
    UIButton *newBtn=(UIButton *)sender;
    
    if (newBtn!=_selectedbtn) {
        
        [newBtn setTitleColor:MAINCOLOR forState:0];
        [_selectedbtn setTitleColor:MAINCHARACTERCOLOR forState:0];
        _selectedbtn=newBtn;
    }
    [UIView animateWithDuration:0.3 animations:^{
        
        _chooseLabel.center=CGPointMake(newBtn.center.x, _chooseLabel.center.y);
        
    }];

    [_goodsListArr removeAllObjects];
    switch (newBtn.tag) {
        case 1:
        {
            DMLog(@"时间");
            sortType=@"0";
        }
            break;
        case 2:
        {
            DMLog(@"销量");
            sortType=@"1";
        }
            break;
        case 3:
        {
            DMLog(@"库存");
            sortType=@"2";
        }
            break;
            
        default:
            break;
    }
    [self requsetGoodsList];
}

#pragma mark 添加新的商品
- (IBAction)addNewGoodsButton:(id)sender {
    
    AddGoodsViewController *businessVC=[[AddGoodsViewController alloc]init];
    //self.navigationController.navigationBarHidden=NO;
    [self.navigationController pushViewController:businessVC animated:YES];
    DMLog(@"添加新的");
}


#pragma mark 进入下一页
-(void)nextBtnClick
{
    goodsInfoViewController *goodsInfoVC=[[goodsInfoViewController alloc]init];
    //self.navigationController.navigationBarHidden=NO;
    goodsInfoVC.goodsID=chooseModel.goodsId;
    [self.navigationController pushViewController:goodsInfoVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)cancelBtn:(id)sender {
    
    UIButton *newBtn=(UIButton *)sender;
    switch (newBtn.tag) {
        case 1:
        {
            DMLog(@"取消");
            [self hiddenEditorView];
        }
            break;
        case 2:
        {
            DMLog(@"确定");
            [self hiddenEditorView];
            categoryNameStr=_categoryName.text;
            sortNumStr=_sortNum.text;
            if (editorType==1) {
                
                [self editorCategoryRequste];
            }else{
                
                [self editorRequset];
            }
        }
            break;
        default:
            break;
    }
    
    
    
}

- (IBAction)categoryEditorBtn:(id)sender {
    
    
    UIButton *newBtn=(UIButton *)sender;

    switch (newBtn.tag) {
        case 1:
        {
            DMLog(@"新建");
            _categoryName.text=@"";
            _sortNum.text=@"";
            editorType=1;
            [self hiddenEditorView];
        }
            break;
        case 2:
        {
            DMLog(@"编辑");
            editorType=2;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenCatetgoryBtn" object:nil];
            [self categoryBtnEditor];
        }
            break;
        default:
            break;
    }
    
    
    
}
- (IBAction)commpleteBtnClick:(id)sender {
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hiddenCatetgoryBtn" object:nil];
    [self categoryBtnEditor];
}
-(void)categoryBtnEditor
{
    _completeBtn.hidden=!_completeBtn.hidden;
    _addCategoryBtn.hidden=!_addCategoryBtn.hidden;
    _editorCategoryBtn.hidden=!_editorCategoryBtn.hidden;
}

@end
