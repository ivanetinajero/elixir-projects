defmodule Discuss.Repo.Migrations.AddUserIdToTopics do
  use Ecto.Migration

  def change do
    # Migracion para modificar una tabla ...
    alter table(:topics) do
      add :user_id, references(:users)
    end
  end

end
