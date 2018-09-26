//
//  BHProgressHUD.m
//  FBBHouse
//
//  Created by guomin on 15/11/4.
//  Copyright © 2015年 FBBHouse. All rights reserved.
//

#import "BHProgressHUD.h"
#import "MBProgressHUD.h"


@implementation BHProgressHUD

+ (void)showMessage:(NSString *)message {
    [self showMessage:message addedToView:[UIApplication sharedApplication].keyWindow];
}

+ (void)showMessage:(NSString *)message addedToView:(UIView *)view {
    [self showMessage:message addedToView:view blockUI:YES hideAfterDelay:1.0f];
}

+ (void)showMessage:(NSString *)message addedToView:(UIView *)view blockUI:(BOOL)blokUI hideAfterDelay:(NSTimeInterval)delay{
    
    if (!view) {
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = message;
    hud.detailsLabel.font = [UIFont systemFontOfSize:17.0];
    hud.userInteractionEnabled = blokUI;
    hud.removeFromSuperViewOnHide = YES;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES afterDelay:delay];
    });
}

@end
