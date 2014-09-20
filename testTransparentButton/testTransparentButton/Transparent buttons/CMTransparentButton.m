//
//  CMTransparentButton.m
//
//  Created by Phạm Quang Dương on 9/19/14.
//  Copyright (c) 2014 GMO RunSystem. All rights reserved.
//

#import "CMTransparentButton.h"
#import "CMTransparentImage.h"

@interface CMTransparentControl()

@property ( nonatomic, ARC_STRONG_OR_RETAIN ) CMTransparentImage *alphaMap;

@end

@interface CMTransparentButton ()

@property ( nonatomic, ARC_STRONG_OR_RETAIN ) UIImage *autoHLImage;
@property ( nonatomic, ARC_STRONG_OR_RETAIN ) UIImage *autoDIImage;

@end

@implementation CMTransparentButton

#pragma mark - Properties

-( void )setHighlighted:(BOOL)highlighted {
    if ( highlighted != self.highlighted ) {
        [ super setHighlighted:highlighted ];
        [ self setNeedsDisplay ];
    }
}

-( void )setEnabled:(BOOL)enabled {
    if ( self.enabled != enabled ) {
        [ super setEnabled:enabled ];
        if ( enabled ) self.autoDIImage = nil;
        [ self setNeedsDisplay ];
    };
}

-( void )setHighlightedBackgroundImage:(UIImage *)highlightedBackgroundImage {
    ARC_RELEASE( _highlightedBackgroundImage )
    _highlightedBackgroundImage = ARC_RETAIN( highlightedBackgroundImage );
    if ( _highlightedBackgroundImage ) self.autoHLImage = nil;
    if ( self.highlighted )[ self setNeedsDisplay ];
}

-( void )setDisabledBackgroundImage:(UIImage *)disabledBackgroundImage {
    ARC_RELEASE( _disabledBackgroundImage );
    _disabledBackgroundImage = ARC_RETAIN( disabledBackgroundImage );
    if ( _disabledBackgroundImage ) self.autoDIImage = nil;
    if ( !self.enabled )[ self setNeedsDisplay ];
}

-( void )setBackgroundImage:(UIImage *)backgroundImage {
    [ super setBackgroundImage:backgroundImage ];
    self.autoDIImage = self.autoHLImage = nil;
}

-( void )setAdjustsImageWhenDisabled:(BOOL)adjustsImageWhenDisabled {
    if ( _adjustsImageWhenDisabled != adjustsImageWhenDisabled ) {
        if ( !adjustsImageWhenDisabled )
            self.autoDIImage = nil;
        _adjustsImageWhenDisabled = adjustsImageWhenDisabled;
    }
}

-( void )setAdjustsImageWhenHighlighted:(BOOL)adjustsImageWhenHighlighted {
    if ( _adjustsImageWhenHighlighted != adjustsImageWhenHighlighted ) {
        if ( !adjustsImageWhenHighlighted )
            self.autoHLImage = nil;
        _adjustsImageWhenHighlighted = adjustsImageWhenHighlighted;
    }
}

#pragma mark - Life cycle

+( CMTransparentButton* )replaceButton:(UIButton *)button {
    CMTransparentButton *transButton = [[ CMTransparentButton alloc ] initWithFrame:button.frame ];
    transButton.tag = button.tag;
    transButton.contentMode = button.contentMode;
    transButton.enabled = button.enabled;
    transButton.highlighted = button.highlighted;
    transButton.selected = button.selected;
    transButton.backgroundColor = [ button backgroundColor ];
    transButton.backgroundImage = [ button backgroundImageForState:UIControlStateNormal ];
    
    UIImage *image = [ button backgroundImageForState:UIControlStateHighlighted ];
    if ( image != nil && image != transButton.backgroundImage )
        transButton.highlightedBackgroundImage = image;
    
    image = [ button backgroundImageForState:UIControlStateDisabled ];
    if ( image != nil && image != transButton.backgroundImage )
        transButton.disabledBackgroundImage = image;
    
    image = [ button backgroundImageForState:UIControlStateSelected ];
    if ( image != nil && image != transButton.backgroundImage )
        transButton.selectedBackgroundImage = image;
    
    transButton.adjustsImageWhenDisabled = button.adjustsImageWhenDisabled;
    transButton.adjustsImageWhenHighlighted = button.adjustsImageWhenHighlighted;
    
    NSSet *allTarget = [ button allTargets ];
    for ( id target in allTarget ) {
        for ( unsigned int i = 0; i <= 8; i++ ) {
            UIControlEvents event = 1 << i;
            NSArray *actions = [ button actionsForTarget:target forControlEvent:event ];
            if ( actions ){
                for ( NSString *selectorName in actions ) {
                    [ transButton addTarget:target action:NSSelectorFromString( selectorName )
                           forControlEvents:event ];
                }
            }
        }
    }
    
    [ button.superview addSubview:transButton ];
    [ button removeFromSuperview ];
    return ARC_AUTO_RELEASE( transButton );
}

