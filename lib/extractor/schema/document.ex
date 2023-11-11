defmodule Extractor.Schema.Document do
  @moduledoc """
  Defines the `Document` structure and provides functions for constructing and manipulating documents.

  The `Document` is a fundamental structure in our system, representing a document
  with a unique identifier, text content, a list of labels, and a list of generations.
  This module offers functions to add or modify these fields immutably,
  facilitating the step-by-step construction of documents.

  ## Structure

  The `Document` structure contains the following fields:
    - `id`: A unique identifier for the document (String).
    - `text`: The text content of the document (String).
    - `labels`: A list of labels associated with the document (list of Strings).
    - `generations`: A list of generations or versions of the document (list of Strings).

  The use of lists for `labels` and `generations` allows for flexibility in classification and
  tracking the document's evolution.

  ## Functions

  The module provides functions to add or update each field of the `Document` structure,
  respecting the typical immutability of data structures in Elixir. Each function
  returns a new instance of the structure with the applied modifications.
  """

  alias Extractor.Schema.Document

  @type t :: %Document{
          id: String.t(),
          text: String.t(),
          labels: list(String.t()),
          generations: list(String.t()),
          metadata: map()
        }

  defstruct id: "", text: "", labels: [], generations: [], metadata: %{}

  @doc """
  Adds or updates the `id` field in a `Document` structure.

  ## Parameters

  - `document`: The `Document` structure to be updated.
  - `id`: The new `id` to be set for the `Document`.

  ## Returns

  A new `Document` structure with the updated `id`.

  ## Examples

    iex> document = %Extractor.Schema.Document{}
    iex> Extractor.Schema.Document.add_id(document, "123")
    %Extractor.Schema.Document{id: "123", text: "", labels: [], generations: [], metadata: %{}}

  """
  @spec add_id(t, String.t()) :: t
  def add_id(%Document{} = document, id), do: %{document | id: id}

  @doc """
  Adds or updates the `text` field in a `Document` structure.

  ## Parameters

  - `document`: The `Document` structure to be updated.
  - `text`: The new text content to be set for the `Document`.

  ## Returns

  A new `Document` structure with the updated text content.

  ## Examples

    iex> document = %Extractor.Schema.Document{id: "123"}
    iex> Extractor.Schema.Document.add_text(document, "Sample text")
    %Extractor.Schema.Document{id: "123", text: "Sample text", labels: [], generations: [], metadata: %{}}

  """
  @spec add_text(t, String.t()) :: t
  def add_text(%Document{} = document, text), do: %{document | text: text}

  @doc """
  Adds labels to the `labels` field in a `Document` structure.

  ## Parameters

  - `document`: The `Document` structure to be updated.
  - `labels`: The list of new labels to be added to the `Document`.

  ## Returns

  A new `Document` structure with the updated labels.

  ## Examples

    iex> document = %Extractor.Schema.Document{id: "123", text: "Sample text"}
    iex> updated_document = Extractor.Schema.Document.add_labels(document, ["label1", "label2"])
    %Extractor.Schema.Document{id: "123", text: "Sample text", labels: ["label1", "label2"], generations: [], metadata: %{}}
    iex> Extractor.Schema.Document.add_labels(updated_document, ["label3"])
    %Extractor.Schema.Document{id: "123", text: "Sample text", labels: ["label1", "label2", "label3"], generations: [], metadata: %{}}

  """
  @spec add_labels(t, list(String.t())) :: t
  def add_labels(%Document{labels: old_labels} = document, labels) do
    %{document | labels: old_labels ++ labels}
  end

  @doc """
  Adds generations to the `generations` field in a `Document` structure.

  ## Parameters

  - `document`: The `Document` structure to be updated.
  - `gens`: The list of new generations to be added to the `Document`.

  ## Returns

  A new `Document` structure with the updated generations.

  ## Examples

    iex> document = %Extractor.Schema.Document{id: "123", text: "Sample text", labels: ["label1"]}
    iex> updated_document = Extractor.Schema.Document.add_generations(document, ["gen1", "gen2"])
    %Extractor.Schema.Document{id: "123", text: "Sample text", labels: ["label1"], generations: ["gen1", "gen2"], metadata: %{}}
    iex> Extractor.Schema.Document.add_generations(updated_document, ["gen3"])
    %Extractor.Schema.Document{id: "123", text: "Sample text", labels: ["label1"], generations: ["gen1", "gen2", "gen3"], metadata: %{}}

  """
  @spec add_generations(t, list(String.t())) :: t
  def add_generations(%Document{generations: old_gens} = document, gens) do
    %{document | generations: old_gens ++ gens}
  end

  @doc """
  Adds metadata to the `metadata` field in a `Document` structure.

  ## Parameters

  - `document`: The `Document` structure to be updated.
  - `gens`: The list of new metadata to be added to the `Document`.

  ## Returns

  A new `Document` structure with the updated metadata.

  ## Examples

    iex> document = %Extractor.Schema.Document{id: "123", text: "Sample text"}
    iex> Extractor.Schema.Document.add_metadata(document, %{model: "human"})
    %Extractor.Schema.Document{id: "123", text: "Sample text", labels: [], generations: [], metadata:  %{model: "human"}}

  """
  @spec add_metadata(t, map()) :: t
  def add_metadata(%Document{metadata: _} = document, metadata) do
    %{document | metadata: metadata}
  end
end
