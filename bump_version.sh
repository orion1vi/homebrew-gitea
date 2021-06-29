#!/bin/sh

binaries="tea gitea"
for bin in ${binaries};do
	file="${bin}.rb"
	case "$bin" in
		tea)
			git_url="https://gitea.com/gitea/tea"
			supported_os="linux-386 linux-amd64 linux-arm64 darwin-amd64";;
		gitea)
			git_url="https://github.com/go-gitea/gitea"
			supported_os="linux-386 linux-amd64 linux-arm64 darwin-10.12-amd64 darwin-10.12-arm64";;
		*)
			>&2 echo "Error: unrecognized binary ($bin)"
			exit 1;;
	esac
	latest=$(curl -sL -o /dev/null -w %{url_effective} "${git_url}/releases/latest")
	version="${latest##*/v}"

	file_url="https://dl.gitea.io/${bin}/${version}"
	for os in ${supported_os}; do
		sha256_file="${bin}-${version}-${os}.xz.sha256"
		sha256=$(curl -sL "${file_url}/${sha256_file}" | awk '{print$1}')
		sed -r "s/^(\s+when \"${os}\" then).*/\1 \"${sha256}\"/" -i "${file}"
	done
	sed -r "s/^(\s+version).*/\1 \"${version}\"/" -i "${file}"
done
