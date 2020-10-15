//
//  MobApmTypeDefine.h
//  MobApm
//
//  Created by maxl on 2020/7/2.
//  Copyright © 2020 mob. All rights reserved.
//

#ifndef MobApmTypeDefine_h
#define MobApmTypeDefine_h

#import <UIKit/UIKit.h>
typedef NS_OPTIONS(NSUInteger, MobApmOptions) {
    MobApmOptionsAppLaunch = 1 << 0,
    MobApmOptionsNetwork = 1 << 1,
    MobApmOptionsAll = ~0UL
};


#endif /* MobApmTypeDefine_h */
