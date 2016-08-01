//
//  Bird.m
//  Objective-C Runtime入门教程
//
//  Created by PilotLabHome on 16/3/17.
//  Copyright © 2016年 PilotLabHome. All rights reserved.
//

#import "Bird.h"
#import "People.h"
@implementation Bird

/****************5.2 消息动态解析
 第一步：通过resolveInstanceMethod：方法决定是否动态添加方法。如果返回Yes则通过class_addMethod动态添加方法，消息得到处理，结束；如果返回No，则进入下一步；
 第二步：这步会进入forwardingTargetForSelector:方法，用于指定备选对象响应这个selector，不能指定为self。如果返回某个对象则会调用对象的方法，结束。如果返回nil，则进入第三部；
 第三部：这步我们要通过methodSignatureForSelector:方法签名，如果返回nil，则消息无法处理。如果返回methodSignature，则进入下一步；
 第四部：这步调用forwardInvocation：方法，我们可以通过anInvocation对象做很多处理，比如修改实现方法，修改响应对象等，如果方法调用成功，则结束。如果失败，则进入doesNotRecognizeSelector方法，若我们没有实现这个方法，那么就会crash。
 
 */
//第一步;我们不动态添加方法，返回NO，进入第二步；
+(BOOL)resolveInstanceMethod:(SEL)sel{
    return NO;
}

//第二步：我们不指定备选对象响应的aSelector，进入第三步
-(id)forwardingTargetForSelector:(SEL)aSelector{
    return nil;
}

//第三步,返回方法选择器，进入第四步
-(NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector{
    
    if ([NSStringFromSelector(aSelector) isEqualToString:@"sing"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:"];
    }
    return [super methodSignatureForSelector:aSelector];
}

//第四步：修改调用对象
-(void)forwardInvocation:(NSInvocation *)anInvocation{
    
    //我们改变调用对象为People
    People *cang = [[People alloc]init];
    cang.name = @"苍老师";
    [anInvocation invokeWithTarget:cang];
}
@end
