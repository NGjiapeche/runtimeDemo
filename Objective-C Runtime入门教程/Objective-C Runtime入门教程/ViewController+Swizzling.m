//
//  ViewController+Swizzling.m
//  Objective-C Runtime入门教程
//
//  Created by PilotLabHome on 16/3/22.
//  Copyright © 2016年 PilotLabHome. All rights reserved.
//

#import "ViewController+Swizzling.h"
#import <objc/runtime.h>
@implementation UIViewController (Swizzling)

//+load 方法是在类被加载的时候调用的.换句话说在 Objective-C runtime 自动调用 +load 方法时，分类中的 +load 方法并不会对主类中的 +load 方法造成覆盖。综上所述，+load 方法是实现 Method Swizzling 逻辑的最佳“场所”。
+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzlingSelector = @selector(mrc_viewWillAppear:);
        
        Method originMethod = class_getInstanceMethod(class, originalSelector);
        Method sizzledMethod  = class_getInstanceMethod(class, swizzlingSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(sizzledMethod), method_getTypeEncoding(sizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzlingSelector, method_getImplementation(sizzledMethod), method_getTypeEncoding(sizzledMethod));
        }else{
            method_exchangeImplementations(originMethod, sizzledMethod);
        }
        NSLog(@"swizzle success = %d",success);
    });
}

//用过友盟统计的同学应该知道，要实现页面的统计功能，我们需要在每个页面的 view controller 中添加如下代码：
/*
 - (void)viewWillDisappear:(BOOL)animated {
 [super viewWillDisappear:animated];
 [MobClick endLogPageView:@"PageOne"];
 }
 */
#pragma mark - Method Swizzling
-(void)mrc_viewWillAppear:(BOOL)animated{
    [self mrc_viewWillAppear:YES];//类方法
    
    //   [MobClick beginLogPageView:NSStringFromClass([self class])];
    NSLog(@"text");
}
- (void)viewWillAppear:(BOOL)animated{
     NSLog(@"123");
 }

@end
