//
//  SYQTableViewCell.h
//  eShangBao
//
//  Created by Dev on 16/6/29.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SYQTableViewCell : UITableViewCell

@property(nonatomic,strong)NSString *contentStr;
@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,assign)BOOL isLine;//是否需要画线

@end
