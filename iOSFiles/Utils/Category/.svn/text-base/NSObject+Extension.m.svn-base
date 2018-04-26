//
//  NSObject+Extension.m
//  iOSFiles
//
//  Created by iMobie on 18/2/27.
//  Copyright © 2018年 iMobie. All rights reserved.
//

#import "NSObject+Extension.h"



@implementation NSObject (Extension)

/// 该方法接收一个方法的签名,和一个可变参数
- (void)performSelector:(SEL)aSelector withObjects:(id)object,... {
    
    // 方法签名(方法的描述)
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:aSelector];
    if (signature == nil) {
        NSAssert(false, @"牛逼的错误,找不到 %@ 方法",NSStringFromSelector(aSelector));
    }
    // 包装方法
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    // 设置方法调用者
    invocation.target = self;
    // 设置需要调用的方法
    invocation.selector = aSelector;
    // 获取除去self、_cmd以外的参数个数
    NSInteger paramsCount = signature.numberOfArguments - 2;
    // 设置参数
    va_list params;
    va_start(params, object);
    int i = 0;
    // [GKEndMark end] 是自定义的结束符号,仅此而已,从而使的该方法可以接收nil做为参数
    for (id tmpObject = object; (id)tmpObject != [ZLEndMark end]; tmpObject = va_arg(params, id)) {
        // 防止越界
        if (i >= paramsCount) break;
        // 去掉self,_cmd所以从2开始
        [invocation setArgument:&tmpObject atIndex:i + 2];
        i++;
    }
    va_end(params);
    // 调用方法
    [invocation invoke];
    // 获取返回值
//    id returnValue = nil;
//    if (signature.methodReturnType) {
//        [invocation getReturnValue:&returnValue];
//    }
//    return returnValue;
}


@end
