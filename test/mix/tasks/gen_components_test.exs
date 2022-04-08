Code.require_file("../../mix_helper.exs", __DIR__)

defmodule Mix.Tasks.Gen.ComponentsTest do
  use ExUnit.Case
  import MixHelper
  alias Mix.Tasks.Gen

  setup do
    Mix.Task.clear()
    :ok
  end

  test "generates components and the catalogue" do
    in_tmp_project(:test_project, fn _proj ->
      Gen.Components.run([])

      assert_file("lib/test_project_web/live/components_catalogue.ex", fn file ->
        assert file =~ ~S|defmodule TestProjectWeb.ComponentsCatalogueLive do|
        assert file =~ ~S|use TestProjectWeb, :live_view|
        assert file =~ ~S|import TestProjectWeb.ComponentsCatalogueLive.Icons|
      end)

      assert_file("lib/test_project_web/components/icon.ex", fn file ->
        assert file =~ ~S|defmodule TestProjectWeb.Components.Icon do|
        assert file =~ ~S|use TestProjectWeb, :component|
        assert file =~ ~S|def icon(assigns) do|
        assert file =~ ~S|def icon_delete(assigns) do|
      end)

      assert_file("lib/test_project_web/live/components_catalogue/icons.ex", fn file ->
        assert file =~ ~S|defmodule TestProjectWeb.ComponentsCatalogueLive.Icons do|
        assert file =~ ~S|import TestProjectWeb.Components.Icon|
      end)
    end)
  end

  test "raises in the root of an umbrella" do
    in_tmp_umbrella_project(:test_umbrella_project, fn _proj ->
      assert_raise(Mix.Error, fn ->
        Gen.Components.run([])
      end)
    end)
  end

  test "raises when not in an apps root directory" do
    send(self(), {:mix_shell_input, :yes?, false})

    in_tmp_umbrella_project(:test_umbrella_project, fn _proj ->
      File.cd!("apps", fn ->
        Mix.Tasks.Phx.New.Web.run(["frontend"])

        assert_raise(Mix.Error, fn ->
          Gen.Components.run([])
        end)
      end)
    end)
  end

  test "generates components and the catalogue in an umbrella app" do
    send(self(), {:mix_shell_input, :yes?, false})

    in_tmp_umbrella_project(:test_umbrella_project, fn _proj ->
      File.cd!("apps", fn ->
        Mix.Tasks.Phx.New.Web.run(["frontend"])

        in_project(:fontend, "frontend", fn _proj ->
          Gen.Components.run([])

          assert_file("lib/frontend/live/components_catalogue.ex", fn file ->
            assert file =~ ~S|defmodule Frontend.ComponentsCatalogueLive do|
            assert file =~ ~S|use Frontend, :live_view|
            assert file =~ ~S|import Frontend.ComponentsCatalogueLive.Icons|
          end)

          assert_file("lib/frontend/components/icon.ex", fn file ->
            assert file =~ ~S|defmodule Frontend.Components.Icon do|
            assert file =~ ~S|use Frontend, :component|
            assert file =~ ~S|def icon(assigns) do|
            assert file =~ ~S|def icon_delete(assigns) do|
          end)

          assert_file("lib/frontend/live/components_catalogue/icons.ex", fn file ->
            assert file =~ ~S|defmodule Frontend.ComponentsCatalogueLive.Icons do|
            assert file =~ ~S|import Frontend.Components.Icon|
          end)
        end)
      end)
    end)
  end
end
