//
//  SpeakerUtil.m
//  Runner
//
//  Created by FH on 2020/5/21.
//  Copyright © 2020年 The Chromium Authors. All rights reserved.
//

#import "SpeakerUtil.h"

@implementation SpeakerUtil

- (void)initSpeaker{
    
    NSString *initString=[[NSString alloc] initWithFormat:@"appid=%@",@"5e8984db"];
    [IFlySpeechUtility createUtility:initString];
    if(_iFlySpeechRecognizer==nil){
        _iFlySpeechRecognizer=[IFlySpeechRecognizer sharedInstance];}
    
    // 设置参数
    if (_iFlySpeechRecognizer != nil) {
        //扩展参数
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
        //设置听写模式
        [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
        //设置最长录音时间
        [_iFlySpeechRecognizer setParameter:@"30000" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [_iFlySpeechRecognizer setParameter:@"1800" forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [_iFlySpeechRecognizer setParameter:@"1800" forKey:[IFlySpeechConstant VAD_BOS]];
        //网络等待时间
        [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        //设置采样率，推荐使用16K
        [_iFlySpeechRecognizer setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
        //设置语言
        [_iFlySpeechRecognizer setParameter:@"zh_cn" forKey:[IFlySpeechConstant LANGUAGE]];
        //设置方言
        [_iFlySpeechRecognizer setParameter:@"mandarin" forKey:[IFlySpeechConstant ACCENT]];
        //设置是否返回标点符号
        [_iFlySpeechRecognizer setParameter:@"0" forKey:[IFlySpeechConstant ASR_PTT]];
        //设置数据返回格式
        [_iFlySpeechRecognizer setParameter:@"plain" forKey:[IFlySpeechConstant RESULT_TYPE]];
        
    }
    // 设置代理
    _iFlySpeechRecognizer.delegate = self;
}
- (void)startSpeakerWith:(FlutterEventSink)result{
    _resultSink=result;
    [_iFlySpeechRecognizer startListening];
    
}

- (void)onResults:(NSArray *)results isLast:(BOOL)isLast{
    if(results!=nil){
        NSLog(@"arr123:%@",results);
        NSMutableString *result=[[NSMutableString alloc] init];
        NSDictionary *nsContent=results[0];
        for(NSString *key in nsContent){
            [result appendString:key];
        }
        _resultSink(result);
    }else{
        NSString *speakContent=@"";
        _resultSink(speakContent);
    }
}
- (void)onCompleted:(IFlySpeechError *)errorCode{
    //NSLog(@"====%@",errorCode.errorDesc);
}

- (void)onEndOfSpeech{
    
}
- (void)onBeginOfSpeech{
    
}
- (void)onVolumeChanged:(int)volume{
    
}
- (void)onCancel{
    
}

- (void)stopSpeaker{
    [_iFlySpeechRecognizer stopListening];
    if(_resultSink!=nil){
        NSString *speakContent=@"";
        _resultSink(speakContent);
    }
    
}

@end
