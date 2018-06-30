# VideoToGifManager
视频转gif图片

示例代码：

```
[VideoToGifManager videoToGifFromURL:url timeRang:NSMakeRange(15, 5) complete:^(GifImage *gifImage, NSError *error) {
	NSLog(@"error: %@", error);
	SHB.imgView.image = gifImage;
}];
        
[VideoToGifManager videoToGifFromURL:url maxDuration:10 complete:^(GifImage *gifImage, NSError *error) {
	NSLog(@"error: %@", error);
	SHB.secView.image = gifImage;
}];
```


