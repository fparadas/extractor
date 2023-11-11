defmodule Extractor.Example.GenerationExample do
  @moduledoc """
  A module for managing generation examples, specifically for handling text prompts and their completions.

  This module facilitates the creation and manipulation of `GenerationExample` structs.
  These structs represent a pair of a text prompt and its corresponding completion,
  commonly used in scenarios such as text generation or response modeling.

  ## Struct

  The `GenerationExample` struct includes the following fields:
    - `prompt`: The text prompt (String).
    - `completion`: The text completion associated with the prompt (String).
  """

  alias Extractor.Example.GenerationExample

  @type t :: %GenerationExample{
          prompt: String.t(),
          completion: String.t()
        }

  defstruct [:prompt, :completion]

  @doc """
  Updates the `prompt` field of a `GenerationExample`.

  ## Parameters

  - `example`: The `GenerationExample` struct to be updated.
  - `prompt`: The new text prompt to be set.

  ## Returns

  The updated `GenerationExample` struct with the new prompt.

  ## Examples

      iex> example = %Extractor.Example.GenerationExample{}
      iex> Extractor.Example.GenerationExample.add_prompt(example, "What is Elixir?")
      %Extractor.Example.GenerationExample{prompt: "What is Elixir?", completion: nil}
  """
  @spec add_prompt(t, String.t()) :: t
  def add_prompt(%GenerationExample{} = example, prompt), do: %{example | prompt: prompt}

  @doc """
  Updates the `completion` field of a `GenerationExample`.

  ## Parameters

  - `example`: The `GenerationExample` struct to be updated.
  - `completion`: The new text completion to be set.

  ## Returns

  The updated `GenerationExample` struct with the new completion.

  ## Examples

      iex> example = %Extractor.Example.GenerationExample{prompt: "What is Elixir?"}
      iex> Extractor.Example.GenerationExample.add_completion(example, "Elixir is a functional programming language.")
      %Extractor.Example.GenerationExample{prompt: "What is Elixir?", completion: "Elixir is a functional programming language."}
  """
  @spec add_completion(t, String.t()) :: t
  def add_completion(%GenerationExample{} = example, completion) do
    %{example | completion: completion}
  end
end
