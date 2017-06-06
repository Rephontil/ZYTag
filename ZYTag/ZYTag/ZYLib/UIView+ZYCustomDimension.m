//
//  UIView+ZYCustomDimension.m
//  dajiaochong
//
//  Created by ZhouYong on 2017/4/12.
//  Copyright © 2017年 kidstone. All rights reserved.
//

#import "UIView+ZYCustomDimension.h"

@implementation UIView (ZYCustomDimension)

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (CGFloat)customWidth{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setCustomWidth:(CGFloat)customWidth{
    CGRect frame = self.frame;
    frame.size.width = ((customWidth / 375.0) * [UIScreen mainScreen].bounds.size.width);
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGFloat)customHeight{
     return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setCustomHeight:(CGFloat)customHeight{
    CGRect frame = self.frame;
    frame.size.height = ((customHeight / 375.0) * [UIScreen mainScreen].bounds.size.width);
    self.frame = frame;
}

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (CGSize)customSize{
    return  self.frame.size;
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setCustomSize:(CGSize)customSize{
    CGRect frame = self.frame;
    frame.size.width =  ((customSize.width / 375.0) * [UIScreen mainScreen].bounds.size.width);
    frame.size.height =  ((customSize.height / 375.0) * [UIScreen mainScreen].bounds.size.width);
    self.frame = frame;
}

- (CGRect)customFrame{
    return self.frame;
}

- (void)setCustomFrame:(CGRect)customFrame{
    CGRect frame = self.frame;
    frame.size.width =  ((customFrame.size.width / 375.0) * [UIScreen mainScreen].bounds.size.width);
    frame.size.height =  ((customFrame.size.height / 375.0) * [UIScreen mainScreen].bounds.size.width);
    self.frame = frame;
}


@end
