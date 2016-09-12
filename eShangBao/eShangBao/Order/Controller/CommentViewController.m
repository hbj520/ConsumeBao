//
//  CommentViewController.m
//  eShangBao
//
//  Created by doumee on 16/1/27.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "CommentViewController.h"
#import "StarView.h"
@interface CommentViewController ()<UITextViewDelegate>
{
    UILabel * _detailLabel;
    UITextView * _commentTV;
    UIView * _mainView;
    UILabel * _countLabel;
    NSString * _commentStr;
    NSString * _massStr;
    NSString * _sendStr;
}

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self backButton];
    self.title=@"评价订单";
    self.view.backgroundColor=BGMAINCOLOR;
    [self backButton];
    
    
    // 加载UI
    [self loadUI];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - loadUI
-(void)loadUI
{
    _mainView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    _mainView.backgroundColor=BGMAINCOLOR;
    [self.view addSubview:_mainView];
    
    UIView * coverView=[[UIView alloc]initWithFrame:CGRectMake(0, 64, WIDTH, H(150))];
    coverView.backgroundColor=[UIColor whiteColor];
    [_mainView addSubview:coverView];
    
    for (int i=0; i<2; i++) {
        UILabel * lineLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, H(49)+i*H(50), WIDTH, H(1))];
        lineLabel.backgroundColor=BGMAINCOLOR;
        [coverView addSubview:lineLabel];
    }

    
    UILabel * commentLabel = [[UILabel alloc]initWithFrame:CGRectMake(W(12), H(15), W(65), H(20))];
    commentLabel.text=@"总体评价";
    commentLabel.font=[UIFont systemFontOfSize:16];
    commentLabel.textColor=RGBACOLOR(63, 62, 63, 1);
    [coverView addSubview:commentLabel];
    
    StarView * commentStar=[[StarView alloc]initWithFrame:CGRectMake(kRight(commentLabel)+W(10), H(14), W(180), H(40)) EmptyImage:@"灰星" StarImage:@"黄星"];
    [commentStar setBlock:^(NSDictionary *dict) {
        _commentStr=dict[@"tag"];
    }];
    [coverView addSubview:commentStar];
    
    
    
    UILabel * massLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(commentLabel)+H(15)*2, W(65), H(20))];
    massLabel.textColor=RGBACOLOR(63, 62, 62, 1);
    massLabel.text=@"质量服务";
    massLabel.font=[UIFont systemFontOfSize:16];
    [coverView addSubview:massLabel];
    
    StarView * massView=[[StarView alloc]initWithFrame:CGRectMake(kRight(massLabel)+W(10), kDown(commentLabel)+H(15)+H(14), W(180), H(40)) EmptyImage:@"灰星" StarImage:@"黄星"];
    [massView setBlock:^(NSDictionary *dic) {
        _massStr=dic[@"tag"];
    }];
    [coverView addSubview:massView];

    UILabel * sendLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(massLabel)+H(15)*2, W(65), H(20))];
    sendLabel.textColor=RGBACOLOR(63, 62, 62, 1);
    sendLabel.text=@"配送服务";
    sendLabel.font=[UIFont systemFontOfSize:16];
    [coverView addSubview:sendLabel];
    
    StarView * sendView=[[StarView alloc]initWithFrame:CGRectMake(kRight(sendLabel)+W(10), kDown(massLabel)+H(15)+H(14), W(180), H(40)) EmptyImage:@"灰星" StarImage:@"黄星"];
    [sendView setBlock:^(NSDictionary *dict) {
        _sendStr=dict[@"tag"];
    }];
    [coverView addSubview:sendView];
    
    UILabel * titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(coverView)+H(10), W(40), H(20))];
    titleLabel.text=@"评价";
    titleLabel.font=[UIFont systemFontOfSize:16];
    [_mainView addSubview:titleLabel];
    
    _commentTV=[[UITextView alloc]initWithFrame:CGRectMake(0, kDown(titleLabel)+H(10), WIDTH, H(200))];
    _commentTV.delegate=self;
    _commentTV.textColor=RGBACOLOR(112, 111, 110, 1);
    _commentTV.font=[UIFont systemFontOfSize:14];
    [_mainView addSubview:_commentTV];
    
    _detailLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(12), kDown(titleLabel)+H(9)*2, WIDTH, H(20))];
    _detailLabel.text=@"写下您的评价吧（对其他的小伙伴们帮助很大哦）";
    _detailLabel.textColor=RGBACOLOR(112, 111, 110, 1);
    _detailLabel.font=[UIFont systemFontOfSize:14];
    [_mainView addSubview:_detailLabel];
    
    _countLabel=[[UILabel alloc]initWithFrame:CGRectMake(W(200), kDown(_commentTV)-H(30), W(120), H(20))];
    _countLabel.text=@"还可以输入200字";
    _countLabel.textColor=RGBACOLOR(112, 111, 110, 1);
    _countLabel.font=[UIFont systemFontOfSize:14];
    [_mainView addSubview:_countLabel];
    
    UIButton * saveBtn=[UIButton buttonWithType:0];
    saveBtn.layer.cornerRadius=2;
    saveBtn.layer.masksToBounds=YES;
    saveBtn.frame=CGRectMake(W(20), kDown(_commentTV)+H(20), WIDTH-W(20)*2, 40);
    saveBtn.backgroundColor=RGBACOLOR(255, 97, 0, 1);
    [saveBtn addTarget:self action:@selector(jump) forControlEvents:1<<6];
    [saveBtn setTitle:@"提交" forState:0];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:0];
    [_mainView addSubview:saveBtn];

}

