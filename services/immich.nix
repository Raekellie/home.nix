{
	config,
	pkgs,
	pkgs-unstable,
	...
}: let
	impermanence = config.custom.impermanence;
in {
	# Default port: 2283
	services.immich = {
		enable = true;
		host = "0.0.0.0";
		openFirewall = true;
		# Unstable is used because the Android app may update more often than nixos-stable
		package = pkgs-unstable.immich;

		mediaLocation = "/storage/internal/immich";
		accelerationDevices = ["/dev/dri/renderD128"];

		# This is for configuring via the web interface. Maybe one day I'll do it all here
		settings = null;
	};
	services.redis.servers.immich.logLevel = "warning";

	# https://wiki.nixos.org/wiki/Accelerated_Video_Playback
	users.users.immich.extraGroups = ["video" "render"];
	hardware.graphics = {
		enable = true;
		extraPackages = with pkgs; [
			vpl-gpu-rt
		];
	};

	environment.persistence."${impermanence.persistPath}" = {
		directories = [
			"/var/lib/redis-immich"
		];
	};
}
