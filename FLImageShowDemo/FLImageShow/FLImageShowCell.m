//
//  FLImageShowCell.m
//  FLImageShowDemo
//
//  Created by fuliang on 16/2/25.
//  Copyright © 2016年 fuliang. All rights reserved.
//

#import "FLImageShowCell.h"
#import "UIImageView+WebCache.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation FLImageShowCell

- (void)awakeFromNib
{
    //设置实现缩放
    //设置代理scrollview的代理对象
    _scrollView.delegate=self;
    //设置最大伸缩比例
    _scrollView.maximumZoomScale = 2.0;
    //设置最小伸缩比例
    _scrollView.minimumZoomScale = 1;
    
    _imageView = [[UIImageView alloc] init];
    _scrollView.childView = _imageView;
}

- (void)updateImageViewFrame:(UIImage *)image
{
    CGFloat mainScreenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat mainScreenHeight = [UIScreen mainScreen].bounds.size.height;
    
    CGSize imageSize = image.size;
    CGSize imageViewSize;
    if (imageSize.width > mainScreenWidth)
    {
        imageViewSize = CGSizeMake(mainScreenWidth, imageSize.height / imageSize.width * mainScreenWidth);
        if (imageViewSize.height > mainScreenHeight)
        {
            imageViewSize = CGSizeMake(imageSize.width / imageSize.height * mainScreenHeight, mainScreenHeight);
        }
    }
    else
    {
        if (imageViewSize.height > mainScreenHeight)
        {
            imageViewSize = CGSizeMake(imageSize.width / imageSize.height * mainScreenHeight, mainScreenHeight);
        }
        else
        {
            imageViewSize = imageSize;
        }
    }
    _imageView.frame = CGRectMake(0, 0, imageViewSize.width, imageViewSize.height);
    _scrollView.childView = _imageView;
}
#pragma mark--重写
- (void)setLocalImageName:(NSString *)localImageName
{
    _localImageName = localImageName;
    _imageView.image = [UIImage imageNamed:localImageName];
    [self updateImageViewFrame:_imageView.image];
}
- (void)setNetImageUrl:(NSString *)netImageUrl
{
    _netImageUrl = netImageUrl;
    [_imageView sd_setImageWithURL:[NSURL URLWithString:netImageUrl] placeholderImage:[UIImage imageNamed:@"image_default"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [self updateImageViewFrame:image];
    }];
}
- (void)setAlbumImageUrl:(NSURL *)albumImageUrl
{
    _albumImageUrl = albumImageUrl;
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library assetForURL:albumImageUrl resultBlock:^(ALAsset *asset) {
        ALAssetRepresentation *representation = asset.defaultRepresentation;
        _imageView.image = [UIImage imageWithCGImage:representation.fullScreenImage];
        [self updateImageViewFrame:_imageView.image];
    } failureBlock:^(NSError *error) {
        NSLog(@"相册url错误");
    }];
}

#pragma mark--UIScrollViewDelegate
-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return _imageView;
}
@end
