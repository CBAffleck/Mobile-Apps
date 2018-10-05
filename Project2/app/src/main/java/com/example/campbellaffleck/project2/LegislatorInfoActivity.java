package com.example.campbellaffleck.project2;

import android.content.Intent;
import android.graphics.Color;
import android.graphics.Typeface;
import android.net.Uri;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.android.volley.AuthFailureError;
import com.android.volley.Request;
import com.android.volley.RequestQueue;
import com.android.volley.Response;
import com.android.volley.VolleyError;
import com.android.volley.VolleyLog;
import com.android.volley.toolbox.JsonObjectRequest;
import com.android.volley.toolbox.Volley;
import com.squareup.picasso.Picasso;
import com.squareup.picasso.Transformation;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import jp.wasabeef.picasso.transformations.RoundedCornersTransformation;

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
    List<String> committeeList = new ArrayList<>();
    LinearLayout mylayout;

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

        ImageView profileView = findViewById(R.id.profileView);
        nameView = findViewById(R.id.nameView);
        final TextView websiteView = findViewById(R.id.websiteView);
        final TextView emailView = findViewById(R.id.emailView);
        final TextView partyView = findViewById(R.id.partyView);

        //Configure formatting for legislator name and party
        nameView.setText(legislator);
        partyView.setText(party);
        if (party.contains("Dem")) {
            partyView.setTextColor(Color.parseColor("#00A2FF"));
        } else {
            partyView.setTextColor(Color.parseColor("#FF644E"));
        }

        //Add external link for going to the legislator's website
        websiteView.setTextColor(Color.parseColor("#929292"));
        websiteView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(website));
                startActivity(browserIntent);
            }
        });

        //Set external link for clicking on contact
        emailView.setTextColor(Color.parseColor("#929292"));
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

        final int radius = 20;
        final int margin = 20;
        final Transformation transformation = new RoundedCornersTransformation(radius, margin);
        Picasso.get().load(photo_url).centerCrop().resize(400, 600).transform(transformation).into(profileView);

        //Get more detailed info such as bills and dates from propublica
        getProPubID(url);
    }

    //Method for looking at response from propublica to get the legislator's member id
    private void getProPubID(String url) {
        JsonObjectRequest request = new JsonObjectRequest(Request.Method.GET, url, null,
                new Response.Listener<JSONObject>() {
                    @Override
                    public void onResponse(JSONObject response) {
                        try {
                            //Goes through json hierarchy in the json response from propublica
                            JSONArray jsonArray = response.getJSONArray("results");
                            JSONObject resultObj = jsonArray.getJSONObject(0);
                            JSONArray roleArray = resultObj.getJSONArray("roles");
                            JSONObject roleObj = roleArray.getJSONObject(0);
                            JSONArray committeeArray = roleObj.getJSONArray("committees");
                            for (int i = 0; i < committeeArray.length(); i++) {
                                JSONObject committee = committeeArray.getJSONObject(i);
                                String name = committee.getString("name");
                                committeeList.add(name);
                            }
                            //Add easily noticeable break to list so we know when we switch to subcommittees when reading the list later
                            committeeList.add("0000");
                            JSONArray subCommitteeArray = roleObj.getJSONArray("subcommittees");
                            for (int i = 0; i < subCommitteeArray.length(); i++) {
                                JSONObject subcommittee = subCommitteeArray.getJSONObject(i);
                                String name = subcommittee.getString("name");
                                committeeList.add(name);
                            }
                            //Add the committees to the activity for the user to see
                            addInfoBoxes();
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

    private void addInfoBoxes() {
        mylayout = findViewById(R.id.linearView);
        for (int i = 0; i < committeeList.size(); i++) {
            LinearLayout.LayoutParams lparams = new LinearLayout.LayoutParams(LinearLayout.LayoutParams.MATCH_PARENT, LinearLayout.LayoutParams.WRAP_CONTENT,60);
            lparams.setMargins(0,10,0,10);
            final LinearLayout display = new LinearLayout(this);
            display.setLayoutParams(lparams);

            if (i == 0) {
                //Formatting for "Committee" title
                final LinearLayout titleDisplay = new LinearLayout(this);
                titleDisplay.setLayoutParams(lparams);
                TextView title = new TextView(this);
                String com = "Committees";
                title.setText(com);
                title.setTypeface(null, Typeface.BOLD);
                title.setTextSize(18);
                title.setGravity(Gravity.CENTER|Gravity.START);
                title.setPadding(30,0,0,0);
                titleDisplay.addView(title);
                mylayout.addView(titleDisplay);
            } else if (committeeList.get(i).contains("0000") && i == 1) {
                //Formatting for adding text when the legislator is on no committees
                final LinearLayout titleDisplay3 = new LinearLayout(this);
                titleDisplay3.setLayoutParams(lparams);
                TextView title3 = new TextView(this);
                String noCom = legislator + " is on no committees";
                title3.setText(noCom);
                title3.setTextColor(Color.parseColor("#FF644E"));
                title3.setTextSize(15);
                title3.setGravity(Gravity.START);
                title3.setPadding(70,0,0,0);
                titleDisplay3.addView(title3);
                mylayout.addView(titleDisplay3);
                //Formatting for "Subcommittee" title
                final LinearLayout titleDisplay2 = new LinearLayout(this);
                titleDisplay2.setLayoutParams(lparams);
                TextView title2 = new TextView(this);
                String subCom = "Subcommittees";
                title2.setText(subCom);
                title2.setTypeface(null, Typeface.BOLD);
                title2.setTextSize(18);
                title2.setGravity(Gravity.CENTER|Gravity.START);
                title2.setPadding(30,0,0,0);
                titleDisplay2.addView(title2);
                mylayout.addView(titleDisplay2);
            } else if (committeeList.get(i).contains("0000")) {
                //Formatting for "Subcommittee" title
                final LinearLayout titleDisplay2 = new LinearLayout(this);
                titleDisplay2.setLayoutParams(lparams);
                TextView title2 = new TextView(this);
                String subCom = "Subcommittees";
                title2.setText(subCom);
                title2.setTypeface(null, Typeface.BOLD);
                title2.setTextSize(18);
                title2.setGravity(Gravity.CENTER|Gravity.START);
                title2.setPadding(30,0,0,0);
                titleDisplay2.addView(title2);
                mylayout.addView(titleDisplay2);
            } else {
                //Formatting for committee/subcommittee names
                TextView name = new TextView(this);
                name.setText(committeeList.get(i));
                name.setTextSize(15);
                name.setGravity(Gravity.START);
                name.setPadding(70, 0, 0, 0);
                display.addView(name);
                mylayout.addView(display);
            }
        }
    }
}
