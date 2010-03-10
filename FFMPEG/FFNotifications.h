//
//  FFNotifications.h
//  Steer
//
//  Created by Gabriel Handford on 3/10/10.
//  Copyright 2010. All rights reserved.
//

#define FFDisplay(...) do { [[NSNotificationCenter defaultCenter] postNotificationName:FFDisplayNotification \
object:[NSString stringWithFormat:__VA_ARGS__]]; } while (0)

extern NSString *const FFDisplayNotification;
extern NSString *const FFOpenNotification;

