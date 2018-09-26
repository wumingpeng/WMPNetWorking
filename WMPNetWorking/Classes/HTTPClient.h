//
//  HTTPClient.h
//  GH-iOS
//
//  Created by 郭敏 on 2016/11/29.
//  Copyright © 2016年 iBinaryOrg. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HTTP_CLIENT [HTTPClient sharedHTTPClient]

// 网络请求返回值code状态
typedef NS_ENUM(NSUInteger, NetworkResponseCode) {
    nrcFailure = 0,
    nrcSuccess = 1,
};

typedef void(^RequestFinishBlock)(id object);
typedef void(^RequestErrorBlock)(NSError *error);

@interface HTTPClient : NSObject

@property (nonatomic,copy) NSString *baseUrl;

+ (HTTPClient *)sharedHTTPClient;

#pragma mark - HTTP Request Headers
/**
 *  给 Request 添加 Headers
 *
 *  @param requestHeaders 包含 Headers 的字典
 */
- (void)setCustomHTTPRequestHeaders:(NSDictionary *)requestHeaders;

/**
 *  相应 HTTP Filed 的 Value
 *
 *  @param field field 名称
 *
 *  @return field 对应的 value
 */
- (NSString *)valueForCustomHTTPRequestHeaderField:(NSString *)field;

/**
 *  移除相应 Field 的 Value
 *
 *  @param field field 名称
 */
- (void)removeCustomValueForHTTPRequestHeaderField:(NSString *)field;

/**
 *  移除所有自定义的 Request Header
 */
- (void)removeAllCustomHTTPRequestHeaderFields;

#pragma mark - Request Methods


/**
 POST 请求，JSON 格式。

 @param url 请求的 path，例如：/user/login.action
 @param dic 请求参数字典，将被转换为 JSON
 @param successBlock 网络请求成功的 block，逻辑的正确与否，需要另行判断。
 @param failureBlock 网络请求失败的 block
 
 @return NSURLSessionDataTask 实例对象
 */
- (NSURLSessionDataTask *)POSTWithUrl:(NSString *)url
              param:(NSDictionary *)dic
            success:(RequestFinishBlock)successBlock
            failure:(RequestErrorBlock)failureBlock;

/**
 GET 请求，JSON 格式。
 
 @param url 请求的 path，例如：/user/login.action
 @param dic 请求参数字典，将被转换为 JSON
 @param successBlock 网络请求成功的 block，逻辑的正确与否，需要另行判断。
 @param failureBlock 网络请求失败的 block
 
 @return NSURLSessionDataTask 实例对象
 */
- (NSURLSessionDataTask *)GETWithUrl:(NSString *)url
             param:(NSDictionary *)dic
           success:(RequestFinishBlock)successBlock
           failure:(RequestErrorBlock)failureBlock;

/**
 上传文件

 @param url 上传地址
 @param dic 参数
 @param data 文件内容
 @return NSURLSessionDataTask 实例对象
 */
- (NSURLSessionDataTask *)uploadFileWithUrl:(NSString *)url
                    param:(NSDictionary *)dic
                     data:(id)data
                 progress:(void (^)(CGFloat uploadProgress))uploadProgressBlock
                  success:(RequestFinishBlock)successBlock
                  failure:(RequestErrorBlock)failureBlock;

/**
 文件下载

 @param url 下载地址
 @param downloadProgressBlock 下载进度的 block
 @param filePath 下载保存路径
 @param completionBlock 现在完成的 block
 @return NSURLSessionDownloadTask 实例对象
 */
- (NSURLSessionDownloadTask *)downloadFromUrl:(NSString *)url
                                     progress:(void (^)(CGFloat downloadProgress))downloadProgressBlock
                                 downloadPath:(NSString *)filePath
                                   completion:(void (^)(NSString *filePath, NSError *error))completionBlock;


@end
