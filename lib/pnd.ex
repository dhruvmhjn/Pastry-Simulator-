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
        #GenServer.cast(:listner,{:stated_s,nodeid})

        GenServer.cast(hostid,{:join,nodeid,0})
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

        #check leaf set
        {firstlist,_} = Integer.parse(List.first(leaf),16)
        {lastleaf,_} = Integer.parse(List.last(leaf),16)

       if((keyval >= firstleaf) &&(keyval <= lastleaf)) do
            #compare abs of differences 
            min_diff_leaf = Enum.min_by(leaf, fn(x) -> Kernel.abs(x - keyval) end)

            #cast to min_diff_leaf        
        end
       


        
        {:noreply,{nodeid,leaf,routetable,req}}
    end

    def handle_cast({:join,incoming_node,path_count},{nodeid,leaf,routetable,req}) do
        path_count=path_count+1
        GenServer.cast(incoming_node,{:routing_table,routetable,path_count})
        incoming_node_hex = String.slice(Atom.to_string(incoming_node),1..-1)
        #NEXT HOP for incoming node
        next_hop = route_lookup(incoming_node_hex,leaf,routetable,nodeid)
        if next_hop != nil do
            GenServer.cast(String.to_atom("n#{next_hop}",{:join_route,incoming_node,path_count))            
        else
            sleep(500)
            IO.puts "Sendign leaf table"
            GenServer.cast(incoming_node,{:leaf_table,leaf,path_count})
        
        end
        {:noreply,{nodeid,leaf,routetable,req}}
    end

    def handle_cast({:join_route,incoming_node,path_count},{nodeid,leaf,routetable,req}) do
        path_count=path_count+1
        GenServer.cast(incoming_node,{:routing_table,routetable,path_count})
        incoming_node_hex = String.slice(Atom.to_string(incoming_node),1..-1)
        #NEXT HOP for incoming node
        next_hop = route_lookup(incoming_node_hex,leaf,routetable,nodeid)
        if next_hop != nil do
            GenServer.cast(String.to_atom("n#{next_hop}",{:join_route,incoming_node,path_count))            
        else
            sleep(500)
            IO.puts "Sendign leaf table"
            GenServer.cast(incoming_node,{:leaf_table,leaf,path_count})
        end
        
        {:noreply,{nodeid,leaf,routetable,req}}
    end

    def handle_cast({:routing_table,new_route_table,path_count},{nodeid,leaf,routetable,req}) do

        





        {:noreply,{nodeid,leaf,routetable,req}}
    end


    def handle_cast({:leaf_table,new_leaf_table,path_count},{nodeid,leaf,routetable,req}) do
        
        GenServer.cast(:listner,{:stated_s,nodeid})
        {:noreply,{nodeid,leaf,routetable,req}}
    end

    def handle_cast()

end