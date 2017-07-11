//
//  GGPersonModel.m
//  MultipleColumns
//
//  Created by Mac on 2017/7/10.
//  Copyright © 2017年 Mr.Gao. All rights reserved.
//

#import "GGPersonModel.h"

@implementation GGPersonModel

- (NSMutableArray *)moblieArray{
    if (!_moblieArray) {
        _moblieArray = [NSMutableArray array];
    }
    return _moblieArray;
}

@end
