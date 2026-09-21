{
	config,
	pkgs,
	lib,
	...
}: {
	imports = [
		./hardware-configuration.nix
		./sops
		../../custom/impermanence.nix
		../../system/common.nix
		../../system/raquel.nix
		../../system/fish.nix
		../../system/utilities.nix
		../../services/ssh.nix
		../../services/ddns-script

		../../services/technitium.nix
		#../../services/caddy.nix
		#../../services/authelia.nix
		#../../services/zabbix.nix
		#../../services/silverbullet.nix
		#../../services/firefly-iii.nix
		#../../services/pufferpanel.nix
	];

	custom.impermanence = {
		enable = true;
		persistPath = "/persist";

		btrfs = {
			enable = true;
			rootDevice = config.fileSystems."/".device;
			rootSubvol = "root";
			daysToKeep = 14;
		};
	};

	boot = {
		kernelPackages = pkgs.linuxPackages_latest;

		loader = {
			timeout = 0;
			systemd-boot = {
				enable = true;
				editor = false;
				configurationLimit = 5;
				memtest86.enable = true;
				#netbootxyz.enable = true; # Reminder for self that this is an option
			};
		};
	};

	networking = {
		hostName = "biglab";
		useNetworkd = true;
	};

	systemd = {
		network = {
			enable = true;
			networks = {
				"10-ether" = {
					matchConfig.Path = "pci-0000:03:00.0";
					networkConfig = {
						DHCP = "ipv4";
						IPv6AcceptRA = true;
					};
					ipv6AcceptRAConfig = {
						Token = "static:::bee6:b00b:fee1:50f7"; # I am exercising my free will as an adult
					};
					linkConfig = {
						RequiredForOnline = "routable";
					};
				};
			};
		};
	};

	services = {
		# TODO: Re-enable this when I have time to properly set it up
		#fail2ban.enable = true;
	};

	# Read the docs/release notes before changing this value
	# (man configuration.nix, https://nixos.org/nixos/options.html, https://nixos.org/manual/nixos/stable/release-notes)
	system.stateVersion = "26.05";
}
