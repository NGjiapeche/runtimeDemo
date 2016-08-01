//
//  ViewController.m
//  Objective-C Runtime入门教程
//
//  Created by PilotLabHome on 16/3/17.
//  Copyright © 2016年 PilotLabHome. All rights reserved.
//

#import "ViewController.h"
/*C++是基于静态类型，而Objective-C是基于动态运行时类型。也就是说用C++编写的程序编译时就直接编译成了可令机器读懂的机器语言；用Objective-C编写的程序不能直接编译成可令机器读懂的机器语言，而是在程序运行的时候，通过Runtime把程序转为可令机器读懂的机器语言。Runtime是Objective不可缺少的重要一部分。*/
#import <objc/runtime.h>
#import <objc/message.h>
#import "NSArray+Swizzle.h"
#import "People.h"
#import "People+Associated.h"
#import "Bird.h"
#import "ViewController+Swizzling.h"
@interface ViewController ()

@end

void sayFuction(id self, SEL _cmd, id some1,id some2){
    NSLog(@"%@岁的%@说：%@", object_getIvar(self, class_getInstanceVariable([self class], "_age")),[self valueForKey:@"name"],some1);

}

@implementation ViewController
/*
 
 struct objc_class {
 Class isa  OBJC_ISA_AVAILABILITY;(Class结构体中的 isa 指向的就是它的 Meta Class。)      我们可以把Meta Class理解为 一个Class对象的Class。简单的说：当我们发送一个消息给一个NSObject对象时，这条消息会在对象的类的方法列表里查找
 当我们发送一个消息给一个类时，这条消息会在类的Meta Class的方法列表里查找
 
 #if !__OBJC2__
 Class super_class                                        OBJC2_UNAVAILABLE;
 const char *name                                         OBJC2_UNAVAILABLE;
 long version                                             OBJC2_UNAVAILABLE;
 long info                                                OBJC2_UNAVAILABLE;
 long instance_size                                       OBJC2_UNAVAILABLE;
 struct objc_ivar_list *ivars                             OBJC2_UNAVAILABLE;
 struct objc_method_list **methodLists                    OBJC2_UNAVAILABLE;
 struct objc_cache *cache                                 OBJC2_UNAVAILABLE;
 struct objc_protocol_list *protocols                     OBJC2_UNAVAILABLE;
 #endif

 */
- (void)viewDidLoad {
    [super viewDidLoad];

    //动态创建对象，创建一个 Person 继承自 NSObject类
    Class People0 = objc_allocateClassPair([NSObject class], "People0", 0);
    
    //添加 NSString *_name 成员变量
    class_addIvar(People0, "_name", sizeof(NSString*), log2(sizeof(NSString*)), @encode(NSString*));
    //添加 int _age 成员变量
    class_addIvar(People0, "_age", sizeof(int), sizeof(int), @encode(int));
    
    //注册方法名为 say 的方法
    SEL s = sel_registerName("say:");
    SEL aSel = @selector(movieTitle); //SEL是selector在Objective-C中的表示类型。Selector 就是oc的virtual table中指向实际执行 function pointer的一个C 字符串；selector可以理解为区别方法的ID。
    
    //为该类 添加 say 方法
    class_addMethod(People0, s, (IMP)sayFuction, "v@:@");/*把C 函数定义为 IMP 这个type；IMP 表示方法实现；最后个参数表上 方法类型*/
    //所有的方法type：http://www.huangyibiao.com/runtime-method-in-detail/
    class_addMethod(People0, @selector(say1), (IMP)sayFuction, "V@:@");
    
    //注册该类
    objc_registerClassPair(People0);
    
    //创建一个类的实例
    id People0Instance = [[People0 alloc]init];
    
    //kvc
    [People0Instance setValue:@"苍老师" forKey:@"name"];    //注意是 name
    
    //从类中获取成员遍历Ivar
    Ivar ageIvar = class_getInstanceVariable(People0, "_age");
    //为People0Instance 的成员变量赋值
    object_setIvar(People0Instance, ageIvar, @18);
    
    //调用 People0Instance 对象中的 s 方法选择器对应的方法
     ((void (*)(id, SEL, id))objc_msgSend)(People0Instance, s, @"大家hao！");
    ((void (*)(id, SEL, id))objc_msgSend)(People0Instance, @selector(say1), @"大家hao123");
//    [People0 say1];
    
    People0Instance = nil;//当People0类或者它的子类的实例还存在，则不能调用objc_disposeClassPair这个方法；因此这里要先销毁实例对象后才能销毁类；
    //销毁类
    objc_disposeClassPair(People0);
    
    [self test];
    
    [self testSwizzle];
    
    [self testAssociated];
    
}

-(void)test{
    People *cang = [[People alloc]init];
    cang.name = @"苍井空";
    cang.age = @(18);
    [cang setValue:@"老师" forKey:@"occuption"];
    
    cang.associatedBust = @(90);
    cang.associatedCallBack = ^(){
        NSLog(@"coding");
    };
    cang.associatedCallBack();
    
    NSDictionary *propertyResultDic = [cang allProperties];
    for (NSString * propertyname in propertyResultDic.allKeys) {
        NSLog(@"propertyName:%@, propertyValue:%@",propertyname, propertyResultDic[propertyname]);

    }
    NSDictionary *ivarResultDic = [cang allIvars];
    for (NSString *ivarName in ivarResultDic.allKeys) {
        NSLog(@"ivarName:%@, ivarValue:%@",ivarName, ivarResultDic[ivarName]);
    }
    
    NSDictionary *methodResultDic = [cang allMethods];
    for (NSString *methodName in methodResultDic.allKeys) {
        NSLog(@"methodName:%@, argumentsCount:%@", methodName, methodResultDic[methodName]);
    }
    
    [cang sing];
    Bird *bird =[[Bird alloc]init];
    bird.name = @"xiaoN";
    ((void (*)(id,SEL))objc_msgSend)(bird, @selector(sing));
    
}

-(void)testSwizzle{
    Method ori_Method =  class_getInstanceMethod([NSArray class], @selector(lastObject));
    Method my_Method = class_getInstanceMethod([NSArray class], @selector(mylastobject));
    method_exchangeImplementations(ori_Method, my_Method);
    
    NSArray *array = @[@"0",@"1",@"2",@"3"];
    NSString *string = [array lastObject];
    NSLog(@"TEST RESULT : %@",string);
}
//第一种情况
-(void)viewWillAppear:(BOOL)animated{
    [self mrc_viewWillAppear:animated];
    NSLog(@"appear!");
}
//第二种情况
/*
-(void)mrc_viewWillAppear:(BOOL)animated{
    
}*/

-(void)testAssociated{

    [People setAssociatedObject:@"123People"];
    NSLog(@"%@",[People associatedObject]);
}
@end
