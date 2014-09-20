//
//  CMViewController.m
//  testTransparentButton
//
//  Created by Phạm Quang Dương on 9/18/14.
//  Copyright (c) 2014 GMO RunSystem. All rights reserved.
//

#import "CMViewController.h"
#import "CMTransparentButton.h"

@interface CMViewController () {
    CMTransparentButton *_btnTransBottom;
    CMTransparentButton *_btnTransLeft;
    CMTransparentButton *_btnTransRight;
    CMTransparentButton *_btnTransCenter;
}

@end

@implementation CMViewController

#define TEST_CM_BUTTON  1

- (void)viewDidLoad
{
    [super viewDidLoad];
#if TEST_CM_BUTTON
    _btnTransBottom = [ CMTransparentButton replaceButton:_btnBottom ];
    _btnTransLeft = [ CMTransparentButton replaceButton:_btnLeft ];
    _btnTransRight = [ CMTransparentButton replaceButton:_btnRight ];
    _btnTransCenter = [ CMTransparentButton replaceButton:_btnCenter ];
    _btnBottom = nil;
    _btnCenter = nil;
    _btnLeft = nil;
    _btnRight = nil;
#endif
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-( void )btnDemo_onTap:(id)sender {
#if TEST_CM_BUTTON
    switch ([ sender tag ]) {
        case 1:
            _lblText.text = @"You tapped on left button which has custom highlight background image.";
            break;
        case 2:
            _lblText.text = @"You tapped on right button which has custom selected background image & work like toggle button.";
            _btnTransCenter.enabled = _btnTransRight.selected;
            break;
        case 3:
            _lblText.text = @"This is bottom button whose highlight is auto adjusted";
            break;
        case 4:
            _lblText.text = @"This is center button which can be disable by right button.";
            break;
        default:
            break;
    }
#endif
}

@end
