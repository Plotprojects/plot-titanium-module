/**
 * Copyright 2014 Floating Market B.V.
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
package com.plotprojects.titanium;

import java.util.*;

import android.util.Log;

import com.plotprojects.retail.android.FilterableNotification;

@SuppressWarnings( "unchecked") //required for Kroll
public final class NotificationJsonUtil {
	private final static String LOG_TAG = "PLOT/Titanium";
	
	private final static String KEY_ID = "identifier";
	private final static String KEY_MESSAGE = "message";
	private final static String KEY_DATA = "data";
	private final static String KEY_GEOFENCE_LATITUDE = "geofenceLatitude";
	private final static String KEY_GEOFENCE_LONGITUDE = "geofenceLongitude";
	private final static String KEY_TRIGGER = "trigger";
	private final static String KEY_DWELLING_MINUTES = "dwellingMinutes";
	
	public static HashMap<String, Object> notificationToMap(FilterableNotification notification) {
		HashMap<String, Object> jsonNotification = new HashMap<String, Object>();
		jsonNotification.put(KEY_ID, notification.getId());
		jsonNotification.put(KEY_MESSAGE, notification.getMessage());
		jsonNotification.put(KEY_DATA, notification.getData());
		jsonNotification.put(KEY_GEOFENCE_LATITUDE, notification.getGeofenceLatitude());
		jsonNotification.put(KEY_GEOFENCE_LONGITUDE, notification.getGeofenceLongitude());
		jsonNotification.put(KEY_TRIGGER, notification.getTrigger());
		jsonNotification.put(KEY_DWELLING_MINUTES, notification.getDwellingMinutes());
		return jsonNotification;
	}
	
	public static HashMap<String, Object>[] notificationsToMap(List<FilterableNotification> notifications) {
		HashMap<String, Object>[] result = new HashMap[notifications.size()];
		int i = 0;
		for (FilterableNotification notification : notifications) {
			result[i] = notificationToMap(notification);
			i++;
		}
		return result;
	}
	
	private static Map<String, FilterableNotification> indexFilterableNotification(List<FilterableNotification> notifications) {
		Map<String, FilterableNotification> result = new HashMap<String, FilterableNotification>();
		for (FilterableNotification n : notifications) {
			result.put(n.getId(), n);
		}
		return result;
	}
	
	public static List<FilterableNotification> getNotifications(Object[] jsonNotifications, List<FilterableNotification> notifications) {
		Map<String, FilterableNotification> notificationsIndexed = indexFilterableNotification(notifications);
		
		List<FilterableNotification> result = new ArrayList<FilterableNotification>();
		
		for (Object obj: jsonNotifications) {
			if (!(obj instanceof Map)) {
				throw new IllegalArgumentException("notifications must contains objects");
			}
			
			Map<String, String> jsonNotification = (Map<String, String>) obj;
			String id = jsonNotification.get(KEY_ID);
			FilterableNotification notification = notificationsIndexed.get(id);
			if (notification == null) {
				Log.w(LOG_TAG, String.format("Couldn't find notification with id '%s' in Notification Filter", id));
				continue;
			}
			notification.setMessage(jsonNotification.get(KEY_MESSAGE));
			notification.setData(jsonNotification.get(KEY_DATA));
			result.add(notification);
		}
		
		return result;
	}
}
