{
	config,
	lib,
	...
}: {
	services = {
		silverbullet = {
			enable = true;
			spaceDir = "/storage/internal/silverbullet";
		};
		caddy.virtualHosts."silverbullet.raquellie.com".extraConfig = ''
			reverse_proxy localhost:${lib.toString config.services.silverbullet.listenPort}
		'';
	};
}
