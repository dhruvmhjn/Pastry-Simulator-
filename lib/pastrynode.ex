defmodule PastryNode do
    use GenServer
    def start_link(x,nodes,numRequests) do
    input_srt = Integer.to_string(x)
    nodeid = String.slice(Base.encode16(:crypto.hash(:sha256, input_srt)),32,32)
    GenServer.start_link(__MODULE__, {nodeid,numRequests}, name: String.to_atom("n#{nodeid}"))    
    end

    def init({selfid,numRequests}) do        
        routetable = Matrix.from_list([[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]])
        {:ok, {selfid,[selfid],routetable,numRequests,0}}
    end

    def route_lookup(key, leaf, routetable , selfid ) do
        {keyval,_} = Integer.parse(key,16)
        {firstleaf,_} = Integer.parse(List.first(leaf),16)
        {lastleaf,_} = Integer.parse(List.last(leaf),16)

        #check leaf set
        if ((keyval >= firstleaf) &&(keyval <= lastleaf)) do
            route_to = Enum.min_by(leaf, fn(x) -> Kernel.abs(elem(Integer.parse(x,16),0) - keyval) end)
            if route_to == selfid do
                route_to = nil
            end
        else #check routing table
            [{match_type, common}|_] = String.myers_difference(selfid,key)
            if match_type == :eq do
                common_len = String.length common
            else
                common_len = 0
            end
                
            {next_digit,_} = Integer.parse(String.slice(key,common_len,1),16)
             if (routetable[common_len][next_digit] != nil) do
                route_to = routetable[common_len][next_digit] 
             else #check all other routing table enteries 
                rtl = Matrix.to_list(routetable)
                routelist = Enum.slice(rtl,common_len,31)
                routelist = List.flatten(routelist)
                routelist = routelist ++ leaf 
                if (!Enum.empty?(routelist))do
                    candidate = Enum.min_by(routelist, fn(x) -> Kernel.abs(elem(Integer.parse(x,16),0) - keyval) end)
                    #compare candidate with self
                    cand_diff = Kernel.abs(elem(Integer.parse(candidate,16),0) - keyval)
                    self_diff = Kernel.abs(elem(Integer.parse(selfid,16),0) - keyval)
                    if(cand_diff < self_diff )do
                        route_to = candidate
                    else
                        route_to = nil
                    end
                else    
                    route_to = nil
                end  
             end
        end

    route_to
    end

    def handle_cast({:intialize_table,hostid},{selfid,leaf,routetable,req,num_created})do
        selflist = Enum.map String.codepoints(selfid), fn(x) -> elem(Integer.parse(x,16),0) end
        
                routetable = put_in routetable[0][Enum.at(selflist,0)], selfid
                routetable = put_in routetable[1][Enum.at(selflist,1)], selfid
                routetable = put_in routetable[2][Enum.at(selflist,2)], selfid
                routetable = put_in routetable[3][Enum.at(selflist,3)], selfid
                routetable = put_in routetable[4][Enum.at(selflist,4)], selfid
                routetable = put_in routetable[5][Enum.at(selflist,5)], selfid
                routetable = put_in routetable[6][Enum.at(selflist,6)], selfid
                routetable = put_in routetable[7][Enum.at(selflist,7)], selfid
                routetable = put_in routetable[8][Enum.at(selflist,8)], selfid
                routetable = put_in routetable[9][Enum.at(selflist,9)], selfid
                routetable = put_in routetable[10][Enum.at(selflist,10)], selfid
                routetable = put_in routetable[11][Enum.at(selflist,11)], selfid
                routetable = put_in routetable[12][Enum.at(selflist,12)], selfid
                routetable = put_in routetable[13][Enum.at(selflist,13)], selfid
                routetable = put_in routetable[14][Enum.at(selflist,14)], selfid
                routetable = put_in routetable[15][Enum.at(selflist,15)], selfid
                routetable = put_in routetable[16][Enum.at(selflist,16)], selfid
                routetable = put_in routetable[17][Enum.at(selflist,17)], selfid
                routetable = put_in routetable[18][Enum.at(selflist,18)], selfid
                routetable = put_in routetable[19][Enum.at(selflist,19)], selfid
                routetable = put_in routetable[20][Enum.at(selflist,20)], selfid
                routetable = put_in routetable[21][Enum.at(selflist,21)], selfid
                routetable = put_in routetable[22][Enum.at(selflist,22)], selfid
                routetable = put_in routetable[23][Enum.at(selflist,23)], selfid
                routetable = put_in routetable[24][Enum.at(selflist,24)], selfid
                routetable = put_in routetable[25][Enum.at(selflist,25)], selfid
                routetable = put_in routetable[26][Enum.at(selflist,26)], selfid
                routetable = put_in routetable[27][Enum.at(selflist,27)], selfid
                routetable = put_in routetable[28][Enum.at(selflist,28)], selfid
                routetable = put_in routetable[29][Enum.at(selflist,29)], selfid
                routetable = put_in routetable[30][Enum.at(selflist,30)], selfid
                routetable = put_in routetable[31][Enum.at(selflist,31)], selfid
    
            #last lines
        GenServer.cast(String.to_atom("n"<>hostid),{:join,selfid,0})
    {:noreply,{selfid,leaf,routetable,req,num_created}}
    end

    def handle_cast({:intialize_table_first},{selfid,leaf,routetable,req,num_created})do
        selflist = Enum.map String.codepoints(selfid), fn(x) -> elem(Integer.parse(x,16),0) end
        
        # rows = Enum.to_list 0..31
        # for row <- rows do
            
        # end

                routetable = put_in routetable[0][Enum.at(selflist,0)], selfid
                routetable = put_in routetable[1][Enum.at(selflist,1)], selfid
                routetable = put_in routetable[2][Enum.at(selflist,2)], selfid
                routetable = put_in routetable[3][Enum.at(selflist,3)], selfid
                routetable = put_in routetable[4][Enum.at(selflist,4)], selfid
                routetable = put_in routetable[5][Enum.at(selflist,5)], selfid
                routetable = put_in routetable[6][Enum.at(selflist,6)], selfid
                routetable = put_in routetable[7][Enum.at(selflist,7)], selfid
                routetable = put_in routetable[8][Enum.at(selflist,8)], selfid
                routetable = put_in routetable[9][Enum.at(selflist,9)], selfid
                routetable = put_in routetable[10][Enum.at(selflist,10)], selfid
                routetable = put_in routetable[11][Enum.at(selflist,11)], selfid
                routetable = put_in routetable[12][Enum.at(selflist,12)], selfid
                routetable = put_in routetable[13][Enum.at(selflist,13)], selfid
                routetable = put_in routetable[14][Enum.at(selflist,14)], selfid
                routetable = put_in routetable[15][Enum.at(selflist,15)], selfid
                routetable = put_in routetable[16][Enum.at(selflist,16)], selfid
                routetable = put_in routetable[17][Enum.at(selflist,17)], selfid
                routetable = put_in routetable[18][Enum.at(selflist,18)], selfid
                routetable = put_in routetable[19][Enum.at(selflist,19)], selfid
                routetable = put_in routetable[20][Enum.at(selflist,20)], selfid
                routetable = put_in routetable[21][Enum.at(selflist,21)], selfid
                routetable = put_in routetable[22][Enum.at(selflist,22)], selfid
                routetable = put_in routetable[23][Enum.at(selflist,23)], selfid
                routetable = put_in routetable[24][Enum.at(selflist,24)], selfid
                routetable = put_in routetable[25][Enum.at(selflist,25)], selfid
                routetable = put_in routetable[26][Enum.at(selflist,26)], selfid
                routetable = put_in routetable[27][Enum.at(selflist,27)], selfid
                routetable = put_in routetable[28][Enum.at(selflist,28)], selfid
                routetable = put_in routetable[29][Enum.at(selflist,29)], selfid
                routetable = put_in routetable[30][Enum.at(selflist,30)], selfid
                routetable = put_in routetable[31][Enum.at(selflist,31)], selfid
    
            #last lines
        GenServer.cast(:listner,{:stated_s,selfid})        
    {:noreply,{selfid,leaf,routetable,req,num_created}}
    end



    def handle_cast({:join, incoming_node ,path_count},{selfid,leaf,routetable,req,num_created}) do
        path_count=path_count+1
        GenServer.cast(String.to_atom("n"<>incoming_node),{:routing_table,routetable,selfid,path_count})
       
        #NEXT HOP for incoming node
        next_hop = route_lookup(incoming_node,leaf,routetable,selfid)
        if next_hop != nil do
            GenServer.cast(String.to_atom("n#{next_hop}"),{:join_route,incoming_node,path_count})            
        else
           
            #IO.puts "Sending leaf table"
            GenServer.cast(String.to_atom("n"<>incoming_node),{:leaf_table,leaf,selfid,path_count})
    
        end
    {:noreply,{selfid,leaf,routetable,req,num_created}}
    end

    def handle_cast({:join_route,incoming_node,path_count},{selfid,leaf,routetable,req,num_created}) do
        path_count=path_count+1
        GenServer.cast(String.to_atom("n"<>incoming_node),{:routing_table,routetable,selfid,path_count})
        
        #NEXT HOP for incoming node
        next_hop = route_lookup(incoming_node,leaf,routetable,selfid)
        if next_hop != nil do
            GenServer.cast(String.to_atom("n#{next_hop}"),{:join_route,incoming_node,path_count})            
        else
           
            #IO.puts "Sending leaf table"
            GenServer.cast(String.to_atom("n"<>incoming_node),{:leaf_table,leaf,selfid,path_count})
        end
    {:noreply,{selfid,leaf,routetable,req,num_created}}
    end

     def handle_cast({:routing_table,new_route_table,sender_nodeid,path_count},{selfid,leaf,routetable,req,num_created}) do
        #dsa
        [{match_type, common}|_] = String.myers_difference(selfid,sender_nodeid)
        if match_type == :eq do
            common_len = String.length common
        else
            common_len = 0
        end
        
        
        rows = Enum.to_list 0..31        

        res = Enum.map rows, fn(row) -> if (row<= common_len) do Map.merge(new_route_table[row],routetable[row]) else routetable[row] end end
        res_map = Matrix.from_list(res)    


    {:noreply,{selfid,leaf,res_map,req,num_created}}
    end


     def handle_cast({:leaf_table,new_leaf_set,sender_nodeid,path_count},{selfid,leaf,routetable,req,num_created}) do
            
        merge_leaf = Enum.dedup(Enum.sort(new_leaf_set ++ leaf))
        merge_size = Enum.count(merge_leaf)
        centre = Enum.find_index(merge_leaf, fn(x) -> x == selfid end)

        {small_leaf, large_leaf} = Enum.split(List.delete(merge_leaf,selfid),centre)

        small_size =  Enum.count(small_leaf)
        large_size =  Enum.count(large_leaf)
        
        if(small_size > 16) do
            small_leaf = Enum.slice(small_leaf, small_size-16, 16) 
            
        end
        if(large_size > 16) do
            large_leaf = Enum.slice(large_leaf, large_size-16, 16) 
        end

        leaf = small_leaf ++ [selfid] ++ large_leaf

        rt_list = List.flatten(Matrix.to_list(routetable))
        route_table_list = Enum.dedup(Enum.sort(rt_list))
        route_table_list = List.delete(route_table_list,selfid)
        
        leaf_list = List.delete(leaf,selfid)
        #Create variable combined list
        
        return_list_1 = Enum.map(route_table_list, fn(x) -> GenServer.call(String.to_atom("n"<>x),{:updatert,routetable,selfid}) end)
        
        return_list_2 = Enum.map(leaf_list, fn(x) -> GenServer.call(String.to_atom("n"<>x),{:update_routeleaf_table,routetable,leaf,selfid}) end)

        #ADD RETURN list check here
        GenServer.cast(:listner,{:stated_s,selfid})
    {:noreply,{selfid,leaf,routetable,req,num_created}}
    end
    
    def handle_call({:updatert,incoming_routetable,sender_nodeid},from,{selfid,leaf,routetable,req,num_created}) do
        
        [{match_type, common}|_] = String.myers_difference(selfid,sender_nodeid)
        if match_type == :eq do
            common_len = String.length common
        else
            common_len = 0
        end
        rows = Enum.to_list 0..31        

        res = Enum.map rows, fn(row) -> if (row<= common_len) do Map.merge(incoming_routetable[row],routetable[row]) else routetable[row] end end
        res_map = Matrix.from_list(res)  


        {:reply,"ok",{selfid,leaf,res_map,req,num_created}} 
    end

    def handle_call({:update_routeleaf_table,incoming_routetable,new_leaf_set,sender_nodeid},from,{selfid,leaf,routetable,req,num_created}) do
       
        [{match_type, common}|_] = String.myers_difference(selfid,sender_nodeid)
        if match_type == :eq do
            common_len = String.length common
        else
            common_len = 0
        end
        rows = Enum.to_list 0..31        

        res = Enum.map rows, fn(row) -> if (row<= common_len) do Map.merge(incoming_routetable[row],routetable[row]) else routetable[row] end end
        res_map = Matrix.from_list(res)  
        
        merge_leaf = Enum.dedup(Enum.sort(new_leaf_set ++ leaf))
        merge_size = Enum.count(merge_leaf)
        centre = Enum.find_index(merge_leaf, fn(x) -> x == selfid end)
        {small_leaf, large_leaf} = Enum.split(List.delete(merge_leaf,selfid),centre)
       
        small_size =  Enum.count(small_leaf)
        large_size =  Enum.count(large_leaf)
        
        if(small_size > 16) do
            small_leaf = Enum.slice(small_leaf, small_size-16, 16) 
            
        end
        if(large_size > 16) do
            large_leaf = Enum.slice(large_leaf, large_size-16, 16) 
        end

        leaf = small_leaf ++ [selfid] ++ large_leaf


        {:reply,"ok",{selfid,leaf,res_map,req,num_created}} 
    end

    #ROUTING MSGS CODE


    def handle_cast({:create_n_requests},{selfid,leaf,routetable,req,num_created}) do
        if(num_created < req)do
            key = String.slice(Base.encode16(:crypto.hash(:sha256, Integer.to_string(:rand.uniform(99999999)) )),32,32)
            next_hop = route_lookup(key,leaf,routetable,selfid)
            if next_hop != nil do
                GenServer.cast(String.to_atom("n#{next_hop}"),{:route_message,key,"this is the msg",0})

            else
                GenServer.cast(:listner,{:delivery,0})

                #SEND hop COUNT 
            end    
            num_created = num_created+1
            Process.sleep(1000)
            GenServer.cast(String.to_atom("n"<>selfid),{:create_n_requests})
        end
    {:noreply,{selfid,leaf,routetable,req,num_created}}
    end

    def handle_cast({:route_message,key,msg,hop_count},{selfid,leaf,routetable,req,num_created}) do
        hop_count = hop_count + 1
        next_hop = route_lookup(key,leaf,routetable,selfid)
        
        if next_hop != nil do
            GenServer.cast(String.to_atom("n#{next_hop}"),{:route_message,key,msg,hop_count})
        
        else
            GenServer.cast(:listner,{:delivery,hop_count})
            #SEND hop COUNT 
        end
    {:noreply,{selfid,leaf,routetable,req,num_created}}   
    end
end