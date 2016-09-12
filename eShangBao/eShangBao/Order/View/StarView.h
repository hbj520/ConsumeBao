//
//  StarView.h
//  EvaluationStar
//
//  Created by 赵贺 on 15/11/26.
//  Copyright © 2015年 赵贺. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StarView : UIView

@property (nonatomic,copy)void(^block)(NSDictionary *dic);
//@property (nonatomic,copy)void(^massBlock)(NSDictionary * dic);
//@property (nonatomic,copy)void(^sendBlock)(NSDictionary * adict);
- (id)initWithFrame:(CGRect)frame EmptyImage:(NSString *)Empty StarImage:(NSString *)Star;
@end
