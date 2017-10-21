defmodule PastryNode do
    use GenServer
    def start_link(x,nodes,numRequests) do
    b=4
    input_srt = Integer.to_string(x)
    nodeid = String.slice(Base.encode16(:crypto.hash(:sha256, input_srt)),32,32)
    GenServer.start_link(__MODULE__, {nodeid,b,nodes,numRequests}, name: String.to_atom("n#{nodeid}"))    
    end

    def init({nodeid,b,nodes,numRequests}) do        
        routetable = Matrix.from_list([[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]])
        {:ok, {nodeid,[],routetable,numRequests}}
    end

    def handle_cast({:intialize_table,hostid},{nodeid,leaf,routetable,req})do

        #last lines
        GenServer.cast(:listner,{:stated_s,nodeid})
        {:noreply,{nodeid,leaf,routetable,req}}
    end
    def handle_cast({:intialize_table_first},{nodeid,leaf,routetable,req})do

        #last lines
        GenServer.cast(:listner,{:stated_s,nodeid})        
        {:noreply,{nodeid,leaf,routetable,req}}
    end
   
    def handle_cast({:route,key},{nodeid,leaf,routetable,req})do
        #compute difference between leafset and key
        {keyval,_} = Integer.parse(key,16)
        {firstlist,_} = Integer.parse(List.first(leaf),16)
        {lastleaf,_} = Integer.parse(List.last(leaf),16)

        [{:eq, common}|_] = String.myers_difference(nodeid,key)
        common_len = String.length common_len
        {next_digit,_} = Integer.parse(String.slice(key,common_len,1),16)

        route_to = cond do
            (keyval >= firstleaf) &&(keyval <= lastleaf) -> Enum.min_by(leaf, fn(x) -> Kernel.abs(x - keyval) end)
            routetable[common_len][next_digit] != nil ->  routetable[common_len][next_digit]
            
            true -> nil
        end
 


        
        {:noreply,{nodeid,leaf,routetable,req}}
    end

#Enum.each routetable,  fn {index, _} -> Enum.each routetable[index], fn{k,v} ->  IO.puts "#{k} --> #{v}"  end end
#Enum.each routetable,  fn {index, _} -> Enum.each routetable[index], fn{k,v} -> [v|qlist] end end
