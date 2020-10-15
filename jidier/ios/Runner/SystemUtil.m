//
//  SystemUtil.m
//  Runner
//
//  Created by FH on 2020/1/8.
//  Copyright © 2020年 The Chromium Authors. All rights reserved.
//

#import "SystemUtil.h"

@implementation SystemUtil
//调起游览器打开网址
+ (void)openUrl:(NSString *)url{
    if(url==nil||url==@""){
       return ;
       }
     NSURL *openUrl=[NSURL URLWithString:[NSString stringWithFormat:@"%@",url]];
    [[UIApplication sharedApplication] openURL:openUrl];
}
//拨打电话
+ (void)callNum:(NSString *)num{
    if(num==nil||num==@""){
        return ;
    }
   NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",num];
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:str]];
}

@end
