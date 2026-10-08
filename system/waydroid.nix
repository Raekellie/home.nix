{
	config,
	pkgs,
	...
}: let
	impermanence = config.custom.impermanence;
in {
	virtualisation.waydroid.enable = true;

	environment = {
		systemPackages = with pkgs; [
			# microG and x86 translation layers installers, along with a keyboard mapping tool
			waydroid-helper
		];

		persistence."${impermanence.persistPath}" = {
			directories = [
				"/var/lib/waydroid"
			];
		};
	};
}
