defmodule Extractor.Cohere.Client do
  alias Extractor.Cohere.Client

  @moduledoc """
  A client module for interacting with the Cohere API, which provides various machine learning models.

  This module facilitates the generation of text using the Cohere API by handling the HTTP request
  and response processes. It allows configuration of request parameters and handles the generation request.
  """

  @type t :: %Client{
          url: String.t(),
          headers: list({String.t(), String.t()})
        }

  defstruct [:url, :headers]

  @doc """
  Creates a new `%Extractor.Cohere.Client{}` struct with default or provided configurations.

  It sets up the client with default API endpoint and headers, including the authorization header
  with an API key fetched from the application environment. Custom options can override these defaults.

  ## Parameters

  - `opts`: Keyword list of options to override default client configurations. Supports keys like `:url` and `:headers`.

  ## Returns

  A new `%Extractor.Cohere.Client{}` struct configured for interacting with the Cohere API.
  """
  @spec new(keyword()) :: t
  def new(opts \\ []) do
    defaults = [
      url: "https://api.cohere.ai/v1",
      headers: default_headers()
    ]

    struct(Client, Keyword.merge(opts, defaults))
  end

  defp default_headers do
    api_key = Application.fetch_env!(:extractor, :cohere_api_key)

    [
      {"Authorization", "Bearer #{api_key}"},
      {"Content-Type", "application/json"},
      {"Accept", "application/json"}
    ]
  end

  def post(client, endpoint, body, http_client) do
    full_url = client.url <> endpoint

    case http_client.post(full_url, body, client.headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: response_body}} ->
        {:ok, response_body}

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Request failed with status code #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
