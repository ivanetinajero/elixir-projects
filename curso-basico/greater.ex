defmodule Greater do
    def greater_than_zero?(0), do: false
    def greater_than_zero?(x) when x > 0, do: true
    #def greater_than_zero?(x) when x < 0, do: false
    def greater_than_zero?(_), do: false
end