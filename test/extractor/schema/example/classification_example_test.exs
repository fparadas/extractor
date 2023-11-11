defmodule Extractor.Example.ClassificationExampleTest do
  use ExUnit.Case
  alias Extractor.Example.ClassificationExample
  alias Extractor.Schema.Document

  doctest Extractor.Example.ClassificationExample

  describe "add_label/2" do
    test "adds a single label to an empty ClassificationExample" do
      example = %ClassificationExample{}
      updated_example = ClassificationExample.add_label(example, "Label1")

      assert updated_example.label == "Label1"
    end

    test "replaces the existing single label in ClassificationExample with a new label" do
      example = %ClassificationExample{label: "OldLabel"}
      updated_example = ClassificationExample.add_label(example, "NewLabel")

      assert updated_example.label == "NewLabel"
    end

    test "converts existing single label to list and adds new labels" do
      example = %ClassificationExample{label: "ExistingLabel"}
      updated_example = ClassificationExample.add_label(example, ["NewLabel1", "NewLabel2"])

      assert updated_example.label == ["ExistingLabel", "NewLabel1", "NewLabel2"]
    end

    test "appends new labels to the existing list of labels in ClassificationExample" do
      example = %ClassificationExample{label: ["Label1", "Label2"]}
      updated_example = ClassificationExample.add_label(example, ["NewLabel1", "NewLabel2"])

      assert updated_example.label == ["Label1", "Label2", "NewLabel1", "NewLabel2"]
    end
  end
end
