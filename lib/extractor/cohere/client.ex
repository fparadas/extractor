defmodule Extractor.Cohere.Client do
  @moduledoc """
  A client module for interacting with the Cohere API, which provides various machine learning models.
  """

  alias Extractor.Cohere.Client

  @type t :: %Client{
          url: String.t(),
          headers: list({String.t(), String.t()})
        }

  defstruct [:url, :headers]

  @doc """
  Fetches the base configuration for the Cohere client.
  """
  @spec get_base() :: t
  def get_base() do
    {:ok, api_key} = Application.fetch_env(:extractor, :cohere_api_key)

    %Client{
      url: "https://api.cohere.ai/v1",
      headers: [
        {"Authorization", "Bearer #{api_key}"},
        {"Content-Type", "application/json"},
        {"Accept", "application/json"}
      ]
    }
  end

  @doc """
  Makes a POST request to the Cohere API.

  ## Parameters

  - `client`: The `Client` struct with the API configuration.
  - `endpoint`: The API endpoint for the POST request.
  - `body`: The JSON-encoded body of the request.

  Returns the response of the request.
  """
  @spec post(Client.t(), String.t(), any(), any()) :: {:ok, any()} | {:error, any()}
  def post(client, endpoint, body, http_client \\ HTTPoison) do
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
