package com.onegini.resource;

import static com.onegini.resource.ResourceRequest.toMap;
import static com.onegini.resource.RestResourceInterface.getResourceCallMethod;
import static com.onegini.resource.RestResourceInterface.getRestAdapterForMethod;

import java.lang.reflect.Method;
import java.util.Collections;

import com.onegini.mobile.sdk.android.library.OneginiClient;
import com.onegini.mobile.sdk.android.library.handlers.OneginiResourceHandler;
import com.onegini.mobile.sdk.android.library.helpers.AnonymousResourceHelperAbstract;
import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;

public class AnonymousResourceClient extends AnonymousResourceHelperAbstract<String> {

  private static final ResourceRequestHeaderInterceptor HEADER_INTERCEPTOR = new ResourceRequestHeaderInterceptor();

  private ResourceRequest resourceRequest;

  public AnonymousResourceClient(final OneginiClient oneginiClient, final ResourceRequest resourceRequest) {
    super(oneginiClient, true);
    this.resourceRequest = resourceRequest;
  }

  @Override
  protected void performResourceActionImpl(final OneginiResourceHandler<String> oneginiResourceHandler,
                                           String[] strings, final String... params) {
    if (resourceRequest == null) {
      return;
    }

    if (resourceRequest.hasHeaders()) {
      HEADER_INTERCEPTOR.setHeaders(toMap(resourceRequest.getHeaders()));
    }

    final Object restClient = buildRestAdapterForMethod(resourceRequest.getRequestMethodString());
    final Method restResourceMethod = getResourceCallMethod(resourceRequest.getRequestMethodString());

    try {
      restResourceMethod
          .invoke(restClient, getAnonymousAuthenticationHeader(), resourceRequest.getPath(), new Callback<String>() {
            @Override
            public void success(final String result, final Response response) {
              oneginiResourceHandler.resourceSuccess(result, Collections.EMPTY_LIST);
            }

            @Override
            public void failure(final RetrofitError error) {
              handleError(error, oneginiResourceHandler, resourceRequest.getScopes(), params);
            }
          });
    } catch (final Exception e) {
      e.printStackTrace();
    }
  }

  private Object buildRestAdapterForMethod(final String requestMethod) {
    return getRestAdapter().create(getRestAdapterForMethod(requestMethod));
  }

}
