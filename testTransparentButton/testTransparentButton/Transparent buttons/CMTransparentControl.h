//
//  CMTransparentControl.h
//
//  Created by Phạm Quang Dương on 9/18/14.
//  Copyright (c) 2014 GMO RunSystem. All rights reserved.
//
//  Custom control which allow "tap through" using background image

#import <UIKit/UIKit.h>

/**
 *  Custom control which draw background image, uses its background image to test transparent pixel,
 *  tracking user touch to change control state & send IBAction
 */
@interface CMTransparentControl : UIControl

/**
 *  Threshold to test pixel can be tapped through. Pixel having alpha value greater than this value is opaque.
 */
@property ( nonatomic, assign ) unsigned int transparentThreshold;
/**
 *  Image to test pixel
 */
@property ( nonatomic, ARC_STRONG_OR_RETAIN ) UIImage *backgroundImage;

@end
