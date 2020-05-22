defmodule Races.Race do
    @moduledoc """
        Módulo que contiene la funcionalidad de CRUD sobre la tabla reces
    """
    use Ecto.Schema
    import Ecto.Changeset
    import Ecto.Query, warn: false
    alias App.Repo

    @primary_key {:raceId, :id, autogenerate: true}
    schema "races" do
        field :year, :integer
        field :round, :integer
        field :circuitId, :integer
        field :name, :string
        field :date, :date
        field :time, :time
        field :url, :string
    end

    def changeset(race, attrs) do
        race
        |> cast(attrs, [:year, :round, :circuitId, :name, :date, :time, :url])
        |> validate_required([:year, :round, :circuitId, :name, :date])
    end

    @doc """
    get_race.
    Regresa un registro de la tabla reces
    ## Parameters
    - id: valor entero de la llave (raceId).
    
    ## Examples
        iex> alias Races.Race
        iex> race = Race.get_race(1000)
        iex> race.name
        "Hungarian Grand Prix"
    """
    def get_race(id) do
        Repo.get!(Races.Race, id)
    end
    
    def create_race(attrs \\ %{}) do
        %Races.Race{}
        |> changeset(attrs)
        |> Repo.insert()
    end
    
    def update_race(%Races.Race{} = race, attrs) do
        race
        |> changeset(attrs)
        |> Repo.update()
    end

    def delete_race(%Races.Race{} = race) do
        Repo.delete(race)
    end

    def max_id do
        Repo.aggregate(Races.Race, :max, :raceId)
    end

end