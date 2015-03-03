package com.onegini.resource;

import com.onegini.mobile.sdk.android.library.OneginiClient;
import com.onegini.mobile.sdk.android.library.handlers.OneginiResourceHandler;
import com.onegini.mobile.sdk.android.library.helpers.AnonymousResourceHelperAbstract;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.Collections;

import retrofit.Callback;
import retrofit.RetrofitError;
import retrofit.client.Response;
import retrofit.http.DELETE;
import retrofit.http.GET;
import retrofit.http.Header;
import retrofit.http.POST;
import retrofit.http.PUT;
import retrofit.http.Path;

public class AnonymousResourceClient extends AnonymousResourceHelperAbstract<String> {
    private final Object anonymousResourceRestClient;
    private String path;
    private String[] scopes;
    private Class<?> restClientImpl;

    public AnonymousResourceClient(OneginiClient oneginiClient, String path, String[] scopes, String requestMethod) {
        super(oneginiClient, true);
        this.scopes = scopes;
        restClientImpl = getRestClientImpl(requestMethod);
        anonymousResourceRestClient = getRestAdapter().create(GetRestClientImpl.class);
        this.path = preparePath(path);
    }

    private String preparePath(String path) {
        if (path.startsWith("/")) {
            return path.replaceFirst("/", "");
        }
        return path;
    }

    @Override
    protected void performResourceActionImpl(final OneginiResourceHandler<String> oneginiResourceHandler, String[] strings, final String... params) {
        Method getResourceMethod = getGetResourceMethod(anonymousResourceRestClient);
        try {
            getResourceMethod.invoke(anonymousResourceRestClient, getAnonymousAuthenticationHeader(), path, new Callback<String>() {
                @Override
                public void success(final String result, final Response response) {
                    oneginiResourceHandler.resourceSuccess(result, Collections.EMPTY_LIST);
                }

                @Override
                public void failure(final RetrofitError error) {
                    handleError(error, oneginiResourceHandler, scopes, params);
                }
            });
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        }
    }

    private Method getGetResourceMethod(Object anonymousResourceRestClient) {
        Method[] methods = restClientImpl.getMethods();
        for (Method m : methods) {
            if (m.getName().equals("getResource")) {
                return m;
            }
        }
        return null;
    }

    public Class<?> getRestClientImpl(String requestMethod) {
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
        throw new RuntimeException("Unsupported request method type " + requestMethod + " only GET,POST,PUT,DELETE supported");

    }


    private interface GetRestClientImpl {
        @GET("/{path}")
        void getResource(@Header("Authorization") String authorizationHeader,
                         @Path(value = "path", encode = false) String requestPath,
                         Callback<String> callback);
    }

    private interface PutRestClientImpl {
        @PUT("/{path}")
        void getResource(@Header("Authorization") String authorizationHeader,
                         @Path(value = "path", encode = false) String requestPath,
                         Callback<String> callback);
    }

    private interface PostRestClientImpl {
        @POST("/{path}")
        void getResource(@Header("Authorization") String authorizationHeader,
                         @Path(value = "path", encode = false) String requestPath,
                         Callback<String> callback);
    }

    private interface DeleteRestClientImpl {
        @DELETE("/{path}")
        void getResource(@Header("Authorization") String authorizationHeader,
                         @Path(value = "path", encode = false) String requestPath,
                         Callback<String> callback);
    }
}
