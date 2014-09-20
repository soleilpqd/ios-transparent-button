//
//  CMTransparentButton.h
//
//  Created by Phạm Quang Dương on 9/19/14.
//  Copyright (c) 2014 GMO RunSystem. All rights reserved.
//
//  Transparent button, use background image to test transparent point. Highlight & disable background images is used for displaying only.

#import "CMTransparentControl.h"

/**
 *  Extend of CMTransparentControl which draw the UI of control depending on its state.
 *  This works like UIButton except that if selected background image is provided, this becomes a toggle button.
 */
@interface CMTransparentButton : CMTransparentControl

@property ( nonatomic, ARC_STRONG_OR_RETAIN ) UIImage *highlightedBackgroundImage;
@property ( nonatomic, ARC_STRONG_OR_RETAIN ) UIImage *disabledBackgroundImage;
/**
 *  If selectedBackgroundImage is provided, this button works like a toggle button
 */
@property ( nonatomic, ARC_STRONG_OR_RETAIN ) UIImage *selectedBackgroundImage;

@property ( nonatomic, assign ) BOOL adjustsImageWhenHighlighted;
@property ( nonatomic, assign ) BOOL adjustsImageWhenDisabled;

// Supprot for XIB design. Design a custom UIButton on xib. Then call this method to make a Transparent button cloned from specified button.
// Finally release the button on xib.
// This method create new transparent button, copy attributes from UIButton: content mode, backgroundColor, backgroundImage for states, states, IBAction (targets for events)
// Then replace new transparent button at place of UIButton, remove UIButton from its parent view.
+( CMTransparentButton* )replaceButton:( UIButton* )button;

@end
