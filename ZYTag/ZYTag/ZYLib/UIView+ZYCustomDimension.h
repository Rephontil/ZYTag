//
//  UIView+ZYCustomDimension.h
//  dajiaochong
//
//  Created by ZhouYong on 2017/4/12.
//  Copyright © 2017年 kidstone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZYCustomDimension)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

@property (nonatomic) CGFloat left;
@property (nonatomic) CGFloat top;
@property (nonatomic) CGFloat right;
@property (nonatomic) CGFloat bottom;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat centerX;
@property (nonatomic) CGFloat centerY;

@property (nonatomic) CGPoint origin;
@property (nonatomic) CGSize  size;

@property (nonatomic, assign)CGSize customSize;
/**
 自定义控件的宽度,以4.7inch为标准进行缩放
 */
@property (nonatomic, assign)CGFloat customWidth;
/**
 自定义控件的高度,以4.7inch为标准进行缩放
 */
@property (nonatomic, assign)CGFloat customHeight;
/**
 自定义尺寸,以4.7inch为标准进行缩放
 */
/**
 自定义尺寸,以4.7inch为标准进行缩放
 */
@property (nonatomic) CGRect customFrame;


@end
