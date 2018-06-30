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

+ (void)videoToGifFromURL:(NSURL *)url complete:(void(^)(GifImage *gifImage))complete;

@end
