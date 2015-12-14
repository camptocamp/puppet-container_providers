require 'spec_helper'

describe Puppet::Type.type(:container).provider(:docker) do

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      before :each do
        Facter.clear
        facts.each do |k, v|
          Facter.stubs(:fact).with(k).returns Facter.add(k) { setcode { v } }
        end
      end

      describe 'instances' do
        it 'should have an instance method' do
          expect(described_class).to respond_to :instances
        end
      end

      describe 'prefetch' do
        it 'should have a prefetch method' do
          expect(described_class).to respond_to :prefetch
        end
      end

      describe '#instances' do
        context 'with no containers' do
          it do
          described_class.expects(:docker).with(['ps', '-a', '-q']).returns "\n"
            expect(described_class.instances.size).to eq(0)
          end
        end

        context 'with a container' do
          before :each do
            described_class.expects(:docker).with(['ps', '-a', '-q']).returns "deadbeefdead\n"
            described_class.expects(:docker).with(['inspect', 'deadbeefdead']).returns %q[
[
{
    "Id": "deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef",
    "Created": "2015-12-14T15:52:12.133449207Z",
    "Path": "bash",
    "Args": [],
    "State": {
        "Running": true,
        "Paused": false,
        "Restarting": false,
        "OOMKilled": false,
        "Dead": false,
        "Pid": "1234",
        "ExitCode": 0,
        "Error": "",
        "StartedAt": "2015-12-14T15:52:12.284335673Z",
        "FinishedAt": "0001-01-01T00:00:00Z"
    },
    "Image": "beefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdead",
    "NetworkSettings": {
        "Bridge": "",
        "EndpointID": "eadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefd",
        "Gateway": "172.17.42.1",
        "GlobalIPv6Address": "",
        "GlobalIPv6PrefixLen": 0,
        "HairpinMode": false,
        "IPAddress": "172.17.0.207",
        "IPPrefixLen": 16,
        "IPv6Gateway": "",
        "LinkLocalIPv6Address": "",
        "LinkLocalIPv6PrefixLen": 0,
        "MacAddress": "01:23:45:67:89:ab",
        "NetworkID": "adbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefde",
        "PortMapping": null,
        "Ports": {},
        "SandboxKey": "/var/run/docker/netns/deaddeadbeef",
        "SecondaryIPAddresses": null,
        "SecondaryIPv6Addresses": null
    },
    "ResolvConfPath": "/var/lib/docker/containers/deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef/resolv.conf",
    "HostnamePath": "/var/lib/docker/containers/deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef/hostname",
    "HostsPath": "/var/lib/docker/containers/deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef/hosts",
    "LogPath": "/var/lib/docker/containers/deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef/deadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeefdeadbeef-json.log",
    "Name": "/jolly_mestorf",
    "RestartCount": 0,
    "Driver": "btrfs",
    "ExecDriver": "native-0.2",
    "MountLabel": "",
    "ProcessLabel": "",
    "AppArmorProfile": "",
    "ExecIDs": null,
    "HostConfig": {
        "Binds": null,
        "ContainerIDFile": "",
        "LxcConf": [],
        "Memory": 0,
        "MemorySwap": 0,
        "CpuShares": 0,
        "CpuPeriod": 0,
        "CpusetCpus": "",
        "CpusetMems": "",
        "CpuQuota": 0,
        "BlkioWeight": 0,
        "OomKillDisable": false,
        "MemorySwappiness": null,
        "Privileged": false,
        "PortBindings": {},
        "Links": null,
        "PublishAllPorts": false,
        "Dns": null,
        "DnsSearch": null,
        "ExtraHosts": null,
        "VolumesFrom": null,
        "Devices": [],
        "NetworkMode": "default",
        "IpcMode": "",
        "PidMode": "",
        "UTSMode": "",
        "CapAdd": null,
        "CapDrop": null,
        "GroupAdd": null,
        "RestartPolicy": {
            "Name": "no",
            "MaximumRetryCount": 0
        },
        "SecurityOpt": null,
        "ReadonlyRootfs": false,
        "Ulimits": null,
        "LogConfig": {
            "Type": "json-file",
            "Config": {}
        },
        "CgroupParent": "",
        "ConsoleSize": [
            0,
            0
        ]
    },
    "GraphDriver": {
        "Name": "btrfs",
        "Data": null
    },
    "Mounts": [],
    "Config": {
        "Hostname": "deaddeadbeef",
        "Domainname": "",
        "User": "",
        "AttachStdin": true,
        "AttachStdout": true,
        "AttachStderr": true,
        "Tty": true,
        "OpenStdin": true,
        "StdinOnce": true,
        "Env": null,
        "Cmd": [
            "bash"
        ],
        "Image": "debian:jessie",
        "Volumes": null,
        "WorkingDir": "",
        "Entrypoint": null,
        "OnBuild": null,
        "Labels": {}
    }
}
]
]
          end

          it { expect(described_class.instances.size).to eq(1) }
          it { expect(described_class.instances.first.instance_variable_get("@property_hash")).to eq( {
            :ensure  => :running,
            :name    => 'jolly_mestorf',
            :image   => 'debian:jessie',
            :command => [ 'bash' ],
          })
          }
        end
      end
    end
  end
end
