defmodule Extractor.Http.Adapter do
  @callback post(url :: String.t(), body :: String.t(), headers :: list) :: String.t()
end
