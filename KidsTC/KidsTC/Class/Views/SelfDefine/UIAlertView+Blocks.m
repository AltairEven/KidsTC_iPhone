//
//  UIAlertView+Blocks.m
//  Shibui
//
//  Created by Jiva DeVoe on 12/28/10.
//  Copyright 2010 Random Ideas, LLC. All rights reserved.
//  Modified by Robert Saunders on 20/01/12
//

#import "UIAlertView+Blocks.h"
#import <objc/runtime.h>

static NSString *LEFT_ACTION_ASS_KEY = @"com.51buy.cancelbuttonaction";
static NSString *RIGHT_ACTION_ASS_KEY = @"com.51buy.otherbuttonaction";

@implementation UIAlertView (Blocks)


-(id)initWithTitle:(NSString *)     title 
           message:(NSString *)     message
   leftButtonTitle:(NSString *)     leftButtonTitle
  leftButtonAction:(void (^)(void)) leftButtonAction
  rightButtonTitle:(NSString*)      rightButtonTitle
 rightButtonAction:(void (^)(void)) rightButtonAction
{
  if((self = [self initWithTitle:title 
                         message:message 
                        delegate:self
               cancelButtonTitle:leftButtonTitle
               otherButtonTitles:rightButtonTitle, nil]))
  {
    // We might get nil for one or both block inputs.  To 
    
    
    // Since this is a catogory, we cant add properties in the usual way.
    // Instead we bind the delegate block to the pointer to self.
    // We use copy to invoke block_copy() to ensure the block is copied off the stack to the heap
    // so that it is still in scope when the delegate callback is invoked.
    if (leftButtonAction) 
    {
      objc_setAssociatedObject(self, (__bridge const void *)(LEFT_ACTION_ASS_KEY), leftButtonAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    if (rightButtonAction) 
    {
      objc_setAssociatedObject(self, (__bridge const void *)(RIGHT_ACTION_ASS_KEY), rightButtonAction, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
    
    if (!leftButtonAction && !rightButtonAction)
    {
        self.delegate = nil;
    }
  }
  return self;
}


// This is a convenience wrapper for the constructor above
+ (void) displayAlertWithTitle:(NSString *)title 
                       message:(NSString *)message
               leftButtonTitle:(NSString *)leftButtonTitle
              leftButtonAction:(void (^)(void))leftButtonAction
              rightButtonTitle:(NSString*)rightButtonTitle
             rightButtonAction:(void (^)(void))rightButtonAction
{
  UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title 
                                                      message:message
                                              leftButtonTitle:leftButtonTitle
                                             leftButtonAction:leftButtonAction
                                             rightButtonTitle:rightButtonTitle
                                            rightButtonAction:rightButtonAction];
  [alertView show];
}



- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
  // Decalare the block variable
  void (^action)(void) = nil;
  
  // Get the block using the correct key 
  // depending on the index of the buttom that was tapped
  if (buttonIndex == 0) 
  {
    action  = objc_getAssociatedObject(self, (__bridge const void *)(LEFT_ACTION_ASS_KEY));
  } 
  else if (buttonIndex == 1)
  {
    action  = objc_getAssociatedObject(self, (__bridge const void *)(RIGHT_ACTION_ASS_KEY));
  }
  
  // Invoke the block if we have it.
  if (action) action();
  
  // Unbind both blocks from ourself so they are released
  // We assign nil to the objects wich will release them automatically
  objc_setAssociatedObject(self, (__bridge const void *)(LEFT_ACTION_ASS_KEY), nil, OBJC_ASSOCIATION_COPY);
  objc_setAssociatedObject(self, (__bridge const void *)(RIGHT_ACTION_ASS_KEY), nil, OBJC_ASSOCIATION_COPY);

}

@end
