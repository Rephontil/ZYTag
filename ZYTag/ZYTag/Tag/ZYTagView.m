//
//  ZYTagView.m
//  dajiaochong
//
//  Created by ZhouYong on 17/3/28.
//  Copyright © 2017年 kidstone. All rights reserved.
//

#import "ZYTagView.h"
#import "UIView+ZYCustomDimension.h"

/**
 *  主屏的宽
 */
#define DEF_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

/**
 *  主屏的高
 */
#define DEF_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height


@implementation ZYTagView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.type = TagTypeNormal;
        self.selected = NO;
        self.backgroundColor = [UIColor clearColor];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
        [self initWithChildView];
        [self layoutChildViewsWithFrame:frame];
        
        
    }
    return self;
}

- (instancetype)init{
    if (self = [super init]) {
    }
    return self;
}

- (void)hide{
    [self removeFromSuperview];
}


/**
 重新调整布局的frame
 
 @param frame frame
 */
-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self layoutChildViewsWithFrame:frame];
}

- (void)initWithChildView{
    self.textField = [[UITextField alloc] init];
    self.backGroundLayer = [[CAShapeLayer alloc] init];
    self.roundLayer = [[CAShapeLayer alloc] init];
}

- (void)layoutChildViewsWithFrame:(CGRect)frame
{
    self.textField.frame = CGRectMake(5, 0, self.width, self.height);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight cornerRadii:CGSizeMake(5, 5)];
    
    self.backGroundLayer.frame = self.bounds;
    self.backGroundLayer.anchorPoint = CGPointMake(0.5, 0.5);  //很关键
    self.backGroundLayer.lineWidth = 0.5f;
    self.backGroundLayer.path = maskPath.CGPath;
    self.textField.layer.mask  = self.backGroundLayer;
    
    //小圆圈
    CGPoint trackCenter = CGPointMake(4 , 4);
    UIBezierPath *trackPath = [UIBezierPath bezierPathWithArcCenter:trackCenter radius:1 startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    self.roundLayer.frame = self.backGroundLayer.bounds;
    self.roundLayer.anchorPoint = CGPointMake(0.5, 0.5);
    self.roundLayer.lineWidth = 0.5f;
    self.roundLayer.path = trackPath.CGPath;
    
    [self addSubview:self.textField];
    //添加并显示
    [self.layer addSublayer:self.backGroundLayer];
    [self.layer addSublayer:self.roundLayer];
    
    [self.layer insertSublayer:self.backGroundLayer below:self.textField.layer];
}

- (void)tap{
    if (self.type == TagTypeNormal) {
        
        if ([self.delegate respondsToSelector:@selector(tagViewDidTouch:atIndex:)]) {
            [self.delegate tagViewDidTouch:self atIndex:self.tag];
        }
    }else if (self.type == TagTypeHistory){
        
        if ([self.delegate respondsToSelector:@selector(tagViewDidTouch:)]) {
            [self.delegate tagViewDidTouch:self];
            
        }
    }
    
}


@end
