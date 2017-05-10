//
//  MDHotelVideoTableViewCell.m
//  Maldives
//
//  Created by Tian Wei You on 16/8/16.
//  Copyright © 2016年 Shanghai DuRui Information Technology Company. All rights reserved.
//

#import "MDHotelVideoTableViewCell.h"

@implementation MDHotelVideoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setVideoUrlStr:(NSString *)videoUrlStr{
    if (!videoUrlStr)return;
    _videoUrlStr = videoUrlStr;
    [self makeVideo];
}

- (void)makeVideo{
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:self.videoUrlStr] options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    [player seekToTime:CMTimeMake(1,1)];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = CGRectMake(10.f, 0.f, KScreenWidth - 20.f, 200.f*KScreenWidth/355.f);
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.layer addSublayer:playerLayer];
    [self makePlayBtn];
    
}
- (void)makePlayBtn{
    UIButton * playBtn = [[UIButton alloc]initWithFrame:CGRectMake(10.f, 0.f, KScreenWidth - 20.f, 200.f*KScreenWidth/355.f)];
    playBtn.backgroundColor = [UIColor colorWithWhite:0.2f alpha:0.6f];
    [playBtn addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:playBtn];
    
    CGFloat readyImageViewWeight = 72.f;
    UIImageView * readyImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0.f, 0.f, readyImageViewWeight, readyImageViewWeight)];
    readyImageView.image = [UIImage imageNamed:@"video_stop_white"];
    readyImageView.center = playBtn.center;
    readyImageView.layer.cornerRadius = readyImageViewWeight/2;
    readyImageView.layer.masksToBounds = YES;
    readyImageView.backgroundColor = [UIColor colorWithWhite:0.6f   alpha:0.8f];
    [self addSubview:readyImageView];
}

- (void)playVideo{
    self.readyToPlayBlock(self.videoUrlStr);
}

@end
