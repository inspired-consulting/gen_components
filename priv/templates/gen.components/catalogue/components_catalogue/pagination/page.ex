defmodule <%= catalogue_module %>.Paginations.Page do
  @moduledoc """
  the copy of a scrivener page.
  Plus adjustments for better demonstration.any()

  https://github.com/drewolson/scrivener/blob/master/lib/scrivener/page.ex
  """

  defstruct [:page_number, :page_size, :total_entries, :total_pages, entries: [], all_entries: []]

  def from_list(entries) when is_list(entries) do
    %__MODULE__{
      all_entries: entries,
      page_number: 1,
      page_size: 10,
      total_entries: length(entries)
    }
    |> rebuild()
  end

  def set_page_size(%__MODULE__{} = me, page_size) when is_integer(page_size) and page_size > 0 do
    %__MODULE__{me | page_size: page_size}
    |> rebuild()
  end

  def set_page_number(%__MODULE__{} = me, page_number) when is_integer(page_number) do
    %__MODULE__{me | page_number: max(page_number, 1)}
    |> rebuild()
  end

  defp rebuild(%__MODULE__{} = me) do
    total_pages = ceil(me.total_entries / me.page_size)
    page_number = min(me.page_number, total_pages)

    %__MODULE__{
      me
      | total_pages: total_pages,
        page_number: page_number,
        entries:
          me.all_entries
          |> Enum.drop(me.page_size * (page_number - 1))
          |> Enum.take(me.page_size)
    }
  end

  defimpl Enumerable do
    alias <%= catalogue_module %>.Paginations.Page
    def count(_page), do: {:error, __MODULE__}
    def member?(_page, _value), do: {:error, __MODULE__}

    def reduce(%Page{entries: entries}, acc, fun) do
      Enumerable.reduce(entries, acc, fun)
    end

    def slice(_page), do: {:error, __MODULE__}
  end

  defimpl Collectable do
    def into(original) do
      original_entries = original.entries
      impl = Collectable.impl_for(original_entries)
      {_, entries_fun} = impl.into(original_entries)

      fun = fn page, command ->
        %{page | entries: entries_fun.(page.entries, command)}
      end

      {original, fun}
    end
  end
end
