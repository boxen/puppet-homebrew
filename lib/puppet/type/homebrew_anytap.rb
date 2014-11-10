Puppet::Type.newtype(:homebrew_anytap) do
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
        raise Puppet::ParseError, "Homebrew_anytap requires a source parameter!"
      end
    end
  end

  newparam(:url) do
    desc "URL of repo"
  end
end
