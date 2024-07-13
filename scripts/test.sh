declare -a pkg_req=('brightnessctl' 'caca-utils' 'cairo-devel' 'cairo-tools' 'cargo' 'file-devel' 'fmt-devel' 'freeglut-devel'
'go1.22' 'gobject-introspection' 'gtk-layer-shell-devel' 'gtkmm3-devel')

	for ((i=0; i<=(${#pkg_req[@]}-1); i++))
	do
		echo ${pkg_req[$i]}
	done