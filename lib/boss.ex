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
            
    def boss_receiver(topology,a,numInt) do
        receive do
            {:rumourpropogated,b} ->
                IO.puts "Time in MilliSeconds: #{b-a}"
                :init.stop
            {:gossip_topology_created} ->
                rstring = "This is the first rumour"
                IO.puts "Gossip Network is created"
                #rstring = "This is the first rumour"
                a = System.system_time(:millisecond)

                if topology == "line" || topology =="full" do
                    GenServer.cast(String.to_atom("node#{:rand.uniform(numInt)}"), {:rumour, rstring})
                end
                if topology == "2D" || topology =="imp2D" do
                    sqn= round(:math.sqrt(numInt))
                    GenServer.cast(String.to_atom("node#{:rand.uniform(sqn)}@#{:rand.uniform(sqn)}"), {:rumour, rstring})
                end
            {:pushsum_topology_created} ->
                IO.puts "PushSum Network is created"
                a = System.system_time(:millisecond)
                if topology == "line" || topology =="full" do
                    GenServer.cast(String.to_atom("node#{:rand.uniform(numInt)}"), {:rumour,0.0,0.0})
                end
                if topology == "2D" || topology =="imp2D" do
                    sqn= round(:math.sqrt(numInt))
                    GenServer.cast(String.to_atom("node#{:rand.uniform(sqn)}@#{:rand.uniform(sqn)}"), {:rumour,0.0,0.0})
                end
            {:sumcomputed,b} ->
                IO.puts "Time in MilliSeconds: #{b-a}"
                :init.stop                
        end
        boss_receiver(topology,a,numInt)
    end
end