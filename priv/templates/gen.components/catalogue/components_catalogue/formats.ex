defmodule <%= catalogue_module %>.Formats do
  use <%= web_module %>, :live_component

  import <%= components_module %>.Format

  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div>
      <section style="margin: 1rem;">
        <h2>tel</h2>
        <p>Wrap a phone number into a clickable tel link.</p>
        <div>
          <.tel number="+49 1234 234 4567" />
        </div>
      </section>

      <section style="margin: 1rem;">
        <h2>email</h2>
        <p>Wrap an email address into a clickable mailto link.</p>
        <div>
          <.email address="someone@example.com" />
        </div>
      </section>

      <section style="margin: 1rem;">
        <h2>Date / time</h2>
        <p>Format a DateTime struct.</p>
        <div style="margin: 1rem;">
          <.form let={f} for={:local_time} phx-change="change-local-time" phx-target={@myself}>
            <div>UTC time: <%%= datetime_select(f, :date_time, value: @datetime) %></div>
            <div>
              Format: <label><%%= radio_button(f, :format, "medium", checked: "medium" == @format) %>&nbsp;medium</label>
              <label><%%= radio_button(f, :format, "short", checked: "short" == @format) %>&nbsp;short</label>
            </div>
          </.form>
        </div>
        <h3>local_time</h3>
        <.local_time format={@format} time={@datetime} />
        <h3>local_date</h3>
        <div>
          <.local_date date={@datetime} />
        </div>
        <h3>local_datetime</h3>
        <div>
          <.local_datetime datetime={@datetime} />
        </div>
      </section>

      <section style="margin: 1rem;">
        <h2>local_number</h2>
        <p>Format a decimal number with dot separator as a local number.</p>
        <div style="margin: 1rem;">
          <.form let={f} for={:local_number} phx-change="change-local-number" phx-target={@myself}>
            <div>UTC time: <%%= number_input(f, :number, value: @number) %></div>
          </.form>
        </div>
        <div>
          <.local_number number={@number} />
        </div>
      </section>
    </div>
    """
  end

  @impl Phoenix.LiveComponent
  def update(_params, socket) do
    {:ok,
     socket
     |> assign(
       format: "short",
       datetime: DateTime.utc_now(),
       number: 12_678.4567
     )}
  end

  @impl Phoenix.LiveComponent
  def handle_event("change-local-time", %{"local_time" => params}, socket) do
    dt =
      params["date_time"]
      |> Map.new(fn {k, v} -> {k, String.to_integer(v)} end)

    {:noreply,
     socket
     |> assign(
       format: params["format"] || "short",
       datetime:
         DateTime.new!(
           Date.new!(dt["year"], dt["month"], dt["day"]),
           Time.new!(dt["hour"], dt["minute"], 0)
         )
     )}
  end

  def handle_event("change-local-number", %{"local_number" => params}, socket) do
    {:noreply,
     socket
     |> assign(number: params["number"])}
  end
end
