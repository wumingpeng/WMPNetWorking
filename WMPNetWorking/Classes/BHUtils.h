//
//  FBUtils.h
//  FBBHouse
//
//  Created by guomin on 15/11/19.
//  Copyright © 2015年 FBBHouse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHUtils : NSObject

#pragma mark - Cache
/**
 *  存储用户数据
 *
 *  @param value 存储的值
 *  @param key   存储的键
 */
+ (void)storeUserDefaultsValue:(id)value forKey:(NSString *)key;

/**
 *  获取用户存储的数据
 *
 *  @param key 存储的键
 *
 *  @return 存储的值
 */
+ (id)userDefaultsValueForKey:(NSString *)key;

/**
 *  数据归档
 *
 *  @param object 待归档的object
 *  @param key    归档使用的key，用于保存文件
 */
+ (void)cacheObject:(id<NSCoding>)object forKey:(NSString *)key;

/**
 *  数据解归档
 *
 *  @param key 解归档使用的key，即本地保存的文件的名称
 *
 *  @return 解归档获得的数据
 */
+ (id)getCacheForKey:(NSString *)key;

/**
 *  删除归档
 *
 *  @param key 归档使用的key
 *
 *  @return 是否删除成功
 */
+ (BOOL)clearCacheForKey:(NSString *)key;

#pragma mark - Date
/**
 *  获取单例的NSDateFormatter实例，降低程序的开销
 *
 *  @return NSDateFormatter实例
 */
+ (NSDateFormatter *)sharedDateFormatter;

/**
 *  将String类型的date，按照指定的format，转换成Date类型
 *
 *  @param dateString   String类型的date
 *  @param formatString 指定的format
 *
 *  @return NSDate实例
 */
+ (NSDate *)dateFromString:(NSString *)dateString withDateFormat:(NSString *)formatString;

/**
 *  将Date按照指定的format，转换成响应的String
 *
 *  @param date         需要转换的Date实例
 *  @param formatString 指定的format
 *
 *  @return 转换得到的String
 */
+ (NSString *)stringFromDate:(NSDate *)date withDateFormat:(NSString *)formatString;

/**
 *  @author Paul, 15-12-12 14:12:12
 *
 *  @brief 将时间戳（timeInterval）按照指定的format，转换成相应的String
 *
 *  @param timeInterval 时间戳
 *  @param formatString 时间显示样式 （eg: yyyy-MM-dd HH:mm:ss）
 *
 *  @return 时间字符串
 */
+ (NSString *)stringFromTimestamp:(NSTimeInterval)timeInterval withDateFormat:(NSString *)formatString;

//传入 秒  得到  xx分钟xx秒
+ (NSString *)getMMSSFromSS:(NSString *)totalTime;

#pragma mark - 适应文字显示所需的宽、高计算
/**
 *  计算在指定参数下，string需要的size
 *
 *  @param str            需要计算的string
 *  @param aFont          显示的font
 *  @param aLineBreakMode 显示的lineBreakMode
 *  @param size           在指定的此size之内进行计算
 *
 *  @return 显示string需要的最小size
 */
+ (CGSize)fitSizeWithString:(NSString*)str
                       font:(UIFont*)aFont
              lineBreakMode:(NSLineBreakMode)aLineBreakMode
                       size:(CGSize)size;

/**
 *  计算在指定参数下，string需要的size
 *
 *  @param str            需要计算的string
 *  @param aFont          显示的font
 *  @param aLineBreakMode 显示的lineBreakMode
 *  @param aWidth         在指定的width宽度下进行计算
 *
 *  @return 显示string需要的最小size
 */
+ (CGSize)fitSizeWithString:(NSString*)str
                       font:(UIFont*)aFont
              lineBreakMode:(NSLineBreakMode)aLineBreakMode
                      width:(float)aWidth;

/**
 *  计算label显示完整的内容，需要的高度
 *
 *  @param aLabel 赋值了text的label
 *
 *  @return label至少需要的高度
 */
+ (CGFloat)fitHeightWithLabel:(UILabel*)aLabel;

/**
 *  计算显示完整attributeString，需要的size
 *
 *  @param str  需要计算的attributeString
 *  @param size 在指定的此size之内进行计算
 *
 *  @return 需要的最小size
 */
+ (CGSize)fitSizeWithAttributeString:(NSAttributedString*)str Size:(CGSize)size;

#pragma mark - 正则匹配
/**
 *  检测是否是电话号码格式
 *
 *  @param phone 传入的待检测电话号码
 *
 *  @return 是电话号码格式则返回YES，否则返回NO。
 */
+ (BOOL)checkIsPhoneNumber:(NSString *)phone;

/**
 *  检测是否是身份证号码格式
 *
 *  @param idNum 传入的待检测身份证号码。
 *
 *  @return 是身份证号码格式则返回YES，否则返回NO。
 */
+ (BOOL)checkIsIdCardNum:(NSString *)idNum;

#pragma mark - Other Utils
/**
 *  检测string是否为空
 *
 *  @param string 传入的string参数
 *
 *  @return 如果为空返回YES，否则NO
 */
+ (BOOL)isEmptyString:(NSString *)string;

/**
 *  获取app显示的名称
 *
 *  @return app名称
 */
+ (NSString *)appName;

@end
