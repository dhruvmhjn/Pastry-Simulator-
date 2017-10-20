defmodule ApplicationSupervisor do
    use Supervisor
    def start_link(args) do
        return = {:ok, sup } = Supervisor.start_link(__MODULE__,args)
        start_workers(sup, args)
        return
    end
    
    def start_workers(sup, [numNodes,numRequests]) do
    
        if algorithm == "push-sum" do
            {:ok, gcpid} = Supervisor.start_child(sup, worker(PushsumCounter, [numNodes,numRequests]))     
            Supervisor.start_child(sup, supervisor(PastrySupervisor, [numNodes,numRequests,gcpid]))
        end
    
    end
    
    def init(_) do
        supervise [], strategy: :one_for_all
    end

end