defmodule Boss do
    def main(args) do 
        parse_args(args)
    end
    defp parse_args(args) do
        cmdarg = OptionParser.parse(args)
        {[],[numNodes,numRequests],[]} = cmdarg
        numNodesInt = String.to_integer(numNodes)
        numRequestsInt = String.to_integer(numRequests)

        #Register yourself
        Process.register(self(),:boss)
        
        ApplicationSupervisor.start_link([numNodesInt,numRequestsInt])
        
        boss_receiver(numNodesInt,numRequestsInt)
    end
            
    def boss_receiver(numNodes,numRequests) do
        receive do
            
            {:nodes_created} ->
                
                IO.puts "Nodes created, netwoek init started"
                nextnode = "n"<>String.slice(Base.encode16(:crypto.hash(:sha256, Integer.to_string(1) ) ),32,32)
                # ADD INIT NEXT cast here 
                GenServer.cast(String.to_atom(nextnode),{:intialize_table_first})

            {:network_ring_created} ->
                IO.puts "Network ring creattion msg recieved."
                n_list = Enum.to_list 1..numNodes
                nodeid_list = Enum.map(n_list, fn(x) -> "n"<>String.slice(Base.encode16(:crypto.hash(:sha256, Integer.to_string(x) ) ),32,32) end)
                #IO.inspect ( Enum.at(nodeid_list,0))
                
                #CAST initial message to everyone 
                
                Enum.map(nodeid_list, fn(x) -> GenServer.cast(String.to_atom(x),{:create_n_requests}) end)

                #a = System.system_time(:millisecond)
                
            {:all_requests_served,b} ->
                avg = b/(numNodes*numRequests)
                IO.puts "Avg Hops: #{avg}"
                :init.stop                
        end
        boss_receiver(numNodes,numRequests)
    end
end