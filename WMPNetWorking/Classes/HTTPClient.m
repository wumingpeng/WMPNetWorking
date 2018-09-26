//
//  HTTPClient.m
//  GH-iOS
//
//  Created by 郭敏 on 2016/11/29.
//  Copyright © 2016年 iBinaryOrg. All rights reserved.
//

#import "HTTPClient.h"
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#import <AFNetworking/AFNetworking.h>
#import "BHUtils.h"
#import "GlobalFunction.h"
#import "BHProgressHUD.h"
#import <YYCategories/YYCategories.h>

static NSTimeInterval const NetworkTimeoutInterval = 60.0;

#define kRequestErrorMessage            @"请求数据出错了"
#define kNoInternetConnectionMessage    @"无网络连接"

@interface HTTPClient ()

@property (nonatomic, strong) AFHTTPSessionManager *httpSessionManager;
@property (nonatomic, strong) AFURLSessionManager *urlSessionManager;
@property (nonatomic, strong) NSMutableDictionary *httpRequestHeaders;
@property (nonatomic, copy) NSString *UUIDString;

@end

@implementation HTTPClient

+ (HTTPClient *)sharedHTTPClient {
    static HTTPClient *_httpClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _httpClient = [[self alloc] init];
    });
    return _httpClient;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        AFHTTPSessionManager *httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:self.baseUrl]];
        
        httpSessionManager.requestSerializer.timeoutInterval = NetworkTimeoutInterval;
        httpSessionManager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        
        httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", nil];
        self.httpSessionManager = httpSessionManager;
        
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    }
    return self;
}

#pragma mark - Getter & Setter
- (NSMutableDictionary *)httpRequestHeaders {
    if (!_httpRequestHeaders) {
        _httpRequestHeaders = [NSMutableDictionary dictionary];
    }
    return _httpRequestHeaders;
}

- (AFURLSessionManager *)urlSessionManager {
    if (!_urlSessionManager) {
        NSURLSessionConfiguration *urlSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        urlSessionConfiguration.timeoutIntervalForResource = 10;
        AFURLSessionManager *urlSessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:urlSessionConfiguration];
        _urlSessionManager = urlSessionManager;
    }
    return _urlSessionManager;
}

- (NSString *)UUIDString {
    if (!_UUIDString) {
        _UUIDString = [BHUtils userDefaultsValueForKey:@"UUID"];
        if (IsEmptyString(_UUIDString)) {
            _UUIDString = [NSString stringWithUUID];
            [BHUtils storeUserDefaultsValue:_UUIDString forKey:@"UUID"];
        }
    }
    return _UUIDString;
}

#pragma mark - HTTP Request Headers
- (void)setCustomHTTPRequestHeaders:(NSDictionary *)requestHeaders {
    [requestHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [self.httpSessionManager.requestSerializer setValue:obj forHTTPHeaderField:key];
        [self.httpRequestHeaders setObject:obj forKey:key];
    }];
}

- (nullable NSString *)valueForCustomHTTPRequestHeaderField:(NSString *)field {
    return [self.httpSessionManager.requestSerializer valueForHTTPHeaderField:field];
}

- (void)removeCustomValueForHTTPRequestHeaderField:(NSString *)field {
    [self.httpSessionManager.requestSerializer setValue:nil forHTTPHeaderField:field];
    [self.httpRequestHeaders removeObjectForKey:field];
}

- (void)removeAllCustomHTTPRequestHeaderFields {
    if (_httpRequestHeaders.count > 0) {
        [self.httpRequestHeaders enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) { 
            [self.httpSessionManager.requestSerializer setValue:nil forHTTPHeaderField:key];
        }];
        [self.httpRequestHeaders removeAllObjects];
        self.httpRequestHeaders = nil;
    }
}

