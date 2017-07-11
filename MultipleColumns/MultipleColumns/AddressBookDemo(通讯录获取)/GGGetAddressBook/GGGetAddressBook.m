//
//  GGGetAddressBook.m
//  MultipleColumns
//
//  Created by Mac on 2017/7/10.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "GGGetAddressBook.h"

#define kGGAddressBookHandle [GGAddressBookHandle sharedAddressBookHandle]
#define START NSData *startTime = [NSData data]
#define END  NSLog(@"Time: %f", -[startTime timeIntervalSinceNow])

@implementation GGGetAddressBook

#pragma mark - < 请求用户是否授权APP访问通讯录的权限 >
+(void)requestAddressBookAuthorization{
    //判断是否授权Block
    [kGGAddressBookHandle requestAuthorizationWithSuccessBlock:^{
        [self getOrderAddressBook:nil authorizationFailure:nil];
    }];
}

#pragma mark - < 初始化 >
+(void)initialize{
    [self getOrderAddressBook:nil authorizationFailure:nil];
}

#pragma mark - < 获取原始顺序所有联系人 >
+ (void)getOriginalAddressBook:(AddressBookArrayBlock)addressBookArray authorizationFailure:(AuthorizationFailure)failure{
    //将耗时操作放入子线程
    dispatch_queue_t queue = dispatch_queue_create("addressBook.arrat", DISPATCH_QUEUE_SERIAL);
    
    //异步执行
    dispatch_async(queue, ^{
        
        NSMutableArray *array = [NSMutableArray array];
        [kGGAddressBookHandle getAddressBookDataSource:^(GGPersonModel *model) {
            [array addObject:model];
        } authorizationFailure:^{
           dispatch_async(dispatch_get_main_queue(), ^{
               failure? failure() : nil;
           });
        }];
        
        //将联系人数组回调到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            addressBookArray? addressBookArray(array) : nil;
        });
    });
}

#pragma mark - < 获取按A~Z顺序排列的所有联系人 >
+ (void)getOrderAddressBook:(AddressBookDictBlock)addressBookInfo authorizationFailure:(AuthorizationFailure)failure{
    //将耗时操作放入子线程
    dispatch_queue_t queue = dispatch_queue_create("addressBook.array", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        NSMutableDictionary *addressBookDict = [NSMutableDictionary dictionary];
        [kGGAddressBookHandle getAddressBookDataSource:^(GGPersonModel *model) {
            //获取姓名的大写首字母
            NSString *firstLetterString = [self getFirstLetterFromString:model.name];
            //如果该字母对应的联系人模型不为空，则添加联系人模型到数组
            if (addressBookDict[firstLetterString]) {
                [addressBookDict[firstLetterString] addObject:model];
            }else{//没有该字母数组,可变字典添加一个key——value
                //创建新发可变数组储存该首字母对应联系人model
                NSMutableArray *arrGroupNames = [NSMutableArray arrayWithObject:model];
                //将字母的姓名数组作为Key-value加入字典中
                [addressBookDict setObject:arrGroupNames forKey:firstLetterString];
            }
        } authorizationFailure:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                failure ? failure() : nil;
            });
        }];
        
        //将addressBookDict字典中的所有KEY值进行排序：A~Z
        NSArray *nameKeys = [[addressBookDict allKeys] sortedArrayUsingSelector:@selector(compare:)];
        
        // 将 "#" 排列在 A~Z 的后面
        if ([nameKeys.firstObject isEqualToString:@"#"]) {
            NSMutableArray *mutableNamekeys = [NSMutableArray arrayWithArray:nameKeys];
            [mutableNamekeys insertObject:nameKeys.firstObject atIndex:nameKeys.count];
            [mutableNamekeys removeObjectAtIndex:0];
            dispatch_async(dispatch_get_main_queue(), ^{
                addressBookInfo ? addressBookInfo(addressBookDict,mutableNamekeys) : nil;
            });
            return;
        }
        //将排序好的通讯录数据回调到主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            addressBookInfo ? addressBookInfo(addressBookDict,nameKeys):nil;
        });
        
    });
    
}

#pragma mark - 获取联系人姓名首字母(传入汉字字符串, 返回大写拼音首字母)
+ (NSString *)getFirstLetterFromString:(NSString *)aString
{
    /** iOS开发中如何更快的实现汉字转拼音 http://www.olinone.com/?p=131 **/
    NSMutableString *mutableString = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    NSString *pinyinString = [mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch locale:[NSLocale currentLocale]];
    /**
     *  *************************************** END ******************************************
     */
    
    // 将拼音首字母装换成大写
    NSString *strPinYin = [[self polyphoneStringHandle:aString pinyinString:pinyinString] uppercaseString];
    // 截取大写首字母
    NSString *firstString = [strPinYin substringToIndex:1];
    // 判断姓名首位是否为大写字母
    NSString * regexA = @"^[A-Z]$";
    NSPredicate *predA = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexA];
    // 获取并返回首字母
    return [predA evaluateWithObject:firstString] ? firstString : @"#";
    
}

/**
 多音字处理
 */
+ (NSString *)polyphoneStringHandle:(NSString *)aString pinyinString:(NSString *)pinyinString
{
    if ([aString hasPrefix:@"长"]) { return @"chang";}
    if ([aString hasPrefix:@"沈"]) { return @"shen"; }
    if ([aString hasPrefix:@"厦"]) { return @"xia";  }
    if ([aString hasPrefix:@"地"]) { return @"di";   }
    if ([aString hasPrefix:@"重"]) { return @"chong";}
    return pinyinString;
}

@end
