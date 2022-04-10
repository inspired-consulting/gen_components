defmodule <%= catalogue_module %>.NavsTop do
  use <%= web_module %>, :component

  import <%= components_module %>.NavTop

  def navs_top(assigns) do
    ~H"""
    <section>
      <.nav_top style="margin: 1rem;">
        <:brand>Gen Components</:brand>
        <.nav_top_item><a class="nav-link active" aria-current="page" href="#">Home</a></.nav_top_item>
        <.nav_top_item><a class="nav-link" href="#">Link</a></.nav_top_item>
        <.nav_top_item><a class="nav-link disabled" href="#" tabindex="-1" aria-disabled="true">Disabled</a></.nav_top_item>
        <.nav_top_item_dropdown id="nav-top-dropdown01" label="Dropdown">
          <li><a class="dropdown-item" href="#">Action</a></li>
          <li><a class="dropdown-item" href="#">Another action</a></li>
          <li><a class="dropdown-item" href="#">Something else here</a></li>
        </.nav_top_item_dropdown>
      </.nav_top>
    </section>
    """
  end
end
