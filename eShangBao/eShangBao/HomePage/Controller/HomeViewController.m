//
//  HomeViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/13.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "HomeViewController.h"
#import "AllianceViewController.h"
#import "PartnerViewController.h"
#import "RecommendCollectionViewCell.h"
#import "ChooseusTableViewCell.h"
#import "ScanerVC.h"
@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSArray*imgArr;//按钮图片数组
    UIScrollView *  _mainScrollView;
    UIScrollView * _bigScorllView;
    UICollectionView * _recommendCollectionView;
    UITableView * _tableView;
    
    NSMutableArray * _chooseusImgArr;//图片数组
    int height;
    int chooseusHeight;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"易商宝";
    chooseusHeight=2;
    _chooseusImgArr=[NSMutableArray arrayWithCapacity:0];
    _bigScorllView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, HEIGHT)];
    _bigScorllView.contentSize=CGSizeMake(0, HEIGHT*2-H(200));
//    _bigScorllView.backgroundColor=[UIColor cyanColor];
    _mainScrollView.showsHorizontalScrollIndicator=NO;
    _bigScorllView.showsVerticalScrollIndicator=NO;
    _bigScorllView.bounces=NO;
//    _mainScrollView.pagingEnabled=YES;
    //    _mainScrollView.scrollEnabled=NO;
    _mainScrollView.delegate=self;
    //    _mainScrollView.backgroundColor=[UIColor redColor];
    //     _mainScrollView.backgroundColor=[UIColor colorWithRed:39/255.0 green:39/255.0 blue:39/255.0 alpha:1];
    [self.view addSubview:_bigScorllView];
    
    // 加载轮播
    [self loadCarousel];
    // 加载按钮
    [self loadButton];
    // 加载热点
    [self hotspot];
    // 加载推荐商家
    [self recommend];
    // 加载UITableView
    [self loadTableView];
    
    [self UINavgationBarBtn];
    // Do any additional setup after loading the view from its nib.
}

// 加载轮播
-(void)loadCarousel
{
    FLAdView *adView = [[FLAdView alloc]initWithFrame:CGRectMake(0, -64, WIDTH, H(120))];
    adView.location = PageControlCenter;//设置pagecontrol的位置
    adView.currentPageColor = [UIColor redColor];//选中pagecontrol的颜色
    adView.normalColor = [UIColor whiteColor];//未选中的pagecontol的颜色
    adView.chageTime = 3.0f;//定时时间 默认3秒
    adView.flDelegate = self;//图片点击事件delegate
    [_bigScorllView addSubview:adView];

}
-(void)loadButton
{
    imgArr=@[@"1@2x.png",@"2@2x.png",@"3@2x.png",@"4@2x.png"];
    for (int i=0; i<4; i++) {
        UIButton * button=[UIButton buttonWithType:0];
        button.frame=CGRectMake(i*W(80), H(130)+H(10)-64, W(80), H(70));
//        button.backgroundColor=[UIColor cyanColor];
        button.tag=i+10;
        [button addTarget:self action:@selector(jumpToOther:) forControlEvents:1<<6];
        [button setImage:[UIImage imageNamed:imgArr[i]] forState:0];
        [_bigScorllView addSubview:button];
    }
    
    UILabel*lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(130)+H(10)*2-64+H(70), WIDTH, H(1))];
    lineLabel.backgroundColor=BGMAINCOLOR;
    [_bigScorllView addSubview:lineLabel];
    
    UIImageView * bannerImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, kDown(lineLabel)+H(5), WIDTH, H(80))];
    bannerImg.image=[UIImage imageNamed:@"banner02"];
    [_bigScorllView addSubview:bannerImg];
    
    UILabel * lineLabel1=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(bannerImg)+H(5), WIDTH, H(1))];
    lineLabel1.backgroundColor=BGMAINCOLOR;
    [_bigScorllView addSubview:lineLabel1];
}

