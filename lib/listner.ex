defmodule Listner do
    use GenServer
    def start_link(numnodes,numrequests) do
        myname = String.to_atom("listner")
        return = GenServer.start_link(__MODULE__, {numnodes,numrequests}, name: myname )
        return
    end
    
    def init({numnodes,numrequests}) do
        {:ok,{numrequests,numnodes}}
    end

    def handle_cast(:heardrumour,{count,numnodes})do
        newcount=count+1
        #IO.puts "#{newcount} node/s have heard the rumour."
        if newcount == numnodes do
            b = System.system_time(:millisecond)
            IO.puts "Rumour Propogated, Terminating."
            send(Process.whereis(:boss),{:rumourpropogated,b})
            #s:init.stop
            #OR Supervisor.stop(sup)
        end
        {:noreply,{newcount,numnodes}}
    end

end