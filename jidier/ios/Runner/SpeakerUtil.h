//
//  SpeakerUtil.h
//  Runner
//
//  Created by FH on 2020/5/21.
//  Copyright © 2020年 The Chromium Authors. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iflyMSC/iflyMSC.h>
#import <iflyMSC/IFlySpeechRecognizer.h>
#import <iflyMSC/IFlySpeechRecognizerDelegate.h>
#import <Flutter/Flutter.h>
@interface SpeakerUtil : NSObject<IFlySpeechRecognizerDelegate>
@property(nonatomic,strong) IFlySpeechRecognizer *iFlySpeechRecognizer;
@property(nonatomic,strong)  FlutterEventSink resultSink;
-(void) initSpeaker;
-(void) startSpeakerWith:(FlutterEventSink) result;
-(void) stopSpeaker;
@end
