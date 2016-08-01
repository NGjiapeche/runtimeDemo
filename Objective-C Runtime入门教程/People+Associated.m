//
//  People+Associated.m
//  Objective-C Runtime入门教程
//
//  Created by PilotLabHome on 16/3/17.
//  Copyright © 2016年 PilotLabHome. All rights reserved.
//

#import "People+Associated.h"

#if TARGET_IPHONE_SIMULATOR
#import <objc/objc-runtime.h>
#else
#import <objc/runtime.h>
#import <objc/message.h>
#endif
@implementation People (Associated)

-(void)setAssociatedBust:(NSNumber *)bust{
    //设置关联对象
    /*
     根据 key 设置 value
    OBJC_EXPORT void objc_setAssociatedObject(id object, const void *key, id value, objc_AssociationPolicy policy)
     
     声明 static char kAssociatedObjectKey; ，使用 &kAssociatedObjectKey 作为 key 值;
     声明 static void *kAssociatedObjectKey = &kAssociatedObjectKey; ，使用 kAssociatedObjectKey 作为 key 值；
     用 selector ，使用 getter 方法的名称作为 key 值。
     
    */
    //通过setter方法这个Key来设置
    objc_setAssociatedObject(self, @selector(associatedBust), bust, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSNumber *)associatedBust{
    return objc_getAssociatedObject(self, @selector(associatedBust));
}

-(void)setAssociatedCallBack:(CodingCallBack)callback{
    objc_setAssociatedObject(self, @selector(associatedCallBack), callback, OBJC_ASSOCIATION_COPY_NONATOMIC);

}
- (CodingCallBack)associatedCallBack {
    return objc_getAssociatedObject(self, @selector(associatedCallBack));
}

+(void)setAssociatedObject:(NSString *)associatedObject{
    objc_setAssociatedObject([self class], @selector(associatedObject), associatedObject, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
//_cmd表示当前调用方法，其实它就是一个方法选择器SEL。一般用于判断方法名或在Associated Objects中唯一标识键名
+(NSString *)associatedObject{
    SEL aSel = @selector(associatedObject);
    return objc_getAssociatedObject(self, _cmd);
//        return objc_getAssociatedObject(self, aSel);
}
@end
