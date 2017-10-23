# # abc = ['a', 'b', 'c']
# # foobar = ["Foo", "bar", "baz"]
# # for abc, foobar do 
# # IO.inspect "#{abc} #{foobar}"
# # end

# # def handle_cast({:route,key},{selfid,leaf,routetable,req,num_created})do
#     #     #compute difference between leafset and key
#     #     {keyval,_} = Integer.parse(key,16)
#     #     {firstlist,_} = Integer.parse(List.first(leaf),16)
#     #     {lastleaf,_} = Integer.parse(List.last(leaf),16)
    
#     #     [{:eq, common}|_] = String.myers_difference(nodeid,key)
#     #     common_len = String.length common_len
#     #     {next_digit,_} = Integer.parse(String.slice(key,common_len,1),16)
    
#     #     rtl = Matrix.to_list(routetable)
#     #     [_|routelist] = Enum.chunk(rtl,common_len)
#     #     routelist = List.flatten(routelist)
#     #     routelist = routelist ++ leaf
#     #     candidate = cond do
#     #         Enum.empty?(routelist) -> nil
#     #         true -> Enum.min_by(routelist, fn(x) -> Kernel.abs(x - keyval) end)
#     #     end
    
#     #     route_to = cond do
#     #         (keyval >= firstleaf) &&(keyval <= lastleaf) -> Enum.min_by(leaf, fn(x) -> Kernel.abs(x - keyval) end)
#     #         routetable[common_len][next_digit] != nil ->  routetable[common_len][next_digit]  
#     #         !Enum.empty?(routelist) && ->          
#     #         true -> nil
#     #     end
        
#     #     if ((keyval >= firstleaf) &&(keyval <= lastleaf)) do
#     #         route_to = Enum.min_by(leaf, fn(x) -> Kernel.abs(elem(Integer.parse(x,16),0) - keyval) end)
#     #     else
#     #         [{:eq, common}|_] = String.myers_difference(nodeid,key)
#     #         common_len = String.length common_len
#     #         {next_digit,_} = Integer.parse(String.slice(key,common_len,1),16)
#     #          if (routetable[common_len][next_digit] != nil) do
#     #             route_to = routetable[common_len][next_digit] 
#     #          else
#     #             rtl = Matrix.to_list(routetable)
#     #             [_|routelist] = Enum.chunk(rtl,common_len)
#     #             routelist = List.flatten(routelist)
#     #             routelist = routelist ++ leaf 
#     #             if (!Enum.empty?(routelist))do
#     #                 candidate = Enum.min_by(routelist, fn(x) -> Kernel.abs(elem(Integer.parse(x,16),0) - keyval)
#     #                 #compare candidate with self
#     #                 cand_diff = Kernel.abs(elem(Integer.parse(candidate,16),0) - keyval)
#     #                 self_diff = Kernel.abs(elem(Integer.parse(nodeid,16),0) - keyval)
#     #                 if(cand_diff < self_diff )do
#     #                     route_to = candidate
#     #                 else
#     #                     route_to = nil
#     #                 end
#     #             else    
#     #                 route_to = nil
#     #             end  
#     #          end
#     #     end
    
        
#     #     {:noreply,{selfid,leaf,routetable,req,num_created}}
#     # end
    
#     #Enum.each routetable,  fn {index, _} -> Enum.each routetable[index], fn{k,v} ->  IO.puts "#{k} --> #{v}"  end end
#     #Enum.each routetable,  fn {index, _} -> Enum.each routetable[index], fn{k,v} -> [v|qlist] end end
    
    
#     #Enum.each routelist,  fn (row) -> Enum.map row, fn(x) -> IO.puts"#{x}"  end end

#     def myfunc() do
#         rows = Enum.to_list 0..1
#         colms = Enum.to_list 0..15
#         st = Matrix.from_list([[],[]])
#         rt = Matrix.from_list([[],[]])
#         rt = put_in rt[0][9], "abc"
#         rt = put_in rt[1][15], "abc"
#         st = put_in st[0][9], "xyz"
#         st = put_in st[0][14], "xyz"       
#         st = put_in st[1][8], "xyz"      
#         st = put_in st[1][10], "xyz"
#         res = for row <- rows, col <- colms do 
#             if((rt[row][col] == nil) && (st[row[col] != nil])) do 
#                 IO.puts "#{rt[row][col]}"
#                # rt[row][col] = put_in rt[row][col],st[row][col]
#              end
#          end
#         rt
#     end