-(void)hotspot
{
    UILabel*hotspotLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), H(130)+H(10)*2+H(80)+H(5)*2-64+H(75), W(40), H(20))];
    hotspotLabel.backgroundColor=GRAYCOLOR;
    hotspotLabel.text=@"热点";
    hotspotLabel.font=[UIFont systemFontOfSize:16*KRatioH];
    hotspotLabel.textAlignment=NSTextAlignmentCenter;
    hotspotLabel.textColor=[UIColor whiteColor];
    [_bigScorllView addSubview:hotspotLabel];
    
    UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(hotspotLabel)+H(5), WIDTH, H(1))];
    lineLabel.backgroundColor=BGMAINCOLOR;
    [_bigScorllView addSubview:lineLabel];
    
    UILabel*detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(kRight(hotspotLabel)+W(5), H(130)+H(10)*2+H(80)+H(5)*2-64+H(75), WIDTH-W(50), H(20))];
    detailLabel.text=@"热烈欢迎老乡鸡入驻本平台，安徽快餐领先品牌";
    detailLabel.textColor=MAINCHARACTERCOLOR;
    detailLabel.font=[UIFont systemFontOfSize:12*KRatioH];
    [_bigScorllView addSubview:detailLabel];
    
    _lineLab=[[UILabel alloc]initWithFrame:CGRectMake(0, kDown(lineLabel)+H(10), WIDTH, H(1))];
    _lineLab.backgroundColor=BGMAINCOLOR;
    [_bigScorllView addSubview:_lineLab];
    
   
}

-(void)recommend
{
    height=2;
    _recImg=[[UIImageView alloc]initWithFrame:CGRectMake( 0, kDown(_lineLab), WIDTH, H(40))];
    _recImg.image=[UIImage imageNamed:@"tjsj"];
    [_bigScorllView addSubview:_recImg];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _recommendCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kDown(_recImg), WIDTH, H(100)*height+(W(5)*height)+H(5)) collectionViewLayout:flowLayout];
    // 注册一个复用的xib文件
    [_recommendCollectionView registerClass:[RecommendCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    _recommendCollectionView.delegate = self;
    _recommendCollectionView.dataSource = self;
    _recommendCollectionView.scrollEnabled=NO;
//    _recommendCollectionView.backgroundColor = [UIColor colorWithRed:39/255.0 green:39/255.0 blue:39/255.0 alpha:1];
    //collectionView.backgroundColor=[UIColor redColor];
    _recommendCollectionView.backgroundColor=[UIColor whiteColor];
    _recommendCollectionView.pagingEnabled=YES;
    _recommendCollectionView.allowsMultipleSelection = YES;//默认为NO,是否可以多选
    [_bigScorllView addSubview:_recommendCollectionView];
    
    _downBtn=[UIButton buttonWithType:0];
    _downBtn.frame=CGRectMake(WIDTH/2-W(100)-W(10), kDown(_recommendCollectionView)+H(5), H(220), H(30));
    [_downBtn setImage:[UIImage imageNamed:@"more"] forState:0];
//    _downBtn.backgroundColor=[UIColor cyanColor];
    [_downBtn addTarget:self action:@selector(addMore) forControlEvents:1<<6];
    [_bigScorllView addSubview:_downBtn];

}


-(void)loadTableView
{
    [_chooseusImgArr addObject:@"zsh01"];
    [_chooseusImgArr addObject:@"zsh02"];
    _chooseusImg=[[UIImageView alloc]initWithFrame:CGRectMake(0, kDown(_downBtn), WIDTH, H(40))];
    _chooseusImg.image=[UIImage imageNamed:@"xzwm"];
    [_bigScorllView addSubview:_chooseusImg];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, kDown(_chooseusImg), WIDTH, H(100)*chooseusHeight) style:0];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.scrollEnabled=NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [_bigScorllView addSubview:_tableView];
    
    _chooseusDownBtn=[UIButton buttonWithType:0];
    _chooseusDownBtn.frame=CGRectMake(WIDTH/2-W(100)-W(10), kDown(_tableView)+H(5), H(220), H(30));
    [_chooseusDownBtn setImage:[UIImage imageNamed:@"more"] forState:0];
    //    _downBtn.backgroundColor=[UIColor cyanColor];
    [_chooseusDownBtn addTarget:self action:@selector(chooseusAddMore) forControlEvents:1<<6];
    [_bigScorllView addSubview:_chooseusDownBtn];
}

