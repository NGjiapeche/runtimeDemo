//
//  NSArray+Swizzle.m
//  Objective-C Runtime入门教程
//
//  Created by PilotLabHome on 16/3/22.
//  Copyright © 2016年 PilotLabHome. All rights reserved.
//

#import "NSArray+Swizzle.h"

@implementation NSArray (Swizzle)

- (id)mylastobject{
    id ret = [self mylastobject];
    NSLog(@"*****mylastObject*******");
    return ret;
}


@end
