/**
 * Copyright 2016 Floating Market B.V.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.meiresearch.android.plotprojects;

import java.util.LinkedList;
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

