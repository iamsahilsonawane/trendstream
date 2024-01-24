package com.example.latest_movies

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.jakewharton.threetenabp.AndroidThreeTen
import com.egeniq.androidtvprogramguide.LivePreviewFragment

class LivePreviewActivity: AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        AndroidThreeTen.init(this)
        setContentView(R.layout.activity_live_full_preview)
        supportActionBar?.hide()
        //get the data from the intent
        val bundle: Bundle? = intent.extras
        val url = bundle?.getString("url")
        url?.let { println(it) }
        supportFragmentManager.beginTransaction()
            .replace(R.id.activity_live_preview, LivePreviewFragment.newInstance(bundle!!))
            .commit()
    }
}