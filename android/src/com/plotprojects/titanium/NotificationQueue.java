package com.plotprojects.titanium;

import android.util.Log;

import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;
import java.util.Queue;

import com.plotprojects.retail.android.FilterableNotification;

final class NotificationQueue {	
	private static final Queue<FilterableNotification> notifications = new LinkedList<FilterableNotification>();	
	private static NewNotificationListener listener = null;
	
	static interface NewNotificationListener {		
		abstract void newNotification();	
	}	
	
	private NotificationQueue() {		
	}
	
	static void setListener(NewNotificationListener newListener) {
		listener = newListener;
		
	}
	
	static void addNotification(FilterableNotification notification) {
		notifications.add(notification);
				
		if (listener != null) {
			listener.newNotification();
		}
	}
	
	static FilterableNotification getNextNotification() {
		return notifications.poll(); //returns null when empty
	}
	
}

