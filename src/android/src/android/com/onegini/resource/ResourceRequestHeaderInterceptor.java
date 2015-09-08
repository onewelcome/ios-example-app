package com.onegini.resource;

import java.util.Iterator;
import java.util.Map;

import retrofit.RequestInterceptor;

public class ResourceRequestHeaderInterceptor implements RequestInterceptor {

  private Map<String, String> headers;

  @Override
  public void intercept(final RequestFacade request) {
    if (headers == null) {
      return;
    }

    final Iterator iterator = headers.entrySet().iterator();
    while (iterator.hasNext()) {
      final Map.Entry<String, String> header = (Map.Entry)iterator.next();
      request.addHeader(header.getKey(), header.getValue());
    }

    nullifyHeadersOnceAdded();
  }

  public void nullifyHeadersOnceAdded() {
    setHeaders(null);
  }

  public void setHeaders(final Map<String, String> headers) {
    this.headers = headers;
  }
}
