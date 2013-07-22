Puppet::Type.newtype(:homebrew_tap) do
  ensurable do
    newvalue :present do
      provider.create
    end

    newvalue :absent do
      provider.destroy
    end

    defaultto :present
  end

  newparam(:source) do
    isnamevar

    validate do |v|
      if v.nil?
        raise Puppet::ParseError, "Homebrew_tap requires a source parameter!"
      end
    end
  end
end
