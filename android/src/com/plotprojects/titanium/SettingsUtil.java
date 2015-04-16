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

import org.appcelerator.titanium.TiApplication;

import android.content.SharedPreferences;

public final class SettingsUtil {	
	private SettingsUtil() {
	}
	
	private static SharedPreferences getSharedPreferences() {
		TiApplication tiApp = TiApplication.getInstance();
		return tiApp.getSharedPreferences("plot-titanium", 0);
	}
	
	public static boolean isNotificationFilterEnabled() {
		SharedPreferences sharedPreferences = getSharedPreferences();
		return sharedPreferences.getBoolean("notificationfilter", false);
	}
	
	public static void setNotificationFilterEnabled(boolean enabled) {
		SharedPreferences sharedPreferences = getSharedPreferences();
		SharedPreferences.Editor editor = sharedPreferences.edit();
		editor.putBoolean("notificationfilter", enabled);
		editor.commit();
	}	

	public static boolean isGeotriggerHandlerEnabled() {
		SharedPreferences sharedPreferences = getSharedPreferences();
		return sharedPreferences.getBoolean("geotriggerhandler", false);
	}

	public static void setGeotriggerHandlerEnabled(boolean enabled) {
		SharedPreferences sharedPreferences = getSharedPreferences();
		SharedPreferences.Editor editor = sharedPreferences.edit();
		editor.putBoolean("geotriggerhandler", enabled);
		editor.commit();
	}	
}
