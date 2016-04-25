package com.onegini.resource;

import static com.onegini.resource.RestResource.DeleteRestClientImpl;
import static com.onegini.resource.RestResource.PostRestClientImpl;
import static com.onegini.resource.RestResource.PutRestClientImpl;

import com.onegini.mobile.sdk.android.library.OneginiClient;
import com.onegini.resource.RestResource.GetRestClientImpl;
import retrofit.RestAdapter;

public class AuthorizedRequestAdapterFactory implements RequestAdapterFactory {

  private final OneginiClient oneginiClient;

  public AuthorizedRequestAdapterFactory(final OneginiClient oneginiClient) {
    this.oneginiClient = oneginiClient;
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
        .setClient(oneginiClient.getResourceRetrofitClient())
        .setEndpoint(oneginiClient.getConfigModel().getResourceBaseUrl())
        .setConverter(new RetrofitByteConverter())
        .setLogLevel(RestAdapter.LogLevel.BASIC)
        .build();
  }

}