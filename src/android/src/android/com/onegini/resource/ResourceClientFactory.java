package com.onegini.resource;

public class ResourceClientFactory {

  private ResourceRequestCallback resourceRequestCallback;
  private RequestAdapterFactory requestAdapterFactory;

  public ResourceClientFactory(final ResourceRequestCallback resourceRequestCallback, final RequestAdapterFactory requestAdapterFactory) {
    this.resourceRequestCallback = resourceRequestCallback;
    this.requestAdapterFactory = requestAdapterFactory;
  }

  public ResourceRequestCommand build(final String httpMethod) {
    if ("GET".equalsIgnoreCase(httpMethod)) {
      return buildGetRequest(resourceRequestCallback, requestAdapterFactory);
    } else if ("POST".equalsIgnoreCase(httpMethod)) {
      return buildPostRequest(resourceRequestCallback, requestAdapterFactory);
    } else if ("PUT".equalsIgnoreCase(httpMethod)) {
      return buildPutRequest(resourceRequestCallback, requestAdapterFactory);
    } else if ("DELETE".equalsIgnoreCase(httpMethod)) {
      return buildDeleteRequest(resourceRequestCallback, requestAdapterFactory);
    }
    return buildGetRequest(resourceRequestCallback, requestAdapterFactory);
  }

  private GetResourceRequestCommand buildGetRequest(final ResourceRequestCallback requestCallback, final RequestAdapterFactory adapterFactory) {
    return new GetResourceRequestCommand(requestCallback, adapterFactory);
  }

  private PostResourceRequestCommand buildPostRequest(final ResourceRequestCallback requestCallback, final RequestAdapterFactory adapterFactory) {
    return new PostResourceRequestCommand(requestCallback, adapterFactory);
  }

  private DeleteResourceRequestCommand buildDeleteRequest(final ResourceRequestCallback requestCallback, final RequestAdapterFactory adapterFactory) {
    return new DeleteResourceRequestCommand(requestCallback, adapterFactory);
  }

  private PutResourceRequestCommand buildPutRequest(final ResourceRequestCallback requestCallback, final RequestAdapterFactory adapterFactory) {
    return new PutResourceRequestCommand(requestCallback, adapterFactory);
  }

}