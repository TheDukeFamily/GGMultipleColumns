//
//  GGAddressBookHandle.m
//  MultipleColumns
//
//  Created by Mac on 2017/7/10.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "GGAddressBookHandle.h"

@interface GGAddressBookHandle ()
#ifdef __IPHONE_9_0
/** IOS9之后的通讯录对象,CNContactStore是一个线程安全的类,可以获取和保存联系,获取并保存组和获取容器 **/
@property (nonatomic, strong) CNContactStore *contactStore;
#endif
@end

@implementation GGAddressBookHandle

GGSingletonM(AddressBookHandle)

#pragma mark - < 判断授权 >
- (void)requestAuthorizationWithSuccessBlock:(void (^)(void))success{
    
    //系统是否大于9.0
    if (IOS9_LATER) {
#ifdef __IPHONE_9_0
        //授权是否成功，若授权成功直接return
        if ([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts] == CNAuthorizationStatusAuthorized)return;
        [self.contactStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (granted) {
                NSLog(@"授权成功");
                success();
            }else{
                NSLog(@"授权失败");
            }
        }];
#endif
    }else{
        //获取授权状态
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        //判断授权状态,如果是未决定状态，才需要请求
        if (status == kABAuthorizationStatusNotDetermined) {//没有授权
            //创建通讯录进行授权
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
            ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                if (granted) {
                    NSLog(@"授权成功");
                    success();
                }else{
                    NSLog(@"授权失败");
                }
            });
        }
        
    }
}

#pragma mark - < 还回每个联系人的模型 >
- (void)getAddressBookDataSource:(GGPersonModelBlock)personModel authorizationFailure:(AuthorizationFailure)failure{
    
    if (IOS9_LATER) {
        [self getDataSourceFrom_IOS9_Ago:personModel authorizationFailure:failure];
    }else{
        [self getDataSourceFrom_IOS9_Ago:personModel authorizationFailure:failure];
    }
}

#pragma mark  - < IOS9之前获取通讯录的方法 >
- (void)getDataSourceFrom_IOS9_Ago:(GGPersonModelBlock)personModel authorizationFailure:(AuthorizationFailure)failure
{
    //获取授权状态
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    
    //没有授权，先执行失败的Block,然后erturn
    if (status != kABAuthorizationStatusAuthorized) {
        failure?failure():nil;
        return;
    }
    
    //创建通讯录对象
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    //按照排序规则从通讯录对象中请求所有联系人， 按姓名属性排序
    ABRecordRef recordRef = ABAddressBookCopyDefaultSource(addressBook);
    CFArrayRef allpeoPleArray = ABAddressBookCopyArrayOfAllPeopleInSourceWithSortOrdering(addressBook, recordRef, kABPersonSortByLastName);
    
    //遍历每个联系人的信息，装入model __bridge CF 在ARC桥接转换
    for (id personInfo in (__bridge NSArray *)allpeoPleArray) {
        
        GGPersonModel *model = [[GGPersonModel alloc] init];
        
        //获取到联系人
        ABRecordRef person = (__bridge ABRecordRef)(personInfo);
        
        //获取全名
        NSString *name = (__bridge_transfer NSString *)ABRecordCopyCompositeName(person);
        model.name = name.length > 0 ? name : @"NameNull";
        
        //获取头像数据
        NSData *imageData = (__bridge_transfer NSData *)ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
        model.headerImage = [UIImage imageWithData:imageData];
        
        //获取用户联系号码
        ABMultiValueRef phones = ABRecordCopyValue(person, kABPersonPhoneProperty);
        
        CFIndex phoneCount = ABMultiValueGetCount(phones);
        for (CFIndex i = 0; i<phoneCount; i++) {
            //取得联系人号码
            NSString *phoneValue = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phones, i);
            //格式化联系人号码
            NSString *mobile = [self removeSpecialSubString:phoneValue];
            [model.moblieArray addObject:mobile ? mobile : @"PhoneNull"];
        }
        
        // 将联系人模型回调出去
        personModel ? personModel(model) :nil;
        
        CFRelease(phones);
    }
    
    // 释放不再使用的对象
    CFRelease(allpeoPleArray);
    CFRelease(recordRef);
    CFRelease(addressBook);
}

#pragma mark - < IOS9之后获取通讯录的方法 >
- (void)getDataSourceFrom_IOS9_Later:(GGPersonModelBlock)personModel authorizationFailure:(AuthorizationFailure)failure
{
#ifdef __IPHONE_9_0
    // 1.获取授权状态
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    // 2.如果没有授权,先执行授权失败的block后return
    if (status != CNAuthorizationStatusAuthorized)
    {
        failure ? failure() : nil;
        return;
    }
    // 3.获取联系人
    // 3.1.创建联系人仓库
    //CNContactStore *store = [[CNContactStore alloc] init];
    
    // 3.2.创建联系人的请求对象
    // keys决定能获取联系人哪些信息,例:姓名,电话,头像等
    NSArray *fetchKeys = @[[CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName],CNContactPhoneNumbersKey,CNContactThumbnailImageDataKey];
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:fetchKeys];
    
    // 3.3.请求联系人
    [self.contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact,BOOL * _Nonnull stop) {
        
        // 获取联系人全名
        NSString *name = [CNContactFormatter stringFromContact:contact style:CNContactFormatterStyleFullName];
        
        // 创建联系人模型
        GGPersonModel *model = [GGPersonModel new];
        model.name = name.length > 0 ? name : @"NameNull" ;
        
        // 联系人头像
        model.headerImage = [UIImage imageWithData:contact.thumbnailImageData];
        
        // 获取一个人的所有电话号码
        NSArray *phones = contact.phoneNumbers;
        
        for (CNLabeledValue *labelValue in phones)
        {
            CNPhoneNumber *phoneNumber = labelValue.value;
            NSString *mobile = [self removeSpecialSubString:phoneNumber.stringValue];
            [model.moblieArray addObject: mobile ? mobile : @"phoneNull"];
        }
        
        //将联系人模型回调出去
        personModel ? personModel(model) : nil;
    }];
#endif
}


//过滤指定字符串(可自定义添加自己过滤的字符串)
- (NSString *)removeSpecialSubString: (NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    return string;
}

#pragma mark - lazy

#ifdef __IPHONE_9_0
- (CNContactStore *)contactStore
{
    if(!_contactStore)
    {
        _contactStore = [[CNContactStore alloc] init];
    }
    return _contactStore;
}
#endif

@end
