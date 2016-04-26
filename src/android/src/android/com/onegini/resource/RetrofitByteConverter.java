package com.onegini.resource;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectOutput;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.lang.reflect.Type;

import org.apache.commons.io.IOUtils;

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
    try {
      final byte[] bytes = getBytes(object);
      return new ByteTypedOutput(bytes);
    } catch (IOException e) {
      return new ByteTypedOutput(new byte[0]);
    }
  }

  public static byte[] fromTypedInput(final TypedInput input) {
    try {
      return IOUtils.toByteArray(input.in());
    } catch (IOException e) {
      return new byte[0];
    }
  }

  private byte[] getBytes(final Object object) throws IOException {
    ByteArrayOutputStream bos = new ByteArrayOutputStream();
    ObjectOutput out = new ObjectOutputStream(bos);
    out.writeObject(object);
    return bos.toByteArray();
  }

  private static class ByteTypedOutput implements TypedOutput {

    private final byte[] bytes;

    public ByteTypedOutput(final byte[] bytes) {
      this.bytes = bytes;
    }

    @Override
    public String fileName() {
      return null;
    }

    @Override
    public String mimeType() {
      return "";
    }

    @Override
    public long length() {
      return bytes.length;
    }

    @Override
    public void writeTo(final OutputStream out) throws IOException {
      out.write(bytes);
    }
  }

}
