//
//  ZYTagVC.h
//  dajiaochong
//
//  Created by ZhouYong on 2017/4/24.
//  Copyright © 2017年 kidstone. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "UIColor+Help.h"


typedef void(^TagBlock)(NSArray *tagArray);


@interface ZYTagVC : UIViewController

/**
 标签的点击回调
 */
@property (nonatomic, copy)TagBlock tagBlock;


/**
 用来存放标签的内容,将标签传递给需要用到的地方,本类通过点击右上角的"完成"按钮,在tagBlock事件中传值.
 */
@property (nonatomic ,strong)NSMutableDictionary<NSString *,NSString *> *initialTags;

@end
