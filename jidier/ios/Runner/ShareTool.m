//
//  ShareTool.m
//  Runner
//
//  Created by FH on 2020/1/2.
//  Copyright © 2020年 The Chromium Authors. All rights reserved.
//分享工具类
//

#import "ShareTool.h"
@implementation ShareTool
- (instancetype)init
{
    self = [super init];
    if (self) {
        [ShareSDK registPlatforms:^(SSDKRegister *platformsRegister) {
            //QQ
           //[platformsRegister setupQQWithAppId:@"1109901562" appkey:@"w3vwID1zUaFqQS5L"];
            [platformsRegister setupQQWithAppId:@"1109901562" appkey:@"w3vwID1zUaFqQS5L" enableUniversalLink:YES universalLink:@"https://www.sandslee.com/"];
            //微信
            [platformsRegister setupWeChatWithAppId:@"WXE5489F425E32F89F" appSecret:@"9724fbbc0599a2a07bc0525c26f76e19" universalLink:@"https://www.sandslee.com/"];
            
            //阿里支付
            [platformsRegister setupAliSocialWithAppId:@"2021001103615444"];
            
        }];
    }
    return self;
}
//分享到QQ好友
- (void)initShareQQ:(NSString *)url toContent:(NSString *)content toResult:(FlutterResult)result{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //[params SSDKSetupQQParamsByText:@"点击跳转记地儿，实现地址导航" images:nil url:[NSURL URLWithString:url] title:content //type:SSDKContentTypeWebPage];
    
    [params SSDKSetupQQParamsByText:@"点击跳转记地儿，实现地址导航" title:content url:[NSURL URLWithString:url] audioFlashURL:nil videoFlashURL:nil thumbImage:@"AppIcon180x180.png" images:nil type:SSDKContentTypeWebPage forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    
    
    [ShareSDK share:SSDKPlatformTypeQQ
         parameters:params
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData,
                      SSDKContentEntity *contentEntity, NSError *error) {
         
         switch (state) {
             case SSDKResponseStateSuccess:
                 NSLog(@"成功");//成功
                 result(0);
                 break;
             case SSDKResponseStateFail:
             {
                 NSLog(@"--%@",error.description);
                 //失败
                 
                 result(0);
                 break;
             }
             case SSDKResponseStateCancel:
                 //取消
                 result(0);
                 break;
                 
             default:
                 result(0);
                 break;
         }
     }];
    
    
}
//分享到支付宝好友
- (void)initShareAlipay:(NSString *)path toResult:(FlutterResult)result{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params SSDKSetupShareParamsByText:@"记地儿" images:[UIImage imageNamed:path] url:nil title:@"记地儿" type:SSDKContentTypeImage];
    
    [ShareSDK share:SSDKPlatformTypeAliSocialTimeline
         parameters:params
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData,
                      SSDKContentEntity *contentEntity, NSError *error) {
         
         switch (state) {
             case SSDKResponseStateSuccess:
                 NSLog(@"成功");//成功
                 result(0);
                 break;
             case SSDKResponseStateFail:
             {
                 NSLog(@"--%@",error.description);
                 //失败
                 
                 result(0);
                 break;
             }
             case SSDKResponseStateCancel:
                 //取消
                 result(0);
                 break;
                 
             default:
                 result(0);
                 break;
         }
     }];
}
//分享到微信好友

- (void)initShareWx:(NSString *)path toResult:(FlutterResult)result{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params SSDKSetupShareParamsByText:@"记地儿" images:[UIImage imageNamed:path] url:nil title:@"记地儿" type:SSDKContentTypeImage];
    [ShareSDK share:SSDKPlatformTypeWechat
         parameters:params
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData,
                      SSDKContentEntity *contentEntity, NSError *error) {
         
         switch (state) {
             case SSDKResponseStateSuccess:
                 NSLog(@"成功");//成功
                 result(0);
                 break;
             case SSDKResponseStateFail:
             {
                 NSLog(@"--%@",error.description);
                 //失败
                 
                 result(@1.0);
                 break;
             }
             case SSDKResponseStateCancel:
                 //取消
                 result(0);
                 break;
                 
             default:
                 result(0);
                 break;
         }
     }];
    
}



@end
