Puppet::Type.newtype(:homebrew_repo) do
  newparam(:path) do
    isnamevar
    
    validate do |v|
      if v.nil?
        raise Puppet::ParseError, "Homebrew_repo requires a path parameter!"
      end
    end
  end

  newproperty(:min_revision) do
    newvalue(/.+/) do
      provider.brew_update
    end
    
    def retrieve
      provider.check_min_revision
    end
  end

  newparam :user do
    desc "User to run this operation as."

    defaultto do
      Facter.value(:boxen_user) || Facter.value(:id) || "root"
    end
  end
end
