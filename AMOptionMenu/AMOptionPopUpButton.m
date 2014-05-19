//
//  AMOptionPopUpButton.m
//  AMOptionMenuDemo
//
//  Created by Andy Mroczkowski on 7/9/09.
//
//  Copyright (c) 2009 Andy Mroczkowski
//
//  Permission is hereby granted, free of charge, to any person obtaining
//  a copy of this software and associated documentation files (the
//  "Software"), to deal in the Software without restriction, including
//  without limitation the rights to use, copy, modify, merge, publish,
//  distribute, sublicense, and/or sell copies of the Software, and to
//  permit persons to whom the Software is furnished to do so, subject to
//  the following conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
//  MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
//  LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
//  WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "AMOptionPopUpButton.h"
#import "AMOptionPopUpButtonCell.h"


#import "AMOptionMenuController.h"

@implementation AMOptionPopUpButton

@synthesize smartTitleTruncation = _smartTitleTruncation;

+ (Class) cellClass
{
    return [AMOptionPopUpButtonCell class];
}


- (void) configure
{
	NSDictionary* titleBindingOptions = [NSDictionary dictionaryWithObjectsAndKeys:
										 @"(No Data Source)", NSNullPlaceholderBindingOption,
										 nil];
	[self bind:@"title" toObject:self withKeyPath:@"cell.optionMenuController.summaryString" options:titleBindingOptions];
}


- (id) initWithFrame:(NSRect)buttonFrame pullsDown:(BOOL)flag
{
	self = [super initWithFrame:buttonFrame pullsDown:flag];
	if( self )
	{
		[self configure];
	}
	return self;
}


- (id) initWithFrame:(NSRect)buttonFrame
{
	return [self initWithFrame:buttonFrame pullsDown:YES];
}


- (void) awakeFromNib
{
	[self configure];
}


- (AMOptionMenuController*) optionMenuController
{
	return [[self cell] optionMenuController];
}


- (void) setOptionMenuController:(AMOptionMenuController*) controller
{
	[[self cell] setOptionMenuController:controller];
}


- (void)setFrameSize:(NSSize)newSize
{
	[super setFrameSize:newSize];
	if( self.smartTitleTruncation )
	{
		[self setTitle:[[self optionMenuController] summaryString]];
	}
}


- (void) setTitle:(NSString*)title
{
	if( self.smartTitleTruncation )
	{
		NSRect titleRect = [[self cell] titleRectForBounds:[self bounds]];
		NSDictionary* attributes = [NSDictionary dictionaryWithObjectsAndKeys:
									[self font], NSFontAttributeName,
									nil];

		NSAttributedString* tmpString = [[NSAttributedString alloc] initWithString:title attributes:attributes];

		//NSLog( @"title string size: %@", NSStringFromSize( [tmpString size] ) );
		//NSLog( @"control text size: %@", NSStringFromSize( titleRect.size) );

		if( [tmpString size].width > titleRect.size.width )
		{
			// -- try to trim it down

			NSRange range = [title rangeOfString:@"|" options:NSBackwardsSearch];
			if( range.location != NSNotFound )
			{
				NSString* newTitle = [[title substringToIndex:range.location]
									  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

				[self setTitle:newTitle];
				return;
			}
		}
	}

	[super setTitle:title];
}

-(void)dealloc
{
  [self unbind:@"title"];
}

@end
