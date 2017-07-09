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

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "AppDelegate.h"
@class IJKMediaControl;

@interface IJKVideoViewController : UIViewController<UIGestureRecognizerDelegate>

@property(atomic,strong) NSURL *url;
@property(atomic, retain) IJKFFMoviePlayerController<IJKMediaPlayback>* player;

- (id)initWithURL:(NSURL *)url;

+ (void)presentFromViewController:(UIViewController *)viewController withTitle:(NSString *)title URL:(NSURL *)url completion:(void(^)())completion;

- (void)onClickMediaControl;
- (void)onDoblueClick;
- (void)onClickOverlay;
- (IBAction)onClickDone:(id)sender;
- (IBAction)onClickPlay:(id)sender;
- (IBAction)onClickPause:(id)sender;
- (IBAction)didSliderTouchDown;
- (IBAction)didSliderTouchCancel;
- (IBAction)didSliderTouchUpOutside;
- (IBAction)didSliderTouchUpInside;
- (IBAction)didSliderValueChanged;
@property(nonatomic,strong) UIVisualEffectView* functionMenu;
@property(nonatomic,strong) IBOutlet IJKMediaControl *mediaControl;
@property (weak, nonatomic) IBOutlet UIControl *Overlay;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UIView *timeView2;
@property(nonatomic) CGFloat openDis;
@property(nonatomic) CGFloat closeDis;
@property(nonatomic) BOOL menuIsClose;
@property(nonatomic) BOOL isModifyTime;
@property(nonatomic) BOOL isModifyVol;
@property(nonatomic) BOOL isModifyBright;
@property(nonatomic) BOOL isLeft;
@property(nonatomic) CGPoint panStart;
@property(nonatomic) CGPoint panStill;
@property(nonatomic) CGPoint panEnd;


@end
