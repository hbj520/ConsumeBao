//
//  LinkPageViewController.m
//  mushiwang
//
//  Created by tx on 15/12/8.
//  Copyright © 2015年 liuyu. All rights reserved.
//

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height

#import "LinkPageViewController.h"
#import "UIImageView+WebCache.h"


@interface LinkPageViewController ()<UIScrollViewDelegate>
@property (nonatomic,strong)UIScrollView * linkScrollView;

@property (nonatomic,strong)UIPageControl * pageControl;



@end

@implementation LinkPageViewController
{
    NSMutableArray * _dataArr;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
    [self parseData];
}
- (void)parseData{

    [self createLinkScroll];
    [self createPageCon];
    [self createShortcutBtn];
    
    
}

- (void)createLinkScroll{
    
    _linkScrollView =[[UIScrollView alloc]initWithFrame:[[UIScreen mainScreen]bounds]];
    _linkScrollView.pagingEnabled=YES;
    _linkScrollView.delegate=self;
    _linkScrollView.contentSize=CGSizeMake(kScreenW*3, kScreenH);
    _linkScrollView.showsVerticalScrollIndicator = FALSE;
    _linkScrollView.showsHorizontalScrollIndicator = FALSE;
    
    NSArray *imageArr=@[@"guideOne",@"guideTwo",@"guideThree"];
    
    for (int i= 0; i<imageArr.count;i++) {
        
        UIImageView * imageView =[[UIImageView alloc]initWithFrame:CGRectMake(kScreenW*i,0, kScreenW, [[UIScreen mainScreen]bounds].size.height)];
        imageView.image=[UIImage imageNamed:imageArr[i]];
        
        
        [_linkScrollView addSubview:imageView];
    }
    
    [self.view addSubview:_linkScrollView];
    
}

- (void)createPageCon{
    _pageControl =[[UIPageControl alloc]initWithFrame:CGRectMake(kScreenW/2-50, kScreenH-60, 100, 30)];
    _pageControl.numberOfPages=3;
    _pageControl.currentPageIndicatorTintColor=MAINCOLOR;
    _pageControl.pageIndicatorTintColor=[UIColor whiteColor];
    [self.view addSubview:_pageControl];
    
}
#pragma mark - 跳过按钮
- (void)createShortcutBtn{
    
    UIButton * ShortcutBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    ShortcutBtn.frame =CGRectMake(kScreenW-60,30, 50, 30);
    [ShortcutBtn setTitle:@"跳过~" forState:UIControlStateNormal];
    [ShortcutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    ShortcutBtn.tag=100;
    ShortcutBtn.titleLabel.font=[UIFont systemFontOfSize:14];
    [ShortcutBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:ShortcutBtn];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int num = scrollView.contentOffset.x/kScreenW;
    _pageControl.currentPage=num;
    if (scrollView.contentOffset.x>kScreenW*2+20) {
         [[NSUserDefaults standardUserDefaults] setObject:@"two"forKey:@"one"];
        self.Block();
       
    }
    
}
- (void)onClick:(UIButton *)btn{
    [[NSUserDefaults standardUserDefaults] setObject:@"two"forKey:@"one"];
    self.Block();
    
}
- (NSMutableArray *)dataArr{
    if (_dataArr==nil) {
        _dataArr=[[NSMutableArray alloc]init];
    }
    return _dataArr;
    
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
