package com.example.campbellaffleck.project2;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.tasks.OnSuccessListener;

public class HomeActivity extends AppCompatActivity {

    private double myLatitude;
    private double myLongitude;
    private int userZip;
    private static final int requestGrant = 0;
    //GeoCodio API Key: 9ebb9f32bbeb5355fbbbb3f3ef3e9b53b7ee5bb

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_home);

        //Get user's current location on start of the app
        FusedLocationProviderClient mFusedLocationClient = LocationServices.getFusedLocationProviderClient(this);
        if (ContextCompat.checkSelfPermission(HomeActivity.this, Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
            mFusedLocationClient.getLastLocation().addOnSuccessListener(this, new OnSuccessListener<Location>() {
                @Override
                public void onSuccess(Location location) {
                    // Got last known location. In some rare situations this can be null.
                    if (location != null) {
                        // Logic to handle location object
                        myLatitude = location.getLatitude();
                        myLongitude = location.getLongitude();
                    }
                }
            });
        } else {
            ActivityCompat.requestPermissions(HomeActivity.this, new String[]{Manifest.permission.ACCESS_FINE_LOCATION}, requestGrant);
        }

        //Set button variables for homepage buttons
        Button searchButton = findViewById(R.id.searchButton);
        Button getLocationButton = findViewById(R.id.getLocationButton);
        Button surpriseLocationButton = findViewById(R.id.surpriseLocationButton);
        final EditText zipCodeEntry = findViewById(R.id.zipcodeEntry);
        zipCodeEntry.setHint("ZIP CODE");
        final TextView zipcodeAlert = findViewById(R.id.zipcodeAlert);
        zipcodeAlert.setVisibility(View.INVISIBLE);

        searchButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (zipCodeEntry.getText().toString().matches("")) {
                    //If the zipCode entry hasn't been filled, display the alert to inform the user to fill it in
                    zipcodeAlert.setVisibility(View.VISIBLE);
                } else {
                    //Get zipcode and transition to new activity with list of reps and senators based on api call
                    userZip = Integer.parseInt(zipCodeEntry.getText().toString());
                    zipcodeAlert.setVisibility(View.INVISIBLE);
                    Intent startPeopleListActivity = new Intent(HomeActivity.this, PeopleListActivity.class);
                    Bundle b = new Bundle();
                    b.putInt("userZip", userZip);
                    b.putDouble("userLat", 0);
                    b.putDouble("userLon", 0);
                    startPeopleListActivity.putExtras(b);
                    startActivity(startPeopleListActivity);
                }

            }
        });

        getLocationButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //Transition to new activity using GeoCodio to find zipcode based on coordinates
                Intent startPeopleListActivity = new Intent(HomeActivity.this, PeopleListActivity.class);
                Bundle b = new Bundle();
                b.putDouble("userLat", myLatitude);
                b.putDouble("userLon", myLongitude);
                b.putInt("userZip", 0);
                startPeopleListActivity.putExtras(b);
                startActivity(startPeopleListActivity);
            }
        });

        surpriseLocationButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //Make random zipcode and transition to list of reps and senators based on api call
            }
        });
    }
}
