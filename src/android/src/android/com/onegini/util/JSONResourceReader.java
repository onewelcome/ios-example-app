package com.onegini.util;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.StringWriter;
import java.io.Writer;

import android.content.res.Resources;
import android.util.Log;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

public class JSONResourceReader {
  private static String TAG = JSONResourceReader.class.getName();

  /**
   * Read from a resources file and create a {@link JSONResourceReader} object that will allow the creation of other
   * objects from this resource.
   *
   * @param resources An application {@link android.content.res.Resources} object.
   * @param id The id for the resource to load, typically held in the raw/ folder.
   */
  public String parse(final Resources resources, final int id) {
    final InputStream resourceReader = resources.openRawResource(id);
    final Writer writer = new StringWriter();
    try {
      BufferedReader reader = new BufferedReader(new InputStreamReader(resourceReader, "UTF-8"));
      String line = reader.readLine();
      while (line != null) {
        writer.write(line);
        line = reader.readLine();
      }
    } catch (Exception e) {
      Log.e(TAG, "Unhandled exception while using JSONResourceReader", e);
    } finally {
      try {
        resourceReader.close();
      } catch (Exception e) {
        Log.e(TAG, "Unhandled exception while using JSONResourceReader", e);
      }
    }

    return writer.toString();
  }

  /**
   * Build an object from the specified JSON resource using Gson.
   *
   * @param type The type of the object to build.
   * @return An object of type T, with member fields populated using Gson.
   */
  public <T> T map(final Class<T> type, final String jsonString) {
    final Gson gson = new GsonBuilder().create();
    return gson.fromJson(jsonString, type);
  }
}
