package com.example.campbellaffleck.project2;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.net.Uri;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.VolleyLog;
import com.android.volley.toolbox.ImageRequest;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;
import com.squareup.picasso.Picasso;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.HashMap;
import java.util.Map;

public class LegislatorInfoActivity extends AppCompatActivity {

    private RequestQueue queue;
    //ProPublica Congress API Key
    String proPubKey = "ueFwgvEE9RxTZelGlUgUIfPzk7dFJcIKdizU0Y9I";
    String chamber;
    String state;
    String url;
    String photo_url;
    int district;
    String legislator;
    String member_id;
    TextView nameView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_legislator_info);

        Bundle b = getIntent().getExtras();
        legislator = b.getString("legislator");
        final String party = b.getString("party");
        final String website = b.getString("website");
        final String email = b.getString("email");
        district = b.getInt("district");
        state = b.getString("state");
        chamber = b.getString("chamber");
        member_id = b.getString("id");

        ImageView profileView = (ImageView) findViewById(R.id.profileView);
        nameView = (TextView) findViewById(R.id.nameView);
        final TextView websiteView = (TextView) findViewById(R.id.websiteView);
        final TextView emailView = (TextView) findViewById(R.id.emailView);
        final TextView partyView = (TextView) findViewById(R.id.partyView);

        //Configure formatting for legislator name and party
        nameView.setText(legislator);
        partyView.setText(party);
        if (party.contains("Dem")) {
            partyView.setTextColor(Color.parseColor("#00A2FF"));
        } else {
            partyView.setTextColor(Color.parseColor("#FF644E"));
        }

        //Add external link for going to the legislator's website
        websiteView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(website));
                startActivity(browserIntent);
            }
        });

        //Set external link for clicking on contact
        emailView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (!email.contains("null")) {
                    Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(email));
                    startActivity(browserIntent);
                } else {
                    String noCon = "No form of contact";
                    emailView.setText(noCon);
                    emailView.setTextColor(Color.RED);
                }
            }
        });

        //Configures url for propublica with member_id from previous activity
        url = "https://api.propublica.org/congress/v1/members/" + member_id + ".json";
        photo_url = "https://theunitedstates.io/images/congress/original/" + member_id + ".jpg";

        queue = Volley.newRequestQueue(this);

        Picasso.get().load(photo_url).into(profileView);
//        ImageRequest request = new ImageRequest(photo_url, new Response.Listener<Bitmap>() {
//            @Override
//            public void onResponse(Bitmap response) {
//                profileView.setImageBitmap(response);
//            }
//        }, 0, 0, Bitmap.Config.RGB_565, new Response.ErrorListener() {
//            @Override
//            public void onErrorResponse(VolleyError error) {
//                profileView.setImageResource(R.drawable.rightarrow);
//            }
//        });
//        queue.add(request);

        //Get more detailed info such as bills and dates from propublica
//        getProPubID(url);
    }

    //Method for looking at response from propublica to get the legislator's member id
    private void getProPubID(String url) {
        JsonObjectRequest request = new JsonObjectRequest(Request.Method.GET, url, null,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject response) {
                        try {
                            //If we're looking for a senator then we need to get the senator id for the correct senator
                            if (chamber == "senate") {
                                String legSub = legislator.substring(legislator.length() - 4);
                                JSONArray jsonArray = response.getJSONArray("results");
                                for (int i = 0; i < jsonArray.length(); i++) {
                                    JSONObject senator = jsonArray.getJSONObject(i);
                                    if (senator.getString("name").contains(legSub)) {
                                        member_id = senator.getString("id");
                                    }
                                }
                            }
                            //Otherwise propublica will only return one result, for the rep, so we can immediately get the id
                            else {
                                String legSub = legislator.substring(legislator.length() - 4);
                                JSONArray jsonArray = response.getJSONArray("results");
                                JSONObject senator = jsonArray.getJSONObject(0);
                                if (senator.getString("name").contains(legSub)) {
                                    member_id = senator.getString("id");
                                }
                            }
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }
                }, new Response.ErrorListener() {
            @Override
            public void onErrorResponse(VolleyError error) {
                VolleyLog.e("Error: ", error.getMessage());
            }
        }) {
            @Override
            public Map getHeaders() throws AuthFailureError {
                HashMap headers = new HashMap();
                headers.put("X-API-Key", proPubKey);
                return headers;
            }
        };
        queue.add(request);
    }
}