-(void)UINavgationBarBtn
{
    _scanBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _scanBtn.frame=CGRectMake( W(40), H(3), W(20), H(20));
    _scanBtn.enabled=NO;
//    _scanBtn.backgroundColor=[UIColor cyanColor];
//    [_scanBtn setTitle:@"账单" forState:UIControlStateNormal];
//    [_scanBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    [_scanBtn addTarget:self action:@selector(scanAction) forControlEvents:1<<6];
    [_scanBtn setImage:[UIImage imageNamed:@"商城主页1_05"] forState:0];
    UIBarButtonItem*rightItem1=[[UIBarButtonItem alloc]initWithCustomView:_scanBtn];
    self.navigationItem.rightBarButtonItem=rightItem1;
    
    _erweimaBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _erweimaBtn.frame=CGRectMake( W(40), H(3), W(20), H(20));
    _erweimaBtn.enabled=NO;
    //    _scanBtn.backgroundColor=[UIColor cyanColor];
    //    [_scanBtn setTitle:@"账单" forState:UIControlStateNormal];
    //    [_scanBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1] forState:UIControlStateNormal];
    [_erweimaBtn setImage:[UIImage imageNamed:@"商城主页1_03"] forState:0];
    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:_erweimaBtn];
    self.navigationItem.leftBarButtonItem=leftItem;

}

#pragma mark - UICollectionViewDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return height*2;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    cell.backgroundColor=RGBACOLOR(247, 137, 0, 1);
    return cell;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(W(150), H(100));
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(H(5), W(5), H(5), W(5));
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return W(5);
}


#pragma mark - UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return chooseusHeight;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChooseusTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell=[[ChooseusTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"cell"];
    }
    cell.textLabel.text=@"ygq";
//    cell.dataImg.image=[UIImage imageNamed:_chooseusImgArr[indexPath.row]];
    cell.selectionStyle=0;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return H(110);
}
#pragma mark - 滚动图的点击方法
-(void)imageTaped:(UIImageView *)imageView{
    NSLog(@"imageView tag is %ld",imageView.tag);
}

#pragma mark - 按钮跳转的方法
-(void)jumpToOther:(UIButton*)sender
{
    switch (sender.tag) {
        case 10:
        {
            AllianceViewController*allianceVC=[[AllianceViewController alloc]init];
            allianceVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:allianceVC animated:YES];
        }
            break;
        case 11:
        {
                    }
            break;
        case 12:
        {
            PartnerViewController*partnerVC=[[PartnerViewController alloc]init];
            partnerVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:partnerVC animated:YES];

        }
            break;
        case 13:
            break;
        default:
            break;
    }
    DMLog(@"sender.tag=%ld",sender.tag);
}

#pragma mark - 增加按钮
-(void)addMore
{
    height+=2;
    _recommendCollectionView.frame=CGRectMake(0, kDown(_recImg), WIDTH, H(100)*height+(W(5)*height)+H(5));
    [_recommendCollectionView reloadData];
    _downBtn.frame=CGRectMake(WIDTH/2-W(100), kDown(_recommendCollectionView)+H(5), H(200), H(30));
    _bigScorllView.contentSize=CGSizeMake(0, HEIGHT*2-H(200)+H(100)*height+H(5)*height-H(210));
    _chooseusImg.frame=CGRectMake(0, kDown(_downBtn), WIDTH, H(40));
    _tableView.frame=CGRectMake(0, kDown(_chooseusImg), WIDTH, H(100)*chooseusHeight);
    _chooseusDownBtn.frame=CGRectMake(WIDTH/2-W(100)-W(10), kDown(_tableView)+H(5), H(220), H(30));
}

-(void)chooseusAddMore
{
    DMLog(@"++");
    chooseusHeight+=1;
    _bigScorllView.contentSize=CGSizeMake(0, HEIGHT*2-H(200)+H(100)*chooseusHeight+H(5)*chooseusHeight-H(210));
    _tableView.frame=CGRectMake(0, kDown(_chooseusImg), WIDTH, H(100)*chooseusHeight+H(10));
    _chooseusDownBtn.frame=CGRectMake(WIDTH/2-W(100)-W(10), kDown(_tableView)+H(5), H(220), H(30));
    [_tableView reloadData];
}

-(void)scanAction
{
    ScanerVC *scanVC=[[ScanerVC alloc]init];
    scanVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:scanVC animated:YES];
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
