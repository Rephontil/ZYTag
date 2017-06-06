//
//  ZYTagView.h
//  dajiaochong
//
//  Created by ZhouYong on 17/3/28.
//  Copyright © 2017年 kidstone. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextField+ZYTextField.h"
@class ZYTagView;

@protocol ZYTagViewDelegate <NSObject>

@optional

- (void)tagViewDidTouch:(ZYTagView *_Nullable)tagView atIndex:(NSUInteger)index;

- (void)tagViewDidTouch:(ZYTagView *_Nullable)tagView;

@end

@interface ZYTagView : UIView

typedef NS_ENUM(NSUInteger,TagType)
{
    TagTypeNormal = 0, //添加标签
    TagTypeHistory = 1,  //历史记录
};


@property (nonatomic, weak)id <ZYTagViewDelegate>delegate;

/**
 标签类型
 */
@property (nonatomic, assign)TagType type;
/**
 标签是否被选中
 */
@property (nonatomic, assign)BOOL selected;
/**
 输入控件
 */
@property (nonatomic, strong)UITextField * _Nullable textField;
/**
 背景图层
 */
@property (nonatomic, strong)CAShapeLayer * _Nullable backGroundLayer;
/**
 小圆圈
 */
@property (nonatomic, strong)CAShapeLayer * _Nullable roundLayer;
/**
 移除自己
 */
- (void)hide;


@end
