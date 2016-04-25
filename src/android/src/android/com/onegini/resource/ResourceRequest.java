package com.onegini.resource;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.onegini.scope.ScopeParser;

public class ResourceRequest {

  public static final int PARAMETERS_WITH_HEADERS_LENGTH = 5;

  private final String path;
  private final String[] scopes;
  private final String requestMethodString;
  private final JSONObject params;
  private final JSONObject headers;

  public static ResourceRequest buildRequestFromArgs(final JSONArray args) {
    try {
      if (args.isNull(4)) {
        return new ResourceRequest(args.getString(0), args.getJSONArray(1), args.getString(2), args.getJSONObject(3));
      } else {
        return new ResourceRequest(args.getString(0), args.getJSONArray(1), args.getString(2), args.getJSONObject(3), args.getJSONObject(4));
      }
    } catch (final JSONException e) {
      e.printStackTrace();
      return null;
    }
  }

  public static String[] parseScopes(final JSONArray scopes) {
    return new ScopeParser().getScopesAsArray(scopes);
  }

  public ResourceRequest(final String path, final JSONArray scopes, final String requestMethodString,
                         final JSONObject params) {
    this(path, scopes, requestMethodString, params, null);
  }

  public ResourceRequest(final String path, final JSONArray scopes, final String requestMethodString,
                         final JSONObject params, final JSONObject headers) {
    this.path = formatPaht(path);
    this.scopes = parseScopes(scopes);
    this.requestMethodString = requestMethodString;
    this.params = params;
    this.headers = headers;
  }

  public String getPath() {
    return path;
  }

  public String[] getScopes() {
    return scopes;
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

  private String formatPaht(String path) {
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