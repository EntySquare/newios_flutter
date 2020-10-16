//
//  ShareTool.h
//  Runner
//
//  Created by FH on 2020/1/2.
//  Copyright © 2020年 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <Flutter/Flutter.h>
#import <MOBFoundation/MobSDK+Privacy.h>
NS_ASSUME_NONNULL_BEGIN

@interface ShareTool : NSObject
-(void) initShareQQ:(NSString *)url toContent:(NSString *)content toResult:( FlutterResult)result ;
-(void) initShareAlipay:(NSString *) path toResult:( FlutterResult)result;
-(void) initShareWx:(NSString *) path toResult:( FlutterResult)result;
@end

NS_ASSUME_NONNULL_END