#if !ARC_ENABLED

-( void )dealloc {
    self.highlightedBackgroundImage = nil;
    self.disabledBackgroundImage = nil;
    self.selectedBackgroundImage = nil;
    self.autoDIImage = nil;
    self.autoHLImage = nil;
    [ super dealloc ];
}

#endif

#pragma mark - Drawing

-( void )drawBackgroundColor {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect( context, self.bounds );
    CGContextSetFillColorWithColor( context, self.backgroundColor.CGColor );
    CGContextFillRect( context, self.bounds );
}

-( void )makeAutoHLImage {
    CGImageRef imageRef = [ self.alphaMap CGImage ];
    UIGraphicsBeginImageContext( self.frame.size );
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM( context, 0, self.bounds.size.height );
    CGContextScaleCTM( context, 1.0f, -1.0f );
    CGContextClipToMask( context, self.bounds, imageRef );
    CGContextSetFillColorWithColor( context, [[[ UIColor blackColor ] colorWithAlphaComponent:0.5f ] CGColor ]);
    CGContextFillRect( context, self.bounds );
    self.autoHLImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

-( void )makeAutoDIImage {
    CGImageRef imageRef = CGBitmapContextCreateImage( UIGraphicsGetCurrentContext() );
    UIGraphicsBeginImageContext( self.frame.size );
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM( context, 0, self.bounds.size.height );
    CGContextScaleCTM( context, 1.0f, -1.0f );
    CGContextClipToMask( context, self.bounds, imageRef );
    CGContextSetFillColorWithColor( context, [[ UIColor whiteColor ] CGColor ]);
    CGContextFillRect( context, self.bounds );
    CGContextSetBlendMode( context, kCGBlendModeLuminosity );
    CGContextDrawImage( context, self.bounds, imageRef );
    self.autoDIImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

-( void )drawImage:( UIImage* )image {
    CGRect imgFrame = [ CMTransparentImage displayFrameForImageSize:image.size
                                                         inViewSize:self.frame.size
                                                     forContentMode:self.contentMode ];
    [ image drawInRect:imgFrame ];
}

-( void )drawMainImage {
    if ( self.selectedBackgroundImage ) {
        if ( self.selected )
            [ self drawImage:self.selectedBackgroundImage ];
        else
            [ super drawRect:self.bounds ];
    } else {
        [ super drawRect:self.bounds ];
    }
}

- (void)drawRect:(CGRect)rect {
    if ( self.enabled ) {
        if ( self.highlighted ) {
            if ( self.highlightedBackgroundImage )
                [ self drawImage:self.highlightedBackgroundImage ];
            else {
                [ self drawMainImage ];
                if ( self.adjustsImageWhenHighlighted ) {
                    [ super drawRect:rect ];
                    if ( self.autoHLImage == nil )
                        [ self makeAutoHLImage ];
                    [ self.autoHLImage drawInRect:self.bounds ];
                }
            }
        } else {
            [ self drawMainImage ];
        }
    } else {
        if ( self.disabledBackgroundImage ) {
            [ self drawImage:self.disabledBackgroundImage ];
        } else {
            [ super drawRect:rect ];
            if ( self.adjustsImageWhenDisabled ) {
                if ( self.autoDIImage == nil )
                    [ self makeAutoDIImage ];
                CGContextClearRect( UIGraphicsGetCurrentContext(), self.bounds );
                [ self.autoDIImage drawInRect:self.bounds ];
            }
        }
    }
}

@end
