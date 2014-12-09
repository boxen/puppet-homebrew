Facter.add(:homebrew_root) do
  confine :operatingsystem => 'Darwin'

  # Explicit, low weight makes this easily overridable
  has_weight 1

  setcode { "#{Facter.value(:boxen_home)}/homebrew" }
end
