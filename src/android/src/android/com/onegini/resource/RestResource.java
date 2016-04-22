package com.onegini.resource;

import retrofit.Callback;
import retrofit.http.Body;
import retrofit.http.DELETE;
import retrofit.http.GET;
import retrofit.http.POST;
import retrofit.http.PUT;
import retrofit.http.Path;

public class RestResource {

  public interface GetRestClientImpl {
    @GET("/{path}")
    void call(@Path(value = "path", encode = false) String requestPath,
              Callback<String> callback);
  }

  public interface DeleteRestClientImpl {
    @DELETE("/{path}")
    void call(@Path(value = "path", encode = false) String requestPath,
              Callback<String> callback);
  }

  public interface PutRestClientImpl {
    @PUT("/{path}")
    void call(@Path(value = "path", encode = false) String requestPath,
              @Body String bodyString,
              Callback<String> callback);
  }

  public interface PostRestClientImpl {
    @POST("/{path}")
    void call(@Path(value = "path", encode = false) String requestPath,
              @Body String bodyString,
              Callback<String> callback);
  }

}