//
//  UITextField+ZYTextField.m
//  dajiaochong
//
//  Created by ZhouYong on 2017/4/23.
//  Copyright © 2017年 kidstone. All rights reserved.
//

#import "UITextField+ZYTextField.h"
#import <objc/runtime.h>

NSString * const ZYTextFieldDidDeleteBackwardNotification = @"com.whojun.textfield.did.notification";
@implementation UITextField (ZYTextField)

+ (void)load {
    //交换2个方法中的IMP
    Method method1 = class_getInstanceMethod([self class], NSSelectorFromString(@"deleteBackward"));
    Method method2 = class_getInstanceMethod([self class], @selector(zy_deleteBackward));
    method_exchangeImplementations(method1, method2);
}

- (void)zy_deleteBackward {
    [self zy_deleteBackward];
    
    if ([self.delegate respondsToSelector:@selector(textFieldDidDeleteBackward:)])
    {
        id <ZYTextFieldDelegate> delegate  = (id<ZYTextFieldDelegate>)self.delegate;
        [delegate textFieldDidDeleteBackward:self];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ZYTextFieldDidDeleteBackwardNotification object:self];
}



@end
