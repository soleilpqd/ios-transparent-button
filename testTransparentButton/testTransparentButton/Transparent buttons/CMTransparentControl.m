//
//  CMTransparentControl.m
//
//  Created by Phạm Quang Dương on 9/18/14.
//  Copyright (c) 2014 GMO RunSystem. All rights reserved.
//

#import "CMTransparentControl.h"
#import "CMTransparentImage.h"

// If YES, enable code to control touch tracking
// If NO, let UIControl control touch tracking => like normal UIButton
#define TOGGLE_MODE 1

@interface CMTransparentControl() {
#if TOGGLE_MODE
    BOOL _touchInside;
#endif
}

@property ( nonatomic, ARC_STRONG_OR_RETAIN ) CMTransparentImage *alphaMap;
#if TOGGLE_MODE
@property ( nonatomic, ARC_STRONG_OR_RETAIN ) UITouch *trackingTouch;
#endif

@end

@implementation CMTransparentControl

#pragma mark - Private

-( void )resetAlphaMap {
    ARC_RELEASE( _alphaMap );
    if ( _backgroundImage ) {
        _alphaMap = [[ CMTransparentImage alloc ] initWithImage:_backgroundImage
                                                containerBounds:self.bounds
                                                    displayRect:[ CMTransparentImage displayFrameForImageSize:_backgroundImage.size
                                                                                                   inViewSize:self.frame.size
                                                                                               forContentMode:self.contentMode ]
                                                  disableRetina:NO ]; // Can not disable retina because we use alphaMap to make clip mask in auto-highlight image
    }
}

-( BOOL )testPoint:( CGPoint )point {
    if ( _alphaMap ) return [ _alphaMap testPoint:point ];
    return NO;
}

#pragma mark - Properties

-( void )setBackgroundImage:(UIImage *)backgroundImage {
    ARC_RELEASE( _backgroundImage )
    _backgroundImage = ARC_RETAIN( backgroundImage );
    [ self resetAlphaMap ];
    [ self setNeedsDisplay ];
}

-( void )setFrame:(CGRect)frame {
    [ super setFrame:frame ];
    [ self resetAlphaMap ];
    [ self setNeedsDisplay ];
}

-( void )setBounds:(CGRect)bounds {
    [ super setBounds:bounds ];
    [ self resetAlphaMap ];
    [ self setNeedsDisplay ];
}

-( void )setBackgroundColor:(UIColor *)backgroundColor {
    [ super setBackgroundColor:backgroundColor ];
    [ self resetAlphaMap ];
    [ self setNeedsDisplay ];
}

-( void )setContentMode:(UIViewContentMode)contentMode {
    if ( self.contentMode != contentMode ) {
        [ super setContentMode:contentMode ];
        [ self resetAlphaMap ];
        [ self setNeedsDisplay ];
    }
}

#pragma mark - Touch

-( BOOL )pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if ( event.type == UIEventTypeTouches )
        return [ self testPoint:point ];
    return NO;
}

#if TOGGLE_MODE

-( BOOL )beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    if ( !self.enabled || event.type != UIEventTypeTouches ) return NO;
    CGPoint point = [ touch locationInView:self ];
    if ([ self testPoint:point ]) {
        self.trackingTouch = touch;
        _touchInside = YES;
        [ self setHighlighted:YES ];
        [ self setSelected:!self.selected ];
        [ self sendActionsForControlEvents:UIControlEventTouchDown ];
        return YES;
    }
    return NO;
}

-( BOOL )continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    if ( !self.enabled || event.type != UIEventTypeTouches ) return NO;
    if ( self.trackingTouch && self.trackingTouch == touch ) {
        CGPoint point = [ self.trackingTouch locationInView:self ];
        if ([ self testPoint:point ]) {
            if ( _touchInside )
                [ self sendActionsForControlEvents:UIControlEventTouchDragInside ];
            else
                [ self sendActionsForControlEvents:UIControlEventTouchDragEnter ];
            _touchInside = YES;
        } else {
            if ( _touchInside )
                [ self sendActionsForControlEvents:UIControlEventTouchDragExit ];
            else
                [ self sendActionsForControlEvents:UIControlEventTouchDragOutside ];
            _touchInside = NO;
        }
        return YES;
    }
    return NO;
}

-( void )endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    if ( self.trackingTouch && self.trackingTouch == touch && event.type == UIEventTypeTouches ) {
        CGPoint point = [ self.trackingTouch locationInView:self ];
        [ self setHighlighted:NO ];
        self.trackingTouch = nil;
        if ([ self testPoint:point ])
            [ self sendActionsForControlEvents:UIControlEventTouchUpInside ];
        else
            [ self sendActionsForControlEvents:UIControlEventTouchUpOutside ];
    }
}

-( void )cancelTrackingWithEvent:(UIEvent *)event {
    if ( self.trackingTouch && event.type == UIEventTypeTouches ) {
        [ self setHighlighted:NO ];
        self.trackingTouch = nil;
        [ self sendActionsForControlEvents:UIControlEventTouchCancel ];
    }
}
#endif

#pragma mark - Life cycle

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect( context, self.bounds );
    CGContextSetFillColorWithColor( context, self.backgroundColor.CGColor );
    CGContextFillRect( context, self.bounds );
    if ( _backgroundImage ) {
        CGRect imageFrame = [ CMTransparentImage displayFrameForImageSize:_backgroundImage.size
                                                               inViewSize:self.frame.size
                                                           forContentMode:self.contentMode ];
        [ _backgroundImage drawInRect:imageFrame ];
    }
}

-( void )dealloc {
    ARC_RELEASE( _backgroundImage )
    ARC_RELEASE( _alphaMap )
#if TOGGLE_MODE
    ARC_RELEASE( _trackingTouch )
#endif
#if !ARC_ENABLED
    [ super dealloc ];
#endif
}

@end
