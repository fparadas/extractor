defmodule Schema.Example.ClassificationExample do
  @moduledoc """
  A module for managing classification examples, particularly for text and its associated labels.

  This module provides functionality to create and manipulate a `ClassificationExample` struct,
  which represents a text example and its corresponding label(s). The label(s) can either be a single
  string or a list of strings, allowing for flexible classification scenarios.

  ## Struct

  The `ClassificationExample` struct includes the following fields:
    - `text`: The text content of the example (String).
    - `label`: The label(s) associated with the text. This can be a single label (String) or multiple labels (list of Strings).
  """

  alias Schema.Example.ClassificationExample
  alias Schema.Document

  @type t :: %ClassificationExample{
          text: String.t(),
          label: String.t() | list(String.t())
        }

  defstruct [:text, :label]

  @doc """
  Updates the `text` field of a `ClassificationExample`.

  ## Parameters

  - `example`: The `ClassificationExample` struct to be updated.
  - `text`: The new text content to be set.

  ## Returns

  The updated `ClassificationExample` struct with the new text content.

  ## Examples

      iex> example = %Schema.Example.ClassificationExample{}
      iex> Schema.Example.ClassificationExample.add_text(example, "Example text")
      %Schema.Example.ClassificationExample{text: "Example text", label: nil}
  """
  @spec add_text(t, String.t()) :: t
  def add_text(%ClassificationExample{} = example, text), do: %{example | text: text}

  @doc """
  Updates or adds a single label to the `label` field of a `ClassificationExample`.

  ## Parameters

  - `example`: The `ClassificationExample` struct to be updated.
  - `label`: The new label to be set or added.

  ## Returns

  The updated `ClassificationExample` struct with the new or added label.

  """
  @spec add_label(t, String.t()) :: t
  def add_label(%ClassificationExample{} = example, label) when is_binary(label) do
    %{example | label: label}
  end

  @spec add_label(t, list(String.t())) :: t
  def add_label(%ClassificationExample{label: old} = example, label)
      when is_binary(old) and is_list(label) do
    %{example | label: [old | label]}
  end

  @spec add_label(t, list(String.t())) :: t
  def add_label(%ClassificationExample{label: old} = example, label)
      when is_list(old) and is_list(label) do
    %{example | label: old ++ label}
  end

  @doc """
  Converts a `Document` struct to a `ClassificationExample` struct.

  ## Parameters

  - `document`: The `Document` struct to be converted.

  ## Returns

  A new `ClassificationExample` struct with the `text` and `label` fields populated from the `Document`.

  ## Examples

      iex> document = %Document{text: "Sample text", labels: ["label1", "label2"]}
      iex> Schema.ClassificationExample.from_document(document)
      %ClassificationExample{text: "Sample text", label: ["label1", "label2"]}
  """
  @spec from_document(Document.t()) :: t
  def from_document(%Document{text: text, labels: labels}) do
    %ClassificationExample{text: text, label: labels}
  end

  @doc """
  Converts a `Document` struct to a `ClassificationExample` struct with a binary label evaluation.

  ## Parameters

  - `document`: The `Document` struct to be converted.
  - `criteria`: A tuple `{:binary, label}` used to evaluate the label. If `label` is in `Document`'s labels, the `ClassificationExample`'s label is 'positive', else 'negative'.

  ## Returns

  A new `ClassificationExample` struct with the `text` field from `Document` and a binary 'positive' or 'negative' label based on the criteria.

  ## Examples

      iex> document = %Document{text: "Sample text", labels: ["label1", "label2"]}
      iex> Schema.ClassificationExample.from_document_with_binary_label(document, "label1")
      %ClassificationExample{text: "Sample text", label: "positive"}
  """
  @spec from_document_with_binary_label(Document.t(), String.t()) :: t
  def from_document_with_binary_label(%Document{text: text, labels: labels}, label) do
    binary_label = evaluate_binary_label(labels, label)
    %ClassificationExample{text: text, label: binary_label}
  end

  defp evaluate_binary_label(labels, label) do
    if label in labels, do: "positive", else: "negative"
  end
end
