package com.onegini.resource;

import com.onegini.mobile.sdk.android.library.OneginiClient;
import com.onegini.mobile.sdk.android.library.handlers.OneginiResourceHandler;
import com.onegini.mobile.sdk.android.library.helpers.AnonymousResourceHelperAbstract;

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
    private final RestClientImpl anonymousResourceRestClient;
    private String path;
    private String[] scopes;

    public AnonymousResourceClient(OneginiClient oneginiClient, String path, String[] scopes, String requestMethod) {
        super(oneginiClient);
        this.scopes = scopes;
        anonymousResourceRestClient = (RestClientImpl) getRestAdapter().create(getRestClientImpl(requestMethod));
        this.path = path;
    }

    @Override
    protected void performResourceActionImpl(final OneginiResourceHandler<String> oneginiResourceHandler, String[] strings, final String... params) {
        anonymousResourceRestClient.getResource(getAnonymousAuthenticationHeader(), path, new Callback<String>() {
            @Override
            public void success(final String result, final Response response) {
                oneginiResourceHandler.resourceSuccess(result);
            }

            @Override
            public void failure(final RetrofitError error) {
                handleError(error, oneginiResourceHandler, scopes, params);
            }
        });
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

    private interface RestClientImpl {
        void getResource(String authorizationHeader, String requestPath, Callback<String> callback);
    }

    private interface GetRestClientImpl extends RestClientImpl {
        @GET("{path}")
        void getResource(@Header("Authorization") String authorizationHeader,
                         @Path(value = "path", encode = false) String requestPath,
                         Callback<String> callback);
    }

    private interface PutRestClientImpl extends RestClientImpl {
        @PUT("{path}")
        void getResource(@Header("Authorization") String authorizationHeader,
                         @Path(value = "path", encode = false) String requestPath,
                         Callback<String> callback);
    }

    private interface PostRestClientImpl extends RestClientImpl {
        @POST("{path}")
        void getResource(@Header("Authorization") String authorizationHeader,
                         @Path(value = "path", encode = false) String requestPath,
                         Callback<String> callback);
    }

    private interface DeleteRestClientImpl extends RestClientImpl {
        @DELETE("{path}")
        void getResource(@Header("Authorization") String authorizationHeader,
                         @Path(value = "path", encode = false) String requestPath,
                         Callback<String> callback);
    }
}
