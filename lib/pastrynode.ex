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
        {:ok, {nodeid,[],routetable,numRequests,0}}
    end

   
    def handle_cast({:route,key},{selfid,leaf,routetable,req,num_created})do
        #compute difference between leafset and key
        {keyval,_} = Integer.parse(key,16)
        {firstlist,_} = Integer.parse(List.first(leaf),16)
        {lastleaf,_} = Integer.parse(List.last(leaf),16)

        [{:eq, common}|_] = String.myers_difference(nodeid,key)
        common_len = String.length common_len
        {next_digit,_} = Integer.parse(String.slice(key,common_len,1),16)

        routelist = Matrix.to_list(routetable)
        [_|rtl] = Enum.chunk(routelist,3)
        rtl = List.flatten(rtl)
        rtl = rtl ++ leaf


        route_to = cond do
            (keyval >= firstleaf) &&(keyval <= lastleaf) -> Enum.min_by(leaf, fn(x) -> Kernel.abs(x - keyval) end)
            routetable[common_len][next_digit] != nil ->  routetable[common_len][next_digit]
            
            true -> nil
        end
 


        
        {:noreply,{selfid,leaf,routetable,req,num_created}}
    end

#Enum.each routetable,  fn {index, _} -> Enum.each routetable[index], fn{k,v} ->  IO.puts "#{k} --> #{v}"  end end
#Enum.each routetable,  fn {index, _} -> Enum.each routetable[index], fn{k,v} -> [v|qlist] end end


#Enum.each routelist,  fn (row) -> Enum.map row, fn(x) -> IO.puts"#{x}"  end end





def handle_cast({:intialize_table,hostid},{selfid,leaf,routetable,req,num_created})do
    
            #last lines
            #GenServer.cast(:listner,{:stated_s,nodeid})
    
            GenServer.cast(hostid,{:join,selfid,0})
            {:noreply,{selfid,leaf,routetable,req,num_created}}
end

def handle_cast({:intialize_table_first},{selfid,leaf,routetable,req,num_created})do
    
            #last lines
            GenServer.cast(:listner,{:stated_s,selfid})        
            {:noreply,{selfid,leaf,routetable,req,num_created}}
end



def handle_cast({:join,incoming_node,path_count},{selfid,leaf,routetable,req,num_created}) do
    path_count=path_count+1
    GenServer.cast(incoming_node,{:routing_table,routetable,path_count})
    incoming_node_hex = String.slice(Atom.to_string(incoming_node),1..-1)
    #NEXT HOP for incoming node
    next_hop = route_lookup(incoming_node_hex,leaf,routetable,selfid)
    if next_hop != nil do
        GenServer.cast(String.to_atom("n#{next_hop}",{:join_route,incoming_node,path_count))            
    else
        sleep(500)
        IO.puts "Sendign leaf table"
        GenServer.cast(incoming_node,{:leaf_table,leaf,path_count})
    
    end
    {:noreply,{selfid,leaf,routetable,req,num_created}}
end

def handle_cast({:join_route,incoming_node,path_count},{selfid,leaf,routetable,req,num_created}) do
    path_count=path_count+1
    GenServer.cast(incoming_node,{:routing_table,routetable,path_count})
    incoming_node_hex = String.slice(Atom.to_string(incoming_node),1..-1)
    #NEXT HOP for incoming node
    next_hop = route_lookup(incoming_node_hex,leaf,routetable,selfid)
    if next_hop != nil do
        GenServer.cast(String.to_atom("n#{next_hop}",{:join_route,incoming_node,path_count))            
    else
        sleep(500)
        IO.puts "Sendign leaf table"
        GenServer.cast(incoming_node,{:leaf_table,leaf,path_count})
    end
    
    {:noreply,{selfid,leaf,routetable,req,num_created}}
end

def handle_cast({:routing_table,new_route_table,path_count},{selfid,leaf,routetable,req,num_created}) do

    

    {:noreply,{selfid,leaf,routetable,req,num_created}}
end


def handle_cast({:leaf_table,new_leaf_table,path_count},{selfid,leaf,routetable,req,num_created}) do
    
    GenServer.cast(:listner,{:stated_s,selfid})
    {:noreply,{selfid,leaf,routetable,req,num_created}}
end

def handle_cast({:create_n_requests},{selfid,leaf,routetable,req,num_created}) do
    if(num_created < req)do
        key = String.slice(Base.encode16(:crypto.hash(:sha256, Integer.to_string(:rand.uniform(99999999)) )),32,32)
        
        next_hop = route_lookup(incoming_node_hex,leaf,routetable,selfid)

        if next_hop != nil do
            GenServer.cast(String.to_atom("n#{next_hop}",{:route,key,message,path_count))            
        else
            #sleep(500)
            #IO.puts "Sendign leaf table"
            #GenServer.cast(incoming_node,{:leaf_table,leaf,path_count}) T

            #SEND PATH COUNT 
        end    

        num_created = num_created+1
    end
    
    
    {:noreply,{selfid,leaf,routetable,req,num_created}}
end

end