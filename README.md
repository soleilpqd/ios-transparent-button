ios-transparent-button
======================

Store image pixel transparency. Apply to UIButton to allow click through using its background image.

## Usage

Add ARC.h, CMTransparentImage.\*, UITransparentButton.\* into your project.
In your xib (storyboard) file, add UIButtons as you want, set its background images. Then go to Identity Inspector set UIButton class to UITransparentButton.

## Classes list:

**ARC.h**: some compiling macro to enable this source code can be added in both ARC and non-ARC project.

**CMTransparentImage**: heart of this code. This object stores alpha value of every image pixels.
Remember that the CGPoint input of testPoint: method of this class is the coordinate of pixel with non-Retina scale. So when we get user's tap point on image displaying view, we have to calculate the coordinate image pixel from this point (without caring about Retina scale of image). Easy way is making a "screenshot" image of view, then make CMTransparentImage object from this image instead of the view's background image (the long init method of CMTransparentImage is similar of this way. This method creates an area, draws image in this area, then makes "screenshot" of area.).

**UITransparentButton**: this subclass of UIButton uses its _background image_ (for normal state) to make CMTransparentImage object. Then it uses this CMTransparentImage object to check point transparency, allow tapping through the transparent point.

**CMTransparentControl, CMTransparentButton**: my custom control. CMTransparentControl draws an image as background, uses its background to check transparency, custom touch tracking (normal UIControl or UIButton switchs Selected state same as Highlight state. This custom touch tracking allows control switching Selected state when touch begins only, so we can make a toggle button). CMTransparentButton extends CMTransparentControl by drawing background based on control state.
