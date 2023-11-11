defmodule Extractor.CohereTest do
  use ExUnit.Case, async: true
  import Mox

  alias Extractor.Cohere
  alias Extractor.Cohere.Client

  # Ensure mocks are verified after each test
  setup :verify_on_exit!

  describe "generate/6" do
    setup do
      Application.put_env(:extractor, :cohere_api_key, "test_api_key")

      client = Client.new()
      {:ok, client: client}
    end

    test "successfully makes a generate request and returns generated text", %{client: client} do
      HTTPoisonMock
      |> expect(:post, fn _, _, _ ->
        {:ok,
         %HTTPoison.Response{status_code: 200, body: "{\"generated_text\": \"Generated text\"}"}}
      end)

      assert {:ok, %{"generated_text" => "Generated text"}} =
               Cohere.generate(client, "model-name", "Hello", 50, 1.0, HTTPoisonMock)
    end

    test "returns an error when the generate request fails", %{client: client} do
      HTTPoisonMock
      |> expect(:post, fn _, _, _ -> {:error, %HTTPoison.Error{reason: :error_reason}} end)

      assert {:error, _reason} =
               Cohere.generate(client, "model-name", "Hello", 50, 1.0, HTTPoisonMock)
    end
  end

  describe "classify/6" do
    setup do
      Application.put_env(:extractor, :cohere_api_key, "test_api_key")

      client = Client.new()
      {:ok, client: client}
    end

    test "successfully makes a classify request and returns results", %{client: client} do
      response_body =
        "{\"classifications\": [{\"input\": \"Text\", \"prediction\": \"Label\"}]}"

      HTTPoisonMock
      |> expect(:post, fn _, _, _ ->
        {:ok, %HTTPoison.Response{status_code: 200, body: response_body}}
      end)

      assert {:ok, classifications} =
               Cohere.classify(client, "model-name", ["Text"], [], HTTPoisonMock)

      assert classifications == %{
               "classifications" => [%{"input" => "Text", "prediction" => "Label"}]
             }
    end

    test "returns an error when the classify request fails", %{client: client} do
      HTTPoisonMock
      |> expect(:post, fn _, _, _ -> {:error, %HTTPoison.Error{reason: :error_reason}} end)

      assert {:error, _reason} =
               Cohere.classify(client, "model-name", ["Text"], [], HTTPoisonMock)
    end
  end
end
