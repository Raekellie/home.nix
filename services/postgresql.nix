{config, ...}: let
	impermanence = config.custom.impermanence;
in {
	services.postgresql = {
		enable = true;
	};

	environment.persistence."${impermanence.persistPath}" = {
		directories = [
			"/var/lib/postgresql"
		];
	};
}
