Facter.add(:homebrew_bottle_url) do
  confine :operatingsystem => :darwin

  has_weight 1

  setcode { "#{Facter.value(:boxen_s3_bucket)}.#{Facter.value(:boxen_s3_host)}/homebrew" }
end
