{pkgs, ...}: {
	services = {
		desktopManager.plasma6.enable = true;
		displayManager = {
			plasma-login-manager.enable = true;
			autoLogin.user = "raquel";
		};
	};

	programs = {
		kdeconnect.enable = true;
		kde-pim.enable = false;
	};

	environment.systemPackages = with pkgs; [
		kdePackages.discover
		kdePackages.kcalc
		kdePackages.kcharselect
		kdePackages.kclock
		kdePackages.kcolorchooser
		kdePackages.ksystemlog
		kdePackages.kate
		kdePackages.filelight

		kdiff3

		kdePackages.kleopatra
		kdePackages.isoimagewriter
		kdePackages.partitionmanager
	];
}
