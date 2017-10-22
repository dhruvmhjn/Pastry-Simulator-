defmodule PastryNode do
    use GenServer
    def start_link(x,nodes,numRequests) do
    b=4
    input_srt = Integer.to_string(x)
    nodeid = String.slice(Base.encode16(:crypto.hash(:sha256, input_srt)),32,32)
    GenServer.start_link(__MODULE__, {nodeid,b,nodes,numRequests}, name: String.to_atom("n#{nodeid}"))    
    end

    def init({selfid,b,nodes,numRequests}) do       

        routetable = Matrix.from_list([[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[],[]])
        #entries in routetable to point to self
        {:ok, {selfid,[selfid],routetable,numRequests,0}}
    end


    def route_lookup(key, leaf, routetable , selfid ) do
        {keyval,_} = Integer.parse(key,16)
        {firstleaf,_} = Integer.parse(List.first(leaf),16)
        {lastleaf,_} = Integer.parse(List.last(leaf),16)

        if ((keyval >= firstleaf) &&(keyval <= lastleaf)) do
            route_to = Enum.min_by(leaf, fn(x) -> Kernel.abs(elem(Integer.parse(x,16),0) - keyval) end)
        else
            [{:eq, common}|_] = String.myers_difference(selfid,key)
            common_len = String.length common
            {next_digit,_} = Integer.parse(String.slice(key,common_len,1),16)
             if (routetable[common_len][next_digit] != nil) do
                route_to = routetable[common_len][next_digit] 
             else
                rtl = Matrix.to_list(routetable)
                [_|routelist] = Enum.chunk(rtl,common_len)
                routelist = List.flatten(routelist)
                routelist = routelist ++ leaf 
                #never empty, remove duplicates

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

   
    # def handle_cast({:route,key},{selfid,leaf,routetable,req,num_created})do
    #     #compute difference between leafset and key
    #     {keyval,_} = Integer.parse(key,16)
    #     {firstlist,_} = Integer.parse(List.first(leaf),16)
    #     {lastleaf,_} = Integer.parse(List.last(leaf),16)
    
    #     [{:eq, common}|_] = String.myers_difference(nodeid,key)
    #     common_len = String.length common_len
    #     {next_digit,_} = Integer.parse(String.slice(key,common_len,1),16)
    
    #     rtl = Matrix.to_list(routetable)
    #     [_|routelist] = Enum.chunk(rtl,common_len)
    #     routelist = List.flatten(routelist)
    #     routelist = routelist ++ leaf
    #     candidate = cond do
    #         Enum.empty?(routelist) -> nil
    #         true -> Enum.min_by(routelist, fn(x) -> Kernel.abs(x - keyval) end)
    #     end
    
    #     route_to = cond do
    #         (keyval >= firstleaf) &&(keyval <= lastleaf) -> Enum.min_by(leaf, fn(x) -> Kernel.abs(x - keyval) end)
    #         routetable[common_len][next_digit] != nil ->  routetable[common_len][next_digit]  
    #         !Enum.empty?(routelist) && ->          
    #         true -> nil
    #     end
        
    #     if ((keyval >= firstleaf) &&(keyval <= lastleaf)) do
    #         route_to = Enum.min_by(leaf, fn(x) -> Kernel.abs(elem(Integer.parse(x,16),0) - keyval) end)
    #     else
    #         [{:eq, common}|_] = String.myers_difference(nodeid,key)
    #         common_len = String.length common_len
    #         {next_digit,_} = Integer.parse(String.slice(key,common_len,1),16)
    #          if (routetable[common_len][next_digit] != nil) do
    #             route_to = routetable[common_len][next_digit] 
    #          else
    #             rtl = Matrix.to_list(routetable)
    #             [_|routelist] = Enum.chunk(rtl,common_len)
    #             routelist = List.flatten(routelist)
    #             routelist = routelist ++ leaf 
    #             if (!Enum.empty?(routelist))do
    #                 candidate = Enum.min_by(routelist, fn(x) -> Kernel.abs(elem(Integer.parse(x,16),0) - keyval)
    #                 #compare candidate with self
    #                 cand_diff = Kernel.abs(elem(Integer.parse(candidate,16),0) - keyval)
    #                 self_diff = Kernel.abs(elem(Integer.parse(nodeid,16),0) - keyval)
    #                 if(cand_diff < self_diff )do
    #                     route_to = candidate
    #                 else
    #                     route_to = nil
    #                 end
    #             else    
    #                 route_to = nil
    #             end  
    #          end
    #     end
    
        
    #     {:noreply,{selfid,leaf,routetable,req,num_created}}
    # end
    
    #Enum.each routetable,  fn {index, _} -> Enum.each routetable[index], fn{k,v} ->  IO.puts "#{k} --> #{v}"  end end
    #Enum.each routetable,  fn {index, _} -> Enum.each routetable[index], fn{k,v} -> [v|qlist] end end
    
    
    #Enum.each routelist,  fn (row) -> Enum.map row, fn(x) -> IO.puts"#{x}"  end end



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
            #GenServer.cast(:listner,{:stated_s,nodeid})
        GenServer.cast(hostid,{:join,selfid,0})
    {:noreply,{selfid,leaf,routetable,req,num_created}}
    end

    def handle_cast({:intialize_table_first},{selfid,leaf,routetable,req,num_created})do
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
        GenServer.cast(:listner,{:stated_s,selfid})        
    {:noreply,{selfid,leaf,routetable,req,num_created}}
    end



    def handle_cast({:join,incoming_node,path_count},{selfid,leaf,routetable,req,num_created}) do
        path_count=path_count+1
        GenServer.cast(incoming_node,{:routing_table,routetable,path_count})
       
        #sincoming_node_hex = String.slice(Atom.to_string(incoming_node),1..-1)
        #NEXT HOP for incoming node
        next_hop = route_lookup(incoming_node,leaf,routetable,selfid)
        if next_hop != nil do
            GenServer.cast(String.to_atom("n#{next_hop}"),{:join_route,incoming_node,path_count})            
        else
            Process.sleep(500)
            IO.puts "Sending leaf table"
            GenServer.cast(incoming_node,{:leaf_table,leaf,path_count})
    
        end
    {:noreply,{selfid,leaf,routetable,req,num_created}}
    end

    def handle_cast({:join_route,incoming_node,path_count},{selfid,leaf,routetable,req,num_created}) do
        path_count=path_count+1
        GenServer.cast(incoming_node,{:routing_table,routetable,path_count})
        #incoming_node_hex = String.slice(Atom.to_string(incoming_node),1..-1)
        #NEXT HOP for incoming node
        next_hop = route_lookup(incoming_node,leaf,routetable,selfid)
        if next_hop != nil do
            GenServer.cast(String.to_atom("n#{next_hop}"),{:join_route,incoming_node,path_count})            
        else
            Process.sleep(500)
            IO.puts "Sending leaf table"
            GenServer.cast(incoming_node,{:leaf_table,leaf,path_count})
        end
    {:noreply,{selfid,leaf,routetable,req,num_created}}
    end

    def handle_cast({:routing_table,new_route_table,path_count},{selfid,leaf,routetable,req,num_created}) do
        #dsa



    {:noreply,{selfid,leaf,routetable,req,num_created}}
    end


    def handle_cast({:leaf_table,new_leaf_table,path_count},{selfid,leaf,routetable,req,num_created}) do
    
        route_table_list = ["AAA"]
        leaf_list = ["BB"]
        #Create variable combined list
        
        return_list_1 = Enum.map(route_table_list, fn(x) -> GenServer.call(String.to_atom(("n"<>x)),{:update_route_table,routetable}) end)
        
        return_list_2 = Enum.map(leaf_list, fn(x) -> GenServer.call(String.to_atom(("n"<>x)),{:update_routeleaf_table,routetable,leaf,selfid}) end)

        #ADD RETURN list check here
        GenServer.cast(:listner,{:stated_s,selfid})
    {:noreply,{selfid,leaf,routetable,req,num_created}}
    end
    
    def handle_call({:update_route_table,incoming_routetable},{selfid,leaf,routetable,req,num_created}) do
        
        {:reply,"ok",{selfid,leaf,routetable,req,num_created}} 
    end

    def handle_call({:update_routeleaf_table,incoming_routetable,incoming_leaf,newnodeid},{selfid,leaf,routetable,req,num_created}) do
        

        {:reply,"ok",{selfid,leaf,routetable,req,num_created}} 
    end

#ROUTING MSGS CODE


    def handle_cast({:create_n_requests},{selfid,leaf,routetable,req,num_created}) do
        if(num_created < req)do
            key = String.slice(Base.encode16(:crypto.hash(:sha256, Integer.to_string(:rand.uniform(99999999)) )),32,32)
            next_hop = route_lookup(key,leaf,routetable,selfid)
            if next_hop != nil do
                GenServer.cast(String.to_atom("n#{next_hop}"),{:route_message,key,"this is the msg",0})

            else


                #SEND hop COUNT 
            end    
            num_created = num_created+1
            Process.sleep(1000)
            GenServer.cast(selfid,{:create_n_requests})
        end
    {:noreply,{selfid,leaf,routetable,req,num_created}}
    end

    def handle_cast({:route_message,key,msg,hop_count},{selfid,leaf,routetable,req,num_created}) do
        next_hop = route_lookup(key,leaf,routetable,selfid)
        
        if next_hop != nil do
            GenServer.cast(String.to_atom("n#{next_hop}"),{:route_message,key,msg,hop_count+1})
        
        else
            #SEND hop COUNT 
        end
    {:noreply,{selfid,leaf,routetable,req,num_created}}   
    end


end