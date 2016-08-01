//
//  ViewController+Swizzling.h
//  Objective-C Runtime入门教程
//
//  Created by PilotLabHome on 16/3/22.
//  Copyright © 2016年 PilotLabHome. All rights reserved.
//

#import "ViewController.h"

@interface UIViewController (Swizzling)
-(void)mrc_viewWillAppear:(BOOL)animated;
@end
