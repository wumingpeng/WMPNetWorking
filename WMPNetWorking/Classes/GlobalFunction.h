//
//  GlobalFunction.h
//  ZGZhishu
//
//  Created by lyb on 15/9/22.
//  Copyright (c) 2015年 Melvins. All rights reserved.
//

#import <Foundation/Foundation.h>

// 判空
extern BOOL IsEmptyString(NSString *string);
extern BOOL IsEmptyArray(NSArray *array);
extern BOOL IsEmptyDictionary(NSDictionary *dictionary);

// Json 解析
extern NSString *JSONStringFromDictionary(NSDictionary *parameters);
extern id JSONObjectFromString(NSString *string);

// NSDate 格式处理
extern NSDate *NSDateWithDateString(NSString *dateString, NSString *dateFormat);
extern NSString *NSStringWithDateAndDateFormat(NSDate *date, NSString *dateFormat);

// 获取APP版本号
extern NSString *ApplicationVersion();

// Color Generator
extern UIColor *UIColorFromRGBA(NSUInteger R, NSUInteger G, NSUInteger B, double A);
extern UIColor *UIColorFromHexNumber(NSInteger hexNumber, float alpha);
