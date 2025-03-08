defmodule TodoAppWeb.TodoController do
  use TodoAppWeb, :controller

  alias TodoApp.Todos
  alias TodoApp.Todos.Todo
  import TodoAppWeb.UserAuth

  plug :require_authenticated_user when action in [:index, :new, :create, :edit, :update, :delete]

  def index(conn, _params) do
    todos = Todos.list_todos(conn.assigns.current_user.id)
    render(conn, "index.html", todos: todos)
  end

  def new(conn, _params) do
    changeset = Todos.change_todo(%Todo{})
    render(conn, :new, changeset: changeset)
  end

  def create(conn, %{"todo" => todo_params}) do
    todo_params_with_user_id = Map.put(todo_params, "user_id", conn.assigns.current_user.id)

    case Todos.create_todo(todo_params_with_user_id, conn.assigns.current_user) do
      {:ok, todo} ->
        conn
        |> put_flash(:info, "Todo created successfully.")
        |> redirect(to: "/todos/#{todo.id}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    todo = Todos.get_todo!(id, conn.assigns.current_user.id)
    render(conn, "show.html", todo: todo)
  end

  def edit(conn, %{"id" => id}) do
    todo = Todos.get_todo!(id, conn.assigns.current_user.id)
    changeset = Todos.change_todo(todo)
    render(conn, "edit.html", todo: todo, changeset: changeset)
  end

  def update(conn, %{"id" => id, "todo" => todo_params}) do
    todo = Todos.get_todo!(id, conn.assigns.current_user.id)

    case Todos.update_todo(todo, todo_params) do
      {:ok, todo} ->
        conn
        |> put_flash(:info, "Todo updated successfully.")
        |> redirect(to: "/todos/#{todo.id}")

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", todo: todo, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    todo = Todos.get_todo!(id, conn.assigns.current_user.id)
    {:ok, _todo} = Todos.delete_todo(todo)

    conn
    |> put_flash(:info, "Todo deleted successfully.")
    |> redirect(to: "/todos")
  end
end
