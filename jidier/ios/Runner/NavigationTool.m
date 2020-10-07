//
//  NavigationTool.m
//  Runner
//
//  Created by FH on 2020/1/2.
//  Copyright © 2020年 The Chromium Authors. All rights reserved.
//

#import "NavigationTool.h"

@implementation NavigationTool
- (instancetype)init
{
    self = [super init];
    if (self) {
       
    }
    return self;
}
- (NSString *)isInstallGaode{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        return @"true";}else{
            return (@"false");
        }
}
- (NSString *)isInstallTenxun{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        return @"true";
    }else{
            return @"false";
        }
    
}
- (NSString *)isInstallMap{
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"http://maps.apple.com/"]]) {
       return  @"true";
        
    }else{
        return @"false";
    }
    
}


/**唤起高德地图**/
- (void)openGaode:(int)way toStartLat:(float)startLat toStartLng:(float)startLng toEndLat:(float)endLat toEndLng:(float)endLng toEndName:(NSString *)endName{
    NSString *tripMode=@"0";
    switch (way) {
        case 0:
            tripMode=@"0";
            break;
        case 1:
            tripMode=@"1";
            break;
        case 2:
            tripMode=@"2";
            break;
    }
    
    NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=ApplicationName&sid=BGVIS1&slat=%f&slon=%f&sname=当前位置&did=BGVIS2&dlat=%f&dlon=%f&dname=%@&dev=%@&m=0&t=%@",startLat,startLng,endLat,endLng,endName,tripMode,tripMode] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([[UIDevice currentDevice].systemVersion integerValue] >= 10) { //iOS10以后,使用新API
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) { NSLog(@"scheme调用结束"); }];
        
    } else { //iOS10以前,使用旧API
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        
    }
    
}
/**唤起腾讯地图**/
- (void)openTenxun:(int)way toStarLat:(float)starLat toStartLng:(float)starLng toAddressName:(NSString *)addressName toEndLat:(float)endLat toEndLng:(float)endLng{
    NSString *type=@"drive";
    
    switch (way) {
        case 0:
            type=@"drive";
            break;
        case 1:
            type=@"bus";
            break;
        case 2:
            type=@"walk";
            break;
    }
    
    
    
    NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=当前位置&fromcoord=%f,%f&type=%@&tocoord=%f,%f&to=%@&coord_type=1&policy=0",starLat,starLng,type,endLat, endLng,addressName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([[UIDevice currentDevice].systemVersion integerValue] >= 10) { //iOS10以后,使用新API
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) { NSLog(@"scheme调用结束"); }];
        
    } else { //iOS10以前,使用旧API
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
        
    }
    
}
- (void)openIos:(int)way toAddressName:(NSString *)addressName toStarLat:(float)starLat toStarLng:(float)starLng toEndLat:(float)endLat toEndLng:(float)endLng{
    CLLocationCoordinate2D loc=CLLocationCoordinate2DMake(endLat,endLng);
    //用户位置
    MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
    //终点位置
    MKMapItem *toLocation = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc]initWithCoordinate:loc addressDictionary:nil] ];
    toLocation.name=addressName;
    
    NSArray *items = @[currentLoc,toLocation];
    //第一个
    NSDictionary *dic ;
    switch (way) {
        case 0:
            dic = @{
                    MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving,
                    MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                    MKLaunchOptionsShowsTrafficKey : @(YES)
                    };
            break;
            
        case 1:
            dic = @{
                    MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeTransit,
                    MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                    MKLaunchOptionsShowsTrafficKey : @(YES)
                    };
            break;
        case 2:
            dic = @{
                    MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeWalking,
                    MKLaunchOptionsMapTypeKey : @(MKMapTypeStandard),
                    MKLaunchOptionsShowsTrafficKey : @(YES)
                    };
            
            break;
            
    }
    
    
    //第二个，都可以用
    //    NSDictionary * dic = @{MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving,
    //                           MKLaunchOptionsShowsTrafficKey: [NSNumber numberWithBool:YES]};
    
    [MKMapItem openMapsWithItems:items launchOptions:dic];
    
}


@end
