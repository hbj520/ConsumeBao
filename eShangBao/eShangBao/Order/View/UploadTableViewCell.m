
//
//  UploadTableViewCell.m
//  eShangBao
//
//  Created by doumee on 16/1/26.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import "UploadTableViewCell.h"

@implementation UploadTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        _headImg=[[UIImageView alloc]initWithFrame:CGRectMake(W(12), <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)]
        
    }
    
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
