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

import com.plotprojects.retail.android.NotificationFilter;
import com.plotprojects.retail.android.NotificationFilterUtil;

import android.content.Intent;
import android.util.Log;
import ti.modules.titanium.android.TiJSService;

public final class NotificationFilterService extends TiJSService implements NotificationFilter {
	private final static String LOG_TAG = "PLOT/Titanium";
	
	public NotificationFilterService() {
		super("plotfilter.js");
	}

	@Override
	public int onStartCommand(Intent intent, int flags, int startId) {		
		if (NotificationFilterUtil.isNotificationFilterIntent(intent)) {
			NotificationFilterUtil.Batch batch = NotificationFilterUtil.getBatch(intent, this);
			if (batch != null) {
				if (SettingsUtil.isNotificationFilterEnabled()) {
					NotificationBatches.addBatch(batch, this, startId);	
					return super.onStartCommand(intent, flags, startId);
				} else {
					batch.sendNotifications(batch.getNotifications());
				}
			} else {
				Log.w(LOG_TAG, "Unable to obtain batch with notifications from intent");
			}
		} else {
			Log.w(LOG_TAG, String.format("Received unexpected intent with action: %s", intent.getAction()));
		}
		stopSelf(startId);
		return START_NOT_STICKY;
	}
	
	@Override
	public void onTaskRemoved(Intent rootIntent) {

	}
	
}
