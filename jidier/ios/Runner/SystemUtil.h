//
//  SystemUtil.h
//  Runner
//系统工具内
//  Created by FH on 2020/1/8.
//  Copyright © 2020年 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface SystemUtil : NSObject

+(void) openUrl:(NSString *)url;
+(void) callNum:(NSString *)num;
@end

NS_ASSUME_NONNULL_END
