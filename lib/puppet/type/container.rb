Puppet::Type.newtype(:container) do
  @doc = "Manage a container."

  ensurable

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
