//
//  CCActionCallFunc+CCActionCallFuncO.m
//  SpaceShip2
//
//  Created by Theeravit Ponsuntikul on 11/28/2557 BE.
//  Copyright (c) 2557 Apportable. All rights reserved.
//

#import "CCActionCallFuncO.h"
#import "objc/message.h"

@implementation CCActionCallFuncO

+ (id) actionWithTarget: (id) t selector:(SEL) s object:(id)object {
    return [[self alloc] initWithTarget:t selector:s object:object];
}

- (id) initWithTarget:(id) t selector:(SEL) s object:(id)object {
    if( (self=[super initWithTarget:t selector:s] ) )
        self.object = object;
    return self;
}

- (void) execute {
    //    objc_msgSend(_targetCallback, _selector, _object);
    
    typedef void (*Func)(id, SEL,...);
    ((Func)objc_msgSend)(_targetCallback, _selector, _object);
}

@end
