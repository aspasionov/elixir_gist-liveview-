defmodule ElixirGistWeb.AllGistsLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.Gists

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(_unsigned_params, _uri, socket) do
    gists = Gists.list_gists()
    socket = assign(socket, gists: gists)
    {:noreply, socket}
  end

  def gist(assigns) do
    {:ok, relative_time} = Timex.format(assigns.gist.updated_at, "{relative}", :relative)

    assigns =
      assigns
      |> assign(relative_time: relative_time)

    ~H"""
    <div class="border borde-white rounded-md p-4 mb-6 shadow-sm shadow-white">
      <div>
        <div class="flex justify-between items-center">
          <div>
            <span class="font-bold">
          <%= @current_user.email %>
        </span>/
            <span class="text-emLavander"><%= @gist.name %></span>
          </div>
          <div class="font-bold">
            <%= @relative_time %>
          </div>
        </div>
      </div>
      <div class="text-sm mt-4 text-emLavander-light">
        <%= @gist.description %>
      </div>
    </div>
    """
  end
end
