//
//  MyTextField.m
//  Taxi

#import "TextFieldPadding.h"

@interface TextFieldPadding ()

@end

@implementation TextFieldPadding

-(CGRect)textRectForBounds:(CGRect)bounds
{
    //return CGRectInset(bounds, 15, 0);
  
        return CGRectInset(bounds, 15, 0);
}
-(CGRect)editingRectForBounds:(CGRect)bounds
{
            return CGRectInset(bounds, 15, 0);
}

@end
