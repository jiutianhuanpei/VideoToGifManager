//
//  VideoToGIfManager.m
//  TestDemo
//
//  Created by 沈红榜 on 2018/6/30.
//  Copyright © 2018年 沈红榜. All rights reserved.
//

#import "VideoToGifManager.h"
#import <AVFoundation/AVFoundation.h>

NSInteger const kTimesacle = 24;   //每秒帧率

@implementation VideoToGifManager

+ (void)videoToGifFromURL:(NSURL *)url complete:(void(^)(GifImage *gifImage))complete {
    
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    [self videoToGifFromAsset:asset complete:complete];
}


+ (void)videoToGifFromAsset:(AVURLAsset *)asset complete:(void(^)(GifImage *gifImage))complete {
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.requestedTimeToleranceBefore = kCMTimeZero;
    generator.requestedTimeToleranceAfter = kCMTimeZero;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        
        NSInteger currentPace = 0;
        
        NSInteger space = asset.duration.timescale / kTimesacle;
        
        while (currentPace < asset.duration.value) {
            
            CMTime time = CMTimeMake(currentPace, asset.duration.timescale);
            NSValue *value = [NSValue valueWithCMTime:time];
            [array addObject:value];
            currentPace += space;
        }
        
        NSMutableArray *images = [NSMutableArray arrayWithCapacity:0];
        
        __block NSInteger index = 0;
        
        [generator generateCGImagesAsynchronouslyForTimes:array completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
            
            index++;
            
            UIImage *img = [UIImage imageWithCGImage:image];
            if (img) {
                [images addObject:img];
            }
            
            if (index == array.count) {
                
                UIImage *gif = [UIImage animatedImageWithImages:images duration:CMTimeGetSeconds(asset.duration)];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    !complete ?: complete(gif);
                });
            }
        }];
    });
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
