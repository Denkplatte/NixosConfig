{ pkgs }:

pkgs.fetchFromGitHub {
  owner  = "xero";
  repo   = "figlet-fonts";
  rev    = "417429ef36ab039cbf192a4424c60aa23fc32de8";
  sha256 = "sha256-QogGNQ772bcYLOzgO0i6ydbzxjn5jnXNav72vW/SXm8="; # fill in — see below
}
