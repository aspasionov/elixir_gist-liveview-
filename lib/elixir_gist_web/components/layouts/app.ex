defmodule ElixirGistWeb.Layouts.App do
  alias Phoenix.LiveView.JS

  def toggle_menu do
    JS.toggle(
      to: "#dd-menu",
      in:
        {"transition ease-out duration-100", "transform opacity-0 translate-y-[-10%]",
         "transform opacity-100 translate-y-0"},
      out:
        {"transition ease-in duration-100", "transform opacity-100 translate-y-0",
         "transform opacity-0 translate-y-[-10%]"}
    )
  end
end
