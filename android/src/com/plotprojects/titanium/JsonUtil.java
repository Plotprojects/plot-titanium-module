/**
 * Copyright 2015 Floating Market B.V.
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
import com.plotprojects.retail.android.Geotrigger;
import com.plotprojects.retail.android.NotificationTrigger;

@SuppressWarnings("unchecked") //required for Kroll
public final class JsonUtil {
	private final static String LOG_TAG = "PLOT/Titanium";
	
	private final static String KEY_ID = "identifier";
	private final static String KEY_MESSAGE = "message";
	private final static String KEY_DATA = "data";
	private final static String KEY_GEOFENCE_LATITUDE = "geofenceLatitude";
	private final static String KEY_GEOFENCE_LONGITUDE = "geofenceLongitude";
	private final static String KEY_TRIGGER = "trigger";
	private final static String KEY_DWELLING_MINUTES = "dwellingMinutes";
	private final static String KEY_NAME = "name";
	private final static String KEY_MATCH_RANGE = "matchRange";
	
	public static HashMap<String, Object> notificationToMap(FilterableNotification notification) {
		HashMap<String, Object> jsonNotification = new HashMap<String, Object>();
		jsonNotification.put(KEY_ID, notification.getId());
		jsonNotification.put(KEY_MESSAGE, notification.getMessage());
		jsonNotification.put(KEY_DATA, notification.getData());
		jsonNotification.put(KEY_GEOFENCE_LATITUDE, notification.getGeofenceLatitude());
		jsonNotification.put(KEY_GEOFENCE_LONGITUDE, notification.getGeofenceLongitude());
		jsonNotification.put(KEY_TRIGGER, notification.getTrigger());
		jsonNotification.put(KEY_DWELLING_MINUTES, notification.getDwellingMinutes());
		jsonNotification.put(KEY_MATCH_RANGE, notification.getMatchRange());
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


	public static HashMap<String, Object> geotriggerToMap(Geotrigger geotrigger) {
		HashMap<String, Object> jsonGeotrigger = new HashMap<String, Object>();
		jsonGeotrigger.put(KEY_ID, geotrigger.getId());
		jsonGeotrigger.put(KEY_NAME, geotrigger.getName());
		jsonGeotrigger.put(KEY_DATA, geotrigger.getData());
		jsonGeotrigger.put(KEY_GEOFENCE_LATITUDE, geotrigger.getGeofenceLatitude());
		jsonGeotrigger.put(KEY_GEOFENCE_LONGITUDE, geotrigger.getGeofenceLongitude());
		jsonGeotrigger.put(KEY_TRIGGER, geotrigger.getTrigger());
		jsonGeotrigger.put(KEY_DWELLING_MINUTES, geotrigger.getDwellingMinutes());
		jsonGeotrigger.put(KEY_MATCH_RANGE, geotrigger.getMatchRange());
		return jsonGeotrigger;
	}
	
	public static HashMap<String, Object>[] geotriggersToMap(List<Geotrigger> geotriggers) {
		HashMap<String, Object>[] result = new HashMap[geotriggers.size()];
		int i = 0;
		for (Geotrigger geotrigger : geotriggers) {
			result[i] = geotriggerToMap(geotrigger);
			i++;
		}
		return result;
	}
	
	private static Map<String, Geotrigger> indexGeotrigger(List<Geotrigger> geotriggers) {
		Map<String, Geotrigger> result = new HashMap<String, Geotrigger>();
		for (Geotrigger geotrigger : geotriggers) {
			result.put(geotrigger.getId(), geotrigger);
		}
		return result;
	}
	
	public static List<Geotrigger> getGeotriggers(Object[] jsonGeotriggers, List<Geotrigger> geotriggers) {
		Map<String, Geotrigger> geotriggersIndexed = indexGeotrigger(geotriggers);
		
		List<Geotrigger> result = new ArrayList<Geotrigger>();
		
		for (Object obj: jsonGeotriggers) {
			if (!(obj instanceof Map)) {
				throw new IllegalArgumentException("geotriggers must contain objects");
			}
			
			Map<String, String> jsonGeotrigger = (Map<String, String>) obj;
			String id = jsonGeotrigger.get(KEY_ID);
			Geotrigger geotrigger = geotriggersIndexed.get(id);
			if (geotrigger == null) {
				Log.w(LOG_TAG, String.format("Couldn't find geotrigger with id '%s' in Geotrigger Handler", id));
				continue;
			}
			result.add(geotrigger);
		}
		
		return result;
	}


	public static HashMap<String, Object> notificationTriggerToMap(NotificationTrigger notification) {
		HashMap<String, Object> jsonNotification = new HashMap<String, Object>();
		jsonNotification.put(KEY_ID, notification.getId());
		jsonNotification.put(KEY_MESSAGE, notification.getMessage());
		jsonNotification.put(KEY_DATA, notification.getData());
		jsonNotification.put(KEY_GEOFENCE_LATITUDE, notification.getGeofenceLatitude());
		jsonNotification.put(KEY_GEOFENCE_LONGITUDE, notification.getGeofenceLongitude());
		jsonNotification.put(KEY_TRIGGER, notification.getTrigger());
		jsonNotification.put(KEY_DWELLING_MINUTES, notification.getDwellingMinutes());
		jsonNotification.put(KEY_MATCH_RANGE, notification.getMatchRange());
		return jsonNotification;
	}
	
	public static HashMap<String, Object>[] notificationTriggersToMap(List<NotificationTrigger> notifications) {
		HashMap<String, Object>[] result = new HashMap[notifications.size()];
		int i = 0;
		for (NotificationTrigger notification : notifications) {
			result[i] = notificationTriggerToMap(notification);
			i++;
		}
		return result;
	}
	
}
