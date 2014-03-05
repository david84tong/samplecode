
#import <QuartzCore/QuartzCore.h>
#import "UIToastView.h"

static const CGFloat kDuration = 2;
static NSMutableArray *toasts;
@interface UIToastView ()

@property (nonatomic, readonly) UILabel *textLabel;

- (void)fadeToastOut;
+ (void)nextToastInView:(UIView *)parentView;

@end

@implementation UIToastView

@synthesize textLabel = _textLabel;

#pragma mark - NSObject

- (id)initWithText:(NSString *)text {
	if ((self = [self initWithFrame:CGRectZero])) {
		// Add corner radius
		self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
		self.layer.cornerRadius = 5;
		self.autoresizingMask = UIViewAutoresizingNone;
		self.autoresizesSubviews = NO;
		
		// Init and add label
		_textLabel = [[UILabel alloc] init];
		_textLabel.text = text;
		_textLabel.font = [UIFont systemFontOfSize:14];
		_textLabel.textColor = [UIColor whiteColor];
		_textLabel.adjustsFontSizeToFitWidth = NO;
		_textLabel.backgroundColor = [UIColor clearColor];
		[_textLabel sizeToFit];
		
		[self addSubview:_textLabel];
		_textLabel.frame = CGRectOffset(_textLabel.frame, 10, 5);
	}
	
	return self;
}


#pragma mark - Public

+ (void)toastInView:(UIView *)parentView withText:(NSString *)text {
	// Add new instance to queue
	UIToastView *view = [[UIToastView alloc] initWithText:text];
  
	CGFloat lWidth = view.textLabel.frame.size.width;
	CGFloat lHeight = view.textLabel.frame.size.height;
	CGFloat pWidth ;
	CGFloat pHeight;
    pHeight = [[UIScreen mainScreen] bounds].size.height;
    pWidth =  [[UIScreen mainScreen] bounds].size.width;
	
	// Change toastview frame
	view.frame = CGRectMake((pWidth - lWidth - 20) / 2., pHeight - lHeight - 60, lWidth + 20, lHeight + 10);
	view.alpha = 0.0f;
	
	if (toasts == nil) {
		toasts = [[NSMutableArray alloc] initWithCapacity:1];
		[toasts addObject:view];
		[UIToastView nextToastInView:parentView];
	}
	else {
		[toasts addObject:view];
	}
}

#pragma mark - Private

- (void)fadeToastOut {
  [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction
   
                   animations:^{
                     self.alpha = 0.f;
                   } 
                   completion:^(BOOL finished){
                     UIView *parentView = self.superview;
                     [self removeFromSuperview];
                     [toasts removeObject:self];
                     if ([toasts count] == 0) {
                       toasts = nil;
                     }
                     else
                       [UIToastView nextToastInView:parentView];
                   }];
}


+ (void)nextToastInView:(UIView *)parentView {
	if ([toasts count] > 0) {
    UIToastView *view = [toasts objectAtIndex:0];
    // Fade into parent view
    [parentView addSubview:view];
    [UIView animateWithDuration:.5  delay:0 options:UIViewAnimationOptionAllowUserInteraction
                     animations:^{
      view.alpha = 1.0;
                     } completion:^(BOOL finished){}];
    
    // Start timer for fade out
    [view performSelector:@selector(fadeToastOut) withObject:nil afterDelay:kDuration];
  }
}

@end
