//
//  NetImagesVC.m
//  FLImageShowDemo
//
//  Created by fuliang on 16/2/26.
//  Copyright © 2016年 fuliang. All rights reserved.
//

#import "NetImagesVC.h"
#import "FLImageShowVC.h"
#import "UIImageView+WebCache.h"

@interface NetImagesVC ()
@property (nonatomic,strong)NSArray *imageUrls;
@end

@implementation NetImagesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    _imageUrls = @[@"http://pica.nipic.com/2007-11-09/200711912453162_2.jpg", @"http://pic13.nipic.com/20110415/1347158_132411659346_2.jpg", @"http://pic.nipic.com/2007-11-09/200711912230489_2.jpg", @"http://pic.nipic.com/2007-11-08/2007118192311804_2.jpg", @"http://img3.redocn.com/20101213/20101211_0e830c2124ac3d92718fXrUdsYf49nDl.jpg", @"http://pic12.nipic.com/20110209/2929643_150952237191_2.jpg", @"http://pic23.nipic.com/20120812/4277683_204018483000_2.jpg", @"http://img2.niutuku.com/desk/anime/3354/3354-4958.jpg"];
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initUI
{
    CGFloat width = 80;
    CGFloat fxWidth = ([UIScreen mainScreen].bounds.size.width - 3 * width) / 4;
    [_imageUrls enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger hang = idx / 3;
        NSInteger lie = idx % 3;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((lie + 1) * fxWidth + lie * width, (hang + 1) * fxWidth + hang * width + 64, width, width)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:obj] placeholderImage:[UIImage imageNamed:@"image_default"]];
        imageView.tag = idx;
        [self.view addSubview:imageView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewAction:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
    }];
}

#pragma mark--点击
- (void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageViewAction:(UITapGestureRecognizer *)tap
{
    UIImageView *imageView = (UIImageView *)tap.view;
    NSInteger tag = imageView.tag;
    NSString *imageUrl = _imageUrls[tag];
    NSLog(@"点击%@",imageUrl);
    
    FLImageShowVC *fvc = [[FLImageShowVC alloc] init];
    fvc.netImageUrlsArray = _imageUrls;
    fvc.currentIndex = tag;
    [self.navigationController pushViewController:fvc animated:YES];
}

@end
