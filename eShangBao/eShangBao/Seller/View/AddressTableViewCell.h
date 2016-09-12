//
//  AddressTableViewCell.h
//  eShangBao
//
//  Created by Dev on 16/1/25.
//  Copyright © 2016年 doumee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddressTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *currentName;
@property (weak, nonatomic) IBOutlet UILabel *currentAddr;

@end
