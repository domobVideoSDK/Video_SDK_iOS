//
//  ViewController.m
//  AssetZoneVideoSample
//
//  Created by wangxijin on 8/11/14.
//  Copyright (c) 2014 domob. All rights reserved.
//

#import "VideoViewController.h"
#import "IndependentVideoManager.h"

@interface VideoViewController () <IndependentVideoManagerDelegate>{
    
    IndependentVideoManager *_manager;

}

@property (retain, nonatomic) IBOutlet UILabel *label;
@property (retain, nonatomic) IBOutlet UIButton *playButton;
@end

@implementation VideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self setTitle:@"视频"];
    
    _playButton.enabled = NO;
    //初始化方法 96ZJ2RsQzeNxTwTCsB 96ZJ36PAzfhNjwTPP6
    _manager = [[IndependentVideoManager alloc]
                                initWithPublisherID:@"96ZJ2RsQzeNxTwTCsB"
                                          andUserID:nil];
    //设置代理
    _manager.delegate = self;
    
    //是否禁用提示框,默认为NO
    _manager.disableShowAlert = NO;
}

#pragma mark - UIResponder
- (IBAction)showVideo{
    
    [_manager presentIndependentVideo];
}

- (IBAction)playVideo {
    
    [_manager presentIndependentVideo];
    
}

- (IBAction)checkVideoAvailable {
    
    [_manager checkVideoAvailable];
}

#pragma mark - Manager Delegate
// 开始加载视频
- (void)ivManagerDidStartLoad:(IndependentVideoManager *)manager {
    
    NSLog(@"<demo>VideoDidStartLoad");
}

// 视频加载完成
- (void)ivManagerDidFinishLoad:(IndependentVideoManager *)manager finished:(BOOL)isFinished
{
    NSLog(@"<demo>VideoDidFinishLoad");
    if (isFinished) {
    
        _label.text = @"缓存完成";
        //加载完让按钮可用
        _playButton.enabled = YES;
    }
}

// 视频加载失败。可能的原因由error部分提供，例如网络连接失败、被禁用等。
- (void)ivManager:(IndependentVideoManager *)manager
failedLoadWithError:(NSError *)error {
    
    NSLog(@"<demo>VideoFailedLoadWithError:%@",error);
}

// 当视频要被呈现出来时，回调该方法
- (void)ivManagerWillPresent:(IndependentVideoManager *)manager {
    _playButton.enabled = NO;
    NSLog(@"<demo>VideoWillPresent");
}

// 当视频被关闭。
- (void)ivManagerDidClosed:(IndependentVideoManager *)manager {
    
    NSLog(@"<demo>VideoDidClosed");
    _playButton.enabled = NO;
    _label.text = @"";
    [manager checkVideoAvailable];
}
// 视频播放完成
- (void)ivManagerCompletePlayVideo:(IndependentVideoManager *)manager{
    
    NSLog(@"<demo>VideoCompletePlay");

}

// 播放视频失败
- (void)ivManagerPlayIndependentVideo:(IndependentVideoManager *)manager
                            withError:(NSError *)error {
    NSLog(@"PlayVideoWithError:%@",error);
}

// 检查视频状态的回调
- (void)ivManager:(IndependentVideoManager *)manager
isIndependentVideoAvailable:(IndependentVideoAvailableState)availableState {
      
    if (availableState == eIVVideoStateFinishedCache) {
        
        _label.text = [NSString stringWithFormat:@"缓存完成"];
        _playButton.enabled = YES;
        
    }
    else if (availableState == eIVVideoStateDownloading){
        _playButton.enabled = NO;
        _label.text = [NSString stringWithFormat:@"正在下载"];
    }
    else{
        _playButton.enabled = NO;
        _label.text = @"无可用视频";
    }
}

@end
