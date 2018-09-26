//
//  BHProgressHUD.h
//  FBBHouse
//
//  Created by guomin on 15/11/4.
//  Copyright © 2015年 FBBHouse. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BHProgressHUD : NSObject

/**
 在屏幕中央显示文字信息（Tost）
 */
+ (void)showMessage:(NSString *)message;
+ (void)showMessage:(NSString *)message addedToView:(UIView *)view;
+ (void)showMessage:(NSString *)message addedToView:(UIView *)view blockUI:(BOOL)blokUI hideAfterDelay:(NSTimeInterval)delay;

@end
