{
	inputs,
	pkgs,
	...
}: let
	alenjandra-wrapped =
		pkgs.symlinkJoin {
			name = "alejandra";
			paths = [pkgs.alejandra];
			buildInputs = [pkgs.makeWrapper];
			postBuild = ''
				wrapProgram $out/bin/alejandra \
				  --add-flags "--experimental-config ${inputs.dotfiles}/config/alejandra.toml"
			'';
		};
in {
	environment.systemPackages = with pkgs; [
		alenjandra-wrapped
		nil
		rustup

		git-filter-repo

		godotPackages.godot
		#godotPackages.godot-export-templates-bin
		steam-run # Useful to be able to run Godot games without messing with paths
	];
}
