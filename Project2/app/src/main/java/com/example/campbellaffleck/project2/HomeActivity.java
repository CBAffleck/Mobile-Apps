package com.example.campbellaffleck.project2;

import android.Manifest;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.location.Location;
import android.os.StrictMode;
import android.support.v4.app.ActivityCompat;
import android.support.v4.content.ContextCompat;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import org.jsoup.nodes.Document;

import com.google.android.gms.location.FusedLocationProviderClient;
import com.google.android.gms.location.LocationServices;
import com.google.android.gms.tasks.OnSuccessListener;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;
import java.util.concurrent.ThreadLocalRandom;

public class HomeActivity extends AppCompatActivity {

    private double myLatitude;
    private double myLongitude;
    private String userZip;
    private static final int requestGrant = 0;
    //GeoCodio API Key: 9ebb9f32bbeb5355fbbbb3f3ef3e9b53b7ee5bb

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
        StrictMode.setThreadPolicy(policy);
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
                    userZip = zipCodeEntry.getText().toString();
                    zipcodeAlert.setVisibility(View.INVISIBLE);
                    Intent startPeopleListActivity = new Intent(HomeActivity.this, PeopleListActivity.class);
                    Bundle b = new Bundle();
                    b.putString("userZip", userZip);
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
                b.putString("userZip", "0");
                startPeopleListActivity.putExtras(b);
                startActivity(startPeopleListActivity);
            }
        });

        surpriseLocationButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                //Get random zip code and transition to list of reps and senators representing that zip code
                String randomZip = getZipCode();
                Intent startPeopleListActivity = new Intent(HomeActivity.this, PeopleListActivity.class);
                Bundle b = new Bundle();
                b.putString("userZip", randomZip);
                b.putDouble("userLat", 0);
                b.putDouble("userLon", 0);
                startPeopleListActivity.putExtras(b);
                startActivity(startPeopleListActivity);
            }
        });
    }

    private String getZipCode() {
        //Make random zipcode and transition to list of reps and senators based on api call
        List<List<String>> zipRangeArray = new ArrayList<>();
        //Website with zip code ranges
        String zipUrl = "https://www.phaster.com/zip_code.html";
        Document document = null;
        try {
            document = Jsoup.connect(zipUrl).followRedirects(false).get();
        } catch (IOException e) {
            e.printStackTrace();
        }
        //Gets elements in the webpage html that contain "thru", which is unique to the zip code ranges
        Elements elems = document.select("td:contains(thru)");
        //Separate out all of the zip codes into ranges and organize them into array lists
        for (Element element : elems) {
            String itemValue = element.toString();
            int start = itemValue.indexOf(">", itemValue.indexOf(">") + 1);
            String sub = itemValue.substring(start + 1);
            String zipRange = sub.substring(0, sub.indexOf("<"));
            List<String> zips = new ArrayList();
            zips.add(zipRange.substring(0, 5));
            zips.add(zipRange.substring(11, 16));
            zipRangeArray.add(zips);
        }
        //Randomly select a zipcode range and then get a random zip code within that range
        List<String> random = zipRangeArray.get(new Random().nextInt(zipRangeArray.size()));
        String firstzip = random.get(0);
        int max = Integer.valueOf(random.get(1));
        int min = Integer.valueOf(random.get(0));
        int rand = new Random().nextInt((max - min) + 1) + min;
        String randomZip = String.valueOf(rand);
        //If the 0 leading a zip code was lost when converting between integer/string, add that 0 back to the start of the zip code string
        if (firstzip.substring(0,1).equals("0")) {
            randomZip = "0" + String.valueOf(rand);
        };
        return randomZip;
    }
}
