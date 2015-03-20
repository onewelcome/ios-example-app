package com.onegini.resource;

import java.lang.reflect.Method;

import retrofit.Callback;
import retrofit.http.Body;
import retrofit.http.DELETE;
import retrofit.http.GET;
import retrofit.http.Header;
import retrofit.http.POST;
import retrofit.http.PUT;
import retrofit.http.Path;

public class RestResourceInterface {

  private static final String RESOURCE_CALL_METHOD = "call";

  public interface GetRestClientImpl {
    @GET("/{path}")
    void call(@Header("Authorization") String authorizationHeader,
              @Path(value = "path", encode = false) String requestPath,
              Callback<String> callback);
  }

  public interface PutRestClientImpl {
    @PUT("/{path}")
    void call(@Header("Authorization") String authorizationHeader,
              @Path(value = "path", encode = false) String requestPath,
              @Body String bodyString,
              Callback<String> callback);
  }

  public interface PostRestClientImpl {
    @POST("/{path}")
    void call(@Header("Authorization") String authorizationHeader,
              @Path(value = "path", encode = false) String requestPath,
              @Body String bodyString,
              Callback<String> callback);
  }

  public interface DeleteRestClientImpl {
    @DELETE("/{path}")
    void call(@Header("Authorization") String authorizationHeader,
              @Path(value = "path", encode = false) String requestPath,
              Callback<String> callback);
  }

  public static Method getResourceCallMethod(final String requestMethod) {
    final Method[] methods = getRestAdapterForMethod(requestMethod).getMethods();
    for (Method m : methods) {
      if (m.getName().equals(RESOURCE_CALL_METHOD)) {
        return m;
      }
    }
    return null;
  }

  public static Class<?> getRestAdapterForMethod(final String requestMethod) {
    if ("GET".equalsIgnoreCase(requestMethod)) {
      return GetRestClientImpl.class;
    }
    if ("POST".equalsIgnoreCase(requestMethod)) {
      return PostRestClientImpl.class;
    }
    if ("PUT".equalsIgnoreCase(requestMethod)) {
      return PutRestClientImpl.class;
    }
    if ("DELETE".equalsIgnoreCase(requestMethod)) {
      return DeleteRestClientImpl.class;
    }
    return null;
  }

}
