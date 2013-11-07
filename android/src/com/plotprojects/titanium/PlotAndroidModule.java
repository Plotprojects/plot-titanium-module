/**
 * Copyright 2013 Floating Market B.V.
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

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.util.Log;

import com.plotprojects.retail.android.Plot;
import com.plotprojects.retail.android.PlotConfiguration;
import com.plotprojects.retail.android.FilterableNotification;
import com.plotprojects.retail.android.OpenUriReceiver;

import java.lang.ref.WeakReference;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;
import java.util.Queue;

import org.appcelerator.kroll.KrollEventCallback;
import org.appcelerator.kroll.KrollModule;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.titanium.TiApplication;
import org.appcelerator.titanium.TiBaseActivity;
import org.appcelerator.titanium.proxy.ActivityProxy;
import org.appcelerator.titanium.proxy.IntentProxy;

@Kroll.module(name="PlotAndroidModule", id="com.plotprojects.ti")
public class PlotAndroidModule extends KrollModule implements NotificationQueue.NewNotificationListener {
	private static final String ENABLE_ON_FIRST_RUN_FIELD = "enableOnFirstRun";
	private static final String COOLDOWN_PERIOD_FIELD = "cooldownPeriod";
	private static final String PUBLIC_TOKEN_FIELD = "publicToken";
	private static final String NOTIFICATION_RECEIVED_EVENT = "plotNotificationReceived";
	private static boolean initialized = false;	
	private WeakReference<TiApplication> tiApp = null;

	@Kroll.onAppCreate
	public static void onAppCreate(TiApplication app) {
		
	}
	
	public void newNotification() {
		if (tiApp == null) {
			return;
		}
		TiApplication app = tiApp.get();
		if (app == null || app != TiApplication.getInstance()) {
			Log.e("PLOT", "Old Module");
			return;
		}
		
		handleNotifications();
	}
	
	private void handleNotifications() {
		while (true) {
			FilterableNotification notification = NotificationQueue.getNextNotification();
			if (notification == null) {
				break;
			}
			handleNotification(notification);
		}
	}
  
	private void handleNotification(FilterableNotification notification) {
		if (hasListeners(NOTIFICATION_RECEIVED_EVENT)) {
			Log.e("PlotAndroidModule", "Opening for listener");
			// Convert notification to map
			Map<String, String> jsonNotification = new HashMap<String, String>();
			jsonNotification.put("id", notification.getId());
			jsonNotification.put("message", notification.getMessage());
			jsonNotification.put("data", notification.getData());
			fireEvent(NOTIFICATION_RECEIVED_EVENT, jsonNotification);
		} else {
			Log.e("PlotAndroidModule", "Opening URI: " + notification.getData());
			if (notification.getData() == null)
				return;

			try {
				Uri uri = Uri.parse(notification.getData());

				Context appContext = TiApplication.getInstance().getApplicationContext();
				Intent openBrowserIntent = new Intent(appContext, OpenUriReceiver.class);
				openBrowserIntent.putExtra("notification", notification);
				
				appContext.sendBroadcast(openBrowserIntent);
			} catch (Throwable e) {
				Log.e("PlotAndroidModule", "Error opening URI: " + notification.getData(), e);
			}
		}
	}

	@Kroll.method
	public void initPlot(@SuppressWarnings("rawtypes") HashMap configuration) {	
		TiApplication appContext = TiApplication.getInstance();
		tiApp = new WeakReference(appContext);
		Activity activity = appContext.getCurrentActivity();

		if (configuration == null) {
			throw new IllegalArgumentException("No configuration object provided.");
		}

		if (!configuration.containsKey(PUBLIC_TOKEN_FIELD)) {
			throw new IllegalArgumentException("Public token not specified.");
		}

		if (!(configuration.get(PUBLIC_TOKEN_FIELD) instanceof String)) {
			throw new IllegalArgumentException("Public key not specified correctly.");
		}

		PlotConfiguration config = new PlotConfiguration((String) configuration.get(PUBLIC_TOKEN_FIELD));

		if (configuration.containsKey(COOLDOWN_PERIOD_FIELD) && !(configuration.get(COOLDOWN_PERIOD_FIELD) instanceof Integer)) {
			throw new IllegalArgumentException("Cooldown period not specified correctly.");
		}
		else if (configuration.containsKey(COOLDOWN_PERIOD_FIELD)) {
			config.setCooldownPeriod((Integer) configuration.get(COOLDOWN_PERIOD_FIELD));
		}

		if (configuration.containsKey(ENABLE_ON_FIRST_RUN_FIELD) && !(configuration.get(ENABLE_ON_FIRST_RUN_FIELD) instanceof Boolean)) {
			throw new IllegalArgumentException("Enable on first run not specified correctly.");
		}
		else if (configuration.containsKey(ENABLE_ON_FIRST_RUN_FIELD)) {
			config.setEnableOnFirstRun((Boolean) configuration.get(ENABLE_ON_FIRST_RUN_FIELD));
		}
		NotificationQueue.setListener(this);
		Plot.init(activity, config);
		
		handleNotifications();
		
	}

	@Kroll.method
	public void enable() {
		Plot.enable();
	}

	@Kroll.method
	public void disable() {
		Plot.disable();
	}

	@Kroll.getProperty @Kroll.method
	public boolean getEnabled() {
		return Plot.isEnabled();
	}

	@Kroll.method
	public void setCooldownPeriod(int cooldownSeconds) {
		Plot.setCooldownPeriod(cooldownSeconds);
	}

	@Kroll.getProperty @Kroll.method
	public String getVersion() {
		return Plot.getVersion();
	}	

}
