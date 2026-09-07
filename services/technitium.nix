{config, ...}: let
	impermanence = config.custom.impermanence;
in {
	services.technitium-dns-server = {
		enable = true;
		openFirewall = true;
	};

	environment.persistence."${impermanence.persistPath}" = {
		directories = [
			"/var/lib/private/technitium-dns-server/"
		];
	};
}
