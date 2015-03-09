package com.onegini.resource;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.onegini.scope.ScopeParser;

public class ResourceRequest {
  private final String path;
  private final String[] scopes;
  private final String requestMethodString;
  private final String paramsEncodingString;
  private final JSONObject params;

  public static ResourceRequest buildRequestFromArgs(final JSONArray args) {
    try {
      return new ResourceRequest(args.getString(0), args.getJSONArray(1), args.getString(2), args.getString(3),
          args.getJSONObject(4));
    } catch (JSONException e) {
      e.printStackTrace();
      return null;
    }
  }

  public ResourceRequest(final String path, final JSONArray scopes, final String requestMethodString,
                  final String paramsEncodingString, final JSONObject params) {
    this.path = formatPaht(path);
    this.scopes = parseScopes(scopes);
    this.requestMethodString = requestMethodString;
    this.paramsEncodingString = paramsEncodingString;
    this.params = params;
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

  public String getParamsEncodingString() {
    return paramsEncodingString;
  }

  public JSONObject getParams() {
    return params;
  }

  private String formatPaht(String path) {
    if (path.startsWith("/")) {
      return path.replaceFirst("/", "");
    }
    return path;
  }

  private String[] parseScopes(final JSONArray scopes) {
    final ScopeParser scopeParser = new ScopeParser();
    try {
      return scopeParser.getScopesAsArray(scopes);
    } catch (JSONException e) {
      e.printStackTrace();
      return null;
    }
  }

}
