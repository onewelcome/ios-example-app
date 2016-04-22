package com.onegini.resource;

import static com.onegini.resource.RestResource.DeleteRestClientImpl;
import static com.onegini.resource.RestResource.PostRestClientImpl;
import static com.onegini.resource.RestResource.PutRestClientImpl;

import com.onegini.resource.RestResource.GetRestClientImpl;

public interface RequestAdapterFactory {

  GetRestClientImpl buildGetRequestAdapter();

  PostRestClientImpl buildPostRequestAdapter();

  PutRestClientImpl buildPutRequestAdapter();

  DeleteRestClientImpl buildDeleteRequestAdapter();

}