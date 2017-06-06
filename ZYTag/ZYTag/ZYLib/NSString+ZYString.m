//
//  NSString+ZYString.m
//  dajiaochong
//
//  Created by ZhouYong on 2017/4/19.
//  Copyright © 2017年 kidstone. All rights reserved.
//

#import "NSString+ZYString.h"

@implementation NSString (ZYString)

/**
 判断字符串是否为空
 
 @param string 要判断的字符串
 @return BOOL
 */
- (BOOL)isZYBlankString:(NSString *)string
{
    return [NSString isZYBlankString:string];
}

/**
 判断字符串是否为空
 
 @param string 要判断的字符串
 @return BOOL
 */
+ (BOOL)isZYBlankString:(NSString *)string
{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    // 去掉前后空格，判断length是否为0
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"] || [string isEqualToString:@"null"]) {
        return YES;
    }
    // 不为空
    return NO;
}


///=============================================================================
///  字 符 串 格 式 处 理
///=============================================================================

/**
 转换点赞/评论数(低于9999正常显示,在10000到99999之间保留一位小数,超过10万不保留小数位)
 
 @param numString 传入的数目字符串
 @return 返回结果
 */
- (NSString *)convertNumToFormetString:(NSString *)numString
{
    CGFloat num = numString.floatValue;
    NSString *returnString = [NSString stringWithFormat:@"%.0f",num];
    if (num > 9999.0) {
        CGFloat newNum = num/10000;
        if (num < 99999.0) {
            returnString = [NSString stringWithFormat:@"%.1f万",newNum];
        }else{
            returnString = [NSString stringWithFormat:@"%.0f万",newNum];
        }
    }
    
    return returnString;
}

/**
 转换点赞/评论数,最多显示99,超过就显示99+
 
 @param numString 传入的数目字符串
 @return 返回结果
 */
- (NSString *)convertNumToMax99String:(NSString *)numString
{
    CGFloat num = numString.floatValue;
    NSString *returnString = [NSString stringWithFormat:@"%.0f",num];
    if (num > 99) {
        returnString = @"99+";
    }
    
    return returnString;
}


///=============================================================================
///  字 符 串 尺 寸 处 理
///=============================================================================
/**
 计算字符串的尺寸
 
 @param string 字符串
 @param font 字符串字体大小
 @param maxWidth 字符串显示的最大宽度
 @return 计算好的字符串尺寸
 */
+ (CGSize)calculateSizeWithString:(NSString *)string
                             font:(CGFloat)font
                         maxWidth:(CGFloat)maxWidth
{
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:font]};
    CGSize ziTiSize = [string boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return ziTiSize;
}

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
                         maxWidth:(CGFloat)maxWidth
{
    NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
    [style1 setLineSpacing:lineSpacing];
    style1.alignment = NSTextAlignmentJustified;
    NSDictionary *attribute = @{NSFontAttributeName:[UIFont systemFontOfSize:font],NSParagraphStyleAttributeName:style1};
    CGSize ziTiSize = [string boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    return ziTiSize;
}


///=============================================================================
///  字 符 串 属 性 处 理
///=============================================================================

/**
 改变range范围内的字体属性(颜色)
 
 @param string 文字
 @param colorStr 指定的颜色
 @param range 需要修改的范围。如果需要全部设置，则可传入 NSRange range = (NSRange){0,0};
 @return 修改后的字符串
 */
+ (NSAttributedString *)changeStr:(NSString *)string
                          toColor:(NSString *)colorStr
                            range:(NSRange)range
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *attributeDic = @{
                                   NSForegroundColorAttributeName:[UIColor colorWithHexString:colorStr],
                                   };
    if (range.length == 0) {
        range = (NSRange){0,[string length]};
    }
    [attributedString addAttributes:attributeDic range:range];
    
    return attributedString;
}

/**
 设置行间距
 
 @param string 文字
 @param lineSpacing 行间距
 @return 字符串
 */
