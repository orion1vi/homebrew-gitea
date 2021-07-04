class Changelog < Formula
  desc "Generate changelog of gitea repository"
  homepage "https://gitea.com/gitea/changelog"
  version "master"

  os = OS.mac? ? "darwin-10.6" : "linux"
  arch = case Hardware::CPU.arch
         when :i386 then "386"
         when :x86_64 then "amd64"
         when :arm64 then "arm64"
         else
           raise "changelog: Unsupported system architecture #{Hardware::CPU.arch}"
         end

  @@filename = "changelog-#{version}-#{os}-#{arch}"
  @@url = "https://dl.gitea.io/changelog-tool/#{version}/#{@@filename}.xz"
  @@sha256 = %x[ curl -sL #{@@url}.sha256 ].split.first

  url @@url
  sha256 @@sha256

  bottle :unneeded
  def install
    filename = Changelog.class_variable_get("@@filename")
    bin.install filename => "changelog"
  end

  test do
    system "#{bin}/changelog", "--version"
  end
end
