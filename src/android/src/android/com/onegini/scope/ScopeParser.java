package com.onegini.scope;

import org.json.JSONArray;
import org.json.JSONException;

public class ScopeParser {
    public String[] getScopesAsArray(final JSONArray scopeAsJson) {
        try {
            String[] scopes = new String[scopeAsJson.length()];
            for (int x = 0; x < scopes.length; ++x) {
                scopes[x] = scopeAsJson.getString(x);
            }
            return scopes;
        } catch (final JSONException exception) {
            return null;
        }
    } 
}
