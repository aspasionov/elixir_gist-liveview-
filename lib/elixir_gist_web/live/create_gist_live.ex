defmodule ElixirGistWeb.CreateGistLive do
  use ElixirGistWeb, :live_view
  alias ElixirGistWeb.GistFormComponet
  alias ElixirGist.{Gists, Gists.Gist}

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="em-gradient flex items-center justify-center">
      <h1 class="font-brand font-bold text-white text-center text-3xl">
        Instantly share Elixir code, notes, and snippets.
      </h1>
    </div>

    <.live_component
      module={GistFormComponet}
      id={:new}
      form={to_form(Gists.change_gist(%Gist{}))}
      current_user={@current_user}
    />
    """
  end
end