#pragma mark - Request Methods
- (NSURLSessionDataTask *)POSTWithUrl:(NSString *)url
              param:(NSDictionary *)dic
            success:(RequestFinishBlock)successBlock
            failure:(RequestErrorBlock)failureBlock {
    
    if (!dic) {
        dic = @{};
    }
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    paramDic[@"_clienttype"] = @"ios";
    paramDic[@"_deviceid"] = [self UUIDString];
    
    printf("\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
    NSLog(@"\n`POST` Request With Url: %@%@\nParams:\n%@", self.httpSessionManager.baseURL, url, paramDic);
    printf("-----------------------------------------------------------------------------\n");
    
    return [self.httpSessionManager POST:url parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        printf("\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n");
        NSLog(@"\n`POST` Response With Url: %@%@\nResponse:\n%@", self.httpSessionManager.baseURL, url, responseObject);
        printf("-----------------------------------------------------------------------------\n");
        
        if (successBlock) {
            successBlock(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorString = [AFNetworkReachabilityManager sharedManager].isReachable ?
        kRequestErrorMessage : kNoInternetConnectionMessage;
        [BHProgressHUD showMessage:errorString
                       addedToView:[UIApplication sharedApplication].keyWindow
                           blockUI:NO
                    hideAfterDelay:2];
        
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

- (NSURLSessionDataTask *)GETWithUrl:(NSString *)url
             param:(NSDictionary *)dic
           success:(RequestFinishBlock)successBlock
           failure:(RequestErrorBlock)failureBlock {
    
    if (!dic) {
        dic = @{};
    }
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    paramDic[@"_clienttype"] = @"ios";
    paramDic[@"_deviceid"] = [self UUIDString];
    
    printf("\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
    NSLog(@"\n`GET` Request With Url: %@%@\nParams:\n%@", self.httpSessionManager.baseURL, url, paramDic);
    printf("-----------------------------------------------------------------------------\n");
 
    return [self.httpSessionManager GET:url parameters:paramDic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        printf("\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n");
        NSLog(@"\n`GET` Response With Url: %@%@\nResponse:\n%@", self.httpSessionManager.baseURL, url, responseObject);
        printf("-----------------------------------------------------------------------------\n");
        
        if (successBlock) {
            successBlock(responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorString = [AFNetworkReachabilityManager sharedManager].isReachable ?
        kRequestErrorMessage : kNoInternetConnectionMessage;
        [BHProgressHUD showMessage:errorString
                       addedToView:[UIApplication sharedApplication].keyWindow
                           blockUI:NO
                    hideAfterDelay:2];
        
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

- (NSURLSessionDataTask *)uploadFileWithUrl:(NSString *)url
                    param:(NSDictionary *)dic
                     data:(id)data
                 progress:(void (^)(CGFloat))uploadProgressBlock
                  success:(RequestFinishBlock)successBlock
                  failure:(RequestErrorBlock)failureBlock {
    
    printf("\n>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
    NSLog(@"\n`POST` Form Data With Url: %@%@\nParams:\n%@", self.httpSessionManager.baseURL, url, dic);
    printf("-----------------------------------------------------------------------------\n");
    
    return [self.httpSessionManager POST:url parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"filename" fileName:@"filename.png" mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (uploadProgressBlock) {
            int64_t totalCount = uploadProgress.totalUnitCount;
            int64_t completedCount = uploadProgress.completedUnitCount;
            CGFloat progress = 1.0 * completedCount / totalCount;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                uploadProgressBlock(progress);
            });
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        printf("\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<\n");
        NSLog(@"\n`POST` Form Data Response With Url: %@%@\nResponse:\n%@", self.httpSessionManager.baseURL, url, responseObject);
        printf("-----------------------------------------------------------------------------\n");
        
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSString *errorString = [AFNetworkReachabilityManager sharedManager].isReachable ?
        kRequestErrorMessage : kNoInternetConnectionMessage;
        [BHProgressHUD showMessage:errorString
                       addedToView:[UIApplication sharedApplication].keyWindow
                           blockUI:NO
                    hideAfterDelay:2];
        
        if (failureBlock) {
            failureBlock(error);
        }
    }];
}

- (NSURLSessionDownloadTask *)downloadFromUrl:(NSString *)url
                                     progress:(void (^)(CGFloat downloadProgress))downloadProgressBlock
                                 downloadPath:(NSString *)filePath
                                   completion:(void (^)(NSString *filePath, NSError *error))completionBlock {
    
    NSMutableURLRequest *downloadRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    downloadRequest.timeoutInterval = 10;
    
    NSURLSessionDownloadTask *downloadTask = [self.httpSessionManager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if (downloadProgressBlock) {
            int64_t totalCount = downloadProgress.totalUnitCount;
            int64_t completedCount = downloadProgress.completedUnitCount;
            CGFloat progress = 1.0 * completedCount / totalCount;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                downloadProgressBlock(progress);
            });
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:filePath isDirectory:NO];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (completionBlock) {
            if (!error) {
                NSString *path = [filePath path];
                completionBlock(path, nil);
            } else {
                completionBlock(nil, error);
            }
        }
    }];
    [downloadTask resume];
    return downloadTask;
}

@end
