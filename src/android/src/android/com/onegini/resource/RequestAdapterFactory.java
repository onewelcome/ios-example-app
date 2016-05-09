package com.onegini.resource;

import static com.onegini.resource.ResourceRequest.toMap;
import static com.onegini.resource.RestResource.DeleteRestClientImpl;
import static com.onegini.resource.RestResource.PostRestClientImpl;
import static com.onegini.resource.RestResource.PutRestClientImpl;

import com.onegini.mobile.sdk.android.library.OneginiClient;
import com.onegini.resource.RestResource.GetRestClientImpl;
import retrofit.RestAdapter;
import retrofit.client.OkClient;

public class RequestAdapterFactory {

  private final OkClient retrofitClient;
  private final OneginiClient oneginiClient;
  private final ResourceRequest resourceRequest;

  public RequestAdapterFactory(final OkClient retrofitClient, final OneginiClient oneginiClient, final ResourceRequest resourceRequest) {
    this.retrofitClient = retrofitClient;
    this.oneginiClient = oneginiClient;
    this.resourceRequest = resourceRequest;
  }

  public GetRestClientImpl buildGetRequestAdapter() {
    return buildRestAdapter().create(GetRestClientImpl.class);
  }

  public PostRestClientImpl buildPostRequestAdapter() {
    return buildRestAdapter().create(PostRestClientImpl.class);
  }

  public PutRestClientImpl buildPutRequestAdapter() {
    return buildRestAdapter().create(PutRestClientImpl.class);
  }

  public DeleteRestClientImpl buildDeleteRequestAdapter() {
    return buildRestAdapter().create(DeleteRestClientImpl.class);
  }

  private RestAdapter buildRestAdapter() {
    return new RestAdapter.Builder()
        .setClient(retrofitClient)
        .setEndpoint(oneginiClient.getConfigModel().getResourceBaseUrl())
        .setConverter(new RetrofitByteConverter())
        .setRequestInterceptor(buildInterceptor())
        .setLogLevel(RestAdapter.LogLevel.BASIC)
        .build();
  }

  private ResourceRequestHeaderInterceptor buildInterceptor() {
    final ResourceRequestHeaderInterceptor resourceRequestHeaderInterceptor = new ResourceRequestHeaderInterceptor();
    if (resourceRequest.hasHeaders()) {
      resourceRequestHeaderInterceptor.setHeaders(toMap(resourceRequest.getHeaders()));
    }

    return resourceRequestHeaderInterceptor;
  }

}