package com.qrilt.eatzie;

import com.parse.Parse;

import io.flutter.app.FlutterApplication;

public class EatzieApplication extends FlutterApplication {
    @Override
    public void onCreate() {
        super.onCreate();

        //init Parse
        Parse.initialize(new Parse.Configuration.Builder(this)
                .applicationId("87c27ca0-2133-400c-aadf-beb43d430315")
                .server("http://34.73.142.234:1337/eatzie/")
                .enableLocalDataStore()
                .build());
    }
}
