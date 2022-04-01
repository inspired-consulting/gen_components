defmodule <%= catalogue_module %>.Alerts do
  use <%= web_module %>, :component

  import <%= components_module %>.Alert

  def alerts(assigns) do
    ~H"""
    <section>
      <h2>Alert</h2>
      <.alert_primary style="margin: 1rem;">primary alert example</.alert_primary>
      <.alert_secondary style="margin: 1rem;">secondary alert example</.alert_secondary>
      <.alert_success style="margin: 1rem;">success alert example</.alert_success>
      <.alert_danger style="margin: 1rem;">danger alert example</.alert_danger>
      <.alert_warning style="margin: 1rem;">warning alert example</.alert_warning>
      <.alert_info style="margin: 1rem;">info alert example</.alert_info>
    </section>
    """
  end
end
