defmodule TodoApp.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    field :title, :string
    field :completed, :boolean, default: false
    # Associate with User
    belongs_to :user, TodoApp.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:title, :completed, :user_id])
    |> validate_required([:title, :completed, :user_id])
  end
end
