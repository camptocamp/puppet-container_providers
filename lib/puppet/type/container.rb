Puppet::Type.newtype(:container) do
  @doc = "Manage a container."

  ensurable do
    newvalue(:created, :event => :container_created) do
      provider.create
    end

    newvalue(:restarting, :event => :container_restarted) do
      provider.restart
    end

    newvalue(:running, :event => :container_running) do
      provider.run
    end

    newvalue(:paused, :event => :container_paused) do
      provider.pause
    end

    newvalue(:exited, :event => :container_exited) do
      provider.exit
    end

    defaultto { :running }
  end

  newparam(:name) do
    desc "The default namevar."
  end

  newproperty(:image) do
    desc "The image to run."
  end

  newproperty(:restart) do
    desc "Manage restart policy."
  end

  newproperty(:command) do
    desc "The command to pass to the entry point."
  end
end
