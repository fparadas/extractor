defmodule Extractor.Cohere.ClientTest do
  use ExUnit.Case, async: true
  import Mox
  alias Extractor.Cohere.Client

  # Ensure mocks are verified after each test
  setup :verify_on_exit!

  describe "new/0" do
    setup do
      # Assuming `:extraxtor` is your app name
      Application.put_env(:extractor, :cohere_api_key, "test_api_key")
      :ok
    end

    test "returns a Client struct with the correct base configuration" do
      client = Client.new()

      assert client.url == "https://api.cohere.ai/v1"

      assert Enum.any?(client.headers, fn
               {"Authorization", value} -> String.contains?(value, "test_api_key")
               _ -> false
             end)
    end
  end

  describe "post/4" do
    setup do
      Application.put_env(:extractor, :cohere_api_key, "test_api_key")

      client = Client.new()
      {:ok, client: client}
    end

    test "successfully makes a POST request and returns response body", %{client: client} do
      response_body = "{\"result\": \"success\"}"

      HTTPoisonMock
      |> expect(:post, fn _, _, _ ->
        {:ok, %HTTPoison.Response{status_code: 200, body: response_body}}
      end)

      assert {:ok, response} = Client.post(client, "/test-endpoint", "{}", HTTPoisonMock)
      assert response == response_body
    end

    test "returns an error when the request fails", %{client: client} do
      HTTPoisonMock
      |> expect(:post, fn _, _, _ -> {:error, %HTTPoison.Error{reason: :error_reason}} end)

      assert {:error, _reason} = Client.post(client, "/test-endpoint", "{}", HTTPoisonMock)
    end
  end
end
