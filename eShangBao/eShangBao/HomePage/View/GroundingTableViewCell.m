//
//  GroundingTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/4/5.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "GroundingTableViewCell.h"
#import "GorundingCollectionViewCell.h"
#import "HomeModel.h"
#import "CategoryViewController.h"
#import "GoodsDetailsViewController.h"
@implementation GroundingTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

//-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    GroundingTableViewCell * cell=[]
//}

+(instancetype)nowStatusWithTableView:(UITableView *)tableView section:(NSInteger)section cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GroundingTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:@"collectionCell"];
    if (!cell) {
        cell=[[GroundingTableViewCell alloc]initWithStyle:0 reuseIdentifier:@"collectionCell"];
    }
    [cell addSubviews:section];
    cell.opaque=YES;
    return cell;
}

-(void)addSubviews:(NSInteger)height;
{
    
    UIView *videoView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 175)];
    videoView.backgroundColor=[UIColor brownColor];
    [self.contentView addSubview:videoView];
    
    myWeb = [[UIWebView alloc] initWithFrame:videoView.bounds];
    
 
    bgImageView=[[UIImageView alloc]initWithFrame:myWeb.frame];
    bgImageView.image=[UIImage imageNamed:@"video"];
    [videoView addSubview:bgImageView];
    [videoView addSubview:myWeb];
    
    
    
    
}

-(void)setModel:(activityModel *)model
{
    
    [bgImageView setImageWithURLString:model.imgUrl placeholderImage:@"video"];
    
    
    
    NSURL *url = [NSURL URLWithString:@"http://devimages.apple.com/iphone/samples/bipbop/gear1/prog_index.m3u8"];
    //http://114.215.188.193:8080/consumption/ad/20160604/5d2742c7-95e2-44ee-96a8-9ac0420a65a6.png 
    // http://devimages.apple.com/iphone/samples/bipbop/gear1/prog_index.m3u8//这里也可以是 mp4
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    [myWeb loadRequest:request];
    
}

//#pragma mark - UICollectionViewDelegate
//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return _dataArr.count;
////    return 2;
//    DMLog(@"count---%ld",(long)_dataArr.count);
//}
//
//-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
////    SellerListModel * model=_dataArr[indexPath.row];
//    GroundingModel * model=_dataArr[indexPath.row];
//    GorundingCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
//    cell.opaque=YES;
//    [cell.recImg setImageWithURLString:model.imgUrl placeholderImage:DEFAULTIMAGE];
//    cell.nameLabel.text=model.goodsName;
//    cell.priceLabel.text=[NSString stringWithFormat:@"售价￥%.2f",[model.price floatValue]];
////    int returnBate=[model.returnBate intValue]*100;
//    NSString * intBate=[NSString stringWithFormat:@"%.1f",[model.returnBate floatValue]*100];
//    if ([intBate isEqualToString:@"0.0"]) {
//        cell.backCoinLabel.hidden=YES;
//    }
//    else
//    {
//        cell.backCoinLabel.hidden=NO;
//        cell.backCoinLabel.text=[NSString stringWithFormat:@"返%.1f%@",[model.returnBate floatValue]*100,@"%"];
//    }
//    
////    [cell.recommendImg setImageWithURLString:model.doorImg placeholderImage:DEFAULTIMAGE];
////    cell.recommendLabel.text=model.shopName;
//    //    cell.backgroundColor=RGBACOLOR(247, 137, 0, 1);
//    return cell;
//}
//
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(W(150), H(150));
//}
//
//-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(H(5), W(5), H(5), W(5));
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
//{
//    return W(5);
//}
//
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    DMLog(@"dian");
//    GroundingModel * model=_dataArr[indexPath.row];
//    GoodsDetailsViewController * cateVC=[[GoodsDetailsViewController alloc]init];
//    cateVC.hidesBottomBarWhenPushed=YES;
//    cateVC.goodsId=model.goodsId;
//    [self.delegate pushView:cateVC];
//
//    
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
