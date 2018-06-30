//
//  VideoToGIfManager.h
//  TestDemo
//
//  Created by 沈红榜 on 2018/6/30.
//  Copyright © 2018年 沈红榜. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef UIImage GifImage;

@interface VideoToGifManager : UIView

/**
 把整个视频转成gif图片

 @param url 视频的url
 @param complete 回调
 */
+ (void)videoToGifFromURL:(NSURL *)url
                 complete:(void(^)(GifImage *gifImage, NSError *error))complete;

/**
 截取视频的前几秒转成gif图片

 @param url 视频的url
 @param maxDuration 要转成gif图片的视频前几秒
 @param complete 回调
 */
+ (void)videoToGifFromURL:(NSURL *)url
              maxDuration:(NSTimeInterval)maxDuration
                 complete:(void(^)(GifImage *gifImage, NSError *error))complete;

/**
 截取视频片断转成gif图片

 @param url 视频的url
 @param timeRang 要截取的视频的时间区间
 @param complete 回调
 */
+ (void)videoToGifFromURL:(NSURL *)url
                    timeRang:(NSRange)timeRang
                    complete:(void(^)(GifImage *gifImage, NSError *error))complete;


@end
