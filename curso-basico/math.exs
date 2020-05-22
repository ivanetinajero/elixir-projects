defmodule Math do

    def mul(x, y) do
        x * y
    end

    def sum(x, y), do: x + y

    IO.inspect(Math.sum(2, 2))
    
end