+ (NSAttributedString *)changeStr:(NSString *)string
                    toLineSpacing:(CGFloat)lineSpacing
{
    NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
    [style1 setLineSpacing:lineSpacing];
    style1.alignment = NSTextAlignmentJustified;
    NSDictionary *attribute = @{
                                NSParagraphStyleAttributeName:style1,
                                };
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attribute];
    
    return attributedString;
}

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
                            range:(NSRange)range
{
    return [NSString changeStr:string toLineSpacing:lineSpacing toColor:colorStr backGroundColor:nil underLineStyle:0 underLineColor:nil range:range];
}

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
                            range:(NSRange)range
{
    return [NSString changeStr:string toLineSpacing:lineSpacing toColor:nil backGroundColor:backColor underLineStyle:0 underLineColor:nil range:range];
}

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
                            range:(NSRange)range
{
    return [NSString changeStr:string toLineSpacing:lineSpacing toColor:colorStr backGroundColor:nil underLineStyle:underLineStyle underLineColor:underLineColor range:range];
}

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
                            range:(NSRange)range
{
    NSMutableParagraphStyle *style1 = [[NSMutableParagraphStyle alloc] init];
    [style1 setLineSpacing:lineSpacing];
    style1.alignment = NSTextAlignmentJustified;
    
    NSDictionary *attributeDic = @{
                                   NSParagraphStyleAttributeName:style1,
                                   
                                   };
#pragma mark下面这个字典,由于设置一定的范围,所以不可以设置行间距或者其他属性.所以这个单独分开
    NSMutableDictionary *attributeColorDic = [NSMutableDictionary dictionary];
    
    if (![NSString isZYBlankString:backColor] && ![NSString isZYBlankString:colorStr]) {
        attributeColorDic = @{
                              NSForegroundColorAttributeName:[UIColor colorWithHexString:colorStr],
                              NSBackgroundColorAttributeName:[UIColor colorWithHexString:backColor]
                              }.mutableCopy;
    }else if ([NSString isZYBlankString:backColor] && ![NSString isZYBlankString:colorStr]){
        attributeColorDic = @{
                              NSForegroundColorAttributeName:[UIColor colorWithHexString:colorStr],
                              }.mutableCopy;
        
    }else if (![NSString isZYBlankString:backColor] && [NSString isZYBlankString:colorStr]){
        attributeColorDic = @{
                              NSBackgroundColorAttributeName:[UIColor colorWithHexString:backColor]
                              }.mutableCopy;
    }
    
#pragma 如果设置了下划线样式
    if (underLineStyle > 0) {
        [attributeColorDic setValue:@(underLineStyle) forKey:NSUnderlineStyleAttributeName];
        if (![NSString isZYBlankString:underLineColor]) {
            
            [attributeColorDic setValue:[UIColor colorWithHexString:underLineColor] forKey:NSUnderlineColorAttributeName];
        }
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributeDic];
    
    if (range.length > string.length) {
        range.length = string.length;
        range = NSMakeRange(0, string.length);
    }
    [attributedString addAttributes:attributeColorDic range:range];
    
    return attributedString;
}

/**
 设置字符之间的字间距（不是行间距！）
 
 @param string 传入的字符串
 @param spacing 字间距
 @param range 需要修改的范围。
 @return 目标字符创
 */
+ (NSAttributedString *)setTextSpacingWithString:(NSString *)string
                                     textSpacing:(CGFloat)spacing
                                           range:(NSRange)range
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *attributeDic = @{
                                   NSKernAttributeName:@(spacing)
                                   };
   
    if (range.length > string.length) {
        range.length = string.length;
        range = NSMakeRange(0, string.length);
    }
    [attributedString addAttributes:attributeDic range:range];
    
    return attributedString;
}

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
                            range:(NSRange)range
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *attributeDic = @{
                                   NSStrikethroughStyleAttributeName:[NSNumber numberWithInteger:deleteLineStyle],
                                   NSStrikethroughColorAttributeName:[UIColor colorWithHexString:deleteLineColor]
                                   };
    
    if (range.length > string.length) {
        range.length = string.length;
        range = NSMakeRange(0, string.length);
    }
    [attributedString addAttributes:attributeDic range:range];

    return attributedString;
}


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
                                   range:(NSRange)range
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSDictionary *attributeDic = @{
                                   NSStrokeColorAttributeName:[UIColor colorWithHexString:strokeColor],
                                   NSStrokeWidthAttributeName:[NSNumber numberWithInteger:strokeWidth]
                                   };
    
    if (range.length > string.length) {
        range.length = string.length;
        range = NSMakeRange(0, string.length);
    }
    [attributedString addAttributes:attributeDic range:range];
    return attributedString;
}






@end
