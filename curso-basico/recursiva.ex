defmodule Recursiva do
    def sum_list(list) do
     sum_list(list, 0)
    end
    
    def sum_list([head | tail], accumulator) do
     sum_list(tail, head + accumulator)
    end

    def sum_list([], accumulator), do: accumulator

     
    def factorial(n) do    
        if n == 0 or n == 1 do
            1
        else
            n * factorial(n-1)  
        end
    end
  
end