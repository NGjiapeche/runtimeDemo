//
//  Bird.h
//  Objective-C Runtime入门教程
//
//  Created by PilotLabHome on 16/3/17.
//  Copyright © 2016年 PilotLabHome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Bird : NSObject

@property (nonatomic, copy) NSString *name;


//这里我们不声明sing方法，将调用途中动态更换调用对象:(跟我们常说的黑魔法：（method swizzling）很像)

@end
