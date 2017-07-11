//
//  GGPersonModel.h
//  MultipleColumns
//
//  Created by Mac on 2017/7/10.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GGPersonModel : NSObject

/** 联系人姓名 **/
@property (nonatomic, copy) NSString *name;

/** 联系人电话,一个联系人可能储存多个号码 **/
@property (nonatomic, strong) NSMutableArray *moblieArray;

/** 联系人头像 **/
@property (nonatomic, strong) UIImage *headerImage;

@end
