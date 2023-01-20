defmodule <%= catalogue_module %>.AvatarUpload do
  use <%= web_module %>, :live_component

  @upload_url "http://localhost:4000/api/upload"

  def update(assigns, socket) do
    socket
    |> allow_upload(
      :uploaded_files,
      accept: [".png", ".jpg", ".jpeg"],
      max_entries: 1,
      max_file_size: 100_000_000,
      auto_upload: true,
      chunk_timeout: 1_000_000_000,
      external: &presign_upload/2
    )
    |> assign(assigns)
    |> assign(upload_state: {:idle, nil})
    |> then(fn s -> {:ok, s} end)
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("upload", _params, socket) do
    {:noreply,
     socket
     |> file_upload_handler()
     |> put_flash(
       :info,
       "Uploaded"
     )}
  end

  @impl true
  def handle_event("cancel-upload", %{"ref" => ref, "value" => _}, socket) do
    {:noreply,
     socket
     |> cancel_upload(:uploaded_files, ref)}
  end

  defp presign_upload(entry, socket) do
    {:ok, %{uploader: "UpChunk", entrypoint: @upload_url}, socket}
  end

  defp file_upload_handler(socket) do
    [%{path: path, filename: _filename}] =
      consume_uploaded_entries(socket, :uploaded_files, fn %{path: path}, entry ->
        {:postpone, %{path: path, filename: entry.client_name}}
      end)

    lv_pid = self()

    {:ok, task_pid} =
      Task.start(fn ->
        {_state, response} = upload_file(path)
        # # Handle response
        # case response.status_code do
        #   200 ->
        #     case Jason.decode(response.body) do
        #       {:ok, %{"url" => url}} ->
        #         IO.puts("Image uploaded successfully to: #{url}")

        #       {:error, %{"error" => error}} ->
        #         IO.puts("Error uploading image: #{error}")
        #     end

        #   _ ->
        #     IO.puts("Error uploading image: #{response.body}")
        # end

        send(lv_pid, {:file_upload, :ok})
        # requires handle_info to be implemented in parent lv
        # @impl true
        # def handle_info({:file_upload, outcome}, socket) do
        #   {:noreply, socket |> assign(upload_state: {:idle, nil})}
        # end
      end)

    socket |> assign(upload_state: {:processing, task_pid})
  end

  defp upload_file(file_path) do
    csrf_token = Phoenix.Controller.get_csrf_token()

    @upload_url
    |> HTTPoison.post(
      {:multipart, [{:file, file_path, {"form-data", [name: "filedata", filename: Path.basename(file_path), csrf_token: csrf_token]}, ["x-csrf-token": csrf_token]}]}
    )
  end

  defp upload_button_text({upload_state, _pid}) do
    case upload_state do
      :processing -> "Processing"
      _ -> "Save"
    end
  end

  defp upload_button_classes({upload_state, _pid}) do
    case upload_state do
      :processing -> "btn loading"
      _ -> ""
    end
  end

  @impl true
  def render(assigns) do
    # assigns = assign_new(assigns, :class, fn -> "" end)
    # _attrs = assigns_to_attributes(assigns, [:class])
    ~H"""
    <div>
      <div>
        <%= for entry <- @uploads.uploaded_files.entries do %>
          <article class="upload-entry">
            <div class="flex flex-row justify-center">
              <figure>
                <.live_img_preview entry={entry} />
                <figcaption class="mt-5">
                  <%= entry.client_name %>
                  <div class="tooltip tooltip-top tooltip-warning" data-tip="Cancel">
                    <button phx-click="cancel-upload" phx-value-ref={entry.ref} aria-label="cancel" phx-target={@myself}>
                      <i class="text-l mdi mdi-close"></i>
                    </button>
                  </div>

                  <%= if entry.done? do %>
                    <div class="tooltip tooltip-right tooltip-success" data-tip="Done">
                      <i class="text-l mdi mdi-check"></i>
                    </div>
                  <% end %>
                </figcaption>
              </figure>
            </div>
            <progress class="progress w-full" value={entry.progress} max="100">
              <%= entry.progress %>%
            </progress>
            <%= for err <- upload_errors(@uploads.uploaded_files, entry) do %>
              <p class="alert alert-danger"><%= inspect(err) %></p>
            <% end %>
          </article>
        <% end %>

        <%= for err <- upload_errors(@uploads.uploaded_files) do %>
          <p class="alert alert-danger"><%= inspect(err) %></p>
        <% end %>
      </div>
      <.form :let={_f} for={:uploads} id="upload-form" phx-change="validate" phx-target={@myself}>
        <div phx-drop-target={@uploads.uploaded_files.ref} class="pt-2">
          <label
            for={@uploads.uploaded_files.ref}
            class="flex flex-col justify-center items-center w-full h-32 bg-gray-50 rounded-lg border-2 border-gray-300 border-dashed cursor-pointer dark:hover:bg-bray-800 dark:bg-gray-700 hover:bg-gray-100 dark:border-gray-600 dark:hover:border-gray-500 dark:hover:bg-gray-600"
          >
            <div class="flex flex-col justify-center items-center pt-5 pb-6">
              <svg aria-hidden="true" class="mb-3 w-10 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12"></path>
              </svg>
              <p class="mb-2 text-sm text-gray-500 dark:text-gray-400">
                <span class="font-semibold">Click to upload</span> or drag and drop
              </p>
              <p class="text-xs text-gray-500 dark:text-gray-400">
                <%= [".png", ".jpg", ".jpeg"] |> Enum.join(", ") %>
              </p>
              <p class="text-xs text-gray-500 dark:text-gray-400">max. 100 MB</p>
            </div>
            <%= live_file_input(@uploads.uploaded_files,
              class: "hidden",
              "data-preview-target": "#upload-preview"
            ) %>
          </label>
        </div>
      </.form>
      <div class="pt-2 flex flex-row justify-center gap-5">
        <div class="tooltip tooltip-bottom" data-tip="Delete">
          <button class="btn btn-outline" phx-click="delete" phx-target={@myself}>
            <i class="text-2xl mdi mdi-delete"></i>
          </button>
        </div>
        <div class="tooltip tooltip-bottom" data-tip="Upload via LV">
          <button type="button" class={"btn btn-outline #{upload_button_classes(@upload_state)}"} phx-click="upload" phx-target={@myself}>
            <i class="text-2xl mdi mdi-content-save"></i>
            <%= upload_button_text(@upload_state) %>
          </button>
        </div>
        <div class="tooltip tooltip-bottom" data-tip="Upload via JS">
          <%= submit class: "btn btn-outline" , form: "upload-form" do %>
            <i class="text-2xl mdi mdi-content-save-move-outline"></i>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
