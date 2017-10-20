defmodule PastrySupervisor do
    use Supervisor
    def start_link(nodes,requests,_) do
        {:ok,pid}= Supervisor.start_link(__MODULE__,{nodes,requests},[])
        #IO.puts "boss pid from nsup : #{inspect(Process.whereis(:boss))}"
        send(Process.whereis(:boss),{:nodes_created})
        {:ok,pid}
    end
    def init({nodes,requests}) do
        n_list = Enum.to_list 1..nodes
        children = Enum.map(n_list, fn(x)->worker(PastryNode, [x,nodes,requests], [id: "node#{x}"]) end)
        supervise children, strategy: :one_for_one
    end
end