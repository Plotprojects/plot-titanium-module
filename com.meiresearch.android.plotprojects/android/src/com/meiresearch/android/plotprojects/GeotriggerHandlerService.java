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

import com.plotprojects.retail.android.GeotriggerHandlerUtil;
import com.plotprojects.retail.android.GeotriggerHandlerBroadcastReceiver;

import androidx.core.app.NotificationCompat;
import android.app.NotificationManager;
import android.app.NotificationChannel;

import android.content.Intent;
import android.content.Context;
import android.util.Log;
import ti.modules.titanium.android.TiBroadcastReceiver;
import android.content.BroadcastReceiver;
import android.location.Location;

import android.widget.Toast;
import android.R;

public class GeotriggerHandlerService extends BroadcastReceiver {
    public void onReceive(Context context, Intent intent) {
        Log.d("GeotriggerHandlerService", "Geofence triggered!");

        //Toast.makeText(context, "Action: " + intent.getAction(), Toast.LENGTH_SHORT).show();

        //create notification channel
        CharSequence name = "plotprojects";
        String description = "plotprojects messages";
        int importance = NotificationManager.IMPORTANCE_DEFAULT;
        NotificationChannel channel = new NotificationChannel("12", name, importance);
        channel.setDescription(description);
        // Register the channel with the system; you can't change the importance
        // or other notification behaviors after this
        NotificationManager notificationManager = context.getSystemService(NotificationManager.class);
        notificationManager.createNotificationChannel(channel);


        NotificationCompat.Builder builder = new NotificationCompat.Builder(context, "12")
                .setSmallIcon(R.drawable.btn_star)
                .setContentTitle("Plot Projects Notification")
                .setContentText("Geotrigger Handled!");

        notificationManager.notify(1, builder.build());
    }

    //This is code that can be adapted so that this broadcastreceiver can be managed from titanium.
    //Previously this was a service and not a broadcast receiver, so onStartCommand is irrelevant for instance.
    //I left in here if you desire to extend TiBroadcastReceiver and place the .js code in the platform/android/assets folder instead
//    public GeotriggerHandlerService() {
//        super("plotgeotriggerhandler.js");
//        Log.d("GeotriggerHandlerService", "GeotriggerHandlerService()");
//    }
//
//    @Override
//    public int onStartCommand(Intent intent, int flags, int startId) {
//        Log.d("GeotriggerHandlerService", "onStartCommand()");
//        if (GeotriggerHandlerUtil.isGeotriggerHandlerBroadcastReceiverIntent(this,intent)) {
//            GeotriggerHandlerUtil.Batch batch = GeotriggerHandlerUtil.getBatch(intent, this);
//            if (batch != null) {
//                if (SettingsUtil.isGeotriggerHandlerEnabled()) {
//                    GeotriggerBatches.addBatch(batch, this, startId);
//                    return super.onStartCommand(intent, flags, startId);
//                } else {
//                    batch.markGeotriggersHandled(batch.getGeotriggers());
//                }
//            } else {
//                Log.w(LOG_TAG, "Unable to obtain batch with geotriggers from intent");
//            }
//        } else {
//            Log.w(LOG_TAG, String.format("Received unexpected intent with action: %s", intent.getAction()));
//        }
//        stopSelf(startId);
//        return START_NOT_STICKY;
//    }
//
//    @Override
//    public void onTaskRemoved(Intent rootIntent) {
//
//    }
    
}
