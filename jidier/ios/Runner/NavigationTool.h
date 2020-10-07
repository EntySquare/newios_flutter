//
//  NavigationTool.h
//  Runner
//
//  Created by FH on 2020/1/2.
//  Copyright © 2020年 The Chromium Authors. All rights reserved.
//导航工具类

//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NavigationTool : NSObject
-(instancetype)init;
-(NSString *) isInstallGaode;
-(NSString *) isInstallTenxun;
-(NSString *) isInstallMap;
-(void)openGaode:(int)way toStartLat:(float )startLat toStartLng:(float)startLng toEndLat:(float)endLat toEndLng:(float)endLng toEndName:(NSString *)endName;
-(void)openTenxun:(int)way toStarLat:(float)starLat toStartLng:(float)starLng toAddressName:(NSString *)addressName toEndLat:(float)endLat toEndLng:(float)endLng;
-(void)openIos:(int)way toAddressName:(NSString *) addressName toStarLat:(float) starLat toStarLng:(float) starLng toEndLat:(float)endLat toEndLng:(float)endLng;
@end

NS_ASSUME_NONNULL_END
