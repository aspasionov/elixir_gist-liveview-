defmodule ElixirGistWeb.GistFormComponet do
  use ElixirGistWeb, :live_component

  alias ElixirGist.{Gists, Gists.Gist}

  def mount(socket) do
    {:ok, socket}
  end

  def handle_event("create", %{"gist" => params}, socket) do
    if params["id"] == "" do
      create_gist(params, socket)
    else
      update_gist(params, socket)
    end
  end

  def handle_event("validate", %{"gist" => params}, socket) do
    changeset = %Gist{} |> Gists.change_gist(params) |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  defp create_gist(params, socket) do
    case Gists.create_gist(socket.assigns.current_user, params) do
      {:ok, gist} ->
        socket = push_event(socket, "clear-textareas", %{})
        changeset = Gists.change_gist(%Gist{})
        socket = assign(socket, form: to_form(changeset))
        {:noreply, push_navigate(socket, to: ~p"/gist?#{[id: gist.id]}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  def render(assigns) do
    ~H"""
    <div>
      <.form for={@form} phx-submit="create" phx-change="validate" phx-target={@myself}>
        <div class="justify-center px-28 w-full space-y-4 mb-10">
          <.input type="hidden" field={@form[:id]} />

          <.input
            field={@form[:description]}
            placeholder="Gist description..."
            autocomplete="off"
            phx-debounce="blur"
          />
          <div>
            <div class="flex p-2 items-center bg-emDark rounded-t-md border">
              <div class="w-[300px] mb-2">
                <.input
                  field={@form[:name]}
                  placeholder="Filename including extension..."
                  autocomplete="off"
                  phx-debounce="blur"
                />
              </div>
            </div>
            <div class="flex w-full js-line-parent" phx-update="ignore" id="gist-wrapper">
              <textarea id="line-numbers" readonly class=" line-number rounded-bl-md">
          <%= "1\n" %>
          </textarea>
              <.input
                phx-hook="UpdateLineNumber"
                id="gist-textarea"
                field={@form[:markup_text]}
                type="textarea"
                custom_class="textarea w-full rounded-br -md"
                placeholder="Insert code..."
                autocomplete="off"
                phx-debounce="blur"
              />
            </div>
          </div>
          <div class="flex justify-end">
            <%= if @id == :new do %>
              <.button class="create_btn" phx-disable-with="Creating...">Create Gist</.button>
            <% else %>
              <.button class="create_btn" phx-disable-with="Updating...">Update Gist</.button>
            <% end %>a
          </div>
        </div>
      </.form>
    </div>
    """
  end

  defp update_gist(params, socket) do
    updated_params = Map.put(params, "id", socket.assigns.id)

    case Gists.update_gist(socket.assigns.current_user, updated_params) do
      {:ok, gist} ->
        socket = push_navigate(socket, to: ~p"/gist?#{[id: gist.id]}")
        {:noreply, socket}

      {:error, message} ->
        {:noreply, put_flash(socket, :error, message)}
    end
  end
end
