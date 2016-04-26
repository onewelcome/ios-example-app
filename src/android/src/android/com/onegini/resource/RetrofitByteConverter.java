package com.onegini.resource;

import java.io.IOException;
import java.lang.reflect.Type;

import org.apache.commons.io.IOUtils;

import com.onegini.mobile.sdk.android.library.helpers.TypedBodyConverter;
import retrofit.converter.ConversionException;
import retrofit.converter.Converter;
import retrofit.mime.TypedInput;
import retrofit.mime.TypedOutput;

public class RetrofitByteConverter implements Converter {

  @Override
  public Object fromBody(final TypedInput body, final Type type) throws ConversionException {
    return fromTypedInput(body);
  }

  @Override
  public TypedOutput toBody(final Object object) {
    return new TypedBodyConverter().toBody(object);
  }

  public static byte[] fromTypedInput(final TypedInput input) {
    try {
      return IOUtils.toByteArray(input.in());
    } catch (IOException e) {
      return new byte[0];
    }
  }

}
