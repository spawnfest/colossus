defmodule TestOptions do
  use ExUnit.Case
  alias Colossus.Options

  @test_options install: %{
                  description: "Install something",
                  options: [path: [required: true], sudo: [default: false]]
                },
                list: %{description: "List things", options: [from1: [required: true]]}

  describe "handle_options/2" do
    test "raise if required options missing" do
      assert_raise RuntimeError, "required options path missing", fn ->
        Options.handle_options(Keyword.get(@test_options, :install).options, %{})
      end
    end

    test "no raise if option is passed" do
      passed_options = %{path: "/home"}

      IO.inspect(
        Options.handle_options(Keyword.get(@test_options, :install).options, passed_options)
      )

      assert passed_options ==
               Options.handle_options(
                 Keyword.get(@test_options, :install).options,
                 passed_options
               )
    end

    test "it set default value" do
      passed_options = %{path: "/home"}
      assert %{sudo: false, path: "/home"} == Options.handle_options(Keyword.get(@test_options, :install).options, passed_options)
    end
  end
end
