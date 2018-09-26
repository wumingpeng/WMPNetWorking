//
//  GlobalFunction.m
//  ZGZhishu
//
//  Created by lyb on 15/9/22.
//  Copyright (c) 2015年 Melvins. All rights reserved.
//

#import "GlobalFunction.h"

BOOL IsEmptyString(NSString *string)
{
    return string == nil  || [string isKindOfClass:[NSNull class]] || string.length == 0;
}

BOOL IsEmptyArray(NSArray *array)
{
    if (!array || [array isKindOfClass:[NSNull class]] || array.count <= 0) {
        return YES;
    } else {
        return NO;
    }
}

BOOL IsEmptyDictionary(NSDictionary *dictionary) {
    if (!dictionary || [dictionary isKindOfClass:[NSNull class]] || dictionary.count <= 0) {
        return YES;
    } else {
        return NO;
    }
}

NSString *JSONStringFromDictionary(NSDictionary *parameters)
{
    NSError *error = nil;
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:&error];;
    
    if (!error) {
        return [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
    } else {
        return nil;
    }
}

id JSONObjectFromString(NSString *string)
{
    if (!string || [string isKindOfClass:[NSNull class]] || string.length <= 0) {
        return nil;
    }
    NSError * error = nil;
    NSData * data = [string dataUsingEncoding:NSUTF8StringEncoding];
    id ret = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    return ret;
    
}

#pragma mark - Date

NSDate *NSDateWithDateString(NSString *dateString, NSString *dateFormat)
{
    if (!dateFormat || dateFormat == NULL) {
        dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    NSDate *date = [dateFormatter dateFromString:dateString];
    return date;
}

NSString *NSStringWithDateAndDateFormat(NSDate *date, NSString *dateFormat)
{
    if (dateFormat == NULL) {
        dateFormat = @"yyyy-MM-dd HH:mm:ss";
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateFormat];
    NSString *dateString = [dateFormatter stringFromDate:date];
    return dateString;
}

// APP版本
NSString *ApplicationVersion()
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

#pragma mark - Color Generate

UIColor *UIColorFromRGBA(NSUInteger R, NSUInteger G, NSUInteger B, double A) {
    return [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A];
}

UIColor *UIColorFromHexNumber(NSInteger hexNumber, float alpha) {
    return [UIColor colorWithRed:((double)((hexNumber & 0xFF0000) >> 16))/255.0 green:((double)((hexNumber & 0xFF00) >> 8))/255.0 blue:((double)(hexNumber & 0xFF))/255.0 alpha:alpha];
}
