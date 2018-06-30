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

+ (void)videoToGifFromURL:(NSURL *)url complete:(void (^)(GifImage *, NSError *))complete {
    
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];

    [self _videoToGifFromAsset:asset timeRang:NSMakeRange(NSNotFound, 0) complete:complete];
}

+ (void)videoToGifFromURL:(NSURL *)url maxDuration:(NSTimeInterval)maxDuation complete:(void (^)(GifImage *, NSError *))complete {
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];

    NSTimeInterval duration = 0;
    
    if (maxDuation > 0) {
        duration = maxDuation;
    } else {
        duration = CMTimeGetSeconds(asset.duration);
    }

    [self _videoToGifFromAsset:asset timeRang:NSMakeRange(0, duration) complete:complete];
}

+ (void)videoToGifFromURL:(NSURL *)url timeRang:(NSRange)timeRang complete:(void (^)(GifImage *, NSError *))complete {
    AVURLAsset *asset = [AVURLAsset assetWithURL:url];
    [self _videoToGifFromAsset:asset timeRang:timeRang complete:complete];
}

+ (void)_videoToGifFromAsset:(AVURLAsset *)asset timeRang:(NSRange)timeRang complete:(void(^)(GifImage *gifImage, NSError *error))complete {
    
    NSTimeInterval duration = CMTimeGetSeconds(asset.duration);
    
    //参数校验
    
    if (timeRang.location == NSNotFound) {
        
    } else if (timeRang.location > duration - 1) {
        NSError *error = [NSError errorWithDomain:@"起始时间不能晚于视频时长" code:666 userInfo:nil];
        NSLog(@"error: %@", error);
        !complete ?: complete(nil, error);
        return;
    } else if (timeRang.location + timeRang.length > duration) {
        NSError *error = [NSError errorWithDomain:@"结束时间不能迟于视频时长" code:666 userInfo:nil];
        NSLog(@"error: %@", error);
        !complete ?: complete(nil, error);
        return;
    }
    
    NSInteger timescale = asset.duration.timescale;
    NSInteger space = timescale / kTimesacle;
    NSInteger maxPace = asset.duration.value;
    
    __block NSInteger currentPace = 0;
    
    CMTimeShow(asset.duration);
    //
    if (timeRang.location != NSNotFound) {
        duration = timeRang.length;
        currentPace = timeRang.location * timescale;
        maxPace = (timeRang.location + timeRang.length) * timescale;
    } else {
        duration = CMTimeGetSeconds(asset.duration);
    }
    
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.requestedTimeToleranceBefore = kCMTimeZero;
    generator.requestedTimeToleranceAfter = kCMTimeZero;
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        
        while (currentPace < maxPace) {
            
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
                
                UIImage *gif = [UIImage animatedImageWithImages:images duration:duration];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    !complete ?: complete(gif, nil);
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
