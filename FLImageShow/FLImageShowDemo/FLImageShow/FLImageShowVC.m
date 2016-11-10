//
//  FLImageShowVC.m
//  FLImageShowDemo
//
//  Created by fuliang on 16/2/25.
//  Copyright © 2016年 fuliang. All rights reserved.
//

#import "FLImageShowVC.h"
#import "FLImageShowCell.h"

typedef enum : NSUInteger {
    FLImageShowTypeLocal,
    FLImageShowTypeNet,
    FLImageShowTypeAlbum,
    FLImageShowTypeError,
} ImageType;

@interface FLImageShowVC ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *myCollectionView;
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *topLabel;
@property (nonatomic,assign)ImageType imageType;
@end

@implementation FLImageShowVC

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加检测旋转通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getNotWithIentationChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    //ui设置
    _topView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    
    //根据数组得出图片类型
    if (_localImageNamesArray.count > 0)
    {
        _imageType = FLImageShowTypeLocal;
        _topLabel.text = [NSString stringWithFormat:@"%ld/%lu",_currentIndex + 1, (unsigned long)_localImageNamesArray.count];
    }
    else if (_netImageUrlsArray.count > 0)
    {
        _imageType = FLImageShowTypeNet;
        _topLabel.text = [NSString stringWithFormat:@"%ld/%lu",_currentIndex + 1, (unsigned long)_netImageUrlsArray.count];
    }
    else if (_albumImageUrlArray.count > 0)
    {
        _imageType = FLImageShowTypeAlbum;
        _topLabel.text = [NSString stringWithFormat:@"%ld/%lu",_currentIndex + 1, (unsigned long)_albumImageUrlArray.count];
    }
    else
    {
        _imageType = FLImageShowTypeError;
        _topLabel.text = @"0/0";
    }
    
    
    [_myCollectionView registerNib:[UINib nibWithNibName:@"FLImageShowCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"FLImageShowCell"];
   
    //设置layout
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenheight = [UIScreen mainScreen].bounds.size.height;
    
    _myCollectionView.pagingEnabled = YES;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(screenWidth, screenheight);
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 10);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 10;
    _myCollectionView.collectionViewLayout = layout;
    
    _myCollectionView.showsVerticalScrollIndicator = NO;
    _myCollectionView.showsHorizontalScrollIndicator = NO;
    
    //添加手势
    UITapGestureRecognizer *singleViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleViewTapAction)];
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:singleViewTap];
    
    UITapGestureRecognizer *doubleViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleViewTapAction)];
    doubleViewTap.numberOfTapsRequired = 2;
    self.view.userInteractionEnabled = YES;
    [self.view addGestureRecognizer:doubleViewTap];
    
    [singleViewTap requireGestureRecognizerToFail:doubleViewTap];
    
    [self rotateView];
    
    //滚动到当前图片位置
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_currentIndex inSection:0];
    [_myCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

#pragma mark--旋转
/**
 *  旋转self.view
 */
- (void)rotateView
{
    CGFloat mainScreenWidth = [[UIApplication sharedApplication].delegate window].bounds.size.width;
    CGFloat mainScreenHeight = [[UIApplication sharedApplication].delegate window].bounds.size.height;
    UIDeviceOrientation orient = [UIDevice currentDevice].orientation;
    switch (orient)
    {
        case UIDeviceOrientationPortrait:
        {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", DeviceOrientationVertical] forKey:DeviceOrientationKey];
            [UIView animateWithDuration:0.5 animations:^{
                self.view.transform = CGAffineTransformIdentity;
            }];
            self.view.frame = CGRectMake(0, 0, mainScreenWidth, mainScreenHeight);
            [self.view layoutIfNeeded];
            //设置layout
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout.itemSize = CGSizeMake(mainScreenWidth, mainScreenHeight);
            layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 10);
            layout.minimumInteritemSpacing = 0;
            layout.minimumLineSpacing = 10;
            _myCollectionView.collectionViewLayout = layout;
            break;
        }
        case UIDeviceOrientationPortraitUpsideDown:
        {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", DeviceOrientationVertical] forKey:DeviceOrientationKey];
            [UIView animateWithDuration:0.5 animations:^{
                self.view.transform = CGAffineTransformIdentity;
            }];
            self.view.frame = CGRectMake(0, 0, mainScreenWidth, mainScreenHeight);
            [self.view layoutIfNeeded];
            //设置layout
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout.itemSize = CGSizeMake(mainScreenWidth, mainScreenHeight);
            layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 10);
            layout.minimumInteritemSpacing = 0;
            layout.minimumLineSpacing = 10;
            _myCollectionView.collectionViewLayout = layout;
            break;
        }
        case UIDeviceOrientationLandscapeLeft:
        {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", DeviceOrientationHorizontal] forKey:DeviceOrientationKey];
            [UIView animateWithDuration:0.5 animations:^{
                self.view.transform = CGAffineTransformMakeRotation(M_PI / 2);
            }];
            
            self.view.frame = CGRectMake(0, 0, mainScreenWidth, mainScreenHeight);
            //设置layout
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout.itemSize = CGSizeMake(mainScreenHeight, mainScreenWidth);
            layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 10);
            layout.minimumInteritemSpacing = 0;
            layout.minimumLineSpacing = 10;
            _myCollectionView.collectionViewLayout = layout;
            break;
        }
        case UIDeviceOrientationLandscapeRight:
        {
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld", DeviceOrientationHorizontal] forKey:DeviceOrientationKey];
            [UIView animateWithDuration:0.5 animations:^{
                self.view.transform = CGAffineTransformMakeRotation(M_PI / 2 * 3);
            }];
            self.view.frame = CGRectMake(0, 0, mainScreenWidth, mainScreenHeight);
            //设置layout
            UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
            layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
            layout.itemSize = CGSizeMake(mainScreenHeight, mainScreenWidth);
            layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 10);
            layout.minimumInteritemSpacing = 0;
            layout.minimumLineSpacing = 10;
            _myCollectionView.collectionViewLayout = layout;
            break;
        }
        default:
            break;
    }
}
#pragma mark--通知
- (void)getNotWithIentationChange:(NSNotification *)not
{
    [self rotateView];
}
#pragma mark--点击
- (void)singleViewTapAction
{
    _topView.hidden = !_topView.hidden;
}
- (void)doubleViewTapAction
{
    FLImageShowCell *cell = (FLImageShowCell *)[_myCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    [UIView animateWithDuration:0.5 animations:^{
        cell.scrollView.zoomScale = cell.scrollView.zoomScale == 1 ? cell.scrollView.maximumZoomScale : 1;
    }];
}
- (IBAction)topLeftBtnClick:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark--UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //滑动后改变顶部显示的当前位置
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    _currentIndex = scrollView.contentOffset.x / screenWidth + 0.5;
    NSInteger allCount = 0;
    switch (_imageType)
    {
        case FLImageShowTypeLocal:
        {
            allCount = _localImageNamesArray.count;
        }
            break;
        case FLImageShowTypeNet:
        {
            allCount = _netImageUrlsArray.count;
        }
            break;
        case FLImageShowTypeAlbum:
        {
            allCount = _albumImageUrlArray.count;
        }
            break;
            
        default:
        {
            allCount = 0;
        }
            break;
    }
    _topLabel.text = [NSString stringWithFormat:@"%ld/%ld",_currentIndex + 1, allCount];
}

#pragma mark--UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    switch (_imageType)
    {
        case FLImageShowTypeLocal:
        {
            return _localImageNamesArray.count;
        }
            break;
        case FLImageShowTypeNet:
        {
            return _netImageUrlsArray.count;
        }
            break;
        case FLImageShowTypeAlbum:
        {
            return _albumImageUrlArray.count;
        }
            break;
            
        default:
        {
            return 0;
        }
            break;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FLImageShowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FLImageShowCell" forIndexPath:indexPath];
    cell.scrollView.zoomScale = 1.0;
    switch (_imageType)
    {
        case FLImageShowTypeLocal:
        {
            cell.localImageName = _localImageNamesArray[indexPath.row];
        }
            break;
        case FLImageShowTypeNet:
        {
            cell.netImageUrl = _netImageUrlsArray[indexPath.row];
        }
            break;
        case FLImageShowTypeAlbum:
        {
            cell.albumImageUrl = _albumImageUrlArray[indexPath.row];
        }
            break;
            
        default:
        {
            return nil;
        }
            break;
    }
    return cell;
}
@end
