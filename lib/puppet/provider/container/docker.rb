Puppet::Type.type(:container).provide(:docker) do

  commands :docker => 'docker'

  mk_resource_methods

  def self.instances
    docker(['ps', '-a']).split("\n").map do |container|
      new({
      })
    end
  end

  def self.prefetch(resources)
    containers = instances
    resources.keys.each do |name|
      if provider = containers.find{ |container| container.name == name }
        resources[name].provider = provider
      end
    end
  end

  def exists?
    @property_hash[:ensure] == :present
  end
end
