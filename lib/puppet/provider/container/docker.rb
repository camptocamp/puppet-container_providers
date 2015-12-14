require 'json'

Puppet::Type.type(:container).provide(:docker) do

  commands :docker => 'docker'

  mk_resource_methods

  def self.instances
    docker(['ps', '-a', '-q']).split.map do |container|
      data = JSON.parse(docker(['inspect', container])).first
      _ensure = if data['State']['Running']
                  :running
                elsif data['State']['Paused']
                  :paused
                elsif data['State']['Restarting']
                  :restarting
                # TODO: created and existed
                end
      new({
        :ensure  => _ensure,
        :name    => data['Name'][1..-1],
        :image   => data['Config']['Image'],
        :command => data['Config']['Cmd'],
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
