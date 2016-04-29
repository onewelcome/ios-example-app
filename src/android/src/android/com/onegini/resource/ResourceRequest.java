package com.onegini.resource;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.onegini.scope.ScopeParser;

public class ResourceRequest {

  public static final int PARAMETERS_WITH_HEADERS_LENGTH = 4;

  private final String path;
  private final String requestMethodString;
  private final JSONObject params;
  private final JSONObject headers;

  public static ResourceRequest buildRequestFromArgs(final JSONArray args) {
    try {
      if (args.isNull(3)) {
        return new ResourceRequest(args.getString(0), args.getString(1), args.getJSONObject(2));
      } else {
        return new ResourceRequest(args.getString(0), args.getString(1), args.getJSONObject(2), args.getJSONObject(3));
      }
    } catch (final JSONException e) {
      e.printStackTrace();
      return null;
    }
  }

  public static String[] parseScopes(final JSONArray scopes) {
    return new ScopeParser().getScopesAsArray(scopes);
  }

  public ResourceRequest(final String path, final String requestMethodString, final JSONObject params) {
    this(path, requestMethodString, params, null);
  }

  public ResourceRequest(final String path, final String requestMethodString, final JSONObject params, final JSONObject headers) {
    this.path = formatPath(path);
    this.requestMethodString = requestMethodString;
    this.params = params;
    this.headers = headers;
  }

  public String getPath() {
    return path;
  }

  public String getRequestMethodString() {
    return requestMethodString;
  }

  public JSONObject getParams() {
    return params;
  }

  public boolean hasHeaders() {
    return headers != null;
  }

  public JSONObject getHeaders() {
    return headers;
  }

  private String formatPath(String path) {
    if (path.startsWith("/")) {
      return path.replaceFirst("/", "");
    }
    return path;
  }

  public static Map<String, String> toMap(final JSONObject object) {
    final Map<String, String> map = new HashMap<String, String>();
    final Iterator<String> keysItr = object.keys();

    try {
      String key, value;
      while (keysItr.hasNext()) {
        key = keysItr.next();
        value = object.getString(key);
        map.put(key, value);
      }
    } catch (final JSONException e) {
      e.printStackTrace();
      return null;
    }
    return map;
  }

}