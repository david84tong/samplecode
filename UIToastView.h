
#import <Foundation/Foundation.h>


@interface UIToastView : UIView {
@private
	UILabel *_textLabel;
}

+ (void)toastInView:(UIView *)parentView withText:(NSString *)text;

@end
