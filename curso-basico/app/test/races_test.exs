defmodule RacesTest do
    use ExUnit.Case
    alias Races.Race

    doctest Race

    test "create_race" do
        params = %{year: 2020, round: 52, circuitId: 1, name: "Race Mexico", date: "2020-05-20"}
        {:ok, race} = Race.create_race(params)
        assert race.raceId > 0
    end

    test "get race" do
        max_id = Race.max_id 
        result = Race.get_race max_id
        assert result.name == "Race Mexico"
    end    

    test "update race" do
        max_id = Race.max_id 
        race = Race.get_race max_id
        attrs_update = %{url: "http://example2.com"}
        {ok, race_updated} = Race.update_race race, attrs_update
        assert race_updated.url != ""
    end 

    test "delete race" do
        max_id = Race.max_id 
        race = Race.get_race max_id
        {result, _} = Race.delete_race race
        assert result==:ok
    end 

end