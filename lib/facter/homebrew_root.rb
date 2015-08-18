Facter.add(:homebrew_root) do
  confine :operatingsystem => 'Darwin'

  # Explicit, low weight makes this easily overridable
  has_weight 1

  setcode do
    if File.exist? "#{Facter.value(:boxen_home)}/homebrew/bin/brew"
      "#{Facter.value(:boxen_home)}/homebrew"
    else
      "/usr/local"
    end
  end
end
