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
        
        boss_receiver(numNodesInt,numRequestsInt,nil)
    end
            
    def boss_receiver(numNodes,numRequests,a) do
        receive do
            {:rumourpropogated,b} ->
                IO.puts "Time in MilliSeconds: #{b-a}"
                :init.stop
            {:nodes_created} ->
                #rstring = "This is the first rumour"
                IO.puts "Nodes created, netwoek init started"
                
                # n_list = Enum.to_list 1..numNodes
                # nodeid_list = Enum.map(n_list, fn(x) -> String.slice(Base.encode16(:crypto.hash(:sha256, Integer.to_string(x) ) ),32,32) end)
                # IO.inspect ( Enum.at(nodeid_list,0))
                
                nextnode = "n"<>String.slice(Base.encode16(:crypto.hash(:sha256, Integer.to_string(1) ) ),32,32)
                # ADD INIT NEXT cast here 
                GenServer.cast(String.to_atom(nextnode),{:intialize_table_first})

                
                #rstring = "This is the first rumour"

            {:network_ring_created} ->
                IO.puts "Network ring creattion msg recieved."
                #a = System.system_time(:millisecond)
                
            {:sumcomputed,b} ->
                IO.puts "Time in MilliSeconds: #{b-a}"
                :init.stop                
        end
        boss_receiver(numNodes,numRequests,a)
    end
end