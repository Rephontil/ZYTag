//
//  NSString+ZYString.h
//  dajiaochong
//
//  Created by ZhouYong on 2017/4/19.
//  Copyright © 2017年 kidstone. All rights reserved.
//  字符串的常用富文本方法

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIColor+Help.h"
@interface NSString (ZYString)

/**
 判断字符串是否为空
 
 @param string 要判断的字符串
 @return BOOL
 */
- (BOOL)isZYBlankString:(NSString *)string;
+ (BOOL)isZYBlankString:(NSString *)string;

/**
 转换点赞/评论数(低于9999正常显示,在10000到99999之间保留一位小数,超过10万不保留小数位)
 
 @param numString 传入的数目字符串
 @return 返回结果
 */
- (NSString *)convertNumToFormetString:(NSString *)numString;

/**
 转换点赞/评论数,最多显示99,超过就显示99+
 
 @param numString 传入的数目字符串
 @return 返回结果
 */
- (NSString *)convertNumToMax99String:(NSString *)numString;

/**
 计算字符串的尺寸
 
 @param string 字符串
 @param font 字符串字体大小
 @param maxWidth 字符串显示的最大宽度
 @return 计算好的字符串尺寸
 */
+ (CGSize)calculateSizeWithString:(NSString *)string
                             font:(CGFloat)font
                         maxWidth:(CGFloat)maxWidth;

/**
 计算字符串的尺寸
 
 @param string 字符串
 @param font 字符串字体大小
 @param lineSpacing 字符串行间距
 @param maxWidth 字符串显示的最大宽度
 @return 计算好的字符串尺寸
 */
+ (CGSize)calculateSizeWithString:(NSString *)string
                             font:(CGFloat)font
                      lineSpacing:(CGFloat)lineSpacing
                         maxWidth:(CGFloat)maxWidth;

/**
 改变range范围内的字体属性(颜色)
 
 @param string 文字
 @param colorStr 指定的颜色
 @param range 需要修改的范围
 @return 修改后的字符串
 */
+ (NSAttributedString *)changeStr:(NSString *)string
                          toColor:(NSString *)colorStr
                            range:(NSRange)range;

/**
 设置行间距
 
 @param string 文字
 @param lineSpacing 行间距
 @return 字符串
 */
+ (NSAttributedString *)changeStr:(NSString *)string
                    toLineSpacing:(CGFloat)lineSpacing;

/**
 设置行间距和部分字体颜色
 
 @param string  文字
 @param lineSpacing 行间距
 @param colorStr 指定的颜色(前景颜色)
 @param range 需要修改的范围
 @return 修改后的字符串
 */
+ (NSAttributedString *)changeStr:(NSString *)string
                    toLineSpacing:(CGFloat)lineSpacing
                          toColor:(NSString *)colorStr
                            range:(NSRange)range;

/**
 设置行间距和部分字体颜色
 
 @param string  文字
 @param lineSpacing 行间距
 @param colorStr 指定的颜色(前景颜色)
 @param range 需要修改的范围
 @return 修改后的字符串
 */
+ (NSAttributedString *)changeStr:(NSString *)string
                    toLineSpacing:(CGFloat)lineSpacing
                  backGroundColor:(NSString *)backColor
                            range:(NSRange)range;

/**
 在规定的范围内设置下划样式和下划线的颜色
 
 @param string 文字
 @param lineSpacing 行间距
 @param colorStr 指定的颜色(前景颜色)
 @param underLineStyle 删除线的样式
 @param range 需要修改的范围
 @return 修改后的字符串
 */
+ (NSAttributedString *)changeStr:(NSString *)string
                    toLineSpacing:(CGFloat)lineSpacing
                          toColor:(NSString *)colorStr
                   underLineStyle:(NSUnderlineStyle)underLineStyle
                   underLineColor:(NSString *)underLineColor
                            range:(NSRange)range;
/**
 设置行间距和部分字体颜色
 
 @param string  文字
 @param lineSpacing 行间距
 @param colorStr 指定的颜色
 @param backColor 指定的后景颜色(背景)
 @param range 需要修改的范围
 @return 修改后的字符串
 */
+ (NSAttributedString *)changeStr:(NSString *)string
                    toLineSpacing:(CGFloat)lineSpacing
                          toColor:(NSString *)colorStr
                  backGroundColor:(NSString *)backColor
                   underLineStyle:(NSUnderlineStyle)underLineStyle
                   underLineColor:(NSString *)underLineColor
                            range:(NSRange)range;

/**
 设置字符之间的字间距（不是行间距！）
 
 @param string 传入的字符串
 @param spacing 字间距
 @param range 需要修改的范围。
 @return 目标字符创
 */
+ (NSAttributedString *)setTextSpacingWithString:(NSString *)string
                                     textSpacing:(CGFloat)spacing
                                           range:(NSRange)range;

/**
 设置字符串的删除样式和删除线条的颜色(无法设定要删除的范围)
 
 @param string 传入的字符串
 @param deleteLineStyle 删除样式
 @param deleteLineColor 删除线条的颜色
 @return 目标字符串
 */
+ (NSAttributedString *)setString:(NSString *)string
                  deleteLineStyle:(NSUnderlineStyle)deleteLineStyle
                  deleteLineColor:(NSString *)deleteLineColor
                            range:(NSRange)range;

/**
 设置文字描边的颜色([-n ~ +n])
 
 @param string 传入的字符串
 @param strokeColor 描边的颜色
 @param strokeWidth 描边的宽度
 @param range 描边的范围
 @return 目标结果
 */
+ (NSAttributedString *)strokeWithString:(NSString *)string
                             strokeColor:(NSString*)strokeColor
                             strokeWidth:(CGFloat)strokeWidth
                                   range:(NSRange)range;




@end
