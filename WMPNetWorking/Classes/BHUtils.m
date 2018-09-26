//
//  FBUtils.m
//  FBBHouse
//
//  Created by guomin on 15/11/19.
//  Copyright © 2015年 FBBHouse. All rights reserved.
//

#import "BHUtils.h"

#define kArchiverPathSuffix     @".archiver"

@implementation BHUtils

#pragma mark - Cache
+ (void)storeUserDefaultsValue:(id)value forKey:(NSString *)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:value forKey:key];
    [userDefaults synchronize];
}

+ (id)userDefaultsValueForKey:(NSString *)key {
    id value = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    return value;
}

+ (void)cacheObject:(id<NSCoding>)object forKey:(NSString *)key {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [key stringByAppendingString:kArchiverPathSuffix];
    NSString *filePath = [rootPath stringByAppendingPathComponent:fileName];
    [NSKeyedArchiver archiveRootObject:object toFile:filePath];
}

+ (id)getCacheForKey:(NSString *)key {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [key stringByAppendingString:kArchiverPathSuffix];
    NSString *filePath = [rootPath stringByAppendingPathComponent:fileName];
    return [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
}

+ (BOOL)clearCacheForKey:(NSString *)key {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [key stringByAppendingString:kArchiverPathSuffix];
    NSString *filePath = [rootPath stringByAppendingPathComponent:fileName];
    return [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
}

#pragma mark - Date
+ (NSDateFormatter *)sharedDateFormatter {
    static NSDateFormatter *dateFormatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dateFormatter = [[NSDateFormatter alloc] init];
    });
    return dateFormatter;
}

+ (NSDate *)dateFromString:(NSString *)dateString withDateFormat:(NSString *)formatString {
    NSDateFormatter *dateFormatter = [self sharedDateFormatter];
    [dateFormatter setDateFormat:formatString];
    return [dateFormatter dateFromString:dateString];
}

+ (NSString *)stringFromDate:(NSDate *)date withDateFormat:(NSString *)formatString {
    NSDateFormatter *dateFormatter = [self sharedDateFormatter];
    [dateFormatter setDateFormat:formatString];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)stringFromTimestamp:(NSTimeInterval)timeInterval withDateFormat:(NSString *)formatString {
    NSDateFormatter *dateFormatter = [self sharedDateFormatter];
    [dateFormatter setDateFormat:formatString];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [dateFormatter stringFromDate:date];
}

//传入 秒  得到  xx分钟xx秒
+ (NSString *)getMMSSFromSS:(NSString *)totalTime
{
    NSInteger seconds = [totalTime integerValue];
    
    //format of minute
    NSString *str_minute = [NSString stringWithFormat:@"%02ld",seconds/60];
    //format of second
    NSString *str_second = [NSString stringWithFormat:@"%02ld",seconds%60];
    //format of time
    NSString *format_time = [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    
    NSLog(@"format_time : %@",format_time);
    
    return format_time;
}

#pragma mark -

+ (CGSize)fitSizeWithString:(NSString*)str
                       font:(UIFont*)aFont
              lineBreakMode:(NSLineBreakMode)aLineBreakMode
                      width:(float)aWidth {
    
    CGSize theSize = [self fitSizeWithString:str
                                        font:aFont
                               lineBreakMode:aLineBreakMode
                                        size:CGSizeMake(aWidth, MAXFLOAT)];
    return theSize;
}

+ (CGSize)fitSizeWithString:(NSString*)str
                       font:(UIFont*)aFont
              lineBreakMode:(NSLineBreakMode)aLineBreakMode
                       size:(CGSize)size {
    
    NSDictionary * info = [NSDictionary dictionaryWithObjectsAndKeys:aFont, NSFontAttributeName,nil];
    CGSize theSize =[str boundingRectWithSize:size
                                      options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                   attributes:info
                                      context:nil].size;
    return theSize;
}

+ (CGSize)fitSizeWithAttributeString:(NSAttributedString*)str Size:(CGSize)size {
    CGSize theSize = [str boundingRectWithSize:(CGSize)size options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading) context:nil].size;
    return theSize;
}

+ (CGFloat)fitHeightWithLabel:(UILabel*)aLabel {
    CGSize theSize = [self fitSizeWithString:aLabel.text
                                        font:aLabel.font
                               lineBreakMode:aLabel.lineBreakMode
                                        size:CGSizeMake(aLabel.frame.size.width, MAXFLOAT)];
    return theSize.height;
}

#pragma mark - 正则匹配
+ (BOOL)checkIsPhoneNumber:(NSString *)phone {
    NSString *phoneRegex = @"^((1[0-9]))\\d{9}$";
    NSPredicate *phonePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES%@", phoneRegex];
    return [phonePredicate evaluateWithObject:phone];
}

+ (BOOL)checkIsIdCardNum:(NSString *)idNum {
    NSString *regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *idCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [idCardPredicate evaluateWithObject:idNum];
}

#pragma mark - Other Utils
+ (BOOL)isEmptyString:(NSString *)string {
    if (!string || string.length == 0) {
        return YES;
    }
    return NO;
}

+ (NSString *)appName {
//        CFStringRef appNameCFString = CFStringCreateWithCString(kCFAllocatorDefault, "CFBundleDisplayName", NSUTF8StringEncoding);
    CFStringRef appNameCFString = (__bridge_retained CFStringRef)@"CFBundleDisplayName";
    NSString *appName = CFBundleGetValueForInfoDictionaryKey(CFBundleGetMainBundle(), appNameCFString);
    CFRelease(appNameCFString);
    return appName;
}

@end
