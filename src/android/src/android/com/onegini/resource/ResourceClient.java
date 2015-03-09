package com.onegini.resource;

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

  private final ResourceRequest resourceRequest;

  public ResourceClient(final OneginiClient oneginiClient, final ResourceRequest resourceRequest) {
    super(oneginiClient, true);
    this.resourceRequest = resourceRequest;
  }

  @Override
  protected void performResourceActionImpl(final OneginiResourceHandler<String> resourceHandler, final String[] scopes,
                                           final String... params) {
    if (resourceRequest == null) {
      return;
    }

    final Object restClient = buildRestAdapterForMethod(resourceRequest.getRequestMethodString());
    final Method restResourceMethod = getResourceCallMethod(resourceRequest.getRequestMethodString());

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

  private Object buildRestAdapterForMethod(final String requestMethod) {
    return getRestAdapter().create(getRestAdapterForMethod(requestMethod));
  }
}
