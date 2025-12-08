defmodule Mix.Tasks.CreateAdmin do
  use Mix.Task
  alias RideFast.Repo
  alias RideFast.Accounts.Admin

  @shortdoc "Cria um usuário admin"

  def run([email, phone, password]) do
    Mix.Task.run("app.start") # inicia a app para ter acesso ao Repo
    content = %{email: email, phone: phone, password: password}

    %Admin{}
    |> Admin.changeset(content)
    |> Admin.password_changeset(content)
    |> Repo.insert!()

    Mix.shell().info("Admin criado com sucesso: #{email}")
  end
end
