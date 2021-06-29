class GiteaHead < Formula
  desc "Git with a cup of tea, painless self-hosted git service"
  homepage "https://gitea.io"
  version "main"

  os = OS.mac? ? "darwin-10.12" : "linux"
  arch = case Hardware::CPU.arch
         when :i386 then "386"
         when :x86_64 then "amd64"
         when :arm64 then "arm64"
         else
           raise "gitea: Unsupported system architecture #{Hardware::CPU.arch}"
         end

  @@filename = "gitea-#{version}-#{os}-#{arch}"
  @@url = "https://dl.gitea.io/gitea/#{version}/#{@@filename}.xz"
  @@sha256 = %x[ curl -sL #{@@url}.sha256 ].split.first

  url @@url
  sha256 @@sha256

  conflicts_with "gitea", because: "both install gitea binaries"
  bottle :unneeded
  def install
    filename = GiteaHead.class_variable_get("@@filename")
    bin.install filename => "gitea"
  end

  test do
    system "#{bin}/gitea", "--version"
  end
end
