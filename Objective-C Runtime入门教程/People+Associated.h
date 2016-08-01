//
//  People+Associated.h
//  Objective-C Runtime入门教程
//
//  Created by PilotLabHome on 16/3/17.
//  Copyright © 2016年 PilotLabHome. All rights reserved.
//

#import "People.h"
typedef void(^CodingCallBack) ();

@interface People (Associated)

//类别本来是不能添加属性的，只能添加方法，理由runtime实现动态添加
@property (nonatomic, strong) NSNumber *associatedBust; // 胸围
@property (nonatomic, copy) CodingCallBack associatedCallBack;  // 写代码



+ (NSString *)associatedObject;
+ (void)setAssociatedObject:(NSString *)associatedObject;

@end
