//
//  AMOptionMenu.h
//  AMOptionMenuDemo
//
//  Created by Andy Mroczkowski on 7/8/09.
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

#import <Foundation/Foundation.h>


extern NSString* const kAMOptionPopUpButtonTitle;

@interface AMOptionMenuItem : NSObject
{
	NSString* _identifier;
	NSString* _title;
	NSString* _shortTitle;
}

@property (nonatomic, retain) NSString* identifier;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* shortTitle;
@property (nonatomic, readonly) NSString* titleForSummary;

+ (AMOptionMenuItem*) itemWithIdentifier:(NSString*)identifier title:(NSString*)title;
+ (AMOptionMenuItem*) itemWithIdentifier:(NSString*)identifier title:(NSString*)title shortTitle:(NSString*)shortTitle;
@end


extern NSString* const kAMOptionMenuContentWillChange;
extern NSString* const kAMOptionMenuContentDidChange;


@interface AMOptionMenuController : NSObject
{
	NSMutableArray* _options;
	NSMutableDictionary* _valuesDict;
	NSMutableDictionary* _stateDict;

	BOOL _allowUnknownOptions;
	BOOL _shouldSeparateSections;
	NSUInteger _maxValuesInSummary;
}

@property (nonatomic, readonly) NSString* summaryString;
@property (nonatomic, assign) BOOL shouldSeparateOptions;
@property (nonatomic, assign) BOOL allowUnkownOptions;
@property (nonatomic, assign) NSUInteger maxValuesInSummary; // defaults to NSUIntegerMax;


- (void) insertOptionWithIdentifier:(NSString*)identifier title:(NSString*)title atIndex:(NSInteger)index;
- (void) setAlternatives:(NSArray*)alternatives forOptionWithIdentifier:(NSString*)optionIdentifier;
- (void) insertOption:(AMOptionMenuItem*)option atIndex:(NSInteger)insertIndex withAternatives:(NSArray*)alternatives;

- (BOOL) insertOptionsFromPropertyListWithURL:(NSURL*)url atIndex:(NSInteger)insertIndex;

- (void) insertItemsInMenu:(NSMenu*)menu atIndex:(NSInteger)insertIndex;

// TODO: make a property?
- (NSDictionary*) state;

@end

