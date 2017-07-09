/*
 * Copyright (C) 2013-2015 Bilibili
 * Copyright (C) 2013-2015 Zhang Rui <bbcallen@gmail.com>
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "IJKMoviePlayerViewController.h"
#import "IJKMediaControl.h"


@implementation IJKVideoViewController

- (void)dealloc
{
}

+ (void)presentFromViewController:(UIViewController *)viewController withTitle:(NSString *)title URL:(NSURL *)url completion:(void (^)())completion {
    [viewController presentViewController:[[IJKVideoViewController alloc] initWithURL:url] animated:YES completion:completion];
}
-(void)didVideoChange:(int)width andVideoHeight:(int)height{
    NSLog(@"Modona create:width:%d,height:%d",width,height);
}
- (instancetype)initWithURL:(NSURL *)url {
    self = [self initWithNibName:@"IJKMoviePlayerViewController" bundle:nil];
    if (self) {
        self.url = url;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#define EXPECTED_IJKPLAYER_VERSION (1 << 16) & 0xFF) | 
- (void)viewDidLoad
{
    [super viewDidLoad];
    _openDis=0;
    _closeDis=0;
    _menuIsClose=YES;
    _isModifyTime=NO;
    _isModifyVol=NO;
    _isModifyBright=NO;
    // Do any additional setup after loading the view from its nib.

//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
//    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];

#ifdef DEBUG
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
#else
    [IJKFFMoviePlayerController setLogReport:NO];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
#endif

    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    // [IJKFFMoviePlayerController checkIfPlayerVersionMatch:YES major:1 minor:0 micro:0];

    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    
    self.player = [[IJKFFMoviePlayerController alloc]  initWithContentURL:self.url withOptions:options];
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.player.view.frame = self.view.bounds;
    self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
    self.player.shouldAutoplay = YES;
    self.view.autoresizesSubviews = YES;
    [self.view addSubview:self.player.view];
    CGRect size=[UIScreen mainScreen].bounds;
    _mediaControl.frame=CGRectMake(0, 0, size.size.height, size.size.width);
    [self.view addSubview:self.mediaControl];
 
    self.view.clipsToBounds=NO;
     UIBlurEffect* blur=[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    _functionMenu=[[UIVisualEffectView alloc] initWithEffect:blur];
    _functionMenu.frame=CGRectMake(_mediaControl.frame.size.width, 0, _mediaControl.frame.size.width/2, _mediaControl.frame.size.height);
   
    
    [self.view addSubview:_functionMenu];
    self.mediaControl.delegatePlayer = self.player;
    UIScreenEdgePanGestureRecognizer* funMenu=[[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(callFunMenu:)];
    funMenu.edges=UIRectEdgeRight;
    
    UIPanGestureRecognizer* funMenuClo=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(closeFunMenu:)];
    [self.view addGestureRecognizer:funMenu];
    _functionMenu.userInteractionEnabled=YES;
    [_functionMenu addGestureRecognizer:funMenuClo];
    
    UITapGestureRecognizer* oneTapOverlay=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickOverlay)];
    
    UITapGestureRecognizer* oneTap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickMediaControl)];
    
    
    UITapGestureRecognizer* doubleTap1=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClick)];
    UITapGestureRecognizer* doubleTap2=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClick)];
  //swipeForDuration
    
    UIPanGestureRecognizer* pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    UIPanGestureRecognizer* pan2=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    
    doubleTap1.numberOfTapsRequired=2;
    doubleTap2.numberOfTapsRequired=2;
    [self.view addGestureRecognizer:oneTap];
    [self.view addGestureRecognizer:doubleTap1];
    [self.Overlay addGestureRecognizer:oneTapOverlay];
    [self.Overlay addGestureRecognizer:doubleTap2];
    [oneTap requireGestureRecognizerToFail:doubleTap1];
    [oneTapOverlay requireGestureRecognizerToFail:doubleTap2];
    [_timeView addGestureRecognizer:pan];
    [_timeView2 addGestureRecognizer:pan2];
}
-(void)pan:(UIPanGestureRecognizer*)recognizer{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
            _panStart=[recognizer locationInView:self.view];
            if(_panStart.x<[_mediaControl frame].size.width/2)
                _isLeft=YES;
            else _isLeft=NO;
            break;
        case UIGestureRecognizerStateChanged:
            _panStill=[recognizer locationInView:self.view];

            if((![self isPanOccupied]|_isModifyTime)&&fabs(_panStill.x-_panStart.x)>7)
            {
                _isModifyTime=YES;
            _timeLabel.hidden=NO;
                _timeLabel.text=[[NSString alloc] initWithFormat:@"%@",[self formatTime:floor((_panStill.x-_panStart.x)/0.8)]];
            }else if((![self isPanOccupied]|_isModifyVol)&&_isLeft&&fabs(_panStill.y-_panStart.y)>7){
                _isModifyVol=YES;
                NSLog(@"modifBright");
            }else if((![self isPanOccupied]|_isModifyBright)&&!_isLeft&&fabs(_panStill.y-_panStart.y)>7){
                _isModifyBright=YES;
                NSLog(@"modifyVOl:%f",(_panStill.y-_panStart.y)/150);
            }
            break;
        case UIGestureRecognizerStateEnded:
            _panEnd=[recognizer locationInView:self.view];
            [self clearPanOccupy];
            break;
        default:
            break;
    }

}
-(void)clearPanOccupy{
    _isModifyTime=NO;
    _isModifyVol=NO;
    _isModifyBright=NO;
}
-(BOOL)isPanOccupied{
    
    return _isModifyTime|_isModifyBright|_isModifyVol;

}


-(void)changeBright:(double)bright{
   
}
-(void)changeVol:(double)vol{
    
    [self.player setPlaybackVolume:vol/100];
}
-(NSString*)formatTime:(double)time{
    int mins=((int)time)/60;
    int seconds=((int)time)%60;
    if(mins!=0)
    {
        if(seconds<0)seconds=-seconds;
        return [[NSString alloc] initWithFormat:@"%2dmin%2ds",mins,seconds];
    }
    else  return [[NSString alloc] initWithFormat:@"%2ds",seconds];
}
-(void)closeFunMenu:(UIPanGestureRecognizer*) recognizer{
    NSLog(@"move2");
    if(recognizer.state==UIGestureRecognizerStateEnded)
    {
        
        [UIView beginAnimations:@"move" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.3f];
        if(_closeDis>=_mediaControl.frame.size.width/6)
        {
            
            _functionMenu.transform = CGAffineTransformTranslate(_functionMenu.transform,_mediaControl.frame.size.width/2-_closeDis,0);
            _menuIsClose=YES;
        }
        else
        {
            
            _functionMenu.transform = CGAffineTransformTranslate(_functionMenu.transform, -_closeDis,0);
        }
        [UIView commitAnimations];
        _closeDis=0;
        
    }
    CGPoint point = [recognizer translationInView:recognizer.view];
    if((_closeDis+point.x)>=0){
    _closeDis+=point.x;
    _functionMenu.transform = CGAffineTransformTranslate(_functionMenu.transform, point.x,0);
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
    }
    
}
-(void)onDoblueClick{
    NSLog(@"double");
}
-(void)callFunMenu:(UIScreenEdgePanGestureRecognizer*) recognizer{
    if(recognizer.state==UIGestureRecognizerStateEnded)
    {
        [UIView beginAnimations:@"move" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:0.3f];
        if((-_openDis)>=_mediaControl.frame.size.width/6)
        {
            _menuIsClose=NO;
            _functionMenu.transform = CGAffineTransformTranslate(_functionMenu.transform,-(_mediaControl.frame.size.width/2+_openDis),0);
            
        }
        else
        {
     
        _functionMenu.transform = CGAffineTransformTranslate(_functionMenu.transform, -_openDis,0);
        }
        [UIView commitAnimations];
        _openDis=0;
        
    }
    CGPoint point = [recognizer translationInView:recognizer.view];
    if(-(_openDis+point.x)<=(_mediaControl.frame.size.width/2))
    {
        NSLog(@"stil");
        _openDis+=point.x;
       _functionMenu.transform = CGAffineTransformTranslate(_functionMenu.transform, point.x,0);
    
    }[recognizer setTranslation:CGPointZero inView:recognizer.view];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self installMovieNotificationObservers];

    [self.player prepareToPlay];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.player shutdown];
    [self removeMovieNotificationObservers];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark IBAction
-(void)doubleClick{
     [self.mediaControl refreshMediaControl];
    if(self.player.isPlaying)
        [self.player pause];
    else
        [self.player play];
    
}
- (void)onClickMediaControl
{
    if(_menuIsClose)
       [self.mediaControl showAndFade];
    else
    {
        [self closeMenu];
        _menuIsClose=YES;
    }

    
}

- (void)onClickOverlay
{
    if(_menuIsClose)
    [self.mediaControl hide];
    else
    {
        [self closeMenu];
        _menuIsClose=YES;
    }
}
-(void)closeMenu{
    [UIView beginAnimations:@"move" context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:0.3f];
    _functionMenu.transform = CGAffineTransformTranslate(_functionMenu.transform,_mediaControl.frame.size.width/2-_closeDis,0);
    _closeDis=0;
    [UIView commitAnimations];
}
- (IBAction)onClickDone:(id)sender
{
  
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
}
-(BOOL)shouldAutorotate{
    return YES;
}
- (IBAction)onClickHUD:(UIBarButtonItem *)sender
{
    if ([self.player isKindOfClass:[IJKFFMoviePlayerController class]]) {
        IJKFFMoviePlayerController *player = self.player;
        player.shouldShowHudView = !player.shouldShowHudView;
        
        sender.title = (player.shouldShowHudView ? @"HUD On" : @"HUD Off");
    }
}

- (IBAction)onClickPlay:(id)sender
{
    [self.mediaControl refreshMediaControl];
    [self.player play];
    
}

- (IBAction)onClickPause:(id)sender
{
    [self.mediaControl refreshMediaControl];
    [self.player pause];
    
}

- (IBAction)didSliderTouchDown
{
    [self.mediaControl beginDragMediaSlider];
}

- (IBAction)didSliderTouchCancel
{
    [self.mediaControl endDragMediaSlider];
}

- (IBAction)didSliderTouchUpOutside
{
    [self.mediaControl endDragMediaSlider];
}

- (IBAction)didSliderTouchUpInside
{
    self.player.currentPlaybackTime = self.mediaControl.mediaProgressSlider.value;
    [self.mediaControl endDragMediaSlider];
}

- (IBAction)didSliderValueChanged
{
    [self.mediaControl continueDragMediaSlider];
}

- (void)loadStateDidChange:(NSNotification*)notification
{
    //    MPMovieLoadStateUnknown        = 0,
    //    MPMovieLoadStatePlayable       = 1 << 0,
    //    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
    //    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started

    IJKMPMovieLoadState loadState = _player.loadState;

    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
    //    MPMovieFinishReasonPlaybackEnded,
    //    MPMovieFinishReasonPlaybackError,
    //    MPMovieFinishReasonUserExited
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];

    switch (reason)
    {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;

        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;

        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;

        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    NSLog(@"mediaIsPreparedToPlayDidChange\n");
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
    //    MPMoviePlaybackStateStopped,
    //    MPMoviePlaybackStatePlaying,
    //    MPMoviePlaybackStatePaused,
    //    MPMoviePlaybackStateInterrupted,
    //    MPMoviePlaybackStateSeekingForward,
    //    MPMoviePlaybackStateSeekingBackward

    switch (_player.playbackState)
    {
        case IJKMPMoviePlaybackStateStopped: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePaused: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
        default: {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

#pragma mark Install Movie Notifications

/* Register observers for the various movie object notifications. */
-(void)installMovieNotificationObservers
{
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];

	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];

	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];

	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
}

#pragma mark Remove Movie Notification Handlers

/* Remove the movie notification observers from the movie object. */
-(void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
}

@end
