defmodule Extractor.Cohere do
  alias Extractor.Example.ClassificationExample

  @callback generate(
              model :: String.t(),
              prompt :: String.t(),
              max_tokens :: integer(),
              temperature :: float()
            ) :: {:ok, any()} | {:error, any()}

  @callback classify(
              model :: String.t(),
              inputs :: list(String.t()),
              examples :: list(ClassificationExample.t()),
              max_tokens :: integer(),
              temperature :: float()
            ) :: {:ok, any()} | {:error, any()}
end
