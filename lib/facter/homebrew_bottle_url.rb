Facter.add(:homebrew_bottle_url) do
  confine :operatingsystem => :darwin

  has_weight 1

  setcode { "#{Facter.value(:boxen_download_url_base)}/homebrew" }
end
