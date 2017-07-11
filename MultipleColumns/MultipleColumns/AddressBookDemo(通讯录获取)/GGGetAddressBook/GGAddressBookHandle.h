//
//  GGAddressBookHandle.h
//  MultipleColumns
//
//  Created by Mac on 2017/7/10.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __IPHONE_9_0
#import <Contacts/Contacts.h>
#endif
#import <AddressBook/AddressBook.h>


#import "GGPersonModel.h"
#import "GGSingLeton.h"

/** 系统版本 **/
#define  IOS9_LATER ([[UIDevice currentDevice] systemVersion].floatValue>9.0?YES:NO)

/** 获取一个联系人的信息Block **/
typedef void(^GGPersonModelBlock)(GGPersonModel *model);

/** 授权失败的Block **/
typedef void(^AuthorizationFailure)(void);


@interface GGAddressBookHandle : NSObject

GGSingletonH(AddressBookHandle);

/**
 请求用户通讯录授权
 @param success 授权成功回调
 **/
- (void)requestAuthorizationWithSuccessBlock:(void(^)(void))success;

/**
 *还回每个联系人的模型
 *@param personModel 单个联系人模型
 *@param failure 授权失败的Block
 **/
- (void)getAddressBookDataSource:(GGPersonModelBlock)personModel authorizationFailure:(AuthorizationFailure)failure;


@end
