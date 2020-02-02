package com.qrilt.eatzie;

import android.util.Log;

import androidx.annotation.NonNull;
import androidx.core.app.NotificationCompat;
import androidx.core.app.NotificationManagerCompat;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;
import com.parse.FunctionCallback;
import com.parse.ParseCloud;
import com.parse.ParseException;
import com.parse.ParseUser;

import java.util.HashMap;

public class EatzieFirebaseMessagingService extends FirebaseMessagingService {
    //Properties
    NotificationManagerCompat notificationManager = NotificationManagerCompat.from(this);

    //Methods
    @Override
    public void onMessageReceived(RemoteMessage remoteMessage) {
        Log.d("DebugK", "Remote Message Received " + remoteMessage.getData());

        //create notification depending on payload
        NotificationCompat.Builder builder = new NotificationCompat.Builder(this, "main")
                .setSmallIcon(R.drawable.launch_background)
                .setContentTitle(remoteMessage.getData().get("title"))
                .setContentText(remoteMessage.getData().get("message"))
                .setPriority(NotificationCompat.PRIORITY_DEFAULT);

        notificationManager.notify(1, builder.build());
    }

    @Override
    public void onNewToken(@NonNull String token) {
        //got new token, update it on Parse
        if (ParseUser.getCurrentUser() != null) {
            HashMap<String, Object> params = new HashMap<>();
            params.put("userId", ParseUser.getCurrentUser().getObjectId());
            params.put("fcmToken", token);
            ParseCloud.callFunctionInBackground("updateUserFCMToken", params, new FunctionCallback<HashMap<String, Object>>() {
                @Override
                public void done(HashMap<String, Object> object, ParseException e) {
                    if (e == null) {
                        return;
                    }
                }
            });
        }
    }
}
