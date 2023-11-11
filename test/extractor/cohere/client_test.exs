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

  describe "generate/6" do
    setup do
      Application.put_env(:extractor, :cohere_api_key, "test_api_key")

      client = Client.new()
      Mox.defmock(HTTPoisonMock, for: Extractor.Http.Adapter)
      {:ok, client: client}
    end

    test "successfully makes a generate request and returns generated text", %{client: client} do
      HTTPoisonMock
      |> expect(:post, fn _, _, _ ->
        {:ok,
         %HTTPoison.Response{status_code: 200, body: "{\"generated_text\": \"Generated text\"}"}}
      end)

      assert {:ok, "Generated text"} =
               Client.generate(client, "model-name", "Hello", 50, 1.0, HTTPoisonMock)
    end

    test "returns an error when the generate request fails", %{client: client} do
      HTTPoisonMock
      |> expect(:post, fn _, _, _ -> {:error, %HTTPoison.Error{reason: :error_reason}} end)

      assert {:error, _reason} =
               Client.generate(client, "model-name", "Hello", 50, 1.0, HTTPoisonMock)
    end
  end

  describe "classify/6" do
    setup do
      Application.put_env(:extractor, :cohere_api_key, "test_api_key")

      client = Client.new()
      Mox.defmock(HTTPoisonMock, for: Extractor.Http.Adapter)
      {:ok, client: client}
    end

    test "successfully makes a classify request and returns results", %{client: client} do
      response_body = "{\"classifications\": [{\"input\": \"Text\", \"prediction\": \"Label\"}]}"

      HTTPoisonMock
      |> expect(:post, fn _, _, _ ->
        {:ok, %HTTPoison.Response{status_code: 200, body: response_body}}
      end)

      assert {:ok, classifications} =
               Client.classify(client, "model-name", ["Text"], [], HTTPoisonMock)

      assert classifications == [%{"input" => "Text", "prediction" => "Label"}]
    end

    test "returns an error when the classify request fails", %{client: client} do
      HTTPoisonMock
      |> expect(:post, fn _, _, _ -> {:error, %HTTPoison.Error{reason: :error_reason}} end)

      assert {:error, _reason} =
               Client.classify(client, "model-name", ["Text"], [], HTTPoisonMock)
    end
  end
end
