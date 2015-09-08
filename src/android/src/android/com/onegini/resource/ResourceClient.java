package com.onegini.resource;

import static com.onegini.resource.ResourceRequest.toMap;
import static com.onegini.resource.RestResourceInterface.getResourceCallMethod;
import static com.onegini.resource.RestResourceInterface.getRestAdapterForMethod;

import java.lang.reflect.Method;
import java.util.Collections;

import com.onegini.mobile.sdk.android.library.OneginiClient;
import com.onegini.mobile.sdk.android.library.handlers.OneginiResourceHandler;
import com.onegini.mobile.sdk.android.library.helpers.ResourceHelperAbstract;

import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;

public class ResourceClient extends ResourceHelperAbstract<String>{

  private static final ResourceRequestHeaderInterceptor HEADER_INTERCEPTOR = new ResourceRequestHeaderInterceptor();
  private static final String REQUEST_METHOD_POST = "POST";
  private static final String REQUEST_METHOD_PUT = "PUT";

  private final ResourceRequest resourceRequest;

  public ResourceClient(final OneginiClient oneginiClient, final ResourceRequest resourceRequest) {
    super(oneginiClient, HEADER_INTERCEPTOR, true);
    this.resourceRequest = resourceRequest;
  }

  @Override
  protected void performResourceActionImpl(final OneginiResourceHandler<String> resourceHandler, final String[] scopes,
                                           final String... params) {
    if (resourceRequest == null) {
      return;
    }

    if (resourceRequest.hasHeaders()) {
      HEADER_INTERCEPTOR.setHeaders(toMap(resourceRequest.getHeaders()));
    }

    final Object restClient = buildRestAdapterForMethod(resourceRequest.getRequestMethodString());
    final Method restResourceMethod = getResourceCallMethod(resourceRequest.getRequestMethodString());

    if (isBodyRequired()) {
      invokeWithBody(resourceHandler, restClient, restResourceMethod, params);
      return;
    }
    invokeWithoutBody(resourceHandler, restClient, restResourceMethod, params);
  }

  private boolean isBodyRequired() {
    return (REQUEST_METHOD_POST.equalsIgnoreCase(resourceRequest.getRequestMethodString())
            || REQUEST_METHOD_PUT.equalsIgnoreCase(resourceRequest.getRequestMethodString()));
  }

  private void invokeWithoutBody(final OneginiResourceHandler<String> resourceHandler, final Object restClient,
                                 final Method restResourceMethod, final String[] params) {
    try {
      restResourceMethod
          .invoke(restClient, getAuthenticationHeader(), resourceRequest.getPath(), new Callback<String>() {
            @Override
            public void success(final String result, final Response response) {
              resourceHandler.resourceSuccess(result, Collections.EMPTY_LIST);
            }

            @Override
            public void failure(final RetrofitError error) {
              handleError(error, resourceHandler, resourceRequest.getScopes(), params);
            }
          });
    } catch (final Exception e) {
      e.printStackTrace();
    }
  }

  private void invokeWithBody(final OneginiResourceHandler<String> resourceHandler, final Object restClient,
                              final Method restResourceMethod, final String[] params) {

    final String body = getRequestBody(params);
    try {
      restResourceMethod
          .invoke(restClient, getAuthenticationHeader(), resourceRequest.getPath(), body, new Callback<String>() {
            @Override
            public void success(final String result, final Response response) {
              resourceHandler.resourceSuccess(result, Collections.EMPTY_LIST);
            }

            @Override
            public void failure(final RetrofitError error) {
              handleError(error, resourceHandler, resourceRequest.getScopes(), params);
            }
          });
    } catch (final Exception e) {
      e.printStackTrace();
    }
  }

  private String getRequestBody(final String[] params) {
    if (params == null || params.length < 1 || params[0] == null) {
      return "{}";
    }
    return params[0];
  }

  private Object buildRestAdapterForMethod(final String requestMethod) {
    return getRestAdapter().create(getRestAdapterForMethod(requestMethod));
  }
}