#pragma mark - UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.26 animations:^{
        _mainView.frame=CGRectMake(0, -140, WIDTH, HEIGHT);
    }];
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length==0) {
        _detailLabel.text=@"写下您的评价吧（对其他的小伙伴们帮助很大哦）";
        _countLabel.text=@"还可以输入200字";
    }else
    {
        _detailLabel.text=@"";
        _countLabel.text=[NSString stringWithFormat:@"还可以输入%u字",200-textView.text.length];
        if (200<textView.text.length) {
            textView.text=[textView.text substringToIndex:200];
            _countLabel.text=[NSString stringWithFormat:@"还可以输入%u字",200-textView.text.length];
            SHOWALERTVIEW(@"请输入200字以内的评价")
        }
    }
    
//    DMLog(@"length=%ld",textView.text.length);
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    [UIView animateWithDuration:0.26 animations:^{
        _mainView.frame=CGRectMake(0, 0, WIDTH, HEIGHT);
    }];

}

#pragma mark - 按钮绑定的方法
-(void)jump
{
    DMLog(@"***%@***%@***%@",_commentStr,_massStr,_sendStr);
    if (_commentStr.length==0) {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"亲，总体感觉还没有评价哦!" buttonTitle:nil];
    }
    else if (_massStr.length==0)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"亲，质量服务还没有评价哦!" buttonTitle:nil];
    }
    else if (_sendStr.length==0)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"亲，配送服务还没有评价哦!" buttonTitle:nil];
    }
    else if (_commentTV.text.length==0)
    {
        [UIAlertView alertWithTitle:@"温馨提示" message:@"亲，评价内容还没有填写哦!" buttonTitle:nil];
    }
    else
    {
        NSDictionary * param=@{@"orderId":_orderId,@"content":_commentTV.text,@"sendScore":_sendStr,@"qualityScore":_massStr,@"totalScore":_commentStr};
        [RequstEngine requestHttp:@"1022" paramDic:param blockObject:^(NSDictionary *dic) {
            DMLog(@"1022--%@",dic);
            DMLog(@"error---%@",dic[@"errorMsg"]);
            if ([dic[@"errorCode"]intValue]==00000) {
                [UIAlertView alertWithTitle:@"温馨提示" message:@"订单评价成功" buttonTitle:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [UIAlertView alertWithTitle:@"温馨提示" message:dic[@"errorMsg"] buttonTitle:nil];
            }
        }];

    }
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
