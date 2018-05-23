//
//  ViewController.m
//  LearnOpenGLESWithGPUImage
//
//  Created by 林伟池 on 16/5/10.
//  Copyright © 2016年 林伟池. All rights reserved.
//

#import "ViewController.h"
#import "GPUImage.h"

@interface ViewController ()
@property (nonatomic, strong) NSMutableArray<GPUImageView *> *gpuImageViewArray;
@property (nonatomic, strong) NSMutableArray<GPUImageMovie *> *gpuImageMovieArray;

@property (nonatomic, strong) CADisplayLink *mDisplayLink;
@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.gpuImageViewArray = [[NSMutableArray<GPUImageView *> alloc] init];
    self.gpuImageMovieArray = [[NSMutableArray<GPUImageMovie *> alloc] init];
    NSArray *fileNamesArray = @[@"abc", @"qwe", @"abc", @"qwe", @"abc", @"qwe"];
    
    for (int indexRow = 0; indexRow < 2; ++indexRow) {
        for (int indexColumn = 0; indexColumn < 3; ++indexColumn) {
            CGRect frame = CGRectMake(CGRectGetWidth(self.view.bounds) / 3 * indexColumn,
                                      100 + CGRectGetWidth(self.view.bounds) / 3 * indexRow,
                                      CGRectGetWidth(self.view.bounds) / 3,
                                      CGRectGetWidth(self.view.bounds) / 3);
            GPUImageMovie *movie = [self getGPUImageMovieWithFileName:fileNamesArray[indexRow * 3 + indexColumn]];
            GPUImageView *view = [self buildGPUImageViewWithFrame:frame imageMovie:movie];
            [self.gpuImageViewArray addObject:view];
            [self.gpuImageMovieArray addObject:movie];
        }
    }
    
    self.mDisplayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displaylink:)];
    [self.mDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (GPUImageMovie *)getGPUImageMovieWithFileName:(NSString *)fileName {
    NSURL *videoUrl = [[NSBundle mainBundle] URLForResource:fileName withExtension:@"mp4"];
    
    GPUImageMovie *imageMovie = [[GPUImageMovie alloc] initWithURL:videoUrl];
    return imageMovie;
}

- (GPUImageView *)buildGPUImageViewWithFrame:(CGRect)frame imageMovie:(GPUImageMovie *)imageMovie {
    
    GPUImageView *imageView = [[GPUImageView alloc] initWithFrame:frame];
    [self.view addSubview:imageView];
    
    // 1080 1920，这里已知视频的尺寸。如果不清楚视频的尺寸，可以先读取视频帧CVPixelBuffer，再用CVPixelBufferGetHeight/Width
    GPUImageCropFilter *cropFilter = [[GPUImageCropFilter alloc] initWithCropRegion:CGRectMake((1920 - 1080) / 2 / 1920, 0, 1080.0 / 1920, 1)];
    
    [imageMovie addTarget:cropFilter];
    [cropFilter addTarget:imageView];
    imageMovie.playAtActualSpeed = YES;
    imageMovie.shouldRepeat = YES;
    
    [imageMovie startProcessing];
    
    return imageView;
}

- (void)displaylink:(CADisplayLink *)displaylink {
}




@end