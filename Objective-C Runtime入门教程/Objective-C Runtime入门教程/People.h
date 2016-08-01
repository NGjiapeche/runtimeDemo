//
//  People.h
//  Objective-C Runtime入门教程
//
//  Created by PilotLabHome on 16/3/17.
//  Copyright © 2016年 PilotLabHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface People : NSObject<NSCoding>
{
    NSString *_occuption;
    NSString *_nationlity;
}

@property (nonatomic, copy) NSString *name; // 姓名
@property (nonatomic, strong) NSNumber *age; // 年龄
@property (nonatomic, copy) NSString *occupation; // 职业
@property (nonatomic, copy) NSString *nationality; // 国籍

- (NSDictionary *)allProperties;
- (NSDictionary *)allIvars;
- (NSDictionary *)allMethods;

-(instancetype)initWithDictionary:(NSDictionary*)dict;

-(NSDictionary *)covertToDictionary;

//添加sing实例方法，但是不提供方法的实现。验证当找不到方法的实现时，动态添加方法。当找不到IMP的时候，方法返回一个 _objc_msgForward 对象，用来标记需要转入消息转发流程，
-(void)sing;

//这里我是实现不提供声明，不修改调用对象，但是将sing方法修改为dance方法。
@end
