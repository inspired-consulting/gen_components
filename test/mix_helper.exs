# Get Mix output sent to the current
# process to avoid polluting tests.
Mix.shell(Mix.Shell.Process)

defmodule MixHelper do
  import ExUnit.Assertions
  import ExUnit.CaptureIO

  def tmp_path do
    Path.expand("../tmp", __DIR__)
  end

  defp random_string(len) do
    len |> :crypto.strong_rand_bytes() |> Base.encode64() |> binary_part(0, len)
  end

  def in_tmp_project(which, function) do
    conf_before = Application.get_env(:gen_components, :generators) || []
    path = Path.join([tmp_path(), random_string(10), to_string(which)])

    try do
      File.rm_rf!(path)
      File.mkdir_p!(path)

      File.cd!(path, fn ->
        File.touch!("mix.exs")
        File.write!("mix.exs", mixfile_contents(which))
        in_project(which, path, function)
      end)
    after
      Application.put_env(:gen_components, :generators, conf_before)
      File.rm_rf!(path)
    end
  end

  def in_tmp_umbrella_project(which, function) do
    conf_before = Application.get_env(:gen_components, :generators) || []
    path = Path.join([tmp_path(), random_string(10), to_string(which)])

    try do
      apps_path = Path.join(path, "apps")
      config_path = Path.join(path, "config")
      umbrella_mix_path = Path.join(path, "mix.exs")
      File.rm_rf!(path)
      File.mkdir_p!(path)
      File.mkdir_p!(apps_path)
      File.mkdir_p!(config_path)
      File.touch!(umbrella_mix_path)
      File.write!(umbrella_mix_path, umbrella_mixfile_contents())

      for file <- ~w(config.exs dev.exs test.exs prod.exs) do
        File.write!(Path.join(config_path, file), "import Config\n")
      end

      in_project(which, path, function)
    after
      Application.put_env(:gen_components, :generators, conf_before)
      File.rm_rf!(path)
    end
  end

  def in_project(app, path, fun) do
    %{name: name, file: file} = Mix.Project.pop()

    try do
      capture_io(:stderr, fn ->
        Mix.Project.in_project(app, path, [], fun)
      end)
    after
      Mix.Project.push(name, file)
    end
  end

  def assert_file(file) do
    assert File.regular?(file), "Expected #{file} to exist, but does not"
  end

  def refute_file(file) do
    refute File.regular?(file), "Expected #{file} to not exist, but it does"
  end

  def assert_file(file, match) do
    cond do
      is_list(match) ->
        assert_file(file, &Enum.each(match, fn m -> assert &1 =~ m end))

      is_binary(match) or Regex.regex?(match) ->
        assert_file(file, &assert(&1 =~ match))

      is_function(match, 1) ->
        assert_file(file)
        match.(File.read!(file))

      true ->
        raise inspect({file, match})
    end
  end

  def modify_file(path, function) when is_binary(path) and is_function(function, 1) do
    path
    |> File.read!()
    |> function.()
    |> write_file!(path)
  end

  defp write_file!(content, path) do
    File.write!(path, content)
  end

  defp umbrella_mixfile_contents do
    """
    defmodule TestUmbrellaProject.MixProject do
      use Mix.Project
      def project do
        [
          apps_path: "apps",
          deps: deps()
        ]
      end
      defp deps do
        []
      end
    end
    """
  end

  defp mixfile_contents(app) do
    """
    defmodule TestProject.MixProject do
      use Mix.Project
      def project do
        [
          app: #{inspect(app)},
          deps: deps()
        ]
      end
      defp deps do
        []
      end
    end
    """
  end
end
