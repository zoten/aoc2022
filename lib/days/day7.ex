defmodule Aoc.Days.Day7 do
  use Aoc.Day,
    day: 7

  def solution(1, input) do
    input |> traverse({nil, nil}) |> collect()
  end

  def solution(2, input) do
    tree = input |> traverse({nil, nil})

    {total_used_space, dirs_under_threshold} =
      tree |> Map.fetch!("/") |> do_collect([], 1_000_000_000_000)

    total_disk_space = 70_000_000
    needed_space = 30_000_000
    current_free_space = total_disk_space - total_used_space
    needed_to_delete = needed_space - current_free_space

    sorted_dirs = Enum.sort(dirs_under_threshold)
    Enum.find(sorted_dirs, nil, fn val -> val > needed_to_delete end)
  end

  defp collect(tree) do
    {_, dirs_under_threshold} = tree |> Map.fetch!("/") |> do_collect([], 100_000)
    Enum.sum(dirs_under_threshold)
  end

  defp do_collect(%{files: files, subdirs: subdirs} = _tree, dirs, threshold) do
    my_size = Enum.reduce(files, 0, fn {_, size}, acc -> acc + size end)

    {subdirs_size, dirs_to_add} =
      Enum.reduce(
        subdirs,
        {0, dirs},
        fn {_dirname, subdir}, {acc, current_dirs} ->
          {subdir_total_size, new_dirs} = do_collect(subdir, current_dirs, threshold)
          {acc + subdir_total_size, new_dirs}
        end
      )

    total_size = my_size + subdirs_size

    if total_size < threshold do
      {total_size, [total_size | dirs_to_add]}
    else
      {total_size, dirs_to_add}
    end
  end

  defp traverse([command | commands], acc) do
    acc = execute(command, acc)
    traverse(commands, acc)
  end

  defp traverse([], {_, tree} = _acc), do: tree

  defp execute("$ cd /", _) do
    {"/", %{"/" => %{subdirs: %{}, files: %{}}}}
  end

  defp execute("$ cd ..", {current_dir, root_dir}) do
    {Path.dirname(current_dir), root_dir}
  end

  defp execute("$ cd " <> dirname, {current_dir, root_dir}) do
    {Path.join(current_dir, dirname), root_dir}
  end

  defp execute("dir " <> dirname, {current_dir, root_dir}) do
    {
      current_dir,
      add_dir(current_dir, dirname, root_dir)
    }
  end

  defp execute("$ ls", acc), do: acc

  defp execute(file, {current_dir, root_dir}) do
    [size, filename] = String.split(file, " ")
    size_int = String.to_integer(size)

    path = to_path(current_dir)

    {current_dir, put_in(root_dir, path ++ [:files, filename], size_int)}
  end

  defp add_dir(path, dirname, root_dir) do
    path = to_path(path) ++ [:subdirs, dirname]

    put_in(root_dir, path, %{subdirs: %{}, files: %{}})
  end

  defp to_path(dir), do: Path.split(dir) |> Enum.intersperse(:subdirs)
end
