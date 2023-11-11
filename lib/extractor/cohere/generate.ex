defmodule Extractor.Cohere.Generate do
  @moduledoc """
  A module for interacting with the text generation endpoint of the Cohere API.
  """

  alias Extractor.Cohere.Client

  @doc """
  Generates text using the Cohere 'generate' API.
  """
  @spec generate(Client.t(), String.t(), String.t(), integer(), float()) ::
          {:ok, String.t()} | {:error, any()}
  def generate(client, model, prompt, max_tokens \\ 50, temperature \\ 1.0) do
    body = prepare_generate_body(model, prompt, max_tokens, temperature)

    case Client.post(client, "/generate", body) do
      {:ok, response_body} ->
        generated_text = handle_response(response_body)
        {:ok, generated_text}

      {:error, reason} ->
        {:error, reason}
    end
  end

  defp prepare_generate_body(model, prompt, max_tokens, temperature) do
    %{
      model: model,
      prompt: prompt,
      max_tokens: max_tokens,
      temperature: temperature
    }
    |> Jason.encode!()
  end

  defp handle_response(body) do
    body |> Jason.decode!() |> Map.get("generated_text")
  end
end
