//
//  GGSingLeton.h
//  MultipleColumns
//
//  Created by Mac on 2017/7/10.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#ifndef GGSingLeton_h
#define GGSingLeton_h


// .h文件
#define GGSingletonH(name) + (instancetype)shared##name;

// .m文件
#define GGSingletonM(name) \
static id _instance; \
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
\
+ (instancetype)shared##name \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
\
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
}

#endif /* GGSingLeton_h */
